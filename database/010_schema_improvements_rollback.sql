-- Rollback for Migration 010: Schema Improvements
-- Run this to undo the changes from 010_schema_improvements.sql
-- WARNING: This will drop all new constraints and indexes

-- ============================================================================
-- 1. DROP INDEXES
-- ============================================================================

DROP INDEX IF EXISTS idx_addresses_profile_id;
DROP INDEX IF EXISTS idx_articles_author_id;
DROP INDEX IF EXISTS idx_articles_slug;
DROP INDEX IF EXISTS idx_cart_items_cart_id;
DROP INDEX IF EXISTS idx_cart_items_variant_id;
DROP INDEX IF EXISTS idx_cart_items_product_id;
DROP INDEX IF EXISTS idx_carts_profile_id;
DROP INDEX IF EXISTS idx_chats_sender_id;
DROP INDEX IF EXISTS idx_chats_room_id;
DROP INDEX IF EXISTS idx_order_items_order_id;
DROP INDEX IF EXISTS idx_order_items_product_id;
DROP INDEX IF EXISTS idx_order_items_variant_id;
DROP INDEX IF EXISTS idx_orders_profile_id;
DROP INDEX IF EXISTS idx_orders_order_number;
DROP INDEX IF EXISTS idx_orders_status;
DROP INDEX IF EXISTS idx_orders_placed_at;
DROP INDEX IF EXISTS idx_product_variants_product_id;
DROP INDEX IF EXISTS idx_product_variants_sku;
DROP INDEX IF EXISTS idx_product_variants_variant_slug;
DROP INDEX IF EXISTS idx_products_brand_id;
DROP INDEX IF EXISTS idx_products_category_id;
DROP INDEX IF EXISTS idx_products_slug;
DROP INDEX IF EXISTS idx_products_default_variant_id;
DROP INDEX IF EXISTS idx_products_is_active;
DROP INDEX IF EXISTS idx_reviews_profile_id;
DROP INDEX IF EXISTS idx_reviews_product_id;
DROP INDEX IF EXISTS idx_wishlist_items_wishlist_id;
DROP INDEX IF EXISTS idx_wishlist_items_product_id;
DROP INDEX IF EXISTS idx_wishlists_profile_id;

-- ============================================================================
-- 2. DROP CHECK CONSTRAINTS
-- ============================================================================

ALTER TABLE coupons DROP CONSTRAINT IF EXISTS coupons_discount_type_check;
ALTER TABLE coupons DROP CONSTRAINT IF EXISTS coupons_percentage_range_check;
ALTER TABLE coupons DROP CONSTRAINT IF EXISTS coupons_fixed_positive_check;
ALTER TABLE coupons DROP CONSTRAINT IF EXISTS coupons_min_order_check;
ALTER TABLE coupons DROP CONSTRAINT IF EXISTS coupons_usage_limit_check;
ALTER TABLE coupons DROP CONSTRAINT IF EXISTS coupons_date_range_check;
ALTER TABLE cart_items DROP CONSTRAINT IF EXISTS cart_items_qty_positive;
ALTER TABLE order_items DROP CONSTRAINT IF EXISTS order_items_qty_positive;
ALTER TABLE reviews DROP CONSTRAINT IF EXISTS reviews_rating_range;
ALTER TABLE product_variants DROP CONSTRAINT IF EXISTS product_variants_price_check;
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_amounts_check;
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_status_check;

-- ============================================================================
-- 3. DROP UNIQUE CONSTRAINT
-- ============================================================================

ALTER TABLE reviews DROP CONSTRAINT IF EXISTS reviews_profile_product_unique;

-- ============================================================================
-- 4. RESTORE ORIGINAL FOREIGN KEYS (without ON DELETE behaviors)
-- ============================================================================

-- Note: This restores foreign keys to their original state without explicit ON DELETE behavior
-- You may need to adjust these based on your original schema

ALTER TABLE addresses DROP CONSTRAINT IF EXISTS addresses_profile_id_fkey;
ALTER TABLE addresses ADD CONSTRAINT addresses_profile_id_fkey 
  FOREIGN KEY (profile_id) REFERENCES profiles(id);

ALTER TABLE articles DROP CONSTRAINT IF EXISTS articles_author_id_fkey;
ALTER TABLE articles ADD CONSTRAINT articles_author_id_fkey 
  FOREIGN KEY (author_id) REFERENCES profiles(id);

ALTER TABLE cart_items DROP CONSTRAINT IF EXISTS cart_items_cart_id_fkey;
ALTER TABLE cart_items ADD CONSTRAINT cart_items_cart_id_fkey 
  FOREIGN KEY (cart_id) REFERENCES carts(id);

