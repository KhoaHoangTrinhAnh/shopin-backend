-- Migration 007: Fix profiles table schema to match auth service queries
-- This migration adds missing columns that auth.service.ts expects

-- Problem identified:
-- 1. Backend queries use 'user_id' column but schema only has 'id'
-- 2. Backend queries use 'role' column but schema doesn't have it
-- 3. Migration 005 was written but may not have been applied to Supabase

-- Solution: Add missing columns and ensure proper constraints

-- 1. Add user_id column if not exists (link to auth.users)
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'profiles' 
    AND column_name = 'user_id'
  ) THEN
    ALTER TABLE public.profiles ADD COLUMN user_id uuid UNIQUE;
    COMMENT ON COLUMN public.profiles.user_id IS 'Foreign key to auth.users.id';
  END IF;
END $$;

-- 2. Add role column if not exists
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'profiles' 
    AND column_name = 'role'
  ) THEN
    ALTER TABLE public.profiles ADD COLUMN role text DEFAULT 'user' CHECK (role IN ('user', 'admin'));
    COMMENT ON COLUMN public.profiles.role IS 'User role: user or admin';
  END IF;
END $$;

-- 3. Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON public.profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email);
CREATE INDEX IF NOT EXISTS idx_profiles_role ON public.profiles(role);

-- 4. Update existing profiles to have default role
UPDATE public.profiles SET role = 'user' WHERE role IS NULL;

-- 5. Migrate existing data: if profiles.id exists but user_id is null,
--    we can't automatically link to auth.users without knowing the mapping.
--    This is a manual step - admin should link profiles to auth users.
--    For new users, the trigger (from migration 005) will handle it.

-- 6. Add foreign key constraint (commented out - enable after data migration)
-- Note: Uncomment this ONLY after ensuring all profiles have valid user_id
-- ALTER TABLE public.profiles 
--   ADD CONSTRAINT fk_profiles_auth_users 
--   FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- 7. Enable RLS if not already enabled
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 8. Create RLS policies (drop existing if present to avoid conflicts)
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Public profiles are viewable by everyone" ON public.profiles;
DROP POLICY IF EXISTS "Service role can do anything" ON public.profiles;

-- Allow users to view their own profile
CREATE POLICY "Users can view own profile" ON public.profiles
  FOR SELECT
  USING (auth.uid() = user_id);

-- Allow users to update their own profile (cannot change role)
CREATE POLICY "Users can update own profile" ON public.profiles
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (
    auth.uid() = user_id 
    AND role = (SELECT role FROM public.profiles WHERE user_id = auth.uid())
  );

-- Allow public to read basic profile info
CREATE POLICY "Public profiles are viewable by everyone" ON public.profiles
  FOR SELECT
  USING (true);

-- Allow service role to do anything (for backend operations)
CREATE POLICY "Service role can do anything" ON public.profiles
  USING (auth.jwt() ->> 'role' = 'service_role');

-- 9. Ensure trigger exists for auto-creating profiles on user signup
-- (This is from migration 005 - reapply in case it wasn't executed)

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (user_id, email, full_name, role, avatar_url)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    'user',
    NULL  -- Will be generated on first login
  )
  ON CONFLICT (user_id) DO NOTHING;  -- Prevent duplicate inserts
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create or replace trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 10. Helper functions
CREATE OR REPLACE FUNCTION public.is_admin(user_uuid uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.profiles WHERE user_id = user_uuid AND role = 'admin'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS text AS $$
BEGIN
  RETURN (SELECT role FROM public.profiles WHERE user_id = auth.uid());
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Summary of changes:
-- ✅ Added user_id column (links to auth.users)
-- ✅ Added role column with CHECK constraint
-- ✅ Created necessary indexes
-- ✅ Set up RLS policies
-- ✅ Created trigger for auto-profile creation
-- ✅ Added helper functions

-- IMPORTANT MANUAL STEPS AFTER RUNNING THIS MIGRATION:
-- 1. For existing profiles without user_id, manually link them to auth.users
-- 2. After linking, uncomment and run the foreign key constraint (line 57-59)
-- 3. Delete orphaned profiles that don't match any auth.users
