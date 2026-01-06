import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import { AddressesService } from '../addresses/addresses.service';
import { CartService } from '../cart/cart.service';
import { CreateOrderDto, OrderResponse, OrdersListResponse, OrderItemResponse } from './dto/orders.dto';
import { randomBytes } from 'crypto';

@Injectable()
export class OrdersService {
  constructor(
    private readonly supabaseService: SupabaseService,
    private readonly addressesService: AddressesService,
    private readonly cartService: CartService,
  ) {}

  /**
   * Generate unique order number in format: SPN-YYMMDD-RANDOM
   * Example: SPN-250103-K8F2
   * Using crypto.randomBytes for collision resistance
   */
  private generateOrderNumber(): string {
    const now = new Date();
    const yy = now.getFullYear().toString().slice(-2);
    const mm = String(now.getMonth() + 1).padStart(2, '0');
    const dd = String(now.getDate()).padStart(2, '0');
    const dateStr = `${yy}${mm}${dd}`;
    const random = randomBytes(2).toString('hex').toUpperCase();
    return `SPN-${dateStr}-${random}`;
  }

  /**
   * Create order from cart
   */
  async createOrder(profileId: string, dto: CreateOrderDto): Promise<OrderResponse> {
    const supabase = this.supabaseService.getClient();

    // Get cart items
    const cart = await this.cartService.getCart(profileId);

    if (!cart.items || cart.items.length === 0) {
      throw new BadRequestException('Cart is empty');
    }

    // Get address
    let addressSnapshot = dto.address;
    if (dto.address_id) {
      const address = await this.addressesService.getAddressById(profileId, dto.address_id);
      addressSnapshot = {
        full_name: address.full_name,
        phone: address.phone,
        address_line: address.address_line,
        ward: address.ward || undefined,
        district: address.district || undefined,
        city: address.city || undefined,
      };
    }

    if (!addressSnapshot) {
      // Try to get default address
      const defaultAddr = await this.addressesService.getDefaultAddress(profileId);
      if (!defaultAddr) {
        throw new BadRequestException('Please provide a delivery address');
      }
      addressSnapshot = {
        full_name: defaultAddr.full_name,
        phone: defaultAddr.phone,
        address_line: defaultAddr.address_line,
        ward: defaultAddr.ward || undefined,
        district: defaultAddr.district || undefined,
        city: defaultAddr.city || undefined,
      };
    }

    const subtotal = cart.total_price;
    const shippingFee = subtotal >= 500000 ? 0 : 30000; // Free shipping over 500k
    const total = subtotal + shippingFee;

    // Create order
    const { data: order, error: orderError } = await supabase
      .from('orders')
      .insert({
        profile_id: profileId,
        order_number: this.generateOrderNumber(),
        status: 'confirmed', // Auto confirm as per requirement
        subtotal,
        shipping_fee: shippingFee,
        total,
        address: addressSnapshot,
        payment_method: dto.payment_method || 'cod',
        note: dto.note || null,
        coupon_code: dto.coupon_code || null,
      })
      .select('*')
      .single();

    if (orderError || !order) {
      throw new BadRequestException('Failed to create order');
    }

    // Create order items
    const orderItems = cart.items.map((item) => ({
      order_id: order.id,
      product_id: item.product_id,
      variant_id: item.variant_id,
      variant_name: item.variant?.attributes 
        ? Object.values(item.variant.attributes).join(' - ')
        : null,
      product_name: item.product?.name || 'Product',
      main_image: item.variant?.main_image || null,
      qty: item.qty,
      unit_price: item.unit_price,
    }));

    const { error: itemsError } = await supabase
      .from('order_items')
      .insert(orderItems);

    if (itemsError) {
      // Rollback order
      const { error: deleteError } = await supabase
        .from('orders')
        .delete()
        .eq('id', order.id);
      
      if (deleteError) {
        throw new BadRequestException('Failed to create order items and rollback failed. Please contact support.');
      }
      throw new BadRequestException(`Failed to create order items: ${itemsError.message}`);
    }

    // Clear cart after successful order
    try {
      await this.cartService.clearCart(profileId);
    } catch (clearError) {
      // Log error but don't fail the order creation
      console.error('Failed to clear cart after order:', clearError);
    }

    // Fetch complete order with items
    return this.getOrderById(profileId, order.id);
  }

  /**
   * Get order by ID
   */
  async getOrderById(profileId: string, orderId: string): Promise<OrderResponse> {
    const supabase = this.supabaseService.getClient();

    const { data: order, error } = await supabase
      .from('orders')
      .select('*')
      .eq('id', orderId)
      .eq('profile_id', profileId)
      .single();

    if (error || !order) {
      throw new NotFoundException('Order not found');
    }

    const { data: items } = await supabase
      .from('order_items')
      .select('*')
      .eq('order_id', orderId);

    const formattedItems: OrderItemResponse[] = (items || []).map((item) => ({
      id: item.id,
      product_id: item.product_id,
      variant_id: item.variant_id,
      variant_name: item.variant_name,
      product_name: item.product_name,
      main_image: item.main_image,
      qty: item.qty,
      unit_price: item.unit_price,
      total_price: item.qty * item.unit_price,
    }));

    // Parse address from JSON if it's a string
    let parsedAddress = order.address;
    if (typeof order.address === 'string') {
      try {
        parsedAddress = JSON.parse(order.address);
      } catch (e) {
        parsedAddress = null;
      }
    }

    return {
      id: order.id,
      order_number: order.order_number,
      profile_id: order.profile_id,
      status: order.status,
      subtotal: order.subtotal,
      shipping_fee: order.shipping_fee,
      total: order.total,
      address: parsedAddress,
      payment_method: order.payment_method,
      note: order.note,
      coupon_code: order.coupon_code,
      placed_at: order.placed_at,
      updated_at: order.updated_at,
      items: formattedItems,
    };
  }

