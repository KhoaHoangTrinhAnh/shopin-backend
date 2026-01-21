import {
  Controller,
  Get,
  Post,
  Put,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { AdminGuard } from './guards/admin.guard';
import { Profile } from '../decorators/profile.decorator';
import { AdminService } from './admin.service';
import { 
  PaginationQueryDto, 
  UpdateOrderStatusDto, 
  ConfirmOrderDto,
  CreateProductDto,
  UpdateProductDto,
  CreateProductVariantDto,
  UpdateProductVariantDto,
} from './dto/admin.dto';

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
   * Get pending cancellation requests
   * NOTE: Must be before @Get('orders/:id') to avoid route conflict
   */
  @Get('orders/cancellations/pending')
  async getPendingCancellations(@Query() query: PaginationQueryDto) {
    return this.adminService.getPendingCancellations(query);
  }

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
   * Get user orders
   */
  @Get('users/:id/orders')
  async getUserOrders(@Param('id') id: string, @Query() query: PaginationQueryDto) {
    return this.adminService.getUserOrders(id, query);
  }

  /**
   * Update user role
   */
  @Patch('users/:id/role')
  async updateUserRole(@Param('id') id: string, @Body() body: { role: 'user' | 'admin' }) {
    return this.adminService.updateUserRole(id, body.role);
  }

  /**
   * Toggle user enabled/disabled status
   */
  @Patch('users/:id/toggle-enabled')
  async toggleUserEnabled(@Param('id') id: string) {
    return this.adminService.toggleUserEnabled(id);
  }

  /**
   * Toggle user chat block status
   */
  @Patch('users/:id/toggle-chat-block')
  async toggleUserChatBlock(@Param('id') id: string) {
    return this.adminService.toggleUserChatBlock(id);
  }

  /**
   * Soft delete user
   */
  @Delete('users/:id')
  async softDeleteUser(@Param('id') id: string) {
    return this.adminService.softDeleteUser(id);
  }

  // =========================================================================
  // PRODUCTS
  // =========================================================================

  /**
   * Get all products with pagination
   */
  @Get('products')
  async getProducts(@Query() query: PaginationQueryDto) {
    return this.adminService.getProducts(query);
  }

  /**
   * Get product detail
   */
  @Get('products/:id')
  async getProductDetail(@Param('id') id: string) {
    return this.adminService.getProductDetail(id);
  }

  /**
   * Create product
   */
  @Post('products')
  async createProduct(@Body() dto: CreateProductDto) {
    return this.adminService.createProduct(dto);
  }

  /**
   * Update product
   */
  @Put('products/:id')
  async updateProduct(@Param('id') id: string, @Body() dto: UpdateProductDto) {
    return this.adminService.updateProduct(id, dto);
  }

  /**
   * Delete product
   */
  @Delete('products/:id')
  async deleteProduct(@Param('id') id: string) {
    return this.adminService.deleteProduct(id);
  }

  /**
   * Toggle product active status
   */
  @Patch('products/:id/toggle-active')
  async toggleProductActive(@Param('id') id: string) {
    return this.adminService.toggleProductActive(id);
  }

  /**
   * Get product variants
   */
  @Get('products/:id/variants')
  async getProductVariants(@Param('id') id: string) {
    return this.adminService.getProductVariants(id);
  }

  /**
   * Create product variant
   */
  @Post('products/:id/variants')
  async createProductVariant(
    @Param('id') productId: string,
    @Body() dto: CreateProductVariantDto
  ) {
    return this.adminService.createProductVariant({ ...dto, product_id: productId });
  }

  /**
   * Update product variant
   */
  @Put('products/:productId/variants/:variantId')
  async updateProductVariant(
    @Param('productId') productId: string,
    @Param('variantId') variantId: string,
    @Body() dto: UpdateProductVariantDto
  ) {
    return this.adminService.updateProductVariant(variantId, dto);
  }

  /**
   * Delete product variant
   */
  @Delete('products/:productId/variants/:variantId')
  async deleteProductVariant(
    @Param('productId') productId: string,
    @Param('variantId') variantId: string
  ) {
    return this.adminService.deleteProductVariant(variantId);
  }
}
