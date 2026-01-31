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
      
      // IMPORTANT: Use user.id (auth.users.id) as the primary identity
      // This ensures consistency across all modules
      request.user = user;
      const { id, ...userData } = user;
      request.profile = { 
        id,  // Use auth.users.id as profile.id
        ...userData 
      };

      return true;
    } catch (error) {
      throw new UnauthorizedException('Invalid or expired token');
    }
  }
}
