import { IsString, IsOptional, IsDateString, IsEnum, Matches, IsUrl } from 'class-validator';
import { Transform } from 'class-transformer';

export class UpdateProfileDto {
  @IsOptional()
  @IsString()
  @Transform(({ value }) => value === '' ? undefined : value)
  full_name?: string;

  @IsOptional()
  @IsString()
  @Transform(({ value }) => value === '' ? undefined : value)
  @Matches(/^\+?[1-9]\d{1,14}$/, {
    message: 'Phone number must be in E.164 format (e.g., +84987654321 or 84987654321)',
  })
  phone?: string;

  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : value)
  @IsEnum(['male', 'female', 'other'])
  gender?: string;

  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : value)
  @IsDateString()
  date_of_birth?: string;

  @IsOptional()
  @IsString()
  @Transform(({ value }) => value === '' ? undefined : value)
  @IsUrl({}, { message: 'Avatar URL must be a valid URL' })
  avatar_url?: string;
}

export class ProfileResponse {
  id: string;
  email: string;
  full_name: string | null;
  phone: string | null;
  gender: string | null;
  date_of_birth: string | null;
  avatar_url: string | null;
  created_at: string;
  updated_at: string;
}