  /**
   * Get all orders for a user
   */
  async getOrders(profileId: string, page: number = 1, limit: number = 10): Promise<OrdersListResponse> {
    const supabase = this.supabaseService.getClient();
    const offset = (page - 1) * limit;

    // Get total count
    const { count } = await supabase
      .from('orders')
      .select('id', { count: 'exact', head: true })
      .eq('profile_id', profileId);

    const total = count || 0;
    const totalPages = Math.ceil(total / limit);

    // Get orders
    const { data: orders, error } = await supabase
      .from('orders')
      .select('*')
      .eq('profile_id', profileId)
      .order('placed_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (error) {
      throw new BadRequestException('Failed to fetch orders');
    }

    // Get items for each order
    const orderIds = (orders || []).map((o) => o.id);
    const { data: allItems } = await supabase
      .from('order_items')
      .select('*')
      .in('order_id', orderIds);

    const itemsByOrder = (allItems || []).reduce((acc, item) => {
      if (!acc[item.order_id]) acc[item.order_id] = [];
      acc[item.order_id].push(item);
      return acc;
    }, {} as Record<string, typeof allItems>);

    const formattedOrders: OrderResponse[] = (orders || []).map((order) => {
      // Parse address from JSON if it's a string
      let parsedAddress = order.address;
      if (typeof order.address === 'string') {
        try {
          parsedAddress = JSON.parse(order.address);
        } catch (e) {
          parsedAddress = null;
        }
      }

      return {
        id: order.id,
        order_number: order.order_number,
        profile_id: order.profile_id,
        status: order.status,
        subtotal: order.subtotal,
        shipping_fee: order.shipping_fee,
        total: order.total,
        address: parsedAddress,
        payment_method: order.payment_method,
        note: order.note,
        coupon_code: order.coupon_code,
        placed_at: order.placed_at,
        updated_at: order.updated_at,
        items: (itemsByOrder[order.id] || []).map((item) => ({
          id: item.id,
          product_id: item.product_id,
          variant_id: item.variant_id,
          variant_name: item.variant_name,
          product_name: item.product_name,
          main_image: item.main_image,
          qty: item.qty,
          unit_price: item.unit_price,
          total_price: item.qty * item.unit_price,
        })),
      };
    });

    return {
      items: formattedOrders,
      total,
      page,
      limit,
      totalPages,
    };
  }

  /**
   * Get most recent order (for success page)
   */
  async getLatestOrder(profileId: string): Promise<OrderResponse | null> {
    const supabase = this.supabaseService.getClient();

    const { data: order } = await supabase
      .from('orders')
      .select('*')
      .eq('profile_id', profileId)
      .order('placed_at', { ascending: false })
      .limit(1)
      .single();

    if (!order) return null;

    return this.getOrderById(profileId, order.id);
  }

  /**
   * Request order cancellation
   * Only allowed when status is 'pending' or 'confirmed'
   */
  async requestCancellation(profileId: string, orderId: string, reason?: string): Promise<OrderResponse> {
    const supabase = this.supabaseService.getClient();

    // Find order and verify ownership
    const { data: order, error: findError } = await supabase
      .from('orders')
      .select('id, profile_id, status, cancellation_requested')
      .eq('id', orderId)
      .eq('profile_id', profileId)
      .single();

    if (findError || !order) {
      throw new NotFoundException('Không tìm thấy đơn hàng');
    }

    // Check if order can be cancelled
    if (!['pending', 'confirmed'].includes(order.status)) {
      throw new BadRequestException('Chỉ có thể yêu cầu hủy đơn hàng ở trạng thái "Chờ xác nhận" hoặc "Đã xác nhận"');
    }

    if (order.cancellation_requested) {
      throw new BadRequestException('Đơn hàng này đã có yêu cầu hủy đang chờ xử lý');
    }

    // Update order with cancellation request
    const { error: updateError } = await supabase
      .from('orders')
      .update({
        cancellation_requested: true,
        cancellation_requested_at: new Date().toISOString(),
        cancellation_reason: reason || 'Khách hàng yêu cầu hủy đơn',
        updated_at: new Date().toISOString(),
      })
      .eq('id', orderId)
      .eq('profile_id', profileId);

    if (updateError) {
      throw new BadRequestException(`Lỗi khi gửi yêu cầu hủy đơn: ${updateError.message}`);
    }

    return this.getOrderById(profileId, orderId);
  }
}
