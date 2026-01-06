-- Migration: Add variant_id to cart_items table
-- Run this in Supabase SQL Editor

-- Add variant_id column to cart_items
alter table cart_items 
add column if not exists variant_id uuid references product_variants(id);

-- Create index for faster lookups
create index if not exists idx_cart_items_variant_id on cart_items(variant_id);
create index if not exists idx_cart_items_cart_id on cart_items(cart_id);

-- Update existing cart_items to set variant_id from variant_name if needed
-- (This is a data migration step - adjust based on your actual data)
-- You may need to manually update existing records based on variant_name matching

-- Note: variant_id is now the primary way to identify variants
-- variant_name can be kept for display purposes or removed if not needed
