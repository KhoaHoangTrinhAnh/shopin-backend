import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { AuthService } from '../auth/auth.service';

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(private readonly authService: AuthService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const authorization = request.headers['authorization'];

    if (!authorization) {
      throw new UnauthorizedException('No authorization header');
    }

    const token = authorization.replace('Bearer ', '');

    try {
      const user = await this.authService.verifySession(token);
      
      // Fetch the complete profile from database
      const profile = await this.authService.getProfile(user.id);
      
      if (!profile) {
        throw new UnauthorizedException('Profile not found');
      }
      
      // IMPORTANT: Attach both user and profile to request
      // user = auth.users data (id, email, etc.)
      // profile = profiles table data (user_id, role, full_name, etc.)
      request.user = user;
      request.profile = profile;

      return true;
    } catch (error) {
      throw new UnauthorizedException('Invalid or expired token');
    }
  }
}
