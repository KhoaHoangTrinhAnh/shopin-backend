import { Injectable, UnauthorizedException, BadRequestException, ConflictException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import { RegisterDto, LoginDto, ResetPasswordRequestDto, UpdateProfileDto } from './dto/auth.dto';
import { AuthResponse, User } from '@supabase/supabase-js';

@Injectable()
export class AuthService {
  constructor(private readonly supabaseService: SupabaseService) {}

  /**
   * Generate SVG avatar with first letter of user's name
   */
  private generateAvatarSVG(name: string): string {
    const firstLetter = (name || 'U').charAt(0).toUpperCase();
    const colors = [
      '#FF6B6B', '#4ECDC4', '#45B7D1', '#FFA07A', '#98D8C8',
      '#F7DC6F', '#BB8FCE', '#85C1E2', '#F8B739', '#52B788'
    ];
    const color = colors[Math.floor(Math.random() * colors.length)];
    
    const svg = `
      <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100">
        <circle cx="50" cy="50" r="50" fill="${color}"/>
        <text x="50" y="50" font-family="Arial, sans-serif" font-size="45" font-weight="bold" 
              fill="white" text-anchor="middle" dominant-baseline="central">
          ${firstLetter}
        </text>
      </svg>
    `.trim();
    
    return `data:image/svg+xml;base64,${Buffer.from(svg).toString('base64')}`;
  }

  /**
   * Register a new user
   * Note: User registration is done on the frontend using Supabase Auth directly
   * This endpoint is for creating/syncing the profile after registration
   */
  async register(registerDto: RegisterDto): Promise<{ user: User; session: any; profile: any }> {
    const supabase = this.supabaseService.getClient();
    const { email, password, full_name, phone } = registerDto;

    try {
      // Use admin API to create user with service_role
      const { data: authData, error: authError } = await supabase.auth.admin.createUser({
        email,
        password,
        email_confirm: true, // Auto-confirm for immediate login
        user_metadata: {
          full_name: full_name || email.split('@')[0],
        },
      });

      if (authError) {
        // Check if user already exists
        if (authError.message.includes('already') || authError.message.includes('exists')) {
          throw new ConflictException('User with this email already exists');
        }
        throw new BadRequestException(authError.message);
      }

      if (!authData.user) {
        throw new BadRequestException('Failed to create user');
      }

      // Generate avatar
      const avatar_url = this.generateAvatarSVG(full_name || email.split('@')[0]);

      // Create profile
      const { data: profile, error: profileError } = await supabase
        .from('profiles')
        .upsert({
          user_id: authData.user.id,
          email,
          full_name: full_name || email.split('@')[0],
          phone: phone || null,
          role: 'user',
          avatar_url,
        })
        .select()
        .single();

      if (profileError) {
        console.error('Profile creation error:', profileError);
        // Clean up auth user if profile creation fails
        await supabase.auth.admin.deleteUser(authData.user.id);
        throw new BadRequestException('Failed to create user profile');
      }

      // Return user and profile without session (user needs to login)
      return {
        user: authData.user,
        session: null, // Client needs to login separately or use the confirmation flow
        profile: profile || { user_id: authData.user.id, email, full_name, role: 'user', avatar_url },
      };
    } catch (error) {
      if (error instanceof ConflictException || error instanceof BadRequestException) {
        throw error;
      }
      throw new BadRequestException('Registration failed: ' + error.message);
    }
  }

  /**
   * Login user
   */
  async login(loginDto: LoginDto): Promise<{ user: User; session: any; profile: any }> {
    const supabase = this.supabaseService.getClient();
    const { email, password } = loginDto;

    try {
      // Sign in with Supabase Auth
      const { data: authData, error: authError } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (authError) {
        throw new UnauthorizedException('Invalid credentials');
      }

      if (!authData.user) {
        throw new UnauthorizedException('Login failed');
      }

      // Fetch user profile
      const { data: profile, error: profileError } = await supabase
        .from('profiles')
        .select('*')
        .eq('user_id', authData.user.id)
        .single();

      if (profileError || !profile) {
        // Profile doesn't exist, create it
        const avatar_url = this.generateAvatarSVG(authData.user.email?.split('@')[0] || 'User');
        
        const { data: newProfile, error: insertError } = await supabase
          .from('profiles')
          .insert({
            user_id: authData.user.id,
            email: authData.user.email,
            full_name: authData.user.email?.split('@')[0],
            role: 'user',
            avatar_url,
          })
          .select()
          .single();

        if (insertError) {
          console.error('Profile insert error:', insertError);
          throw new BadRequestException('Failed to create user profile');
        }

        return {
          user: authData.user,
          session: authData.session,
          profile: newProfile,
        };
      }

      // Generate avatar if missing
      if (!profile.avatar_url) {
        const avatar_url = this.generateAvatarSVG(profile.full_name || profile.email.split('@')[0]);
        await supabase
          .from('profiles')
          .update({ avatar_url })
          .eq('user_id', authData.user.id);
        profile.avatar_url = avatar_url;
      }

      return {
        user: authData.user,
        session: authData.session,
        profile,
      };
    } catch (error) {
      if (error instanceof UnauthorizedException) {
        throw error;
      }
      throw new UnauthorizedException('Login failed: ' + error.message);
    }
  }

  /**
   * Logout user - invalidate the token by signing out
   * Note: With service_role client, we use admin API to sign out specific user
   */
  async logout(accessToken: string): Promise<{ message: string }> {
    const supabase = this.supabaseService.getClient();
    
    try {
      // First verify the token to get user info
      const { data: { user }, error: verifyError } = await supabase.auth.getUser(accessToken);
      
      if (verifyError || !user) {
        // Token already invalid, still remove from cache
        this.tokenCache.delete(accessToken);
        return { message: 'Logged out successfully' };
      }

      // Use admin API to sign out the user (requires service_role)
      const { error } = await supabase.auth.admin.signOut(accessToken);
      
      // Remove token from cache immediately
      this.tokenCache.delete(accessToken);
      
      if (error) {
        console.warn('Admin signOut failed (non-critical):', error.message);
        // Even if signOut fails, the token will expire naturally
      }

      return { message: 'Logged out successfully' };
    } catch (error) {
      console.error('Logout error:', error);
      // Return success anyway - client should clear its session
      return { message: 'Logged out successfully' };
    }
  }

  /**
   * Request password reset email
   */
  async requestPasswordReset(resetDto: ResetPasswordRequestDto): Promise<{ message: string }> {
    const supabase = this.supabaseService.getClient();
    const { email } = resetDto;

    if (!process.env.FRONTEND_URL) {
      throw new BadRequestException('FRONTEND_URL is not configured');
    }

    const { error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${process.env.FRONTEND_URL}/auth/reset-password`,
    });

    if (error) {
      throw new BadRequestException(error.message);
    }

    return {
      message: 'Password reset email sent. Please check your inbox.',
    };
  }

  /**
   * Get current user profile
   * Auto-creates profile if it doesn't exist (for users who registered before trigger was added)
   */
  async getProfile(userId: string): Promise<any> {
    const supabase = this.supabaseService.getClient();

    try {
      const { data: profile, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('user_id', userId)
        .single();

      if (error || !profile) {
        // Profile not found - try to create it from auth.users
        const { data: { user }, error: userError } = await supabase.auth.admin.getUserById(userId);
        
        if (userError || !user) {
          throw new UnauthorizedException('User not found');
        }

        // Create profile for this user
        const avatar_url = this.generateAvatarSVG(user.email?.split('@')[0] || 'User');
        
        const { data: newProfile, error: createError } = await supabase
          .from('profiles')
          .insert({
            user_id: user.id,
            email: user.email,
            full_name: user.user_metadata?.full_name || user.email?.split('@')[0],
            role: 'user',
            avatar_url,
          })
          .select()
          .single();

        if (createError || !newProfile) {
          throw new UnauthorizedException('Failed to create profile');
        }

        return newProfile;
      }

      return profile;
    } catch (error) {
      if (error instanceof UnauthorizedException) {
        throw error;
      }
      throw new UnauthorizedException('Failed to fetch profile: ' + error.message);
    }
  }

  /**
   * Update user profile
   */
  async updateProfile(userId: string, updateDto: UpdateProfileDto): Promise<any> {
    const supabase = this.supabaseService.getClient();

    try {
      const { data: profile, error } = await supabase
        .from('profiles')
        .update(updateDto)
        .eq('user_id', userId)
        .select()
        .single();

      if (error) {
        throw new BadRequestException('Failed to update profile');
      }

      return profile;
    } catch (error) {
      throw new BadRequestException('Failed to update profile: ' + error.message);
    }
  }

  // Simple in-memory token cache (5 minutes TTL)
  // Security trade-off: Revoked tokens remain valid for up to TOKEN_CACHE_TTL (configurable)
  // For higher-security deployments, reduce TOKEN_CACHE_TTL or use external cache with revocation list
  private tokenCache = new Map<string, { user: User; expiresAt: number }>();
  private readonly TOKEN_CACHE_TTL = 5 * 60 * 1000; // 5 minutes (configurable)

  /**
   * Verify user session with caching to reduce Supabase API calls
   */
  async verifySession(accessToken: string): Promise<User> {
    // Check cache first
    const cached = this.tokenCache.get(accessToken);
    if (cached && cached.expiresAt > Date.now()) {
      return cached.user;
    }

    const supabase = this.supabaseService.getClient();

    try {
      const { data: { user }, error } = await supabase.auth.getUser(accessToken);

      if (error || !user) {
        // Remove from cache if invalid
        this.tokenCache.delete(accessToken);
        throw new UnauthorizedException('Invalid session');
      }

      // Cache the verified user
      this.tokenCache.set(accessToken, {
        user,
        expiresAt: Date.now() + this.TOKEN_CACHE_TTL,
      });

      // Clean up old cache entries (simple cleanup)
      if (this.tokenCache.size > 1000) {
        const now = Date.now();
        for (const [key, value] of this.tokenCache.entries()) {
          if (value.expiresAt < now) {
            this.tokenCache.delete(key);
          }
        }
      }

      return user;
    } catch (error) {
      // Remove from cache on error
      this.tokenCache.delete(accessToken);
      
      // If it's a timeout error, provide more helpful message
      if (error.message?.includes('timeout') || error.code === 'UND_ERR_CONNECT_TIMEOUT') {
        throw new UnauthorizedException('Authentication service temporarily unavailable. Please try again.');
      }
      
      throw new UnauthorizedException('Session verification failed: ' + error.message);
    }
  }

  /**
   * Social login (Google, Facebook, etc.)
   */
  async socialLogin(provider: 'google' | 'facebook'): Promise<{ url: string }> {
    const supabase = this.supabaseService.getClient();

    try {
      const { data, error } = await supabase.auth.signInWithOAuth({
        provider,
        options: {
          redirectTo: `${process.env.FRONTEND_URL}/auth/callback`,
        },
      });

      if (error) {
        throw new BadRequestException(error.message);
      }

      return {
        url: data.url,
      };
    } catch (error) {
      throw new BadRequestException('Social login failed: ' + error.message);
    }
  }

  /**
   * Change user password
   */
  async changePassword(userId: string, currentPassword: string, newPassword: string): Promise<{ message: string }> {
    const supabase = this.supabaseService.getClient();

    // First, verify the current password by attempting to sign in
    const { data: user } = await supabase.auth.admin.getUserById(userId);
    
    if (!user?.user?.email) {
      throw new UnauthorizedException('User not found');
    }

    // Verify current password
    const { error: signInError } = await supabase.auth.signInWithPassword({
      email: user.user.email,
      password: currentPassword,
    });

    if (signInError) {
      throw new UnauthorizedException('Current password is incorrect');
    }

    // Update to new password
    const { error: updateError } = await supabase.auth.admin.updateUserById(userId, {
      password: newPassword,
    });

    if (updateError) {
      throw new BadRequestException('Failed to update password: ' + updateError.message);
    }

    return { message: 'Password updated successfully' };
  }

  /**
   * Delete user account and all associated data
   */
  async deleteAccount(userId: string, password: string): Promise<{ message: string }> {
    const supabase = this.supabaseService.getClient();

    // Verify password before deletion
    const { data: user } = await supabase.auth.admin.getUserById(userId);
    
    if (!user?.user?.email) {
      throw new UnauthorizedException('User not found');
    }

    // Get profile
    const profile = await this.getProfile(userId);
    if (!profile) {
      throw new UnauthorizedException('Profile not found');
    }

    // Verify password
    const { error: signInError } = await supabase.auth.signInWithPassword({
      email: user.user.email,
      password: password,
    });

    if (signInError) {
      throw new UnauthorizedException('Password is incorrect');
    }

    // Delete user data in order (respecting foreign key constraints)
    try {
      // Delete order items first, then orders
      const { data: orders, error: ordersSelectError } = await supabase
        .from('orders')
        .select('id')
        .eq('profile_id', profile.id);

      if (ordersSelectError) {
        throw new BadRequestException('Failed to fetch orders: ' + ordersSelectError.message);
      }

      if (orders && orders.length > 0) {
        const orderIds = orders.map(o => o.id);
        const { error: orderItemsError } = await supabase.from('order_items').delete().in('order_id', orderIds);
        if (orderItemsError) {
          throw new BadRequestException('Failed to delete order items: ' + orderItemsError.message);
        }

        const { error: ordersError } = await supabase.from('orders').delete().eq('profile_id', profile.id);
        if (ordersError) {
          throw new BadRequestException('Failed to delete orders: ' + ordersError.message);
        }
      }

      // Delete cart items and cart
      const { data: carts, error: cartsSelectError } = await supabase
        .from('carts')
        .select('id')
        .eq('profile_id', profile.id);

      if (cartsSelectError) {
        throw new BadRequestException('Failed to fetch carts: ' + cartsSelectError.message);
      }

      if (carts && carts.length > 0) {
        const cartIds = carts.map(c => c.id);
        const { error: cartItemsError } = await supabase.from('cart_items').delete().in('cart_id', cartIds);
        if (cartItemsError) {
          throw new BadRequestException('Failed to delete cart items: ' + cartItemsError.message);
        }

        const { error: cartsError } = await supabase.from('carts').delete().eq('profile_id', profile.id);
        if (cartsError) {
          throw new BadRequestException('Failed to delete carts: ' + cartsError.message);
        }
      }

      // Delete wishlist items and wishlist
      const { data: wishlists, error: wishlistsSelectError } = await supabase
        .from('wishlists')
        .select('id')
        .eq('profile_id', profile.id);

      if (wishlistsSelectError) {
        throw new BadRequestException('Failed to fetch wishlists: ' + wishlistsSelectError.message);
      }

      if (wishlists && wishlists.length > 0) {
        const wishlistIds = wishlists.map(w => w.id);
        const { error: wishlistItemsError } = await supabase.from('wishlist_items').delete().in('wishlist_id', wishlistIds);
        if (wishlistItemsError) {
          throw new BadRequestException('Failed to delete wishlist items: ' + wishlistItemsError.message);
        }

        const { error: wishlistsError } = await supabase.from('wishlists').delete().eq('profile_id', profile.id);
        if (wishlistsError) {
          throw new BadRequestException('Failed to delete wishlists: ' + wishlistsError.message);
        }
      }

      // Delete addresses
      const { error: addressesError } = await supabase.from('addresses').delete().eq('profile_id', profile.id);
      if (addressesError) {
        throw new BadRequestException('Failed to delete addresses: ' + addressesError.message);
      }

      // Delete reviews
      const { error: reviewsError } = await supabase.from('reviews').delete().eq('profile_id', profile.id);
      if (reviewsError) {
        throw new BadRequestException('Failed to delete reviews: ' + reviewsError.message);
      }

      // Delete chats
      const { error: chatsError } = await supabase.from('chats').delete().eq('sender_id', profile.id);
      if (chatsError) {
        throw new BadRequestException('Failed to delete chats: ' + chatsError.message);
      }

      // Delete articles
      const { error: articlesError } = await supabase.from('articles').delete().eq('author_id', profile.id);
      if (articlesError) {
        throw new BadRequestException('Failed to delete articles: ' + articlesError.message);
      }

      // Delete profile (using user_id to match auth.users.id)
      const { error: profileError } = await supabase.from('profiles').delete().eq('user_id', userId);
      if (profileError) {
        throw new BadRequestException('Failed to delete profile: ' + profileError.message);
      }

      // Finally, delete auth user
      const { error: deleteError } = await supabase.auth.admin.deleteUser(userId);

      if (deleteError) {
        throw new BadRequestException('Failed to delete account: ' + deleteError.message);
      }

      return { message: 'Account deleted successfully' };
    } catch (error) {
      throw new BadRequestException('Failed to delete account: ' + error.message);
    }
  }
}

