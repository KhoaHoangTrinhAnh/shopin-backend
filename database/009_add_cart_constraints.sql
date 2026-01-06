-- Migration 009: Add unique constraints to prevent duplicate cart items and carts
-- Run this in Supabase SQL Editor

-- 1. Add unique constraint on carts to prevent duplicate carts per profile
-- First, remove any duplicate carts (keep the oldest one based on created_at)
-- Use DISTINCT ON instead of MIN(uuid) which doesn't exist
DELETE FROM cart_items 
WHERE cart_id IN (
  SELECT c.id 
  FROM carts c
  WHERE c.id NOT IN (
    SELECT DISTINCT ON (profile_id) id
    FROM carts
    ORDER BY profile_id, created_at ASC, id
  )
);

DELETE FROM carts 
WHERE id NOT IN (
  SELECT DISTINCT ON (profile_id) id
  FROM carts
  ORDER BY profile_id, created_at ASC, id
);

-- Add unique constraint on profile_id
ALTER TABLE carts 
ADD CONSTRAINT carts_profile_id_unique UNIQUE (profile_id);

-- 2. Add unique constraint on cart_items to prevent duplicate items per variant
-- First, remove any duplicate cart items (keep the one with highest qty)
-- Note: cart_items uses 'added_at' not 'created_at'
DELETE FROM cart_items
WHERE id NOT IN (
  SELECT DISTINCT ON (cart_id, variant_id) id
  FROM cart_items
  ORDER BY cart_id, variant_id, qty DESC, added_at DESC
);

-- Add unique constraint on cart_id + variant_id
ALTER TABLE cart_items
ADD CONSTRAINT cart_items_cart_variant_unique UNIQUE (cart_id, variant_id);

-- 3. Add index for better performance on cart lookups
CREATE INDEX IF NOT EXISTS cart_items_cart_id_idx ON cart_items(cart_id);
CREATE INDEX IF NOT EXISTS cart_items_variant_id_idx ON cart_items(variant_id);

-- 4. Add updated_at column to cart_items if not exists
ALTER TABLE cart_items ADD COLUMN IF NOT EXISTS updated_at timestamp with time zone DEFAULT now();

-- 5. Add updated_at trigger for cart_items and carts
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_cart_items_updated_at ON cart_items;
CREATE TRIGGER update_cart_items_updated_at
  BEFORE UPDATE ON cart_items
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_carts_updated_at ON carts;
CREATE TRIGGER update_carts_updated_at
  BEFORE UPDATE ON carts
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
