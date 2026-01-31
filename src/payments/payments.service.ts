import { Injectable, Logger, BadRequestException, NotFoundException, InternalServerErrorException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { SupabaseService } from '../supabase/supabase.service';
import { CartService } from '../cart/cart.service';
import { CreateSepayPaymentDto, CreatePaymentResponseDto, PaymentStatusResponseDto, SepayWebhookDto } from './dto/create-payment.dto';
import * as crypto from 'crypto';
import { SePayPgClient } from 'sepay-pg-node';

// SePay SDK types
interface SepayCheckoutResult {
  checkoutUrl: string;
  paymentId?: string;
  orderNumber?: string;
  success?: boolean;
  error?: string;
}

interface SepayConfig {
  merchantId: string;
  secretKey: string;
  environment: 'sandbox' | 'production';
}

@Injectable()
export class PaymentsService {
  private readonly logger = new Logger(PaymentsService.name);
  private readonly sepayConfig: SepayConfig;
  private readonly frontendUrl: string;
  private readonly sepayClient: SePayPgClient;

  constructor(
    private readonly configService: ConfigService,
    private readonly supabaseService: SupabaseService,
    private readonly cartService: CartService,
  ) {
    const sepayEnv = this.configService.get<string>('SEPAY_ENV') || 'sandbox';
    const merchantId = this.configService.get<string>('SEPAY_MERCHANT_ID');
    const secretKey = this.configService.get<string>('SEPAY_SECRET_KEY');
    
    // Validate credentials in production
    if (sepayEnv === 'production') {
      if (!merchantId || !secretKey) {
        throw new Error('SEPAY_MERCHANT_ID and SEPAY_SECRET_KEY are required in production environment');
      }
    }
    
    this.sepayConfig = {
      merchantId: merchantId || 'SP-TEST-MERCHANT-001',
      secretKey: secretKey || 'spsk_test_abcdef1234567890',
      environment: sepayEnv as 'sandbox' | 'production',
    };
    this.frontendUrl = this.configService.get<string>('FRONTEND_URL') || 'http://localhost:3000';
    
    // Initialize SePay SDK client
    this.sepayClient = new SePayPgClient({
      env: this.sepayConfig.environment,
      merchant_id: this.sepayConfig.merchantId,
      secret_key: this.sepayConfig.secretKey,
    });
    
    this.logger.log(`SePay initialized in ${this.sepayConfig.environment} mode with merchant ${this.sepayConfig.merchantId}`);
    
    // Warn if sandbox simulation is enabled
    if (this.sepayConfig.environment === 'sandbox') {
      this.logger.warn('SANDBOX MODE ENABLED - Simulated payment verification allowed. DO NOT use in production!');
    }
  }

  /**
   * Generate unique order invoice number for SePay
   */
  private generateOrderNumber(): string {
    const timestamp = Date.now().toString(36).toUpperCase();
    const random = crypto.randomBytes(4).toString('hex').toUpperCase();
    return `SHOPIN-${timestamp}-${random}`;
  }

  /**
   * Generate HMAC signature for SePay request validation
   */
  private generateSignature(data: string): string {
    return crypto
      .createHmac('sha256', this.sepayConfig.secretKey)
      .update(data)
      .digest('hex');
  }

  /**
   * Verify webhook signature from SePay
   */
  verifyWebhookSignature(payload: string, signature: string): boolean {
    try {
      // Validate inputs
      if (!payload || !signature) {
        return false;
      }
      
      // Validate hex strings
      const hexRegex = /^[0-9a-fA-F]+$/;
      if (!hexRegex.test(signature) || signature.length % 2 !== 0) {
        this.logger.warn('Invalid signature format');
        return false;
      }
      
      const expectedSignature = this.generateSignature(payload);
      
      // Validate buffers before comparison
      let signatureBuffer: Buffer;
      let expectedBuffer: Buffer;
      
      try {
        signatureBuffer = Buffer.from(signature, 'hex');
        expectedBuffer = Buffer.from(expectedSignature, 'hex');
      } catch (error) {
        this.logger.warn('Failed to parse signature buffers');
        return false;
      }
      
      // Check lengths match before timing-safe comparison
      if (signatureBuffer.length !== expectedBuffer.length) {
        return false;
      }
      
      return crypto.timingSafeEqual(expectedBuffer, signatureBuffer);
    } catch (error) {
      this.logger.error('Signature verification error', error);
      return false;
    }
  }

  /**
   * Create a SePay checkout session
   */
  async createSepayPayment(dto: CreateSepayPaymentDto, userId: string): Promise<CreatePaymentResponseDto> {
    this.logger.log(`Creating SePay payment for order ${dto.orderId}, amount: ${dto.amount}, userId: ${userId}`);

    // Validate order exists and belongs to user
    const { data: order, error: orderError } = await this.supabaseService
      .getClient()
      .from('orders')
      .select('id, total, status, payment_status, profile_id')
      .eq('id', dto.orderId)
      .single();

    if (orderError || !order) {
      this.logger.error(`Order not found: ${dto.orderId}, error: ${orderError?.message}`);
      throw new NotFoundException('Đơn hàng không tồn tại');
    }

    this.logger.log(`Order found: ${order.id}, profile_id: ${order.profile_id}, requesting user: ${userId}`);

    // Verify order belongs to user
    if (order.profile_id !== userId) {
      this.logger.warn(`User ${userId} tried to pay for order ${dto.orderId} belonging to ${order.profile_id}`);
      throw new BadRequestException('Bạn không có quyền thanh toán đơn hàng này');
    }

    // Check if order is already paid
    if (order.payment_status === 'paid') {
      throw new BadRequestException('Đơn hàng đã được thanh toán');
    }

    // Validate amount matches order total
    if (Math.abs(dto.amount - Number(order.total)) > 1) {
      this.logger.warn(`Amount mismatch: received ${dto.amount}, expected ${order.total}`);
      throw new BadRequestException('Số tiền không khớp với đơn hàng');
    }

    // Generate unique order number for SePay
    const orderNumber = this.generateOrderNumber();

    // Create payment transaction record (check for duplicates first)
    const { data: existingTransaction } = await this.supabaseService
      .getClient()
      .from('payment_transactions')
      .select('id, transaction_id, status')
      .eq('order_id', dto.orderId)
      .eq('status', 'pending')
      .single();
    
    if (existingTransaction) {
      this.logger.log(`Reusing existing pending transaction for order ${dto.orderId}`);
      // Return existing transaction instead of creating duplicate
      const existingCheckoutUrl = this.sepayClient.checkout.initCheckoutUrl();
      const existingFormFields = this.sepayClient.checkout.initOneTimePaymentFields({
        operation: 'PURCHASE',
        payment_method: 'BANK_TRANSFER',
        order_invoice_number: orderNumber,
        order_amount: dto.amount,
        currency: 'VND',
        order_description: `Thanh toán đơn hàng ${orderNumber}`,
        success_url: dto.returnUrl || `${this.frontendUrl}/orders/success?orderId=${dto.orderId}`,
        error_url: dto.cancelUrl || `${this.frontendUrl}/checkout?cancelled=true&orderId=${dto.orderId}`,
        cancel_url: dto.cancelUrl || `${this.frontendUrl}/checkout?cancelled=true&orderId=${dto.orderId}`,
      });
      
      return {
        checkoutUrl: existingCheckoutUrl,
        paymentId: existingTransaction.id,
        orderNumber,
        formFields: existingFormFields,
      };
    }
    
    const { data: transaction, error: transactionError } = await this.supabaseService
      .getClient()
      .from('payment_transactions')
      .insert({
        order_id: dto.orderId,
        provider: 'sepay',
        order_invoice_number: orderNumber,
        amount: dto.amount,
        currency: 'VND',
        status: 'pending',
      })
      .select()
      .single();

    if (transactionError) {
      this.logger.error(`Failed to create payment transaction: ${transactionError.message}`);
      throw new InternalServerErrorException('Không thể tạo giao dịch thanh toán');
    }

    // Build return URLs
    const returnUrl = dto.returnUrl || `${this.frontendUrl}/orders/success?orderId=${dto.orderId}`;
    const cancelUrl = dto.cancelUrl || `${this.frontendUrl}/checkout?cancelled=true&orderId=${dto.orderId}`;
    const webhookUrl = `${this.configService.get('API_URL') || 'http://localhost:3000'}/api/payments/sepay/webhook`;

    // Use official SePay SDK to create checkout
    const checkoutUrl = this.sepayClient.checkout.initCheckoutUrl();
    const checkoutFormFields = this.sepayClient.checkout.initOneTimePaymentFields({
      operation: 'PURCHASE',
      payment_method: 'BANK_TRANSFER',  // QR Bank Transfer
      order_invoice_number: orderNumber,
      order_amount: dto.amount,  // Number type
      currency: 'VND',
      order_description: `Thanh toán đơn hàng ${orderNumber}`,
      success_url: returnUrl,
      error_url: cancelUrl,
      cancel_url: cancelUrl,
    });

    this.logger.log(`Created SePay checkout URL for order ${orderNumber}`);

    return {
      checkoutUrl,
      paymentId: transaction.id,
      orderNumber,
      formFields: checkoutFormFields, // Return form fields for frontend to render
    };
  }

  /**
   * Handle SePay webhook callback
   */
  async handleSepayWebhook(webhookData: SepayWebhookDto, signature: string): Promise<{ success: boolean; message: string }> {
    this.logger.log(`Received SePay webhook for order ${webhookData.orderNumber}`);

    // Verify signature (skip in sandbox for testing)
    if (this.sepayConfig.environment === 'production') {
      const payload = JSON.stringify(webhookData);
      if (!this.verifyWebhookSignature(payload, signature)) {
        this.logger.error('Invalid webhook signature');
        throw new BadRequestException('Invalid signature');
      }
    }

    // Find payment transaction by order number
    const { data: transaction, error: findError } = await this.supabaseService
      .getClient()
      .from('payment_transactions')
      .select('id, order_id, status')
      .eq('order_invoice_number', webhookData.orderNumber)
      .single();

    if (findError || !transaction) {
      this.logger.error(`Transaction not found for order ${webhookData.orderNumber}`);
      throw new NotFoundException('Giao dịch không tồn tại');
    }

    // Prevent duplicate processing
    if (transaction.status === 'success') {
      this.logger.warn(`Transaction ${webhookData.orderNumber} already processed`);
      return { success: true, message: 'Transaction already processed' };
    }

    // Map SePay status to our status
    const statusMap: Record<string, 'success' | 'failed' | 'cancelled' | 'pending'> = {
      'SUCCESS': 'success',
      'COMPLETED': 'success',
      'PAID': 'success',
      'FAILED': 'failed',
      'CANCELLED': 'cancelled',
      'EXPIRED': 'cancelled',
      'PENDING': 'pending',
    };

    const newStatus = statusMap[webhookData.status.toUpperCase()] || 'pending';

    // Update payment transaction
    const { data: updateData, error: updateError } = await this.supabaseService
      .getClient()
      .from('payment_transactions')
      .update({
        status: newStatus,
        transaction_id: webhookData.transactionId,
        payment_method: webhookData.paymentMethod,
        raw_response: webhookData,
        updated_at: new Date().toISOString(),
      })
      .eq('id', transaction.id)
      .select();

    if (updateError || !updateData) {
      this.logger.error(`Failed to update transaction: ${updateError?.message}`, {
        code: updateError?.code,
        details: updateError?.details
      });
      throw new InternalServerErrorException('Không thể cập nhật giao dịch');
    }

    // If payment successful, update order status and clear cart
    if (newStatus === 'success') {
      // First, get order to retrieve profile_id for cart clearing
      const { data: orderData } = await this.supabaseService
        .getClient()
        .from('orders')
        .select('id, profile_id')
        .eq('id', transaction.order_id)
        .single();

      // Update order status
      const { data: orderUpdateData, error: orderUpdateError } = await this.supabaseService
        .getClient()
        .from('orders')
        .update({
          payment_status: 'paid',
          status: 'confirmed',
          updated_at: new Date().toISOString(),
        })
        .eq('id', transaction.order_id)
        .select();

      if (orderUpdateError || !orderUpdateData) {
        this.logger.error(`Failed to update order status: ${orderUpdateError?.message}`, {
          code: orderUpdateError?.code,
          details: orderUpdateError?.details,
          orderId: transaction.order_id
        });
        throw new InternalServerErrorException('Thanh toán thành công nhưng không thể cập nhật đơn hàng');
      } else {
        this.logger.log(`Order ${transaction.order_id} marked as paid and confirmed`);
      }

      // Clear cart after successful payment
      if (orderData?.profile_id) {
        try {
          await this.cartService.clearCart(orderData.profile_id);
          this.logger.log(`Cleared cart for user ${orderData.profile_id} after successful payment`);
        } catch (cartError) {
          this.logger.error(`Failed to clear cart: ${cartError.message}`);
          // Don't throw - payment was successful, user can manually clear cart
        }
      }
    }

    return { success: true, message: `Payment ${newStatus}` };
  }

  /**
   * Get payment status for an order
   */
  async getPaymentStatus(orderId: string, userId: string): Promise<PaymentStatusResponseDto> {
    // Verify order belongs to user
    const { data: order, error: orderError } = await this.supabaseService
      .getClient()
      .from('orders')
      .select('id, profile_id, payment_status')
      .eq('id', orderId)
      .single();

    if (orderError || !order) {
      throw new NotFoundException('Đơn hàng không tồn tại');
    }

    if (order.profile_id !== userId) {
      throw new BadRequestException('Bạn không có quyền xem thông tin thanh toán này');
    }

    // Get latest payment transaction
    const { data: transaction, error: txError } = await this.supabaseService
      .getClient()
      .from('payment_transactions')
      .select('*')
      .eq('order_id', orderId)
      .order('created_at', { ascending: false })
      .limit(1)
      .single();

    if (txError || !transaction) {
      return {
        status: 'pending',
        orderId,
        message: 'Chưa có giao dịch thanh toán',
      };
    }

    return {
      status: transaction.status,
      orderId,
      transactionId: transaction.transaction_id,
      message: transaction.status === 'success' ? 'Thanh toán thành công' : undefined,
    };
  }

  /**
   * Verify payment after redirect from SePay
   */
  async verifyPaymentReturn(orderId: string, transactionId: string, userId: string): Promise<PaymentStatusResponseDto> {
    this.logger.log(`Verifying payment return for order ${orderId}, transaction ${transactionId}`);

    // Verify order belongs to user
    const { data: order, error: orderError } = await this.supabaseService
      .getClient()
      .from('orders')
      .select('id, profile_id, payment_status')
      .eq('id', orderId)
      .single();

    if (orderError || !order) {
      throw new NotFoundException('Đơn hàng không tồn tại');
    }

    if (order.profile_id !== userId) {
      throw new BadRequestException('Bạn không có quyền xác minh thanh toán này');
    }

    // Check if already paid
    if (order.payment_status === 'paid') {
      return {
        status: 'success',
        orderId,
        transactionId,
        message: 'Đơn hàng đã được thanh toán',
      };
    }

    // Find the transaction
    const { data: transaction } = await this.supabaseService
      .getClient()
      .from('payment_transactions')
      .select('*')
      .eq('order_id', orderId)
      .order('created_at', { ascending: false })
      .limit(1)
      .single();

    if (!transaction) {
      return {
        status: 'pending',
        orderId,
        message: 'Không tìm thấy giao dịch thanh toán',
      };
    }

    // In sandbox mode ONLY (and not in production NODE_ENV), simulate verification
    // This is a SECURITY CRITICAL check - never allow in production
    const isAllowedSandbox = this.sepayConfig.environment === 'sandbox' && 
                             process.env.NODE_ENV !== 'production';
    
    if (isAllowedSandbox && transaction.status === 'pending') {
      // For sandbox testing: if transactionId matches expected format, mark as success
      if (transactionId && transactionId.startsWith('TXN')) {
        this.logger.warn(`SANDBOX: Simulating payment verification for ${transactionId}`);
        
        await this.supabaseService
          .getClient()
          .from('payment_transactions')
          .update({
            status: 'success',
            transaction_id: transactionId,
            updated_at: new Date().toISOString(),
          })
          .eq('id', transaction.id);

        await this.supabaseService
          .getClient()
          .from('orders')
          .update({
            payment_status: 'paid',
            status: 'confirmed',
            updated_at: new Date().toISOString(),
          })
          .eq('id', orderId);

        return {
          status: 'success',
          orderId,
          transactionId,
          message: 'Thanh toán thành công (sandbox)',
        };
      }
    }

    return {
      status: transaction.status,
      orderId,
      transactionId: transaction.transaction_id,
      message: transaction.status === 'success' ? 'Thanh toán thành công' : 'Đang xử lý thanh toán',
    };
  }
}
