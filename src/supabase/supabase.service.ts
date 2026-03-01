import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createClient, SupabaseClient } from '@supabase/supabase-js';

@Injectable()
export class SupabaseService {
  private supabase: SupabaseClient;

  constructor(private configService: ConfigService) {
    const supabaseUrl = this.configService.get<string>('supabase.url');
    /**
     * SECURITY WARNING: Using Service Role Key
     * 
     * The service role key bypasses Row Level Security (RLS) policies.
     * This is intentional for server-side operations but comes with risks:
     * 
     * 1. NEVER expose this key to client-side code
     * 2. NEVER commit this key to version control
     * 3. Use environment variables only
     * 4. Implement proper authorization checks in your service layer
     * 5. Consider using anon key + RLS for stricter security where possible
     * 
     * Use service role key ONLY when you need to:
     * - Perform admin operations
     * - Bypass RLS for trusted server operations
     * - Access data across user boundaries (e.g., analytics)
     */
    const supabaseKey = this.configService.get<string>('supabase.serviceRoleKey');
    
    if (!supabaseUrl || !supabaseKey) {
      throw new Error('Supabase URL and Service Role Key must be provided');
    }

    this.supabase = createClient(supabaseUrl, supabaseKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
      global: {
        fetch: (url, options: RequestInit = {}) => {
          // Add timeout to all fetch requests (30 seconds)
          const controller = new AbortController();
          const timeoutId = setTimeout(() => controller.abort(), 30000);
          
          // Preserve caller's abort signal by combining signals
          let combinedSignal = controller.signal;
          
          if (options.signal) {
            // Use AbortSignal.any if available (Node 20+)
            if (typeof AbortSignal.any === 'function') {
              combinedSignal = AbortSignal.any([options.signal, controller.signal]);
            } else {
              // Fallback: listen to caller signal and abort our controller
              const callerSignal = options.signal as AbortSignal;
              callerSignal.addEventListener('abort', () => controller.abort(), { once: true });
            }
          }
          
          return fetch(url, {
            ...options,
            signal: combinedSignal,
          }).finally(() => clearTimeout(timeoutId));
        },
      },
    });
  }

  getClient(): SupabaseClient {
    return this.supabase;
  }

  /**
   * Create a Supabase client with user's JWT token
   * Use this for RPC functions that need auth.uid() context
   * 
   * @param accessToken - User's JWT access token from Supabase Auth
   * @returns SupabaseClient configured with user's auth context
   */
  getClientWithAuth(accessToken: string): SupabaseClient {
    // Validate accessToken is non-empty
    if (!accessToken || accessToken.trim() === '') {
      throw new Error('accessToken must be a non-empty string');
    }
    
    const supabaseUrl = this.configService.get<string>('supabase.url');
    const supabaseAnonKey = this.configService.get<string>('supabase.anonKey');
    
    if (!supabaseUrl || !supabaseAnonKey) {
      throw new Error('Supabase URL and Anon Key must be provided');
    }

    // Create client with anon key and set user's JWT token
    return createClient(supabaseUrl, supabaseAnonKey, {
      global: {
        headers: {
          Authorization: `Bearer ${accessToken}`,
        },
        fetch: (url, options: RequestInit = {}) => {
          // Add timeout to all fetch requests (30 seconds)
          const controller = new AbortController();
          const timeoutId = setTimeout(() => controller.abort(), 30000);
          
          let combinedSignal = controller.signal;
          
          if (options.signal) {
            if (typeof AbortSignal.any === 'function') {
              combinedSignal = AbortSignal.any([options.signal, controller.signal]);
            } else {
              const callerSignal = options.signal as AbortSignal;
              callerSignal.addEventListener('abort', () => controller.abort(), { once: true });
            }
          }
          
          return fetch(url, {
            ...options,
            signal: combinedSignal,
          }).finally(() => clearTimeout(timeoutId));
        },
      },
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    });
  }
}
