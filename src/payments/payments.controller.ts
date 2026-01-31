import {
  Controller,
  Post,
  Get,
  Body,
  Query,
  Param,
  Headers,
  HttpCode,
  HttpStatus,
  UseGuards,
  Req,
  Logger,
} from '@nestjs/common';
import { PaymentsService } from './payments.service';
import {
  CreateSepayPaymentDto,
  CreatePaymentResponseDto,
  PaymentStatusResponseDto,
  SepayWebhookDto,
  VerifyPaymentDto,
} from './dto/create-payment.dto';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';

@Controller('payments')
export class PaymentsController {
  private readonly logger = new Logger(PaymentsController.name);

  constructor(private readonly paymentsService: PaymentsService) {}

  @Post('sepay/create')
  @UseGuards(JwtAuthGuard)
  async createSepayPayment(
    @Body() dto: CreateSepayPaymentDto,
    @Req() req: any,
  ): Promise<CreatePaymentResponseDto> {
    const userId = req.user?.sub || req.user?.id;
    this.logger.log(`Creating SePay payment for user ${userId}, order ${dto.orderId}`);
    return this.paymentsService.createSepayPayment(dto, userId);
  }

  @Post('sepay/webhook')
  @HttpCode(HttpStatus.OK)
  async handleSepayWebhook(
    @Body() webhookData: SepayWebhookDto,
    @Headers('x-sepay-signature') signature: string,
  ): Promise<{ success: boolean; message: string }> {
    this.logger.log(`Received SePay webhook for order: ${webhookData.orderNumber}, tx: ${webhookData.transactionId}`);
    
    if (!signature) {
      this.logger.error('Webhook signature missing');
      throw new BadRequestException('Signature required');
    }
    
    return this.paymentsService.handleSepayWebhook(webhookData, signature);
  }

  @Get('status/:orderId')
  @UseGuards(JwtAuthGuard)
  async getPaymentStatus(
    @Param('orderId') orderId: string,
    @Req() req: any,
  ): Promise<PaymentStatusResponseDto> {
    const userId = req.user?.sub || req.user?.id;
    return this.paymentsService.getPaymentStatus(orderId, userId);
  }

  @Post('verify')
  @UseGuards(JwtAuthGuard)
  async verifyPayment(
    @Body() dto: VerifyPaymentDto,
    @Req() req: any,
  ): Promise<PaymentStatusResponseDto> {
    const userId = req.user?.sub || req.user?.id;
    this.logger.log(`Verifying payment for order ${dto.orderId}`);
    return this.paymentsService.verifyPaymentReturn(dto.orderId, dto.transactionId, userId);
  }

  @Get('sepay/return')
  async handleSepayReturn(
    @Query('orderNumber') orderNumber: string,
    @Query('transactionId') transactionId: string,
    @Query('status') status: string,
  ): Promise<{ redirectUrl: string; status: string }> {
    // Validate and sanitize parameters
    const validStatuses = ['success', 'failed', 'pending', 'cancelled'];
    const transactionIdRegex = /^[A-Za-z0-9_-]{1,64}$/;
    
    if (!transactionId || !transactionIdRegex.test(transactionId)) {
      this.logger.warn(`Invalid transactionId format: ${transactionId}`);
      return {
        redirectUrl: '/orders/error',
        status: 'error',
      };
    }
    
    const sanitizedStatus = validStatuses.includes(status) ? status : 'unknown';
    
    this.logger.log(`SePay return: order=${orderNumber}, tx=${transactionId}, status=${sanitizedStatus}`);
    
    // This endpoint handles the redirect from SePay after payment
    // The frontend will call /verify to confirm the payment
    return {
      redirectUrl: `/orders/success?transactionId=${encodeURIComponent(transactionId)}&status=${encodeURIComponent(sanitizedStatus)}`,
      status: sanitizedStatus,
    };
  }
}
