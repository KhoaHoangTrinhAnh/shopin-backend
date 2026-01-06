import { Injectable, NotFoundException, BadRequestException, ConflictException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import { AddToCartDto, UpdateCartItemDto, CartResponse, CartItemResponse, SyncCartDto } from './dto/cart.dto';

@Injectable()
export class CartService {
  constructor(private readonly supabaseService: SupabaseService) {}

  /**
   * Get or create cart for user
   */
  private async getOrCreateCart(profileId: string): Promise<string> {
    const supabase = this.supabaseService.getClient();

    // Check if cart exists
    const { data: existingCart, error: fetchError } = await supabase
      .from('carts')
      .select('id')
      .eq('profile_id', profileId)
      .maybeSingle(); // Use maybeSingle() to avoid error when no rows

    if (fetchError) {
      throw new BadRequestException('Failed to fetch cart: ' + fetchError.message);
    }

    if (existingCart) {
      return existingCart.id;
    }

    // Create new cart
    const { data: newCart, error: createError } = await supabase
      .from('carts')
      .insert({ profile_id: profileId })
      .select('id')
      .single();

    if (createError) {
      // Check if it's a duplicate cart error (race condition)
      if (createError.code === '23505') {
        // Unique constraint violation - cart was created by another request
        // Retry fetching the cart
        const { data: retryCart, error: retryError } = await supabase
          .from('carts')
          .select('id')
          .eq('profile_id', profileId)
          .single();

        if (retryError || !retryCart) {
          throw new ConflictException('Failed to create or retrieve cart');
        }

        return retryCart.id;
      }

      throw new BadRequestException('Failed to create cart: ' + createError.message);
    }

    if (!newCart) {
      throw new BadRequestException('Failed to create cart: No data returned');
    }

    return newCart.id;
  }

  /**
   * Add item to cart
   */
  async addToCart(profileId: string, addToCartDto: AddToCartDto): Promise<CartItemResponse> {
    const supabase = this.supabaseService.getClient();
    const { variant_id, qty } = addToCartDto;

    // Verify variant exists and get product_id & price & stock
    const { data: variant, error: variantError } = await supabase
      .from('product_variants')
      .select('id, product_id, price, qty, is_active')
      .eq('id', variant_id)
      .single();

    if (variantError) {
      throw new NotFoundException('Product variant not found: ' + variantError.message);
    }

    if (!variant) {
      throw new NotFoundException('Product variant not found');
    }

    if (!variant.is_active) {
      throw new BadRequestException('Product variant is not available');
    }

    const cartId = await this.getOrCreateCart(profileId);

    // Check if item already exists in cart
    const { data: existingItem, error: existingError } = await supabase
      .from('cart_items')
      .select('id, qty')
      .eq('cart_id', cartId)
      .eq('variant_id', variant_id)
      .maybeSingle();

    if (existingError) {
      throw new BadRequestException('Failed to check existing cart item: ' + existingError.message);
    }

    if (existingItem) {
      // Update quantity - validate stock at time of update
      const newQty = existingItem.qty + qty;
      
      // Re-fetch latest stock to avoid TOCTOU
      const { data: latestVariant, error: stockError } = await supabase
        .from('product_variants')
        .select('qty')
        .eq('id', variant_id)
        .single();

      if (stockError || !latestVariant) {
        throw new BadRequestException('Failed to verify stock availability');
      }

      if (latestVariant.qty < newQty) {
        throw new BadRequestException(`Only ${latestVariant.qty} items available in stock`);
      }

      const { data: updated, error: updateError } = await supabase
        .from('cart_items')
        .update({ qty: newQty, updated_at: new Date().toISOString() })
        .eq('id', existingItem.id)
        .select('*, product_variants!inner(id, sku, main_image, attributes, price, qty), products!inner(id, name, slug)')
        .single();

      if (updateError) {
        throw new BadRequestException('Failed to update cart item: ' + updateError.message);
      }

      if (!updated) {
        throw new BadRequestException('Failed to update cart item: No data returned');
      }

      return this.formatCartItem(updated);
    }

    // Validate stock before inserting
    if (variant.qty < qty) {
      throw new BadRequestException(`Only ${variant.qty} items available in stock`);
    }

    // Add new item
    const { data: newItem, error: insertError } = await supabase
      .from('cart_items')
      .insert({
        cart_id: cartId,
        variant_id,
        product_id: variant.product_id,
        qty,
        unit_price: variant.price,
      })
      .select('*, product_variants!inner(id, sku, main_image, attributes, price, qty), products!inner(id, name, slug)')
      .single();

    if (insertError) {
      // Handle duplicate cart item race condition
      if (insertError.code === '23505') {
        // Unique constraint violation - item was added by another request
        throw new ConflictException('Item already in cart. Please refresh.');
      }
      throw new BadRequestException('Failed to add item to cart: ' + insertError.message);
    }

    if (!newItem) {
      throw new BadRequestException('Failed to add item to cart: No data returned');
    }

    return this.formatCartItem(newItem);
  }

  /**
   * Get user's cart with items
   */
  async getCart(profileId: string): Promise<CartResponse> {
    const supabase = this.supabaseService.getClient();

    const cartId = await this.getOrCreateCart(profileId);

    const { data: cart, error: cartError } = await supabase
      .from('carts')
      .select('id, profile_id, created_at, updated_at')
      .eq('id', cartId)
      .single();

    if (cartError || !cart) {
      throw new NotFoundException('Cart not found');
    }

    const { data: items, error: itemsError } = await supabase
      .from('cart_items')
      .select('*, product_variants!inner(id, sku, main_image, attributes, price, qty), products!inner(id, name, slug)')
      .eq('cart_id', cartId);

    if (itemsError) {
      throw new BadRequestException('Failed to fetch cart items');
    }

    const formattedItems = (items || []).map((item) => this.formatCartItem(item));
    const totalItems = formattedItems.reduce((sum, item) => sum + item.qty, 0);
    const totalPrice = formattedItems.reduce((sum, item) => sum + item.qty * item.unit_price, 0);

    return {
      id: cart.id,
      profile_id: cart.profile_id,
      items: formattedItems,
      total_items: totalItems,
      total_price: totalPrice,
      created_at: cart.created_at,
      updated_at: cart.updated_at,
    };
  }

  /**
   * Update cart item quantity
   */
  async updateCartItem(profileId: string, itemId: string, updateDto: UpdateCartItemDto): Promise<CartItemResponse> {
    const supabase = this.supabaseService.getClient();
    const { qty } = updateDto;

    // Verify ownership
    const { data: item, error: fetchError } = await supabase
      .from('cart_items')
      .select('*, carts!inner(profile_id), product_variants!inner(qty)')
      .eq('id', itemId)
      .single();

    if (fetchError || !item || item.carts.profile_id !== profileId) {
      throw new NotFoundException('Cart item not found');
    }

    if (item.product_variants.qty < qty) {
      throw new BadRequestException(`Only ${item.product_variants.qty} items available in stock`);
    }

    const { data: updated, error: updateError } = await supabase
      .from('cart_items')
      .update({ qty })
      .eq('id', itemId)
      .select('*, product_variants!inner(id, sku, main_image, attributes, price, qty), products!inner(id, name, slug)')
      .single();

    if (updateError || !updated) {
      throw new BadRequestException('Failed to update cart item');
    }

    return this.formatCartItem(updated);
  }

  /**
   * Remove item from cart
   */
  async removeCartItem(profileId: string, itemId: string): Promise<{ message: string }> {
    const supabase = this.supabaseService.getClient();

    // Verify ownership
    const { data: item, error: fetchError } = await supabase
      .from('cart_items')
      .select('*, carts!inner(profile_id)')
      .eq('id', itemId)
      .single();

    if (fetchError || !item || item.carts.profile_id !== profileId) {
      throw new NotFoundException('Cart item not found');
    }

    const { error: deleteError } = await supabase
      .from('cart_items')
      .delete()
      .eq('id', itemId);

    if (deleteError) {
      throw new BadRequestException('Failed to remove cart item');
    }

    return { message: 'Item removed from cart' };
  }

  /**
   * Clear cart
   */
  async clearCart(profileId: string): Promise<{ message: string }> {
    const supabase = this.supabaseService.getClient();

    const cartId = await this.getOrCreateCart(profileId);

    const { error } = await supabase
      .from('cart_items')
      .delete()
      .eq('cart_id', cartId);

    if (error) {
      throw new BadRequestException('Failed to clear cart');
    }

    return { message: 'Cart cleared' };
  }

  /**
   * Format cart item response
   */
  private formatCartItem(item: any): CartItemResponse {
    return {
      id: item.id,
      cart_id: item.cart_id,
      variant_id: item.variant_id,
      product_id: item.product_id,
      qty: item.qty,
      unit_price: item.unit_price,
      added_at: item.added_at,
      product: item.products ? {
        id: item.products.id,
        name: item.products.name,
        slug: item.products.slug,
        main_image: item.product_variants?.main_image || null,
      } : undefined,
      variant: item.product_variants ? {
        id: item.product_variants.id,
        sku: item.product_variants.sku,
        main_image: item.product_variants.main_image,
        attributes: item.product_variants.attributes,
        price: item.product_variants.price || item.unit_price,
        name: item.product_variants.attributes?.name || item.product_variants.sku,
        color: item.product_variants.attributes?.color || '',
        qty: item.product_variants.qty,
      } : undefined,
    };
  }

  /**
   * Sync entire cart with optimistic updates
   * Validates stock and corrects quantities
   * Implements error handling for all database operations
   */
  async syncCart(profileId: string, syncDto: SyncCartDto): Promise<CartResponse> {
    const supabase = this.supabaseService.getClient();
    const cartId = await this.getOrCreateCart(profileId);

    // Get all variant IDs from the sync request
    const variantIds = syncDto.items.map(item => item.variant_id);

    if (variantIds.length === 0) {
      // If no items, clear cart
      const { error: clearError } = await supabase
        .from('cart_items')
        .delete()
        .eq('cart_id', cartId);

      if (clearError) {
        throw new BadRequestException('Failed to clear cart: ' + clearError.message);
      }

      return this.getCart(profileId);
    }

    // Fetch all variants with stock info
    const { data: variants, error: variantsError } = await supabase
      .from('product_variants')
      .select('id, product_id, price, qty, is_active')
      .in('id', variantIds);

    if (variantsError) {
      throw new BadRequestException('Failed to fetch variant information: ' + variantsError.message);
    }

    const variantsMap = new Map(variants?.map(v => [v.id, v]) || []);

    // Get current cart items
    const { data: currentItems, error: currentItemsError } = await supabase
      .from('cart_items')
      .select('id, variant_id, qty')
      .eq('cart_id', cartId);

    if (currentItemsError) {
      throw new BadRequestException('Failed to fetch current cart items: ' + currentItemsError.message);
    }

    const currentItemsMap = new Map(
      (currentItems || []).map(item => [item.variant_id, item])
    );

    const correctedItems: any[] = [];
    const itemsToInsert: any[] = [];
    const itemsToUpdate: any[] = [];
    const itemIdsToDelete: string[] = [];

    // Process each item in the sync request
    for (const syncItem of syncDto.items) {
      const variant = variantsMap.get(syncItem.variant_id);
      
      if (!variant || !variant.is_active) {
        // Variant doesn't exist or is inactive - skip
        continue;
      }

      // Check stock availability and correct quantity
      const requestedQty = syncItem.qty;
      const availableStock = variant.qty;
      const correctedQty = Math.min(Math.max(requestedQty, 0), availableStock);

      if (correctedQty === 0) {
        // Remove item if quantity is 0
        const existingItem = currentItemsMap.get(syncItem.variant_id);
        if (existingItem) {
          itemIdsToDelete.push(existingItem.id);
        }
        continue;
      }

      const existingItem = currentItemsMap.get(syncItem.variant_id);

      if (existingItem) {
        // Update existing item
        if (existingItem.qty !== correctedQty) {
          itemsToUpdate.push({
            id: existingItem.id,
            qty: correctedQty,
            unit_price: variant.price,
          });
        }
      } else {
        // Insert new item
        itemsToInsert.push({
          cart_id: cartId,
          variant_id: syncItem.variant_id,
          product_id: variant.product_id,
          qty: correctedQty,
          unit_price: variant.price,
        });
      }

      correctedItems.push({
        variant_id: syncItem.variant_id,
        qty: correctedQty,
        was_corrected: correctedQty !== requestedQty,
      });
    }

    // Remove items that are not in the sync request
    for (const [variantId, item] of currentItemsMap) {
      const isInSyncRequest = syncDto.items.some(si => si.variant_id === variantId);
      if (!isInSyncRequest) {
        itemIdsToDelete.push(item.id);
      }
    }

    // Execute database operations with error handling
    // Note: Supabase doesn't support true transactions, but we handle errors for each operation
    try {
      if (itemIdsToDelete.length > 0) {
        const { error: deleteError } = await supabase
          .from('cart_items')
          .delete()
          .in('id', itemIdsToDelete);

        if (deleteError) {
          throw new BadRequestException('Failed to delete cart items: ' + deleteError.message);
        }
      }

      if (itemsToInsert.length > 0) {
        const { error: insertError } = await supabase
          .from('cart_items')
          .insert(itemsToInsert);

        if (insertError) {
          throw new BadRequestException('Failed to insert cart items: ' + insertError.message);
        }
      }

      if (itemsToUpdate.length > 0) {
        // Update items one by one with error handling
        for (const item of itemsToUpdate) {
          const { error: updateError } = await supabase
            .from('cart_items')
            .update({ qty: item.qty, unit_price: item.unit_price, updated_at: new Date().toISOString() })
            .eq('id', item.id);

          if (updateError) {
            throw new BadRequestException(`Failed to update cart item ${item.id}: ` + updateError.message);
          }
        }
      }
    } catch (error) {
      // If any operation fails, throw the error
      // Note: Without transaction support, some changes might be partially applied
      // Consider implementing a rollback mechanism or retry logic in production
      throw error;
    }

    // Fetch and return updated cart
    return this.getCart(profileId);
  }
}
