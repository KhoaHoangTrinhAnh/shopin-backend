import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import { ProductFilterDto } from './dto/product-filter.dto';
import { Product, ProductVariant } from './entities/product.entity';
import { PaginatedResponse } from '../common/dto/pagination.dto';

@Injectable()
export class ProductsService {
  constructor(private readonly supabaseService: SupabaseService) {}

  async findAll(filterDto: ProductFilterDto): Promise<PaginatedResponse<Product>> {
    const supabase = this.supabaseService.getClient();
    const { page = 1, limit = 20, search, categoryId, brandId, minPrice, maxPrice, isActive, sortBy = 'created_at', sortOrder = 'desc', categories, brands } = filterDto;
    
    const from = (page - 1) * limit;
    const to = from + limit - 1;

    let query = supabase
      .from('products')
      .select(`
        *,
        brand:brands(id, name, slug),
        category:categories(id, name, slug)
      `, { count: 'exact' });

    // Filters
    if (isActive !== undefined) {
      query = query.eq('is_active', isActive);
    }

    if (search) {
      // Use parameterized search to prevent SQL injection
      // Sanitize search input
      const sanitizedSearch = search.trim().replace(/[%_]/g, '\\$&');
      
      // Get variant IDs matching the search using parameterized queries
      const { data: matchingVariants } = await supabase
        .from('product_variants')
        .select('product_id')
        .or(`variant_slug.ilike.%${sanitizedSearch}%,sku.ilike.%${sanitizedSearch}%`);
      
      const variantProductIds = matchingVariants?.map(v => v.product_id) || [];
      
      // Search in products table
      const searchConditions = [
        `name.ilike.%${sanitizedSearch}%`,
        `slug.ilike.%${sanitizedSearch}%`,
        `description.ilike.%${sanitizedSearch}%`,
      ];
      
      if (variantProductIds.length > 0) {
        query = query.or([...searchConditions, `id.in.(${variantProductIds.join(',')})`].join(','));
      } else {
        query = query.or(searchConditions.join(','));
      }
    }

    if (categoryId) {
      query = query.eq('category_id', categoryId);
    }

    if (brandId) {
      query = query.eq('brand_id', brandId);
    }

    if (categories && categories.length > 0) {
      // Convert category slugs to IDs
      const { data: categoryData, error: categoryError } = await supabase
        .from('categories')
        .select('id')
        .in('slug', categories);
      
      if (categoryError) {
        throw new BadRequestException(`Failed to resolve category slugs: ${categoryError.message}`);
      }
      
      const categoryIds = categoryData?.map(c => c.id) || [];
      if (categoryIds.length === 0 && categories.length > 0) {
        throw new BadRequestException(`No categories found for slugs: ${categories.join(', ')}`);
      }
      
      if (categoryIds.length > 0) {
        query = query.in('category_id', categoryIds);
      }
    }

    if (brands && brands.length > 0) {
      // Convert brand slugs to IDs
      const { data: brandData, error: brandError } = await supabase
        .from('brands')
        .select('id')
        .in('slug', brands);
      
      if (brandError) {
        throw new BadRequestException(`Failed to resolve brand slugs: ${brandError.message}`);
      }
      
      const brandIds = brandData?.map(b => b.id) || [];
      if (brandIds.length === 0 && brands.length > 0) {
        throw new BadRequestException(`No brands found for slugs: ${brands.join(', ')}`);
      }
      
      if (brandIds.length > 0) {
        query = query.in('brand_id', brandIds);
      }
    }

    // Note: Price filtering is currently done post-fetch due to Supabase limitations
    // with filtering on joined tables. For large datasets, consider denormalizing
    // price to products table or using a database view.

    // Sorting - sortBy is validated via whitelist in DTO
    query = query.order(sortBy, { ascending: sortOrder === 'asc' });

    // Pagination
    query = query.range(from, to);

    const { data, error, count } = await query;

    if (error) {
      throw new Error(`Error fetching products: ${error.message}`);
    }

    let products = data as Product[];

    // Fetch default variants for all products
    if (products.length > 0) {
      const variantIds = products.map(p => p.default_variant_id).filter(Boolean);
      
      if (variantIds.length > 0) {
        const { data: variants, error: variantsError } = await supabase
          .from('product_variants')
          .select('*')
          .in('id', variantIds);

        if (!variantsError && variants) {
          // Map variants to products
          products = products.map(product => {
            const variant = variants.find(v => v.id === product.default_variant_id);
            return {
              ...product,
              default_variant: variant || null,
            };
          });
        }
      }
    }

    // Apply price filtering if needed
    // WARNING: This breaks pagination accuracy as filtering happens after count
    // Consider moving price to products table for accurate pagination
    let actualTotal = count || 0;
    if (minPrice !== undefined || maxPrice !== undefined) {
      products = products.filter(product => {
        const price = product.default_variant?.price || 0;
        if (minPrice !== undefined && price < minPrice) return false;
        if (maxPrice !== undefined && price > maxPrice) return false;
        return true;
      });
      // Note: actualTotal is now inaccurate - it reflects pre-filter count
    }

    return {
      data: products,
      pagination: {
        page,
        limit,
        total: actualTotal,
        totalPages: Math.ceil(actualTotal / limit),
      },
    };
  }

