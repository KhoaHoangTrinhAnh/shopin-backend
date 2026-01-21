import {
  Controller,
  Get,
  Post,
  Put,
  Patch,
  Body,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { AdminGuard } from './guards/admin.guard';
import { Profile } from '../decorators/profile.decorator';
import { AdminService } from './admin.service';
import { PaginationQueryDto, UpdateOrderStatusDto, ConfirmOrderDto } from './dto/admin.dto';

@Controller('admin')
@UseGuards(JwtAuthGuard, AdminGuard)
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  // =========================================================================
  // DASHBOARD
  // =========================================================================

  /**
   * Get dashboard statistics
   */
  @Get('dashboard')
  async getDashboardStats() {
    return this.adminService.getDashboardStats();
  }

  // =========================================================================
  // ORDERS
  // =========================================================================

  /**
   * Get all orders with pagination
   */
  @Get('orders')
  async getOrders(@Query() query: PaginationQueryDto) {
    return this.adminService.getOrders(query);
  }

  /**
   * Get order detail
   */
  @Get('orders/:id')
  async getOrderDetail(@Param('id') id: string) {
    return this.adminService.getOrderDetail(id);
  }

  /**
   * Confirm order
   */
  @Post('orders/:id/confirm')
  async confirmOrder(
    @Param('id') id: string,
    @Profile() profile: { id: string },
    @Body() dto: ConfirmOrderDto,
  ) {
    return this.adminService.confirmOrder(id, profile.id, dto);
  }

  /**
   * Update order status
   */
  @Put('orders/:id/status')
  async updateOrderStatus(
    @Param('id') id: string,
    @Profile() profile: { id: string },
    @Body() dto: UpdateOrderStatusDto,
  ) {
    return this.adminService.updateOrderStatus(id, profile.id, dto);
  }

  /**
   * Get pending cancellation requests
   */
  @Get('orders/cancellations/pending')
  async getPendingCancellations(@Query() query: PaginationQueryDto) {
    return this.adminService.getPendingCancellations(query);
  }

  /**
   * Approve cancellation request
   */
  @Post('orders/:id/cancellation/approve')
  async approveCancellation(
    @Param('id') id: string,
    @Profile() profile: { id: string },
  ) {
    return this.adminService.approveCancellation(id, profile.id);
  }

  /**
   * Reject cancellation request
   */
  @Post('orders/:id/cancellation/reject')
  async rejectCancellation(
    @Param('id') id: string,
    @Profile() profile: { id: string },
    @Body() body: { reason?: string },
  ) {
    return this.adminService.rejectCancellation(id, profile.id, body.reason);
  }

  // =========================================================================
  // USERS
  // =========================================================================

  /**
   * Get all users with pagination
   */
  @Get('users')
  async getUsers(@Query() query: PaginationQueryDto) {
    return this.adminService.getUsers(query);
  }

  /**
   * Get user detail
   */
  @Get('users/:id')
  async getUserDetail(@Param('id') id: string) {
    return this.adminService.getUserDetail(id);
  }

  /**
   * Update user role
   */
  @Patch('users/:id/role')
  async updateUserRole(@Param('id') id: string, @Body() body: { role: 'user' | 'admin' }) {
    return this.adminService.updateUserRole(id, body.role);
  }
}
