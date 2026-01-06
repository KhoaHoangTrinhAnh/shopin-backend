-- Migration 008: Add addresses table and update orders table
-- Run this in Supabase SQL Editor

-- 1. Create addresses table
CREATE TABLE IF NOT EXISTS addresses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  full_name text NOT NULL,
  phone text NOT NULL,
  address_line text NOT NULL,
  ward text,
  district text,
  city text,
  is_default boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create index for profile lookup
CREATE INDEX IF NOT EXISTS addresses_profile_id_idx ON addresses(profile_id);
CREATE INDEX IF NOT EXISTS addresses_is_default_idx ON addresses(profile_id, is_default);

-- 2. Update orders table to add missing columns
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS order_number text UNIQUE,
ADD COLUMN IF NOT EXISTS payment_method text DEFAULT 'cod',
ADD COLUMN IF NOT EXISTS note text,
ADD COLUMN IF NOT EXISTS variant_id uuid;

-- Update order_items table
ALTER TABLE order_items
ADD COLUMN IF NOT EXISTS variant_id uuid REFERENCES product_variants(id),
ADD COLUMN IF NOT EXISTS main_image text;

-- Create index for order lookup
CREATE INDEX IF NOT EXISTS orders_profile_id_idx ON orders(profile_id);
CREATE INDEX IF NOT EXISTS orders_order_number_idx ON orders(order_number);
CREATE INDEX IF NOT EXISTS orders_status_idx ON orders(status);

-- 3. Enable RLS on addresses
ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;

-- RLS policies for addresses (users can only see/modify their own addresses)
CREATE POLICY "Users can view own addresses" ON addresses
  FOR SELECT USING (auth.uid()::text = profile_id::text);

CREATE POLICY "Users can insert own addresses" ON addresses
  FOR INSERT WITH CHECK (auth.uid()::text = profile_id::text);

CREATE POLICY "Users can update own addresses" ON addresses
  FOR UPDATE USING (auth.uid()::text = profile_id::text);

CREATE POLICY "Users can delete own addresses" ON addresses
  FOR DELETE USING (auth.uid()::text = profile_id::text);

-- Grant access for service role
GRANT ALL ON addresses TO service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON addresses TO authenticated;