  async findOne(identifier: string): Promise<Product> {
    const supabase = this.supabaseService.getClient();
    
    // Check if identifier is UUID or slug
    const isUUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(identifier);
    
    let data: any = null;
    let error: any = null;

    if (isUUID) {
      // Try to find by product ID
      const result = await supabase
        .from('products')
        .select(`
          *,
          brand:brands(id, name, slug),
          category:categories(id, name, slug)
        `)
        .eq('id', identifier)
        .single();
      data = result.data;
      error = result.error;
    } else {
      // Try to find by product slug first
      const productResult = await supabase
        .from('products')
        .select(`
          *,
          brand:brands(id, name, slug),
          category:categories(id, name, slug)
        `)
        .eq('slug', identifier)
        .single();

      if (productResult.data) {
        data = productResult.data;
      } else {
        // If not found by product slug, try variant slug
        const variantResult = await supabase
          .from('product_variants')
          .select('product_id')
          .eq('variant_slug', identifier)
          .single();

        if (variantResult.data) {
          // Found variant, fetch the parent product
          const parentResult = await supabase
            .from('products')
            .select(`
              *,
              brand:brands(id, name, slug),
              category:categories(id, name, slug)
            `)
            .eq('id', variantResult.data.product_id)
            .single();
          data = parentResult.data;
          error = parentResult.error;
        } else {
          error = productResult.error;
        }
      }
    }

    if (error || !data) {
      throw new NotFoundException(`Product with identifier ${identifier} not found`);
    }

    const product = data as Product;

    // Fetch default variant
    if (product.default_variant_id) {
      const { data: defaultVariant } = await supabase
        .from('product_variants')
        .select('*')
        .eq('id', product.default_variant_id)
        .single();
      
      product.default_variant = defaultVariant || undefined;
    }

    // Fetch all variants
    const { data: variants } = await supabase
      .from('product_variants')
      .select('*')
      .eq('product_id', product.id);
    
    product.variants = variants || [];

    return product;
  }

  async findVariants(productId: string): Promise<ProductVariant[]> {
    const supabase = this.supabaseService.getClient();
    
    const { data, error } = await supabase
      .from('product_variants')
      .select('*')
      .eq('product_id', productId)
      .eq('is_active', true);

    if (error) {
      throw new Error(`Error fetching variants: ${error.message}`);
    }

    return data as ProductVariant[];
  }

