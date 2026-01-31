-- Migration: Add user_id to profiles table and fix FK references
-- Purpose: Use auth.users.id as primary identity instead of profiles.id

BEGIN;

-- Step 0: Validation - Check for data issues before proceeding
DO $$
DECLARE
  null_email_count INTEGER;
  missing_user_count INTEGER;
  duplicate_email_count INTEGER;
BEGIN
  -- Check for profiles with NULL email
  SELECT COUNT(*) INTO null_email_count
  FROM profiles
  WHERE email IS NULL;
  
  IF null_email_count > 0 THEN
    RAISE EXCEPTION 'Found % profiles with NULL email - cannot proceed', null_email_count;
  END IF;
  
  -- Check for profiles with emails not in auth.users
  SELECT COUNT(*) INTO missing_user_count
  FROM profiles p
  WHERE NOT EXISTS (
    SELECT 1 FROM auth.users au WHERE au.email = p.email
  );
  
  IF missing_user_count > 0 THEN
    RAISE EXCEPTION 'Found % profiles with emails not in auth.users - cannot proceed', missing_user_count;
  END IF;
  
  -- Check for duplicate emails in auth.users
  SELECT COUNT(*) INTO duplicate_email_count
  FROM (
    SELECT email
    FROM auth.users
    WHERE email IS NOT NULL
    GROUP BY email
    HAVING COUNT(*) > 1
  ) dups;
  
  IF duplicate_email_count > 0 THEN
    RAISE EXCEPTION 'Found % duplicate emails in auth.users - cannot proceed', duplicate_email_count;
  END IF;
END $$;

-- Step 1: Add user_id column to profiles table
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS user_id uuid UNIQUE;

-- Step 2: Add FK constraint to auth.users
ALTER TABLE profiles ADD CONSTRAINT fk_profiles_user_id 
  FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- Step 3: Create index for performance
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON profiles(user_id);

-- Step 4: For existing profiles, we need to link them to auth.users
-- This assumes each profile.email matches an auth.users.email
-- Only update rows where match exists (already validated above)
UPDATE profiles p
SET user_id = au.id
FROM auth.users au
WHERE au.email = p.email
  AND au.email IS NOT NULL
  AND p.user_id IS NULL;

-- Step 5: Make user_id NOT NULL after populating
ALTER TABLE profiles ALTER COLUMN user_id SET NOT NULL;

-- Step 6: Update all FK references to use user_id instead of id
-- Note: This requires dropping and recreating FKs

-- Detect orphaned rows before updating
DO $$
DECLARE
  orphaned_addresses INTEGER;
  orphaned_carts INTEGER;
BEGIN
  SELECT COUNT(*) INTO orphaned_addresses
  FROM addresses
  WHERE profile_id IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM profiles WHERE profiles.id = addresses.profile_id);
  
  SELECT COUNT(*) INTO orphaned_carts
  FROM carts
  WHERE profile_id IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM profiles WHERE profiles.id = carts.profile_id);
  
  IF orphaned_addresses > 0 OR orphaned_carts > 0 THEN
    RAISE WARNING 'Found % orphaned addresses and % orphaned carts', orphaned_addresses, orphaned_carts;
  END IF;
END $$;

-- Drop existing FKs
ALTER TABLE addresses DROP CONSTRAINT IF EXISTS addresses_profile_id_fkey;
ALTER TABLE carts DROP CONSTRAINT IF EXISTS carts_profile_id_fkey;
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_profile_id_fkey;
ALTER TABLE wishlists DROP CONSTRAINT IF EXISTS wishlists_profile_id_fkey;
ALTER TABLE reviews DROP CONSTRAINT IF EXISTS reviews_profile_id_fkey;
ALTER TABLE chats DROP CONSTRAINT IF EXISTS chats_sender_id_fkey;
ALTER TABLE articles DROP CONSTRAINT IF EXISTS articles_author_id_fkey;
ALTER TABLE conversations DROP CONSTRAINT IF EXISTS conversations_user_id_fkey;
ALTER TABLE chat_messages DROP CONSTRAINT IF EXISTS chat_messages_sender_id_fkey;
ALTER TABLE audit_logs DROP CONSTRAINT IF EXISTS audit_logs_admin_id_fkey;
ALTER TABLE ai_usage_logs DROP CONSTRAINT IF EXISTS ai_usage_logs_user_id_fkey;

