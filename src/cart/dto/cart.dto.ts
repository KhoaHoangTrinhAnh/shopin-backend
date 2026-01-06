import { IsUUID, IsInt, Min, IsOptional, IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

export class AddToCartDto {
  @IsUUID()
  variant_id: string;

  @IsInt()
  @Min(1)
  qty: number;
}

export class UpdateCartItemDto {
  @IsInt()
  @Min(1)
  qty: number;
}

export class SyncCartItemDto {
  @IsUUID()
  variant_id: string;

  @IsInt()
  @Min(0)
  qty: number;
}

export class SyncCartDto {
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SyncCartItemDto)
  items: SyncCartItemDto[];
}

export class CartItemResponse {
  id: string;
  cart_id: string;
  variant_id: string;
  product_id: string;
  qty: number;
  unit_price: number;
  added_at: string;
  
  // Populated fields
  product?: {
    id: string;
    name: string;
    slug: string;
    main_image: string | null;
  };
  variant?: {
    id: string;
    sku: string;
    main_image: string;
    attributes: Record<string, any>;
    price: number;
    name: string;
    color: string;
    qty: number;
  };
}

export class CartResponse {
  id: string;
  profile_id: string;
  items: CartItemResponse[];
  total_items: number;
  total_price: number;
  created_at: string;
  updated_at: string;
}