ALTER TABLE cart_items DROP CONSTRAINT IF EXISTS cart_items_product_id_fkey;
ALTER TABLE cart_items ADD CONSTRAINT cart_items_product_id_fkey 
  FOREIGN KEY (product_id) REFERENCES products(id);

ALTER TABLE cart_items DROP CONSTRAINT IF EXISTS cart_items_variant_id_fkey;
ALTER TABLE cart_items ADD CONSTRAINT cart_items_variant_id_fkey 
  FOREIGN KEY (variant_id) REFERENCES product_variants(id);

ALTER TABLE carts DROP CONSTRAINT IF EXISTS carts_profile_id_fkey;
ALTER TABLE carts ADD CONSTRAINT carts_profile_id_fkey 
  FOREIGN KEY (profile_id) REFERENCES profiles(id);

ALTER TABLE chats DROP CONSTRAINT IF EXISTS chats_sender_id_fkey;
ALTER TABLE chats ADD CONSTRAINT chats_sender_id_fkey 
  FOREIGN KEY (sender_id) REFERENCES profiles(id);

ALTER TABLE order_items DROP CONSTRAINT IF EXISTS order_items_order_id_fkey;
ALTER TABLE order_items ADD CONSTRAINT order_items_order_id_fkey 
  FOREIGN KEY (order_id) REFERENCES orders(id);

ALTER TABLE order_items DROP CONSTRAINT IF EXISTS order_items_product_id_fkey;
ALTER TABLE order_items ADD CONSTRAINT order_items_product_id_fkey 
  FOREIGN KEY (product_id) REFERENCES products(id);

ALTER TABLE order_items DROP CONSTRAINT IF EXISTS order_items_variant_id_fkey;
ALTER TABLE order_items ADD CONSTRAINT order_items_variant_id_fkey 
  FOREIGN KEY (variant_id) REFERENCES product_variants(id);

ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_profile_id_fkey;
ALTER TABLE orders ADD CONSTRAINT orders_profile_id_fkey 
  FOREIGN KEY (profile_id) REFERENCES profiles(id);

ALTER TABLE product_variants DROP CONSTRAINT IF EXISTS product_variants_product_id_fkey;
ALTER TABLE product_variants ADD CONSTRAINT product_variants_product_id_fkey 
  FOREIGN KEY (product_id) REFERENCES products(id);

ALTER TABLE products DROP CONSTRAINT IF EXISTS products_brand_id_fkey;
ALTER TABLE products ADD CONSTRAINT products_brand_id_fkey 
  FOREIGN KEY (brand_id) REFERENCES brands(id);

ALTER TABLE products DROP CONSTRAINT IF EXISTS products_category_id_fkey;
ALTER TABLE products ADD CONSTRAINT products_category_id_fkey 
  FOREIGN KEY (category_id) REFERENCES categories(id);

ALTER TABLE products DROP CONSTRAINT IF EXISTS fk_products_default_variant;
ALTER TABLE products ADD CONSTRAINT fk_products_default_variant 
  FOREIGN KEY (default_variant_id) REFERENCES product_variants(id);

ALTER TABLE reviews DROP CONSTRAINT IF EXISTS reviews_profile_id_fkey;
ALTER TABLE reviews ADD CONSTRAINT reviews_profile_id_fkey 
  FOREIGN KEY (profile_id) REFERENCES profiles(id);

ALTER TABLE reviews DROP CONSTRAINT IF EXISTS reviews_product_id_fkey;
ALTER TABLE reviews ADD CONSTRAINT reviews_product_id_fkey 
  FOREIGN KEY (product_id) REFERENCES products(id);

ALTER TABLE wishlist_items DROP CONSTRAINT IF EXISTS wishlist_items_wishlist_id_fkey;
ALTER TABLE wishlist_items ADD CONSTRAINT wishlist_items_wishlist_id_fkey 
  FOREIGN KEY (wishlist_id) REFERENCES wishlists(id);

ALTER TABLE wishlist_items DROP CONSTRAINT IF EXISTS wishlist_items_product_id_fkey;
ALTER TABLE wishlist_items ADD CONSTRAINT wishlist_items_product_id_fkey 
  FOREIGN KEY (product_id) REFERENCES products(id);

ALTER TABLE wishlists DROP CONSTRAINT IF EXISTS wishlists_profile_id_fkey;
ALTER TABLE wishlists ADD CONSTRAINT wishlists_profile_id_fkey 
  FOREIGN KEY (profile_id) REFERENCES profiles(id);
