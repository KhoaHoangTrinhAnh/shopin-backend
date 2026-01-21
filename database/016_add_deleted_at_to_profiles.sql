-- Migration: Add deleted_at to profiles table
-- Date: 2026-01-06
-- Description: Add soft delete support for user profiles

-- Add deleted_at column to profiles table
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS deleted_at timestamp with time zone;

-- Create index for better query performance on non-deleted users
CREATE INDEX IF NOT EXISTS idx_profiles_deleted_at 
ON public.profiles(deleted_at) 
WHERE deleted_at IS NULL;

-- Update RLS policies to exclude deleted users from normal queries
-- First, drop existing policies if they need updating
DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;

-- Recreate policies with deleted_at check
CREATE POLICY "Users can view their own profile"
ON public.profiles FOR SELECT
TO authenticated
USING (
  auth.uid() = id 
  AND deleted_at IS NULL
);

CREATE POLICY "Users can update their own profile"
ON public.profiles FOR UPDATE
TO authenticated
USING (
  auth.uid() = id 
  AND deleted_at IS NULL
)
WITH CHECK (
  auth.uid() = id 
  AND deleted_at IS NULL
);

-- Admin can view all profiles including deleted
DROP POLICY IF EXISTS "Admins can view all profiles" ON public.profiles;
CREATE POLICY "Admins can view all profiles"
ON public.profiles FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'admin'
  )
);

-- Admin can update all profiles including soft delete
DROP POLICY IF EXISTS "Admins can update all profiles" ON public.profiles;
CREATE POLICY "Admins can update all profiles"
ON public.profiles FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'admin'
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'admin'
  )
);

-- Comment on column
COMMENT ON COLUMN public.profiles.deleted_at IS 'Timestamp when user was soft deleted. NULL means user is active.';
