import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';

@Injectable()
export class AdminGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const profile = request.profile;

    if (!profile) {
      throw new ForbiddenException('Không có quyền truy cập');
    }

    if (profile.role !== 'admin') {
      throw new ForbiddenException('Chỉ admin mới có quyền truy cập');
    }

    // Check if admin account is blocked
    if (profile.blocked === true) {
      throw new ForbiddenException('Tài khoản admin đã bị khóa');
    }

    return true;
  }
}
