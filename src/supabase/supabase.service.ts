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
    });
  }

  getClient(): SupabaseClient {
    return this.supabase;
  }
}