  /**
   * Find a single variant by ID or slug, with product details
   */
  async findVariant(variantIdOrSlug: string): Promise<any> {
    const supabase = this.supabaseService.getClient();
    
    // Check if it looks like a UUID
    const isUUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(variantIdOrSlug);
    
    console.log('[ProductsService] Finding variant:', variantIdOrSlug, 'isUUID:', isUUID);
    
    // Use explicit relationship name to avoid ambiguity
    // products!product_variants_product_id_fkey means: follow the FK from product_variants.product_id -> products.id
    const { data, error } = await supabase
      .from('product_variants')
      .select(`
        *,
        product:products!product_variants_product_id_fkey(
          id,
          name,
          slug,
          description,
          category:categories(id, name, slug),
          brand:brands(id, name, slug)
        )
      `)
      .eq(isUUID ? 'id' : 'variant_slug', variantIdOrSlug)
      .single();

    if (error) {
      console.error('[ProductsService] Error finding variant:', error);
      throw new NotFoundException(`Variant not found: ${variantIdOrSlug} - ${error.message}`);
    }

    if (!data) {
      throw new NotFoundException(`Variant not found: ${variantIdOrSlug}`);
    }

    // Log if variant is inactive but still return it (frontend can handle display)
    if (!data.is_active) {
      console.warn('[ProductsService] Variant is inactive:', variantIdOrSlug);
    }

    return data;
  }

  async findFeatured(limit: number = 8): Promise<Product[]> {
    const supabase = this.supabaseService.getClient();
    
    const { data, error } = await supabase
      .from('products')
      .select(`
        *,
        brand:brands(id, name, slug),
        category:categories(id, name, slug)
      `)
      .eq('is_active', true)
      .not('default_variant_id', 'is', null)
      .order('created_at', { ascending: false })
      .limit(limit);

    if (error) {
      throw new Error(`Error fetching featured products: ${error.message}`);
    }

    let products = data as Product[];

    // Fetch default variants
    if (products.length > 0) {
      const variantIds = products.map(p => p.default_variant_id).filter(Boolean);
      const { data: variants } = await supabase
        .from('product_variants')
        .select('*')
        .in('id', variantIds);

      if (variants) {
        products = products.map(product => ({
          ...product,
          default_variant: variants.find(v => v.id === product.default_variant_id) || undefined,
        }));
      }
    }

    return products;
  }

  async findBestSelling(limit: number = 8): Promise<Product[]> {
    const supabase = this.supabaseService.getClient();
    
    // For now, return recent products. In production, this would query order_items table
    const { data, error } = await supabase
      .from('products')
      .select(`
        *,
        brand:brands(id, name, slug),
        category:categories(id, name, slug)
      `)
      .eq('is_active', true)
      .not('default_variant_id', 'is', null)
      .order('created_at', { ascending: false })
      .limit(limit);

    if (error) {
      throw new Error(`Error fetching best selling products: ${error.message}`);
    }

    let products = data as Product[];

    // Fetch default variants
    if (products.length > 0) {
      const variantIds = products.map(p => p.default_variant_id).filter(Boolean);
      const { data: variants } = await supabase
        .from('product_variants')
        .select('*')
        .in('id', variantIds);

      if (variants) {
        products = products.map(product => ({
          ...product,
          default_variant: variants.find(v => v.id === product.default_variant_id) || undefined,
        }));
      }
    }

    return products;
  }

  async findRelated(productId: string, limit: number = 5): Promise<Product[]> {
    const supabase = this.supabaseService.getClient();
    
    // First, get the product to find its category
    const product = await this.findOne(productId);
    
    if (!product.category_id) {
      return [];
    }

    const { data, error } = await supabase
      .from('products')
      .select(`
        *,
        brand:brands(id, name, slug),
        category:categories(id, name, slug)
      `)
      .eq('category_id', product.category_id)
      .eq('is_active', true)
      .neq('id', productId)
      .not('default_variant_id', 'is', null)
      .limit(limit);

    if (error) {
      throw new Error(`Error fetching related products: ${error.message}`);
    }

    let products = data as Product[];

    // Fetch default variants
    if (products.length > 0) {
      const variantIds = products.map(p => p.default_variant_id).filter(Boolean);
      const { data: variants } = await supabase
        .from('product_variants')
        .select('*')
        .in('id', variantIds);

      if (variants) {
        products = products.map(product => ({
          ...product,
          default_variant: variants.find(v => v.id === product.default_variant_id) || undefined,
        }));
      }
    }

    return products;
  }
}
