import { IsString, IsOptional, IsNumber, Min, ValidateNested, ValidateIf } from 'class-validator';
import { Type } from 'class-transformer';
import { AddressSnapshotDto } from './orders.dto';

/**
 * DTO for creating a direct order (bypassing cart)
 * Used for "Buy Now" functionality where user purchases a single product directly
 */
export class CreateDirectOrderDto {
  @IsString()
  variant_id: string; // Required: the product variant UUID or slug to purchase

  @IsNumber()
  @Min(1)
  qty: number; // Required: quantity to purchase

  @ValidateIf((o) => !o.address)
  @IsString()
  address_id?: string; // Use existing address

  @ValidateIf((o) => !o.address_id)
  @ValidateNested()
  @Type(() => AddressSnapshotDto)
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
