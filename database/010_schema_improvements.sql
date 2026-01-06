-- Migration 010: Comprehensive schema improvements based on CodeRabbit review
-- Addresses: indexes, ON DELETE behaviors, constraints, circular FK fix
-- Run this in Supabase SQL Editor

-- ============================================================================
-- 1. ADD INDEXES ON FOREIGN KEY COLUMNS FOR QUERY PERFORMANCE
-- ============================================================================

-- Addresses table
CREATE INDEX IF NOT EXISTS idx_addresses_profile_id ON addresses(profile_id);

-- Articles table
CREATE INDEX IF NOT EXISTS idx_articles_author_id ON articles(author_id);
CREATE INDEX IF NOT EXISTS idx_articles_slug ON articles(slug);

-- Cart items table (some already exist from migration 009)
CREATE INDEX IF NOT EXISTS idx_cart_items_cart_id ON cart_items(cart_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_variant_id ON cart_items(variant_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_product_id ON cart_items(product_id);

-- Carts table
CREATE INDEX IF NOT EXISTS idx_carts_profile_id ON carts(profile_id);

-- Chats table
CREATE INDEX IF NOT EXISTS idx_chats_sender_id ON chats(sender_id);
CREATE INDEX IF NOT EXISTS idx_chats_room_id ON chats(room_id);

-- Order items table
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_order_items_variant_id ON order_items(variant_id);

-- Orders table
CREATE INDEX IF NOT EXISTS idx_orders_profile_id ON orders(profile_id);
CREATE INDEX IF NOT EXISTS idx_orders_order_number ON orders(order_number);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_placed_at ON orders(placed_at DESC);

-- Product variants table
CREATE INDEX IF NOT EXISTS idx_product_variants_product_id ON product_variants(product_id);
CREATE INDEX IF NOT EXISTS idx_product_variants_sku ON product_variants(sku);
CREATE INDEX IF NOT EXISTS idx_product_variants_variant_slug ON product_variants(variant_slug);

-- Products table
CREATE INDEX IF NOT EXISTS idx_products_brand_id ON products(brand_id);
CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_slug ON products(slug);
CREATE INDEX IF NOT EXISTS idx_products_default_variant_id ON products(default_variant_id);
CREATE INDEX IF NOT EXISTS idx_products_is_active ON products(is_active);

-- Reviews table
CREATE INDEX IF NOT EXISTS idx_reviews_profile_id ON reviews(profile_id);
CREATE INDEX IF NOT EXISTS idx_reviews_product_id ON reviews(product_id);

-- Wishlist items table
CREATE INDEX IF NOT EXISTS idx_wishlist_items_wishlist_id ON wishlist_items(wishlist_id);
CREATE INDEX IF NOT EXISTS idx_wishlist_items_product_id ON wishlist_items(product_id);

-- Wishlists table
CREATE INDEX IF NOT EXISTS idx_wishlists_profile_id ON wishlists(profile_id);

-- ============================================================================
-- 2. DEFINE ON DELETE BEHAVIORS FOR FOREIGN KEYS
-- ============================================================================

-- Note: Cannot modify existing constraints directly, must drop and recreate
-- This is a template showing the desired ON DELETE behaviors

-- Addresses: CASCADE (delete addresses when profile is deleted)
ALTER TABLE addresses DROP CONSTRAINT IF EXISTS addresses_profile_id_fkey;
ALTER TABLE addresses ADD CONSTRAINT addresses_profile_id_fkey 
  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE;

-- Articles: SET NULL (keep article but clear author when profile deleted)
ALTER TABLE articles DROP CONSTRAINT IF EXISTS articles_author_id_fkey;
ALTER TABLE articles ADD CONSTRAINT articles_author_id_fkey 
  FOREIGN KEY (author_id) REFERENCES profiles(id) ON DELETE SET NULL;

-- Cart items: CASCADE (delete cart items when cart is deleted)
ALTER TABLE cart_items DROP CONSTRAINT IF EXISTS cart_items_cart_id_fkey;
ALTER TABLE cart_items ADD CONSTRAINT cart_items_cart_id_fkey 
  FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE;

-- Cart items: SET NULL (allow product/variant deletion without breaking cart)
ALTER TABLE cart_items DROP CONSTRAINT IF EXISTS cart_items_product_id_fkey;
ALTER TABLE cart_items ADD CONSTRAINT cart_items_product_id_fkey 
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL;

ALTER TABLE cart_items DROP CONSTRAINT IF EXISTS cart_items_variant_id_fkey;
ALTER TABLE cart_items ADD CONSTRAINT cart_items_variant_id_fkey 
  FOREIGN KEY (variant_id) REFERENCES product_variants(id) ON DELETE SET NULL;

-- Carts: CASCADE (delete cart when profile is deleted)
ALTER TABLE carts DROP CONSTRAINT IF EXISTS carts_profile_id_fkey;
ALTER TABLE carts ADD CONSTRAINT carts_profile_id_fkey 
  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE;

-- Chats: SET NULL (keep chat history even if profile deleted)
ALTER TABLE chats DROP CONSTRAINT IF EXISTS chats_sender_id_fkey;
ALTER TABLE chats ADD CONSTRAINT chats_sender_id_fkey 
  FOREIGN KEY (sender_id) REFERENCES profiles(id) ON DELETE SET NULL;

-- Order items: CASCADE (delete order items when order is deleted)
ALTER TABLE order_items DROP CONSTRAINT IF EXISTS order_items_order_id_fkey;
ALTER TABLE order_items ADD CONSTRAINT order_items_order_id_fkey 
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE;

-- Order items: RESTRICT (prevent product/variant deletion if in orders)
ALTER TABLE order_items DROP CONSTRAINT IF EXISTS order_items_product_id_fkey;
ALTER TABLE order_items ADD CONSTRAINT order_items_product_id_fkey 
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT;

ALTER TABLE order_items DROP CONSTRAINT IF EXISTS order_items_variant_id_fkey;
ALTER TABLE order_items ADD CONSTRAINT order_items_variant_id_fkey 
  FOREIGN KEY (variant_id) REFERENCES product_variants(id) ON DELETE RESTRICT;

-- Orders: RESTRICT (prevent profile deletion if they have orders)
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_profile_id_fkey;
ALTER TABLE orders ADD CONSTRAINT orders_profile_id_fkey 
  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE RESTRICT;

-- Product variants: CASCADE (delete variants when product is deleted)
ALTER TABLE product_variants DROP CONSTRAINT IF EXISTS product_variants_product_id_fkey;
ALTER TABLE product_variants ADD CONSTRAINT product_variants_product_id_fkey 
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;

-- Products: RESTRICT (prevent brand/category deletion if products exist)
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_brand_id_fkey;
ALTER TABLE products ADD CONSTRAINT products_brand_id_fkey 
  FOREIGN KEY (brand_id) REFERENCES brands(id) ON DELETE RESTRICT;

ALTER TABLE products DROP CONSTRAINT IF EXISTS products_category_id_fkey;
ALTER TABLE products ADD CONSTRAINT products_category_id_fkey 
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT;

-- Reviews: CASCADE (delete reviews when profile is deleted)
ALTER TABLE reviews DROP CONSTRAINT IF EXISTS reviews_profile_id_fkey;
ALTER TABLE reviews ADD CONSTRAINT reviews_profile_id_fkey 
  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE;

-- Reviews: CASCADE (delete reviews when product is deleted)
ALTER TABLE reviews DROP CONSTRAINT IF EXISTS reviews_product_id_fkey;
ALTER TABLE reviews ADD CONSTRAINT reviews_product_id_fkey 
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;

-- Wishlist items: CASCADE (delete wishlist items when wishlist is deleted)
ALTER TABLE wishlist_items DROP CONSTRAINT IF EXISTS wishlist_items_wishlist_id_fkey;
ALTER TABLE wishlist_items ADD CONSTRAINT wishlist_items_wishlist_id_fkey 
  FOREIGN KEY (wishlist_id) REFERENCES wishlists(id) ON DELETE CASCADE;

-- Wishlist items: CASCADE (delete wishlist items when product is deleted)
ALTER TABLE wishlist_items DROP CONSTRAINT IF EXISTS wishlist_items_product_id_fkey;
ALTER TABLE wishlist_items ADD CONSTRAINT wishlist_items_product_id_fkey 
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;

-- Wishlists: CASCADE (delete wishlist when profile is deleted)
ALTER TABLE wishlists DROP CONSTRAINT IF EXISTS wishlists_profile_id_fkey;
ALTER TABLE wishlists ADD CONSTRAINT wishlists_profile_id_fkey 
  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE;

-- ============================================================================
-- 3. FIX CIRCULAR FOREIGN KEY DEPENDENCY (products <-> product_variants)
-- ============================================================================

-- Make the circular FK deferrable so we can insert product first, then variant, then update product
ALTER TABLE products DROP CONSTRAINT IF EXISTS fk_products_default_variant;
ALTER TABLE products ADD CONSTRAINT fk_products_default_variant 
  FOREIGN KEY (default_variant_id) REFERENCES product_variants(id) 
  ON DELETE RESTRICT
  DEFERRABLE INITIALLY DEFERRED;

-- ============================================================================
-- 4. ADD BUSINESS LOGIC CONSTRAINTS FOR COUPONS
-- ============================================================================

-- Add CHECK constraint for discount_type (must be 'percentage' or 'fixed')
ALTER TABLE coupons DROP CONSTRAINT IF EXISTS coupons_discount_type_check;
ALTER TABLE coupons ADD CONSTRAINT coupons_discount_type_check 
  CHECK (discount_type IN ('percentage', 'fixed'));

-- Percentage discount must be between 0 and 100
ALTER TABLE coupons DROP CONSTRAINT IF EXISTS coupons_percentage_range_check;
ALTER TABLE coupons ADD CONSTRAINT coupons_percentage_range_check 
  CHECK (
    (discount_type = 'percentage' AND discount_value > 0 AND discount_value <= 100)
    OR discount_type != 'percentage'
  );

-- Fixed discount must be positive
ALTER TABLE coupons DROP CONSTRAINT IF EXISTS coupons_fixed_positive_check;
ALTER TABLE coupons ADD CONSTRAINT coupons_fixed_positive_check 
  CHECK (
    (discount_type = 'fixed' AND discount_value > 0)
    OR discount_type != 'fixed'
  );

-- Min order amount must be non-negative
ALTER TABLE coupons DROP CONSTRAINT IF EXISTS coupons_min_order_check;
ALTER TABLE coupons ADD CONSTRAINT coupons_min_order_check 
  CHECK (min_order_amount >= 0);

-- Usage limit must be positive if set
ALTER TABLE coupons DROP CONSTRAINT IF EXISTS coupons_usage_limit_check;
ALTER TABLE coupons ADD CONSTRAINT coupons_usage_limit_check 
  CHECK (usage_limit IS NULL OR usage_limit > 0);

-- Date range validation: starts_at must be before expires_at
ALTER TABLE coupons DROP CONSTRAINT IF EXISTS coupons_date_range_check;
ALTER TABLE coupons ADD CONSTRAINT coupons_date_range_check 
  CHECK (expires_at IS NULL OR starts_at IS NULL OR starts_at < expires_at);

-- ============================================================================
-- 5. PREVENT MULTIPLE REVIEWS PER USER PER PRODUCT
-- ============================================================================

-- Add unique constraint on (profile_id, product_id)
-- First, remove any duplicate reviews (keep the most recent one)
DELETE FROM reviews
WHERE id NOT IN (
  SELECT DISTINCT ON (profile_id, product_id) id
  FROM reviews
  ORDER BY profile_id, product_id, created_at DESC, id
);

-- Now add the unique constraint
ALTER TABLE reviews DROP CONSTRAINT IF EXISTS reviews_profile_product_unique;
ALTER TABLE reviews ADD CONSTRAINT reviews_profile_product_unique 
  UNIQUE (profile_id, product_id);

-- ============================================================================
-- 6. REMOVE UNUSUAL variant_id FROM orders TABLE (if not used)
-- ============================================================================

-- Check if variant_id column is being used in orders table
-- If it's not needed (order_items already have variant_id), you can remove it:
-- ALTER TABLE orders DROP COLUMN IF EXISTS variant_id;

-- Note: Commenting this out as it may be used for something.
-- Uncomment and run manually if you've confirmed it's not needed.

-- ============================================================================
-- 7. ADD ADDITIONAL USEFUL CONSTRAINTS
-- ============================================================================

-- Ensure qty in cart_items is positive
ALTER TABLE cart_items DROP CONSTRAINT IF EXISTS cart_items_qty_positive;
ALTER TABLE cart_items ADD CONSTRAINT cart_items_qty_positive 
  CHECK (qty > 0);

-- Ensure qty in order_items is positive
ALTER TABLE order_items DROP CONSTRAINT IF EXISTS order_items_qty_positive;
ALTER TABLE order_items ADD CONSTRAINT order_items_qty_positive 
  CHECK (qty > 0);

-- Ensure rating in reviews is between 1 and 5
ALTER TABLE reviews DROP CONSTRAINT IF EXISTS reviews_rating_range;
ALTER TABLE reviews ADD CONSTRAINT reviews_rating_range 
  CHECK (rating >= 1 AND rating <= 5);

-- Ensure prices are non-negative
ALTER TABLE product_variants DROP CONSTRAINT IF EXISTS product_variants_price_check;
ALTER TABLE product_variants ADD CONSTRAINT product_variants_price_check 
  CHECK (price >= 0 AND (original_price IS NULL OR original_price >= 0));

-- Ensure order totals are non-negative
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_amounts_check;
ALTER TABLE orders ADD CONSTRAINT orders_amounts_check 
  CHECK (subtotal >= 0 AND shipping_fee >= 0 AND total >= 0);

-- Ensure order status is valid
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_status_check;
ALTER TABLE orders ADD CONSTRAINT orders_status_check 
  CHECK (status IN ('pending', 'confirmed', 'processing', 'shipping', 'delivered', 'cancelled', 'refunded'));

-- ============================================================================
-- SUMMARY
-- ============================================================================

-- This migration adds:
-- 1. Comprehensive indexes on all foreign keys for better query performance
-- 2. Explicit ON DELETE behaviors for data integrity
-- 3. Fix for circular FK dependency (deferrable constraint)
-- 4. Business logic constraints for coupons
-- 5. Unique constraint to prevent duplicate reviews
-- 6. Additional data validation constraints

-- Note: Run this migration after ensuring no existing data violates the new constraints
