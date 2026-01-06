import { IsString, IsOptional, IsUUID, IsNumber, Min, IsArray, ValidateNested, IsEnum, ValidateIf } from 'class-validator';
import { Type } from 'class-transformer';
export enum OrderStatus {
  PENDING = 'pending',
  CONFIRMED = 'confirmed',
  PROCESSING = 'processing',
  SHIPPING = 'shipping',
  DELIVERED = 'delivered',
  CANCELLED = 'cancelled',
  REFUNDED = 'refunded',
}
export class AddressSnapshotDto {
  @IsString()
  full_name: string;

  @IsString()
  phone: string;

  @IsString()
  address_line: string;

  @IsString()
  @IsOptional()
  ward?: string;

  @IsString()
  @IsOptional()
  district?: string;

  @IsString()
  @IsOptional()
  city?: string;
}

export class CreateOrderDto {
  @IsUUID()
  @ValidateIf((o) => !o.address)
  @IsOptional()
  address_id?: string; // Use existing address

  @ValidateNested()
  @Type(() => AddressSnapshotDto)
  @ValidateIf((o) => !o.address_id)
  @IsOptional()
  address?: AddressSnapshotDto; // Or provide address directly

  @IsString()
  @IsOptional()
  payment_method?: string;

  @IsString()
  @IsOptional()
  note?: string;

  @IsString()
  @IsOptional()
  coupon_code?: string;
}

export class OrderItemResponse {
  id: string;
  product_id: string | null;
  variant_id: string | null;
  variant_name: string | null;
  product_name: string | null;
  main_image: string | null;
  qty: number;
  unit_price: number;
  total_price: number;
}

export class OrderResponse {
  id: string;
  order_number: string;
  profile_id: string;
  @IsEnum(OrderStatus)
  status: OrderStatus;
  subtotal: number;
  shipping_fee: number;
  total: number;
  address: AddressSnapshotDto | null;
  payment_method: string | null;
  note: string | null;
  coupon_code: string | null;
  placed_at: string;
  updated_at: string;
  items: OrderItemResponse[];
}

export class OrdersListResponse {
  items: OrderResponse[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

export class UpdateOrderStatusDto {
  @IsString()
  status: 'pending' | 'confirmed' | 'shipping' | 'delivered' | 'cancelled';
}
