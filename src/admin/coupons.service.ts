import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import { CreateCouponDto, UpdateCouponDto, PaginationQueryDto } from './dto/admin.dto';

@Injectable()
export class CouponsService {
  constructor(private readonly supabaseService: SupabaseService) {}

  /**
   * Get all coupons with pagination
   */
  async findAll(query: PaginationQueryDto) {
    const { page = 1, limit = 20, search, status, sort = 'created_at', order = 'desc' } = query;
    const offset = (page - 1) * limit;

    const supabase = this.supabaseService.getClient();
    let queryBuilder = supabase
      .from('coupons')
      .select('*', { count: 'exact' });

    // Apply filters
    if (search) {
      queryBuilder = queryBuilder.or(`code.ilike.%${search}%,description.ilike.%${search}%`);
    }

    if (status === 'active') {
      queryBuilder = queryBuilder.eq('is_active', true);
    } else if (status === 'inactive') {
      queryBuilder = queryBuilder.eq('is_active', false);
    }

    // Apply sorting
    queryBuilder = queryBuilder.order(sort, { ascending: order === 'asc' });

    // Apply pagination
    queryBuilder = queryBuilder.range(offset, offset + limit - 1);

    const { data, error, count } = await queryBuilder;

    if (error) {
      throw new BadRequestException(`Lỗi khi lấy danh sách mã giảm giá: ${error.message}`);
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
   * Get a single coupon by ID
   */
  async findOne(id: string) {
    const supabase = this.supabaseService.getClient();

    const { data, error } = await supabase
      .from('coupons')
      .select('*')
      .eq('id', id)
      .single();

    if (error) {
      throw new NotFoundException(`Không tìm thấy mã giảm giá với ID: ${id}`);
    }

    return data;
  }

  /**
   * Create a new coupon
   */
  async create(dto: CreateCouponDto) {
    const supabase = this.supabaseService.getClient();

    // Check code uniqueness
    const { data: existing } = await supabase
      .from('coupons')
      .select('id')
      .eq('code', dto.code.toUpperCase())
      .single();

    if (existing) {
      throw new BadRequestException(`Mã giảm giá ${dto.code} đã tồn tại`);
    }

    const couponData = {
      ...dto,
      code: dto.code.toUpperCase(),
      is_active: dto.is_active ?? true,
    };

    const { data, error } = await supabase
      .from('coupons')
      .insert(couponData)
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Lỗi khi tạo mã giảm giá: ${error.message}`);
    }

    return data;
  }

  /**
   * Update a coupon
   */
  async update(id: string, dto: UpdateCouponDto) {
    const supabase = this.supabaseService.getClient();

    // Check coupon exists
    const { data: existing, error: findError } = await supabase
      .from('coupons')
      .select('id')
      .eq('id', id)
      .single();

    if (findError || !existing) {
      throw new NotFoundException(`Không tìm thấy mã giảm giá với ID: ${id}`);
    }

    // Check code uniqueness if updating code
    if (dto.code) {
      const { data: codeExists } = await supabase
        .from('coupons')
        .select('id')
        .eq('code', dto.code.toUpperCase())
        .neq('id', id)
        .single();

      if (codeExists) {
        throw new BadRequestException(`Mã giảm giá ${dto.code} đã tồn tại`);
      }
      dto.code = dto.code.toUpperCase();
    }

    const updateData = { ...dto, updated_at: new Date().toISOString() };

    const { data, error } = await supabase
      .from('coupons')
      .update(updateData)
      .eq('id', id)
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Lỗi khi cập nhật mã giảm giá: ${error.message}`);
    }

    return data;
  }

  /**
   * Delete a coupon
   */
  async delete(id: string) {
    const supabase = this.supabaseService.getClient();

    const { error } = await supabase.from('coupons').delete().eq('id', id);

    if (error) {
      throw new BadRequestException(`Lỗi khi xóa mã giảm giá: ${error.message}`);
    }

    return { message: 'Xóa mã giảm giá thành công' };
  }

  /**
   * Toggle coupon active status
   */
  async toggleStatus(id: string) {
    const supabase = this.supabaseService.getClient();

    // Get current status
    const { data: existing, error: findError } = await supabase
      .from('coupons')
      .select('is_active')
      .eq('id', id)
      .single();

    if (findError || !existing) {
      throw new NotFoundException(`Không tìm thấy mã giảm giá với ID: ${id}`);
    }

    const { data, error } = await supabase
      .from('coupons')
      .update({
        is_active: !existing.is_active,
        updated_at: new Date().toISOString(),
      })
      .eq('id', id)
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Lỗi khi thay đổi trạng thái mã giảm giá: ${error.message}`);
    }

    return data;
  }

  /**
   * Validate coupon (public)
   */
  async validateCoupon(code: string, orderTotal: number) {
    const supabase = this.supabaseService.getClient();

    const { data: coupon, error } = await supabase
      .from('coupons')
      .select('*')
      .eq('code', code.toUpperCase())
      .eq('is_active', true)
      .single();

    if (error || !coupon) {
      throw new NotFoundException('Mã giảm giá không hợp lệ');
    }

    // Check expiry
    if (coupon.expires_at && new Date(coupon.expires_at) < new Date()) {
      throw new BadRequestException('Mã giảm giá đã hết hạn');
    }

    // Check start date
    if (coupon.start_date && new Date(coupon.start_date) > new Date()) {
      throw new BadRequestException('Mã giảm giá chưa có hiệu lực');
    }

    // Check usage limit
    if (coupon.usage_limit && coupon.usage_count >= coupon.usage_limit) {
      throw new BadRequestException('Mã giảm giá đã hết lượt sử dụng');
    }

    // Check minimum order value
    if (coupon.min_order_value && orderTotal < coupon.min_order_value) {
      throw new BadRequestException(
        `Đơn hàng cần tối thiểu ${coupon.min_order_value.toLocaleString('vi-VN')}đ để sử dụng mã này`,
      );
    }

    // Calculate discount
    let discount = 0;
    if (coupon.discount_type === 'percentage') {
      discount = (orderTotal * coupon.discount_value) / 100;
      if (coupon.max_discount && discount > coupon.max_discount) {
        discount = coupon.max_discount;
      }
    } else {
      discount = coupon.discount_value;
    }

    return {
      valid: true,
      coupon,
      discount,
    };
  }
}
