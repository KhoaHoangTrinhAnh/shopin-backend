import { IsString, IsOptional, IsArray, IsEnum, ValidateNested, IsNumber, IsInt, Min, Max } from 'class-validator';
import { Type, Transform } from 'class-transformer';

// ============================================================================
// ARTICLE BLOCK DTOs
// ============================================================================

export class TextBlockDto {
  @IsString()
  type: 'text';

  @IsString()
  content: string;

  @IsOptional()
  @IsString()
  @IsEnum(['h2', 'h3', 'p'])
  level?: 'h2' | 'h3' | 'p';
}

export class ImageBlockDto {
  @IsString()
  type: 'image';

  @IsString()
  url: string;

  @IsOptional()
  @IsString()
  alt?: string;

  @IsOptional()
  @IsString()
  caption?: string;
}

// Union type for blocks
export type ArticleBlockDto = TextBlockDto | ImageBlockDto;

// ============================================================================
// ARTICLE DTOs
// ============================================================================

export class CreateArticleDto {
  @IsString()
  title: string;

  @IsOptional()
  @IsString()
  slug?: string;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  tags?: string[];

  @IsOptional()
  @IsString()
  content?: string;

  @IsOptional()
  @IsArray()
  content_blocks?: ArticleBlockDto[];

  @IsOptional()
  @IsString()
  featured_image?: string;

  @IsOptional()
  @IsString()
  topic?: string;

  @IsOptional()
  @IsString()
  keyword?: string;

  @IsOptional()
  @IsString()
  meta_title?: string;

  @IsOptional()
  @IsString()
  meta_description?: string;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  meta_keywords?: string[];

  @IsOptional()
  @IsString()
  seo_keywords?: string;

  @IsOptional()
  @IsString()
  @IsEnum(['draft', 'published'])
  status?: 'draft' | 'published';
}

export class UpdateArticleDto {
  @IsOptional()
  @IsString()
  title?: string;

  @IsOptional()
  @IsString()
  slug?: string;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  tags?: string[];

  @IsOptional()
  @IsString()
  content?: string;

  @IsOptional()
  @IsArray()
  content_blocks?: ArticleBlockDto[];

  @IsOptional()
  @IsString()
  featured_image?: string;

  @IsOptional()
  @IsString()
  topic?: string;

  @IsOptional()
  @IsString()
  keyword?: string;

  @IsOptional()
  @IsString()
  meta_title?: string;

  @IsOptional()
  @IsString()
  meta_description?: string;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  meta_keywords?: string[];

  @IsOptional()
  @IsString()
  seo_keywords?: string;

  @IsOptional()
  @IsString()
  @IsEnum(['draft', 'published'])
  status?: 'draft' | 'published';
}

export class GenerateArticleDto {
  @IsString()
  keyword: string;

  @IsOptional()
  @IsString()
  topic?: string;

  @IsOptional()
  customPrompt?: string | Record<string, any>; // Can be text string or JSONB object
}

// ============================================================================
// COUPON DTOs
// ============================================================================

export class CreateCouponDto {
  @IsString()
  code: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsString()
  @IsEnum(['percentage', 'fixed'])
  discount_type: 'percentage' | 'fixed';

  @IsNumber()
  @Min(0)
  discount_value: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  min_order_value?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  max_discount?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  usage_limit?: number;

  @IsOptional()
  @IsString()
  @Transform(({ value }) => value ? new Date(value).toISOString() : null)
  starts_at?: string;

  @IsOptional()
  @IsString()
  @Transform(({ value }) => value ? new Date(value).toISOString() : null)
  expires_at?: string;

  @IsOptional()
  is_active?: boolean;
}

export class UpdateCouponDto {
  @IsOptional()
  @IsString()
  code?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsString()
  @IsEnum(['percentage', 'fixed'])
  discount_type?: 'percentage' | 'fixed';

  @IsOptional()
  @IsNumber()
  @Min(0)
  discount_value?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  min_order_value?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  max_discount?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  usage_limit?: number;

  @IsOptional()
  @IsString()
  @Transform(({ value }) => value ? new Date(value).toISOString() : null)
  starts_at?: string;

  @IsOptional()
  @IsString()
  @Transform(({ value }) => value ? new Date(value).toISOString() : null)
  expires_at?: string;

  @IsOptional()
  is_active?: boolean;
}

// ============================================================================
// SETTINGS DTOs
// ============================================================================

