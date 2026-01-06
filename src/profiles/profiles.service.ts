import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { SupabaseService } from '../supabase/supabase.service';
import { UpdateProfileDto, ProfileResponse } from './dto/profiles.dto';

@Injectable()
export class ProfilesService {
  constructor(
    private readonly supabaseService: SupabaseService,
    private readonly configService: ConfigService,
  ) {}

  /**
   * Get user profile by ID
   */
  async getProfile(profileId: string): Promise<ProfileResponse> {
    const supabase = this.supabaseService.getClient();

    const { data: profile, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', profileId)
      .single();

    if (error || !profile) {
      throw new NotFoundException('Profile not found');
    }

    return {
      id: profile.id,
      email: profile.email,
      full_name: profile.full_name,
      phone: profile.phone,
      gender: profile.gender,
      date_of_birth: profile.date_of_birth,
      avatar_url: profile.avatar_url,
      created_at: profile.created_at,
      updated_at: profile.updated_at,
    };
  }

  /**
   * Update user profile
   */
  async updateProfile(
    profileId: string,
    dto: UpdateProfileDto,
  ): Promise<ProfileResponse> {
    const supabase = this.supabaseService.getClient();

    const updateData: any = {
      updated_at: new Date().toISOString(),
    };

    if (dto.full_name !== undefined) updateData.full_name = dto.full_name;
    if (dto.phone !== undefined) updateData.phone = dto.phone;
    if (dto.gender !== undefined) updateData.gender = dto.gender;
    if (dto.date_of_birth !== undefined) updateData.date_of_birth = dto.date_of_birth;
    if (dto.avatar_url !== undefined) updateData.avatar_url = dto.avatar_url;

    const { data: updated, error } = await supabase
      .from('profiles')
      .update(updateData)
      .eq('id', profileId)
      .select()
      .single();

    if (error || !updated) {
      throw new BadRequestException(`Failed to update profile: ${error?.message || 'Unknown error'}`);
    }

    return {
      id: updated.id,
      email: updated.email,
      full_name: updated.full_name,
      phone: updated.phone,
      gender: updated.gender,
      date_of_birth: updated.date_of_birth,
      avatar_url: updated.avatar_url,
      created_at: updated.created_at,
      updated_at: updated.updated_at,
    };
  }

  /**
   * Upload avatar to Supabase Storage
   * Validates file size (max 5MB) and extracts extension safely
   * Returns absolute public URL for the uploaded avatar
   */
  async uploadAvatar(profileId: string, file: Express.Multer.File): Promise<string> {
    const supabase = this.supabaseService.getClient();
    
    // Validate file size (5MB max) for security
    const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    if (file.size > MAX_FILE_SIZE) {
      throw new BadRequestException(`File size exceeds maximum allowed size of ${MAX_FILE_SIZE / 1024 / 1024}MB`);
    }
    
    // Safely extract file extension
    const fileExtMatch = file.originalname.match(/\.(\w+)$/);
    if (!fileExtMatch) {
      throw new BadRequestException('Invalid file name: Unable to determine file extension');
    }
    const fileExt = fileExtMatch[1];
    
    const fileName = `${profileId}-${Date.now()}.${fileExt}`;
    const filePath = `profile_images/${fileName}`;

    const { data, error } = await supabase.storage
      .from('shopin_storage')
      .upload(filePath, file.buffer, {
        contentType: file.mimetype,
        upsert: true,
      });

    if (error) {
      throw new BadRequestException(`Failed to upload avatar: ${error.message}`);
    }

    // Construct full absolute URL for the uploaded file
    const supabaseUrl = this.configService.get<string>('supabase.url');
    const absoluteUrl = `${supabaseUrl}/storage/v1/object/public/shopin_storage/${filePath}`;

    return absoluteUrl;
  }
}
