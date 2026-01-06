import {
  Controller,
  Get,
  Put,
  Body,
  UseGuards,
  Post,
  UseInterceptors,
  UploadedFile,
  BadRequestException,
  UnauthorizedException,
  ParseFilePipeBuilder,
  HttpStatus,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ProfilesService } from './profiles.service';
import { UpdateProfileDto } from './dto/profiles.dto';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { Profile } from '../decorators/profile.decorator';

@Controller('profiles')
@UseGuards(JwtAuthGuard)
export class ProfilesController {
  constructor(private readonly profilesService: ProfilesService) {}

  /**
   * GET /profiles - Get current user's profile
   */
  @Get()
  async getProfile(@Profile() profile: any) {
    if (!profile?.id) {
      throw new UnauthorizedException('Invalid profile data');
    }
    return this.profilesService.getProfile(profile.id);
  }

  /**
   * PUT /profiles - Update current user's profile
   */
  @Put()
  async updateProfile(@Profile() profile: any, @Body() dto: UpdateProfileDto) {
    if (!profile?.id) {
      throw new UnauthorizedException('Invalid profile data');
    }
    return this.profilesService.updateProfile(profile.id, dto);
  }

  /**
   * POST /profiles/avatar - Upload avatar
   * File validation: Max 5MB, only image types (jpg, jpeg, png, gif, webp)
   */
  @Post('avatar')
  @UseInterceptors(FileInterceptor('avatar'))
  async uploadAvatar(
    @Profile() profile: any,
    @UploadedFile(
      new ParseFilePipeBuilder()
        .addFileTypeValidator({
          fileType: /(jpg|jpeg|png|gif|webp)$/,
        })
        .addMaxSizeValidator({
          maxSize: 5 * 1024 * 1024, // 5MB
        })
        .build({
          errorHttpStatusCode: HttpStatus.UNPROCESSABLE_ENTITY,
          fileIsRequired: true,
        }),
    )
    file: Express.Multer.File,
  ) {
    if (!profile?.id) {
      throw new UnauthorizedException('Invalid profile data');
    }

    const avatarUrl = await this.profilesService.uploadAvatar(profile.id, file);
    
    // Update profile with new avatar URL and return complete updated profile
    const updatedProfile = await this.profilesService.updateProfile(profile.id, { avatar_url: avatarUrl });

    return updatedProfile;
  }
}