export class ShopInfoDto {
  @IsOptional()
  @IsString()
  shop_name?: string;

  @IsOptional()
  @IsString()
  contact_email?: string;

  @IsOptional()
  @IsString()
  hotline?: string;
}

export class ShippingConfigDto {
  @IsOptional()
  @IsNumber()
  @Min(0)
  default_shipping_fee?: number;

  @IsOptional()
  @IsString()
  estimated_delivery_days?: string;
}

export class OrderConfigDto {
  @IsOptional()
  cod_enabled?: boolean;
}

export class DefaultSEODto {
  @IsOptional()
  @IsString()
  meta_title?: string;

  @IsOptional()
  @IsString()
  meta_description?: string;
}

export class APISettingsDto {
  @IsOptional()
  @IsString()
  key?: string;

  @IsOptional()
  @IsString()
  model_name?: string;

  @IsOptional()
  @IsString()
  api_endpoint?: string;

  @IsOptional()
  @IsString()
  default_prompt?: string;

  @IsOptional()
  @IsString()
  description?: string;
}

// Legacy DTOs (for backward compatibility)
export class AISettingsDto {
  @IsOptional()
  @IsString()
  api_key?: string;

  @IsOptional()
  @IsString()
  model?: string;

  @IsOptional()
  @IsString()
  api_url?: string;

  @IsOptional()
  @IsString()
  prompt?: string;
}

export class ShopSettingsDto {
  @IsOptional()
  @IsString()
  shop_name?: string;

  @IsOptional()
  @IsString()
  shop_description?: string;

  @IsOptional()
  @IsString()
  contact_email?: string;

  @IsOptional()
  @IsString()
  contact_phone?: string;

  @IsOptional()
  @IsString()
  address?: string;

  @IsOptional()
  social_links?: {
    facebook?: string;
    instagram?: string;
    youtube?: string;
  };

  @IsOptional()
  @IsNumber()
  @Min(0)
  shipping_fee?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  free_shipping_threshold?: number;
}

// ============================================================================
// ORDER DTOs
// ============================================================================

export class ConfirmOrderDto {
  @IsOptional()
  @IsString()
  admin_notes?: string;
}

export class UpdateOrderStatusDto {
  @IsString()
  @IsEnum(['pending', 'confirmed', 'processing', 'shipping', 'delivered', 'cancelled'])
  status: string;

  @IsOptional()
  @IsString()
  admin_notes?: string;
}

// ============================================================================
// PRODUCT DTOs
// ============================================================================

export class CreateProductDto {
  @IsString()
  name: string;

  @IsString()
  slug: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsNumber()
  brand_id: number;

  @IsNumber()
  category_id: number;

  @IsOptional()
  @IsString()
  meta_title?: string;

  @IsOptional()
  @IsString()
  meta_description?: string;

  @IsOptional()
  is_active?: boolean;
}

export class UpdateProductDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  slug?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsNumber()
  brand_id?: number;

  @IsOptional()
  @IsNumber()
  category_id?: number;

  @IsOptional()
  @IsString()
  meta_title?: string;

  @IsOptional()
  @IsString()
  meta_description?: string;

  @IsOptional()
  is_active?: boolean;
}

export class CreateProductVariantDto {
  @IsString()
  product_id: string;

  @IsOptional()
  @IsString()
  sku?: string;

  @IsOptional()
  @IsString()
  color?: string;

  @IsOptional()
  @IsString()
  storage?: string;

  @IsNumber()
  @Min(0)
  price: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  original_price?: number;

  @IsNumber()
  @Min(0)
  qty: number;

  @IsOptional()
  @IsString()
  main_image?: string;
}

export class UpdateProductVariantDto {
  @IsOptional()
  @IsString()
  sku?: string;

  @IsOptional()
  @IsString()
  color?: string;

  @IsOptional()
  @IsString()
  storage?: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  price?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  original_price?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  qty?: number;

  @IsOptional()
  @IsString()
  main_image?: string;
}

// ============================================================================
// QUERY DTOs
// ============================================================================

export class PaginationQueryDto {
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number = 1;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number = 20;

  @IsOptional()
  @IsString()
  search?: string;

  @IsOptional()
  @IsString()
  status?: string;

  @IsOptional()
  @IsString()
  sort?: string;

  @IsOptional()
  @IsString()
  order?: 'asc' | 'desc';
}
