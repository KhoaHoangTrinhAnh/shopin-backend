import { Injectable, NotFoundException, ConflictException, BadRequestException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import { AddFavoriteDto, FavoriteItemResponse, FavoritesResponse } from './dto/favorites.dto';

@Injectable()
export class FavoritesService {
  constructor(private readonly supabaseService: SupabaseService) {}

  /**
   * Get or create wishlist for a profile
   */
  private async getOrCreateWishlist(profileId: string): Promise<string> {
    const supabase = this.supabaseService.getClient();

    const { data: existing } = await supabase
      .from('wishlists')
      .select('id')
      .eq('profile_id', profileId)
      .single();

    if (existing) {
      return existing.id;
    }

    const { data: created, error } = await supabase
      .from('wishlists')
      .insert({ profile_id: profileId })
      .select('id')
      .single();

    if (error || !created) {
      throw new Error('Failed to create wishlist');
    }

    return created.id;
  }

  /**
   * Get all favorites for a user
   */
  async getFavorites(profileId: string): Promise<FavoritesResponse> {
    const supabase = this.supabaseService.getClient();
    const wishlistId = await this.getOrCreateWishlist(profileId);

    const { data: items, error } = await supabase
      .from('wishlist_items')
      .select(`
        product_id,
        added_at,
        products!inner(
          id,
          name,
          slug,
          default_variant_id,
          categories(id, name, slug)
        )
      `)
      .eq('wishlist_id', wishlistId)
      .order('added_at', { ascending: false });

    if (error) {
      throw new Error('Failed to fetch favorites');
    }

    // Fetch default variants for all products
    const productIds = (items || []).map((item: any) => item.products.id);
    const variantIds = (items || []).map((item: any) => item.products.default_variant_id);

    const { data: variants } = await supabase
      .from('product_variants')
      .select('id, price, original_price, main_image')
      .in('id', variantIds);

    const variantsMap = new Map(
      (variants || []).map((v: any) => [v.id, v])
    );

    const formattedItems: FavoriteItemResponse[] = (items || []).map((item: any) => {
      const product = item.products;
      const defaultVariant = variantsMap.get(product.default_variant_id);
      
      return {
        product_id: item.product_id,
        added_at: item.added_at,
        product: {
          id: product.id,
          name: product.name,
          slug: product.slug,
          category: Array.isArray(product.categories) && product.categories.length > 0 
            ? product.categories[0] 
            : undefined,
          default_variant: defaultVariant,
        },
      };
    });

    return {
      items: formattedItems,
      total: formattedItems.length,
    };
  }

  /**
   * Add product to favorites
   */
  async addFavorite(profileId: string, dto: AddFavoriteDto): Promise<FavoriteItemResponse> {
    const supabase = this.supabaseService.getClient();
    const wishlistId = await this.getOrCreateWishlist(profileId);

    // Check if product exists
    const { data: product, error: productError } = await supabase
      .from('products')
      .select(`
        id,
        name,
        slug,
        default_variant_id,
        categories(id, name, slug)
      `)
      .eq('id', dto.product_id)
      .single();

    if (productError || !product) {
      throw new NotFoundException('Product not found');
    }

    // Fetch default variant separately
    const { data: defaultVariant } = await supabase
      .from('product_variants')
      .select('id, price, original_price, main_image')
      .eq('id', product.default_variant_id)
      .single();

    // Check if already in wishlist
    const { data: existing } = await supabase
      .from('wishlist_items')
      .select('product_id')
      .eq('wishlist_id', wishlistId)
      .eq('product_id', dto.product_id)
      .single();

    if (existing) {
      throw new ConflictException('Product already in favorites');
    }

    // Add to wishlist
    const { data: item, error: insertError } = await supabase
      .from('wishlist_items')
      .insert({
        wishlist_id: wishlistId,
        product_id: dto.product_id,
      })
      .select('product_id, added_at')
      .single();

    if (insertError || !item) {
      throw new Error('Failed to add to favorites');
    }

    return {
      product_id: item.product_id,
      added_at: item.added_at,
      product: {
        id: product.id,
        name: product.name,
        slug: product.slug,
        category: Array.isArray(product.categories) && product.categories.length > 0
          ? product.categories[0]
          : undefined,
        default_variant: defaultVariant || undefined,
      },
    };
  }

  /**
   * Remove product from favorites
   */
  async removeFavorite(profileId: string, productId: string): Promise<{ message: string }> {
    const supabase = this.supabaseService.getClient();
    const wishlistId = await this.getOrCreateWishlist(profileId);

    const { error } = await supabase
      .from('wishlist_items')
      .delete()
      .eq('wishlist_id', wishlistId)
      .eq('product_id', productId);

    if (error) {
      throw new Error('Failed to remove from favorites');
    }

    return { message: 'Removed from favorites' };
  }

  /**
   * Check if product is in favorites
   */
  async isFavorite(profileId: string, productId: string): Promise<boolean> {
    const supabase = this.supabaseService.getClient();
    const wishlistId = await this.getOrCreateWishlist(profileId);

    const { data } = await supabase
      .from('wishlist_items')
      .select('product_id')
      .eq('wishlist_id', wishlistId)
      .eq('product_id', productId)
      .single();

    return !!data;
  }

  /**
   * Toggle favorite status
   * Fixed race condition by checking status immediately before action
   */
  async toggleFavorite(profileId: string, productId: string): Promise<{ isFavorite: boolean }> {
    const supabase = this.supabaseService.getClient();

    // Get wishlist first
    const { data: wishlist, error: wishlistError } = await supabase
      .from('wishlists')
      .select('id')
      .eq('profile_id', profileId)
      .maybeSingle();

    if (wishlistError) {
      throw new BadRequestException('Failed to fetch wishlist: ' + wishlistError.message);
    }

    if (!wishlist) {
      // No wishlist exists, create it and add the product
      const { data: newWishlist, error: createError } = await supabase
        .from('wishlists')
        .insert({ profile_id: profileId })
        .select('id')
        .single();

      if (createError || !newWishlist) {
        throw new BadRequestException('Failed to create wishlist');
      }

      await this.addFavorite(profileId, { product_id: productId });
      return { isFavorite: true };
    }

    // Check current favorite status
    const { data: existingItem, error: checkError } = await supabase
      .from('wishlist_items')
      .select('wishlist_id')
      .eq('wishlist_id', wishlist.id)
      .eq('product_id', productId)
      .maybeSingle();

    if (checkError) {
      throw new BadRequestException('Failed to check favorite status: ' + checkError.message);
    }

    if (existingItem) {
      // Already a favorite - remove it
      await this.removeFavorite(profileId, productId);
      return { isFavorite: false };
    } else {
      // Not a favorite - add it
      await this.addFavorite(profileId, { product_id: productId });
      return { isFavorite: true };
    }
  }
}
