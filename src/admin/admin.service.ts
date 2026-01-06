import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import { PaginationQueryDto, UpdateOrderStatusDto, ConfirmOrderDto } from './dto/admin.dto';

@Injectable()
export class AdminService {
  constructor(private readonly supabaseService: SupabaseService) {}

  // =========================================================================
  // DASHBOARD
  // =========================================================================

  /**
   * Get dashboard statistics
   */
  async getDashboardStats() {
    const supabase = this.supabaseService.getClient();

    // Get current date range (this month)
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1).toISOString();
    const startOfLastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1).toISOString();
    const endOfLastMonth = new Date(now.getFullYear(), now.getMonth(), 0).toISOString();

    // Parallel queries for stats
    const [
      totalOrdersResult,
      lastMonthOrdersResult,
      totalRevenueResult,
      lastMonthRevenueResult,
      totalUsersResult,
      lastMonthUsersResult,
      totalProductsResult,
      pendingOrdersResult,
      recentOrdersResult,
      ordersByStatusResult,
      totalArticlesResult,
    ] = await Promise.all([
      // Total orders this month
      supabase
        .from('orders')
        .select('id', { count: 'exact', head: true })
        .gte('placed_at', startOfMonth),
      // Total orders last month
      supabase
        .from('orders')
        .select('id', { count: 'exact', head: true })
        .gte('placed_at', startOfLastMonth)
        .lte('placed_at', endOfLastMonth),
      // Total revenue this month
      supabase
        .from('orders')
        .select('total')
        .gte('placed_at', startOfMonth)
        .in('status', ['confirmed', 'processing', 'shipping', 'delivered']),
      // Total revenue last month
      supabase
        .from('orders')
        .select('total')
        .gte('placed_at', startOfLastMonth)
        .lte('placed_at', endOfLastMonth)
        .in('status', ['confirmed', 'processing', 'shipping', 'delivered']),
      // Total users
      supabase.from('profiles').select('id', { count: 'exact', head: true }),
      // Users joined last month
      supabase
        .from('profiles')
        .select('id', { count: 'exact', head: true })
        .gte('created_at', startOfLastMonth)
        .lte('created_at', endOfLastMonth),
      // Total products
      supabase.from('products').select('id', { count: 'exact', head: true }).eq('is_active', true),
      // Pending orders
      supabase
        .from('orders')
        .select('id', { count: 'exact', head: true })
        .eq('status', 'pending'),
      // Recent orders
      supabase
        .from('orders')
        .select(`
          id,
          placed_at,
          status,
          total,
          profile_id,
          customer:profiles!orders_profile_id_fkey(id, full_name, email, avatar_url)
        `)
        .order('placed_at', { ascending: false })
        .limit(10),
      // Orders grouped by status
      supabase.rpc('get_orders_count_by_status'),
      // Total articles
      supabase.from('articles').select('id', { count: 'exact', head: true }),
    ]);

    // Calculate revenue
    const thisMonthRevenue = (totalRevenueResult.data || []).reduce(
      (sum: number, order: { total: number }) => sum + (order.total || 0),
      0,
    );
    const lastMonthRevenue = (lastMonthRevenueResult.data || []).reduce(
      (sum: number, order: { total: number }) => sum + (order.total || 0),
      0,
    );

    // Calculate percentage changes
    const ordersChange = this.calculatePercentageChange(
      totalOrdersResult.count || 0,
      lastMonthOrdersResult.count || 0,
    );
    const revenueChange = this.calculatePercentageChange(thisMonthRevenue, lastMonthRevenue);
    const usersThisMonth = (totalUsersResult.count || 0) - (lastMonthUsersResult.count || 0);
    const usersChange = this.calculatePercentageChange(
      usersThisMonth,
      lastMonthUsersResult.count || 0,
    );

    // Process orders by status - fallback if RPC doesn't exist
    let ordersByStatus: Array<{ status: string; count: number }> = [];
    if (ordersByStatusResult.data && Array.isArray(ordersByStatusResult.data)) {
      ordersByStatus = ordersByStatusResult.data;
    } else {
      // Fallback: get counts manually
      const statuses = ['pending', 'confirmed', 'processing', 'shipping', 'delivered', 'cancelled', 'refunded'];
      const statusCounts = await Promise.all(
        statuses.map(async (status) => {
          const { count } = await supabase
            .from('orders')
            .select('id', { count: 'exact', head: true })
            .eq('status', status);
          return { status, count: count || 0 };
        }),
      );
      ordersByStatus = statusCounts;
    }

    return {
      stats: {
        orders: {
          total: totalOrdersResult.count || 0,
          change: ordersChange,
        },
        revenue: {
          total: thisMonthRevenue,
          change: revenueChange,
        },
        users: {
          total: totalUsersResult.count || 0,
          change: usersChange,
        },
        products: {
          total: totalProductsResult.count || 0,
        },
        pendingOrders: pendingOrdersResult.count || 0,
      },
      recentOrders: (recentOrdersResult.data || []).map((order: any) => ({
        ...order,
        total_price: order.total, // Alias for frontend compatibility
        created_at: order.placed_at,
      })),
      ordersByStatus,
      totalArticles: totalArticlesResult.count || 0,
    };
  }

  private calculatePercentageChange(current: number, previous: number): number {
    if (previous === 0) return current > 0 ? 100 : 0;
    return Math.round(((current - previous) / previous) * 100);
  }

  // =========================================================================
  // ORDERS MANAGEMENT
  // =========================================================================

  /**
   * Get all orders with pagination
   */
  async getOrders(query: PaginationQueryDto) {
    const { page = 1, limit = 20, search, status, sort = 'placed_at', order = 'desc' } = query;
    const offset = (page - 1) * limit;

    const supabase = this.supabaseService.getClient();
    let queryBuilder = supabase
      .from('orders')
      .select(
        `
        *,
        customer:profiles!orders_profile_id_fkey(id, full_name, email, phone, avatar_url),
        items:order_items(
          id,
          quantity,
          price,
          product:products(id, name, thumbnail)
        )
      `,
        { count: 'exact' },
      );

    // Apply filters
    if (search) {
      queryBuilder = queryBuilder.or(`id.ilike.%${search}%`);
    }

    if (status) {
      queryBuilder = queryBuilder.eq('status', status);
    }

    // Apply sorting
    queryBuilder = queryBuilder.order(sort, { ascending: order === 'asc' });

    // Apply pagination
    queryBuilder = queryBuilder.range(offset, offset + limit - 1);

    const { data, error, count } = await queryBuilder;

    if (error) {
      throw new BadRequestException(`Lỗi khi lấy danh sách đơn hàng: ${error.message}`);
    }

    return {
      data,
      meta: {
        total: count || 0,
        page,
        limit,
        totalPages: Math.ceil((count || 0) / limit),
      },
    };
  }

  /**
   * Get order detail
   */
  async getOrderDetail(id: string) {
    const supabase = this.supabaseService.getClient();

    const { data, error } = await supabase
      .from('orders')
      .select(
        `
        *,
        customer:profiles!orders_profile_id_fkey(id, full_name, email, phone, avatar_url),
        items:order_items(
          id,
          quantity,
          price,
          product:products(id, name, thumbnail, slug)
        ),
        confirmed_by_admin:profiles!orders_confirmed_by_fkey(id, full_name)
      `,
      )
      .eq('id', id)
      .single();

    if (error) {
      throw new NotFoundException(`Không tìm thấy đơn hàng với ID: ${id}`);
    }

    return data;
  }

  /**
   * Confirm order
   */
  async confirmOrder(id: string, adminId: string, dto: ConfirmOrderDto) {
    const supabase = this.supabaseService.getClient();

    const { data: order, error: findError } = await supabase
      .from('orders')
      .select('id, status')
      .eq('id', id)
      .single();

    if (findError || !order) {
      throw new NotFoundException(`Không tìm thấy đơn hàng với ID: ${id}`);
    }

    if (order.status !== 'pending') {
      throw new BadRequestException('Chỉ có thể xác nhận đơn hàng đang chờ xử lý');
    }

    const { data, error } = await supabase
      .from('orders')
      .update({
        status: 'confirmed',
        confirmed_at: new Date().toISOString(),
        confirmed_by: adminId,
        admin_notes: dto.admin_notes,
        updated_at: new Date().toISOString(),
      })
      .eq('id', id)
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Lỗi khi xác nhận đơn hàng: ${error.message}`);
    }

    return data;
  }

  /**
   * Update order status
   */
  async updateOrderStatus(id: string, adminId: string, dto: UpdateOrderStatusDto) {
    const supabase = this.supabaseService.getClient();

    const { data: order, error: findError } = await supabase
      .from('orders')
      .select('id, status')
      .eq('id', id)
      .single();

    if (findError || !order) {
      throw new NotFoundException(`Không tìm thấy đơn hàng với ID: ${id}`);
    }

    const updateData: Record<string, unknown> = {
      status: dto.status,
      admin_notes: dto.admin_notes,
      updated_at: new Date().toISOString(),
    };

    // Set confirmed info if confirming
    if (dto.status === 'confirmed' && order.status === 'pending') {
      updateData.confirmed_at = new Date().toISOString();
      updateData.confirmed_by = adminId;
    }

    const { data, error } = await supabase
      .from('orders')
      .update(updateData)
      .eq('id', id)
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Lỗi khi cập nhật trạng thái đơn hàng: ${error.message}`);
    }

    return data;
  }

  // =========================================================================
  // USERS MANAGEMENT
  // =========================================================================

  /**
   * Get all users with pagination
   */
  async getUsers(query: PaginationQueryDto) {
    const { page = 1, limit = 20, search, sort = 'created_at', order = 'desc' } = query;
    const offset = (page - 1) * limit;

    const supabase = this.supabaseService.getClient();
    let queryBuilder = supabase
      .from('profiles')
      .select('*', { count: 'exact' });

    // Apply filters
    if (search) {
      queryBuilder = queryBuilder.or(
        `full_name.ilike.%${search}%,email.ilike.%${search}%,phone.ilike.%${search}%`,
      );
    }

    // Apply sorting
    queryBuilder = queryBuilder.order(sort, { ascending: order === 'asc' });

    // Apply pagination
    queryBuilder = queryBuilder.range(offset, offset + limit - 1);

    const { data, error, count } = await queryBuilder;

    if (error) {
      throw new BadRequestException(`Lỗi khi lấy danh sách người dùng: ${error.message}`);
    }

    return {
      data,
      meta: {
        total: count || 0,
        page,
        limit,
        totalPages: Math.ceil((count || 0) / limit),
      },
    };
  }

  /**
   * Get user detail
   */
  async getUserDetail(id: string) {
    const supabase = this.supabaseService.getClient();

    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', id)
      .single();

    if (error) {
      throw new NotFoundException(`Không tìm thấy người dùng với ID: ${id}`);
    }

    // Get user orders count
    const { count: ordersCount } = await supabase
      .from('orders')
      .select('id', { count: 'exact', head: true })
      .eq('user_id', id);

    // Get user addresses
    const { data: addresses } = await supabase
      .from('addresses')
      .select('*')
      .eq('user_id', id);

    return {
      ...data,
      ordersCount: ordersCount || 0,
      addresses: addresses || [],
    };
  }

  /**
   * Update user role
   */
  async updateUserRole(id: string, role: 'user' | 'admin') {
    const supabase = this.supabaseService.getClient();

    const { data, error } = await supabase
      .from('profiles')
      .update({ role, updated_at: new Date().toISOString() })
      .eq('id', id)
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Lỗi khi cập nhật quyền người dùng: ${error.message}`);
    }

    return data;
  }

  // =========================================================================
  // ORDER CANCELLATION MANAGEMENT
  // =========================================================================

  /**
   * Get orders with pending cancellation requests
   */
  async getPendingCancellations(query: PaginationQueryDto) {
    const { page = 1, limit = 20 } = query;
    const offset = (page - 1) * limit;

    const supabase = this.supabaseService.getClient();
    
    const { data, error, count } = await supabase
      .from('orders')
      .select(
        `
        *,
        customer:profiles!orders_profile_id_fkey(id, full_name, email, phone, avatar_url)
      `,
        { count: 'exact' },
      )
      .eq('cancellation_requested', true)
      .is('cancellation_approved', null)
      .order('cancellation_requested_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (error) {
      throw new BadRequestException(`Lỗi khi lấy danh sách yêu cầu hủy: ${error.message}`);
    }

    return {
      data,
      meta: {
        total: count || 0,
        page,
        limit,
        totalPages: Math.ceil((count || 0) / limit),
      },
    };
  }

  /**
   * Approve cancellation request
   */
  async approveCancellation(orderId: string, adminId: string) {
    const supabase = this.supabaseService.getClient();

    const { data: order, error: findError } = await supabase
      .from('orders')
      .select('id, status, cancellation_requested, cancellation_approved')
      .eq('id', orderId)
      .single();

    if (findError || !order) {
      throw new NotFoundException(`Không tìm thấy đơn hàng với ID: ${orderId}`);
    }

    if (!order.cancellation_requested) {
      throw new BadRequestException('Đơn hàng này chưa có yêu cầu hủy');
    }

    if (order.cancellation_approved !== null) {
      throw new BadRequestException('Yêu cầu hủy này đã được xử lý');
    }

    const { data, error } = await supabase
      .from('orders')
      .update({
        status: 'cancelled',
        cancellation_approved: true,
        cancellation_approved_at: new Date().toISOString(),
        cancellation_approved_by: adminId,
        updated_at: new Date().toISOString(),
      })
      .eq('id', orderId)
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Lỗi khi duyệt yêu cầu hủy: ${error.message}`);
    }

    return data;
  }

  /**
   * Reject cancellation request
   */
  async rejectCancellation(orderId: string, adminId: string, reason?: string) {
    const supabase = this.supabaseService.getClient();

    const { data: order, error: findError } = await supabase
      .from('orders')
      .select('id, status, cancellation_requested, cancellation_approved')
      .eq('id', orderId)
      .single();

    if (findError || !order) {
      throw new NotFoundException(`Không tìm thấy đơn hàng với ID: ${orderId}`);
    }

    if (!order.cancellation_requested) {
      throw new BadRequestException('Đơn hàng này chưa có yêu cầu hủy');
    }

    if (order.cancellation_approved !== null) {
      throw new BadRequestException('Yêu cầu hủy này đã được xử lý');
    }

    const { data, error } = await supabase
      .from('orders')
      .update({
        cancellation_approved: false,
        cancellation_approved_at: new Date().toISOString(),
        cancellation_approved_by: adminId,
        admin_notes: reason || 'Yêu cầu hủy đơn bị từ chối',
        updated_at: new Date().toISOString(),
      })
      .eq('id', orderId)
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Lỗi khi từ chối yêu cầu hủy: ${error.message}`);
    }

    return data;
  }
}
