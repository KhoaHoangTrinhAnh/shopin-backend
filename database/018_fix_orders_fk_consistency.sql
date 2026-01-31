-- Migration: Fix inconsistent FK references in orders table
-- Date: 2026-01-31
-- Purpose: Unify all orders FK references to use auth.users(id) instead of mixing with profiles(id)

BEGIN;

-- Step 1: Update existing data - map profiles.id to auth.users.id
-- For cancellation_approved_by
UPDATE orders o
SET cancellation_approved_by = p.user_id
FROM profiles p
WHERE p.id = o.cancellation_approved_by
  AND o.cancellation_approved_by IS NOT NULL;

-- For confirmed_by
UPDATE orders o
SET confirmed_by = p.user_id
FROM profiles p
WHERE p.id = o.confirmed_by
  AND o.confirmed_by IS NOT NULL;

-- Step 2: Drop existing inconsistent FK constraints
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_cancellation_approved_by_fkey;
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_confirmed_by_fkey;

-- Step 3: Recreate FK constraints pointing to auth.users(id) for consistency
-- All user references in orders table now point to the same canonical user table
ALTER TABLE orders ADD CONSTRAINT orders_cancellation_approved_by_fkey
  FOREIGN KEY (cancellation_approved_by) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE orders ADD CONSTRAINT orders_confirmed_by_fkey
  FOREIGN KEY (confirmed_by) REFERENCES auth.users(id) ON DELETE SET NULL;

-- Step 4: Add comments for documentation
COMMENT ON CONSTRAINT orders_profile_id_fkey ON orders IS 'Customer who placed the order';
COMMENT ON CONSTRAINT orders_cancellation_approved_by_fkey ON orders IS 'Admin who approved cancellation';
COMMENT ON CONSTRAINT orders_confirmed_by_fkey ON orders IS 'Admin who confirmed the order';

COMMIT;

-- Migration Notes:
-- - All user-related FKs in orders now consistently reference auth.users(id)
-- - Previous references to profiles.id have been migrated to auth.users.id via profiles.user_id
-- - ON DELETE SET NULL used for admin actions to preserve order history
