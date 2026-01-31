import {
  Controller,
  Get,
  Post,
  Param,
  Body,
  Query,
  UseGuards,
  ParseIntPipe,
} from '@nestjs/common';
import { OrdersService } from './orders.service';
import { CreateOrderDto } from './dto/orders.dto';
import { CreateDirectOrderDto } from './dto/create-direct-order.dto';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { Profile } from '../decorators/profile.decorator';

@Controller('orders')
@UseGuards(JwtAuthGuard)
export class OrdersController {
  constructor(private readonly ordersService: OrdersService) {}

  @Post()
  async createOrder(@Profile() profile: any, @Body() dto: CreateOrderDto) {
    console.log('[OrdersController] Creating order for user:', profile.id);
    return this.ordersService.createOrder(profile.id, dto);
  }

  /**
   * Create order directly from a product variant (bypass cart)
   * Used for "Buy Now" functionality
   */
  @Post('direct')
  async createDirectOrder(@Profile() profile: any, @Body() dto: CreateDirectOrderDto) {
    console.log('[OrdersController] Creating direct order for user:', profile.id, 'variant:', dto.variant_id);
    return this.ordersService.createDirectOrder(profile.id, dto);
  }

  @Get()
  async getOrders(
    @Profile() profile: any,
    @Query('page', new ParseIntPipe({ optional: true })) page: number = 1,
    @Query('limit', new ParseIntPipe({ optional: true })) limit: number = 10,
  ) {
    return this.ordersService.getOrders(profile.id, page, limit);
  }

  @Get('latest')
  async getLatestOrder(@Profile() profile: any) {
    const order = await this.ordersService.getLatestOrder(profile.id);
    return { order };
  }

  @Get(':id')
  async getOrderById(@Profile() profile: any, @Param('id') id: string) {
    return this.ordersService.getOrderById(profile.id, id);
  }

  /**
   * Request order cancellation
   */
  @Post(':id/cancel')
  async requestCancellation(
    @Profile() profile: any,
    @Param('id') id: string,
    @Body() body: { reason?: string },
  ) {
    return this.ordersService.requestCancellation(profile.id, id, body.reason);
  }
}
