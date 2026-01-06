import { Controller, Get, Post, Put, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { CartService } from './cart.service';
import { AddToCartDto, UpdateCartItemDto, SyncCartDto } from './dto/cart.dto';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { Profile } from '../decorators/profile.decorator';

@Controller('cart')
@UseGuards(JwtAuthGuard)
export class CartController {
  constructor(private readonly cartService: CartService) {}

  /**
   * Add item to cart
   * POST /api/cart/items
   */
  @Post('items')
  async addToCart(@Profile() profile: any, @Body() addToCartDto: AddToCartDto) {
    return this.cartService.addToCart(profile.id, addToCartDto);
  }

  /**
   * Get user's cart
   * GET /api/cart
   */
  @Get()
  async getCart(@Profile() profile: any) {
    return this.cartService.getCart(profile.id);
  }

  /**
   * Update cart item quantity
   * PUT /api/cart/items/:id
   */
  @Put('items/:id')
  async updateCartItem(
    @Profile() profile: any,
    @Param('id') itemId: string,
    @Body() updateDto: UpdateCartItemDto,
  ) {
    return this.cartService.updateCartItem(profile.id, itemId, updateDto);
  }

  /**
   * Remove item from cart
   * DELETE /api/cart/items/:id
   */
  @Delete('items/:id')
  async removeCartItem(@Profile() profile: any, @Param('id') itemId: string) {
    return this.cartService.removeCartItem(profile.id, itemId);
  }

  /**
   * Clear cart
   * DELETE /api/cart
   */
  @Delete()
  async clearCart(@Profile() profile: any) {
    return this.cartService.clearCart(profile.id);
  }

  /**
   * Sync entire cart with optimistic updates
   * POST /api/cart/sync
   */
  @Post('sync')
  async syncCart(@Profile() profile: any, @Body() syncDto: SyncCartDto) {
    return this.cartService.syncCart(profile.id, syncDto);
  }
}
