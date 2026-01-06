import { IsOptional, IsString, IsNumber, IsBoolean, IsArray, Min, IsIn } from 'class-validator';
import { Type } from 'class-transformer';
import { PaginationDto } from '../../common/dto/pagination.dto';

// Allowed sort fields to prevent SQL injection
export const ALLOWED_SORT_FIELDS = ['created_at', 'updated_at', 'name', 'price'] as const;
export type SortField = typeof ALLOWED_SORT_FIELDS[number];

export const SORT_ORDER = ['asc', 'desc'] as const;
export type SortOrder = typeof SORT_ORDER[number];

export class ProductFilterDto extends PaginationDto {
  @IsOptional()
  @IsString()
  search?: string;

  // Single ID filters (for direct filtering)
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  categoryId?: number;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  brandId?: number;

  // Price filters with validation
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0, { message: 'Minimum price must be at least 0' })
  minPrice?: number;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0, { message: 'Maximum price must be at least 0' })
  maxPrice?: number;

  @IsOptional()
  @Type(() => Boolean)
  @IsBoolean()
  isActive?: boolean = true;

  // Whitelisted sort field to prevent SQL injection
  @IsOptional()
  @IsString()
  @IsIn(ALLOWED_SORT_FIELDS, { message: 'Invalid sort field. Allowed: created_at, updated_at, name, price' })
  sortBy?: SortField = 'created_at';

  // Validated sort order
  @IsOptional()
  @IsString()
  @IsIn(SORT_ORDER, { message: 'Sort order must be either "asc" or "desc"' })
  sortOrder?: SortOrder = 'desc';

  // Array filters (for multi-select, e.g., slug-based filtering via categories/brands arrays)
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  categories?: string[];

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  brands?: string[];
}
