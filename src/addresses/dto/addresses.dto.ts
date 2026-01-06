import { IsString, IsNotEmpty, IsOptional, IsBoolean, MaxLength } from 'class-validator';

export class CreateAddressDto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  full_name: string;

  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  phone: string;

  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  address_line: string;

  @IsString()
  @IsOptional()
  @MaxLength(100)
  ward?: string;

  @IsString()
  @IsOptional()
  @MaxLength(100)
  district?: string;

  @IsString()
  @IsOptional()
  @MaxLength(100)
  city?: string;

  @IsBoolean()
  @IsOptional()
  is_default?: boolean;
}

export class UpdateAddressDto {
  @IsString()
  @IsOptional()
  @MaxLength(100)
  full_name?: string;

  @IsString()
  @IsOptional()
  @MaxLength(20)
  phone?: string;

  @IsString()
  @IsOptional()
  @MaxLength(255)
  address_line?: string;

  @IsString()
  @IsOptional()
  @MaxLength(100)
  ward?: string;

  @IsString()
  @IsOptional()
  @MaxLength(100)
  district?: string;

  @IsString()
  @IsOptional()
  @MaxLength(100)
  city?: string;

  @IsBoolean()
  @IsOptional()
  is_default?: boolean;
}

export class AddressResponse {
  id: string;
  profile_id: string;
  full_name: string;
  phone: string;
  address_line: string;
  ward: string | null;
  district: string | null;
  city: string | null;
  is_default: boolean;
  created_at: string;
  updated_at: string;
}

export class AddressesResponse {
  items: AddressResponse[];
  default_address: AddressResponse | null;
  total: number;
}
