import { createParamDecorator, ExecutionContext } from '@nestjs/common';

/**
 * Extract JWT access token from Authorization header
 * Returns the token string or null if Authorization header is missing or invalid
 * Usage: @AccessToken() token: string | null
 */
export const AccessToken = createParamDecorator(
  (data: unknown, ctx: ExecutionContext): string | null => {
    const request = ctx.switchToHttp().getRequest();
    const authorization = request.headers['authorization'];
    
    if (!authorization) {
      return null;
    }
    
    // Validate Bearer scheme (case-insensitive)
    const bearerMatch = authorization.match(/^Bearer\s+(.+)$/i);
    if (!bearerMatch) {
      return null;
    }
    
    // Extract token from "Bearer <token>"
    return bearerMatch[1];
  },
);
