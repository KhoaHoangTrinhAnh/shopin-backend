-- Migration 012: Setup Supabase Storage bucket for profile images
-- Uses 'shopin_storage' bucket with 'profile_images' folder for avatars
-- Run this in Supabase SQL Editor

-- ============================================================================
-- 1. ENSURE SHOPIN_STORAGE BUCKET EXISTS
-- ============================================================================

-- Insert/update bucket if not exists
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'shopin_storage',
  'shopin_storage',
  true, -- Public bucket for asset access
  10485760, -- 10MB max file size
  ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp']
)
ON CONFLICT (id) DO UPDATE SET
  public = true,
  file_size_limit = 10485760,
  allowed_mime_types = ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];

-- ============================================================================
-- 2. SET BUCKET POLICIES (RLS)
-- ============================================================================

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Avatar images are publicly accessible" ON storage.objects;
DROP POLICY IF EXISTS "Users can upload their own avatar" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own avatar" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own avatar" ON storage.objects;
DROP POLICY IF EXISTS "Public read access for shopin_storage" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can upload to profile_images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update profile_images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete profile_images" ON storage.objects;

-- Allow public read access to all files in shopin_storage
CREATE POLICY "Public read access for shopin_storage"
ON storage.objects FOR SELECT
USING (bucket_id = 'shopin_storage');

-- Allow authenticated users to upload to profile_images folder
CREATE POLICY "Authenticated users can upload to profile_images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'shopin_storage' 
  AND (storage.foldername(name))[1] = 'profile_images'
);

-- Allow authenticated users to update their files in profile_images
CREATE POLICY "Authenticated users can update profile_images"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'shopin_storage' AND (storage.foldername(name))[1] = 'profile_images')
WITH CHECK (bucket_id = 'shopin_storage' AND (storage.foldername(name))[1] = 'profile_images');

-- Allow authenticated users to delete their files in profile_images
CREATE POLICY "Authenticated users can delete profile_images"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'shopin_storage' AND (storage.foldername(name))[1] = 'profile_images');

-- ============================================================================
-- 3. VERIFY BUCKET CREATION
-- ============================================================================

DO $$ 
DECLARE
  bucket_exists boolean;
BEGIN
  SELECT EXISTS (
    SELECT 1 FROM storage.buckets 
    WHERE id = 'shopin_storage'
  ) INTO bucket_exists;
  
  IF bucket_exists THEN
    RAISE NOTICE 'Migration 012 completed successfully: shopin_storage bucket configured';
    RAISE NOTICE 'Profile images should be stored in shopin_storage/profile_images folder';
  ELSE
    RAISE WARNING 'Migration 012 incomplete: shopin_storage bucket not found';
  END IF;
END $$;

