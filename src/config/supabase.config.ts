import { registerAs } from '@nestjs/config';

export default registerAs('supabase', () => {
  const url = process.env.SUPABASE_URL;
  const anonKey = process.env.SUPABASE_ANON_KEY;
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!url) {
    throw new Error('SUPABASE_URL is required but not set in environment variables');
  }

  if (!anonKey) {
    throw new Error('SUPABASE_ANON_KEY is required but not set in environment variables');
  }

  if (!serviceRoleKey) {
    throw new Error('SUPABASE_SERVICE_ROLE_KEY is required but not set in environment variables');
  }

  return {
    url,
    anonKey,
    serviceRoleKey,
  };
});