-- Update all FK columns to use auth.users.id instead of profiles.id (JOIN-based)
UPDATE addresses a
SET profile_id = p.user_id
FROM profiles p
WHERE p.id = a.profile_id
  AND a.profile_id IS NOT NULL;

UPDATE carts c
SET profile_id = p.user_id
FROM profiles p
WHERE p.id = c.profile_id
  AND c.profile_id IS NOT NULL;

UPDATE orders o
SET profile_id = (SELECT user_id FROM profiles WHERE id = o.profile_id)
WHERE profile_id IS NOT NULL;

UPDATE wishlists w
SET profile_id = (SELECT user_id FROM profiles WHERE id = w.profile_id)
WHERE profile_id IS NOT NULL;

UPDATE reviews r
SET profile_id = (SELECT user_id FROM profiles WHERE id = r.profile_id)
WHERE profile_id IS NOT NULL;

UPDATE chats c
SET sender_id = (SELECT user_id FROM profiles WHERE id = c.sender_id)
WHERE sender_id IS NOT NULL;

UPDATE articles a
SET author_id = (SELECT user_id FROM profiles WHERE id = a.author_id)
WHERE author_id IS NOT NULL;

UPDATE conversations c
SET user_id = (SELECT user_id FROM profiles WHERE id = c.user_id)
WHERE user_id IS NOT NULL;

UPDATE chat_messages cm
SET sender_id = (SELECT user_id FROM profiles WHERE id = cm.sender_id)
WHERE sender_id IS NOT NULL;

UPDATE audit_logs al
SET admin_id = (SELECT user_id FROM profiles WHERE id = al.admin_id)
WHERE admin_id IS NOT NULL;

UPDATE ai_usage_logs aul
SET user_id = (SELECT user_id FROM profiles WHERE id = aul.user_id)
WHERE user_id IS NOT NULL;

-- Recreate FKs to reference auth.users(id) instead of profiles(id)
ALTER TABLE addresses ADD CONSTRAINT addresses_profile_id_fkey
  FOREIGN KEY (profile_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE carts ADD CONSTRAINT carts_profile_id_fkey
  FOREIGN KEY (profile_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE orders ADD CONSTRAINT orders_profile_id_fkey
  FOREIGN KEY (profile_id) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE wishlists ADD CONSTRAINT wishlists_profile_id_fkey
  FOREIGN KEY (profile_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE reviews ADD CONSTRAINT reviews_profile_id_fkey
  FOREIGN KEY (profile_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE chats ADD CONSTRAINT chats_sender_id_fkey
  FOREIGN KEY (sender_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE articles ADD CONSTRAINT articles_author_id_fkey
  FOREIGN KEY (author_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE conversations ADD CONSTRAINT conversations_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE chat_messages ADD CONSTRAINT chat_messages_sender_id_fkey
  FOREIGN KEY (sender_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE audit_logs ADD CONSTRAINT audit_logs_admin_id_fkey
  FOREIGN KEY (admin_id) REFERENCES auth.users(id) ON DELETE RESTRICT;

ALTER TABLE ai_usage_logs ADD CONSTRAINT ai_usage_logs_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- Step 7: Add comment for documentation and commit transaction
COMMENT ON COLUMN profiles.user_id IS 'Reference to auth.users.id - primary user identity';
COMMENT ON COLUMN profiles.id IS 'Deprecated - use user_id instead';

COMMIT;
