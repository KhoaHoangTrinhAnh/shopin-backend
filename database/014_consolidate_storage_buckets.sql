-- Migration 014: Consolidate Storage Buckets
-- Removes 'avatars' bucket and standardizes on 'shopin_storage'
-- All profile images should use shopin_storage/profile_images
-- Run this in Supabase SQL Editor

-- ============================================================================
-- 1. MIGRATE EXISTING AVATAR DATA
-- ============================================================================

-- Update any avatar URLs in profiles table that reference the old bucket
UPDATE public.profiles
SET avatar_url = REPLACE(avatar_url, '/storage/v1/object/public/avatars/', '/storage/v1/object/public/shopin_storage/')
WHERE avatar_url LIKE '%/storage/v1/object/public/avatars/%';

-- ============================================================================
-- 2. COPY FILES FROM AVATARS TO SHOPIN_STORAGE (if bucket has files)
-- ============================================================================

-- Note: Supabase Storage doesn't support SQL-based file copying between buckets
-- You must use one of these methods to move files:

-- METHOD 1: Use Supabase Dashboard
-- 1. Go to Storage > avatars bucket
-- 2. Download all files
-- 3. Go to Storage > shopin_storage bucket
-- 4. Create 'profile_images' folder if not exists
-- 5. Upload files to shopin_storage/profile_images

-- METHOD 2: Use Supabase API/CLI
-- Run this JavaScript in browser console or Node.js:
/*
const { createClient } = require('@supabase/supabase-js');
const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

async function migrateFiles() {
  // List all files in avatars bucket
  const { data: files } = await supabase.storage.from('avatars').list('profile_images');
  
  for (const file of files) {
    // Download from avatars
    const { data: fileData } = await supabase.storage
      .from('avatars')
      .download(`profile_images/${file.name}`);
    
    // Upload to shopin_storage
    await supabase.storage
      .from('shopin_storage')
      .upload(`profile_images/${file.name}`, fileData, {
        contentType: file.metadata?.mimetype,
        upsert: true
      });
  }
  
  console.log('Migration complete!');
}

migrateFiles();
*/

-- ============================================================================
-- 3. DROP OLD AVATAR BUCKET POLICIES
-- ============================================================================

-- Drop all policies related to 'avatars' bucket
DROP POLICY IF EXISTS "Avatar images are publicly accessible" ON storage.objects;
DROP POLICY IF EXISTS "Users can upload their own avatar" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own avatar" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own avatar" ON storage.objects;

-- ============================================================================
-- 4. DELETE ALL FILES FROM AVATARS BUCKET
-- ============================================================================

-- Delete all objects in the avatars bucket
-- This allows the bucket to be deleted without foreign key constraint errors
DELETE FROM storage.objects WHERE bucket_id = 'avatars';

-- ============================================================================
-- 5. DELETE AVATARS BUCKET
-- ============================================================================

-- Now we can safely delete the avatars bucket
DELETE FROM storage.buckets WHERE id = 'avatars';

-- ============================================================================
-- 6. VERIFY MIGRATION
-- ============================================================================

DO $$ 
DECLARE
  avatars_bucket_exists boolean;
  shopin_storage_exists boolean;
  avatars_object_count integer;
BEGIN
  -- Check if avatars bucket still exists
  SELECT EXISTS (
    SELECT 1 FROM storage.buckets WHERE id = 'avatars'
  ) INTO avatars_bucket_exists;
  
  -- Check if shopin_storage bucket exists
  SELECT EXISTS (
    SELECT 1 FROM storage.buckets WHERE id = 'shopin_storage'
  ) INTO shopin_storage_exists;
  
  -- Count objects in avatars bucket (should be 0 before deletion)
  SELECT COUNT(*) INTO avatars_object_count
  FROM storage.objects WHERE bucket_id = 'avatars';
  
  IF NOT avatars_bucket_exists AND shopin_storage_exists THEN
    RAISE NOTICE 'Migration 014 completed successfully!';
    RAISE NOTICE '- avatars bucket removed';
    RAISE NOTICE '- shopin_storage bucket is the only storage bucket';
    RAISE NOTICE '- Profile images should be stored in shopin_storage/profile_images';
    RAISE NOTICE '- Avatar URLs updated in profiles table';
  ELSIF avatars_bucket_exists AND avatars_object_count > 0 THEN
    RAISE WARNING 'Migration 014 incomplete: avatars bucket still has % files', avatars_object_count;
    RAISE WARNING 'Files have been deleted automatically. Verify your data!';
  ELSIF avatars_bucket_exists THEN
    RAISE WARNING 'Migration 014 incomplete: avatars bucket still exists';
  ELSIF NOT shopin_storage_exists THEN
    RAISE WARNING 'Migration 014 incomplete: shopin_storage bucket not found';
    RAISE WARNING 'Please run migration 012 first to create shopin_storage bucket';
  END IF;
END $$;

