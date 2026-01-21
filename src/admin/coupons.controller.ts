import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  Patch,
} from '@nestjs/common';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { AdminGuard } from './guards/admin.guard';
import { CouponsService } from './coupons.service';
import { CreateCouponDto, UpdateCouponDto, PaginationQueryDto } from './dto/admin.dto';

@Controller('admin/coupons')
@UseGuards(JwtAuthGuard, AdminGuard)
export class CouponsController {
  constructor(private readonly couponsService: CouponsService) {}

  /**
   * Get all coupons with pagination
   */
  @Get()
  async findAll(@Query() query: PaginationQueryDto) {
    return this.couponsService.findAll(query);
  }

  /**
   * Get a single coupon by ID
   */
  @Get(':id')
  async findOne(@Param('id') id: string) {
    return this.couponsService.findOne(id);
  }

  /**
   * Create a new coupon
   */
  @Post()
  async create(@Body() dto: CreateCouponDto) {
    return this.couponsService.create(dto);
  }

  /**
   * Update a coupon
   */
  @Put(':id')
  async update(@Param('id') id: string, @Body() dto: UpdateCouponDto) {
    return this.couponsService.update(id, dto);
  }

  /**
   * Delete a coupon
   */
  @Delete(':id')
  async delete(@Param('id') id: string) {
    return this.couponsService.delete(id);
  }

  /**
   * Toggle coupon active status
   */
  @Patch(':id/toggle')
  async toggleStatus(@Param('id') id: string) {
    return this.couponsService.toggleStatus(id);
  }
}

// ============================================================================
// PUBLIC COUPONS CONTROLLER (for validating coupons)
// ============================================================================

@Controller('coupons')
export class PublicCouponsController {
  constructor(private readonly couponsService: CouponsService) {}

  /**
   * Validate a coupon code
   */
  @Post('validate')
  @UseGuards(JwtAuthGuard)
  async validateCoupon(@Body() body: { code: string; orderTotal: number }) {
    return this.couponsService.validateCoupon(body.code, body.orderTotal);
  }
}
