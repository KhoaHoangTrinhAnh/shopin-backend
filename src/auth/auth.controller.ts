import { Controller, Post, Get, Put, Body, Headers, UnauthorizedException, Query, Req, BadRequestException, Param, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto, LoginDto, ResetPasswordRequestDto, UpdateProfileDto, ChangePasswordDto, DeleteAccountDto } from './dto/auth.dto';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { Profile } from '../decorators/profile.decorator';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  /**
   * Register a new user
   * POST /api/auth/register
   */
  @Post('register')
  async register(@Body() registerDto: RegisterDto) {
    return this.authService.register(registerDto);
  }

  /**
   * Login user
   * POST /api/auth/login
   */
  @Post('login')
  async login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  /**
   * Logout user
   * POST /api/auth/logout
   */
  @Post('logout')
  async logout(@Headers('authorization') authorization: string) {
    if (!authorization) {
      // No auth header = already logged out
      return { message: 'Logged out successfully' };
    }

    if (!authorization.startsWith('Bearer ')) {
      throw new UnauthorizedException('Invalid authorization header format');
    }

    const token = authorization.replace('Bearer ', '');
    return this.authService.logout(token);
  }

  /**
   * Request password reset email
   * POST /api/auth/forgot-password
   */
  @Post('forgot-password')
  async forgotPassword(@Body() resetDto: ResetPasswordRequestDto) {
    return this.authService.requestPasswordReset(resetDto);
  }

  /**
   * Get current user profile
   * GET /api/auth/profile
   */
  @Get('profile')
  async getProfile(@Headers('authorization') authorization: string) {
    if (!authorization) {
      throw new UnauthorizedException('No authorization header');
    }

    const token = authorization.replace('Bearer ', '');
    const user = await this.authService.verifySession(token);
    return this.authService.getProfile(user.id);
  }

  /**
   * Update user profile
   * PUT /api/auth/profile
   */
  @Put('profile')
  async updateProfile(
    @Headers('authorization') authorization: string,
    @Body() updateDto: UpdateProfileDto,
  ) {
    if (!authorization) {
      throw new UnauthorizedException('No authorization header');
    }

    const token = authorization.replace('Bearer ', '');
    const user = await this.authService.verifySession(token);
    return this.authService.updateProfile(user.id, updateDto);
  }

  /**
   * Verify session
   * GET /api/auth/verify
   */
  @Get('verify')
  async verify(@Headers('authorization') authorization: string) {
    if (!authorization) {
      throw new UnauthorizedException('No authorization header');
    }

    const token = authorization.replace('Bearer ', '');
    const user = await this.authService.verifySession(token);
    const profile = await this.authService.getProfile(user.id);
    
    return {
      user,
      profile,
    };
  }

  /**
   * Social login (Google, Facebook)
   * GET /api/auth/social/:provider
   */
  @Get('social/:provider')
  async socialLogin(@Param('provider') provider: 'google' | 'facebook') {
    if (!provider || !['google', 'facebook'].includes(provider)) {
      throw new UnauthorizedException('Invalid provider');
    }
    
    return this.authService.socialLogin(provider);
  }

  /**
   * Change password
   * POST /api/auth/change-password
   */
  @Post('change-password')
  @UseGuards(JwtAuthGuard)
  async changePassword(@Profile() profile: any, @Body() dto: ChangePasswordDto) {
    return this.authService.changePassword(profile.user_id, dto.current_password, dto.new_password);
  }

  /**
   * Delete account
   * POST /api/auth/delete-account
   */
  @Post('delete-account')
  @UseGuards(JwtAuthGuard)
  async deleteAccount(@Profile() profile: any, @Body() dto: DeleteAccountDto) {
    return this.authService.deleteAccount(profile.user_id, dto.password);
  }
}
