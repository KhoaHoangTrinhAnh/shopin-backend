# Database Migrations

This folder contains SQL migration files for the ShopIn database schema.

## Migration Files

### Existing Migrations
- `001_schema.sql` - Initial schema creation
- `002_database_inserts.sql` - Initial data inserts
- `003_database_inserts.sql` - Additional data inserts
- `004_database_inserts.sql` - More data inserts
- `005_auth_profiles_update.sql` - Auth and profiles updates
- `006_add_variant_id_to_cart_items.sql` - Add variant_id to cart items
- `007_fix_profiles_schema.sql` - Fix profiles schema
- `008_addresses_orders.sql` - Addresses and orders schema
- `009_add_cart_constraints.sql` - **FIXED**: Add unique constraints to carts and cart_items

### New Migrations
- `010_schema_improvements.sql` - **NEW**: Comprehensive schema improvements addressing CodeRabbit recommendations
- `010_schema_improvements_rollback.sql` - Rollback script for migration 010
- `011_add_profile_columns.sql` - **NEW**: Add gender and date_of_birth columns to profiles table
- `012_setup_storage_bucket.sql` - **NEW**: Setup Supabase Storage bucket for avatar uploads

## Migration 009 Fix

**Problem**: The original `009_add_cart_constraints.sql` used `MIN(uuid)` which doesn't exist in PostgreSQL.

**Error**:
```
ERROR: 42883: function min(uuid) does not exist
```

**Solution**: Replaced with `DISTINCT ON` approach:
```sql
SELECT DISTINCT ON (profile_id) id
FROM carts
ORDER BY profile_id, created_at ASC, id
```

## Migration 010: Schema Improvements

This migration addresses all CodeRabbit recommendations:

### 1. Performance: Foreign Key Indexes
Added indexes on all foreign key columns for better query performance:
- `addresses`, `articles`, `cart_items`, `carts`, `chats`
- `order_items`, `orders`, `product_variants`, `products`
- `reviews`, `wishlist_items`, `wishlists`

**Benefits**:
- Faster JOIN operations
- Improved query performance on filtered queries

## Migration 011: Add Profile Columns

**Problem**: Profile update feature failing due to missing columns.

**Errors**:
```
Could not find the 'gender' column of 'profiles' in the schema cache
Could not find the 'date_of_birth' column of 'profiles' in the schema cache
```

**Solution**: Added missing columns to profiles table:
```sql
ALTER TABLE profiles ADD COLUMN gender text CHECK (gender IN ('male', 'female', 'other'));
ALTER TABLE profiles ADD COLUMN date_of_birth date;
```

**Benefits**:
- Complete user profile support
- Gender-based demographic queries
- Age verification capabilities

## Migration 012: Setup Storage Bucket

**Problem**: Avatar upload failing with "bucket not found" error.

**Error**:
```
POST http://localhost:3000/api/profiles/avatar 400 (Bad Request)
Toast: bucket not found
```

**Solution**: Created dedicated `avatars` bucket with proper configuration:
```sql
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES ('avatars', 'avatars', true, 5242880, ARRAY['image/jpeg', ...]);
```

**Benefits**:
- Proper avatar storage isolation
- 5MB file size limit enforcement
- Allowed MIME types validation
- Public read access for avatars
- Secure upload policies (authenticated users only)
- Better performance for ON DELETE operations

### 2. Data Integrity: ON DELETE Behaviors

Defined explicit ON DELETE behaviors for all foreign keys:

| Table | Column | Behavior | Reason |
|-------|--------|----------|--------|
| addresses | profile_id | CASCADE | Delete addresses when profile deleted |
| articles | author_id | SET NULL | Keep articles, clear author |
| cart_items | cart_id | CASCADE | Delete items with cart |
| cart_items | product_id, variant_id | SET NULL | Allow product deletion |
| carts | profile_id | CASCADE | Delete cart with profile |
| chats | sender_id | SET NULL | Keep chat history |
| order_items | order_id | CASCADE | Delete items with order |
| order_items | product_id, variant_id | RESTRICT | Prevent deletion if in orders |
| orders | profile_id | RESTRICT | Prevent profile deletion with orders |
| product_variants | product_id | CASCADE | Delete variants with product |
| products | brand_id, category_id | RESTRICT | Prevent deletion if products exist |
| reviews | profile_id, product_id | CASCADE | Delete reviews with parent |
| wishlist_items | wishlist_id, product_id | CASCADE | Delete items with parent |
| wishlists | profile_id | CASCADE | Delete wishlist with profile |

### 3. Circular FK Fix: Products ↔ Product Variants

**Problem**: Circular dependency prevents table creation in correct order.

**Solution**: Made `fk_products_default_variant` DEFERRABLE:
```sql
ALTER TABLE products ADD CONSTRAINT fk_products_default_variant 
  FOREIGN KEY (default_variant_id) REFERENCES product_variants(id) 
  ON DELETE RESTRICT
  DEFERRABLE INITIALLY DEFERRED;
```

**Usage**:
```sql
BEGIN;
INSERT INTO products (id, ..., default_variant_id) VALUES (..., NULL);
INSERT INTO product_variants (id, product_id, ...) VALUES (...);
UPDATE products SET default_variant_id = ... WHERE id = ...;
COMMIT;
```

### 4. Business Logic: Coupon Constraints

Added CHECK constraints for data integrity:
- `discount_type` must be 'percentage' or 'fixed'
- Percentage: 0 < value ≤ 100
- Fixed: value > 0
- `min_order_amount` ≥ 0
- `usage_limit` > 0 or NULL
- `valid_from` < `valid_to`

### 5. Data Integrity: Unique Review Constraint

Prevents multiple reviews per user per product:
```sql
ALTER TABLE reviews ADD CONSTRAINT reviews_profile_product_unique 
  UNIQUE (profile_id, product_id);
```

### 6. Additional Validation Constraints

- Cart/order item qty > 0
- Review rating: 1-5
- Product prices ≥ 0
- Order amounts ≥ 0
- Order status enum validation

## Running Migrations

### Execute Migration 009 (Fixed)
```sql
-- In Supabase SQL Editor
\i 009_add_cart_constraints.sql
```

### Execute Migration 010
```sql
-- In Supabase SQL Editor
\i 010_schema_improvements.sql
```

### Rollback Migration 010 (if needed)
```sql
-- In Supabase SQL Editor
\i 010_schema_improvements_rollback.sql
```

## Pre-Migration Checklist

Before running migration 010:

- [ ] Backup your database
- [ ] Check for duplicate reviews (will be deleted):
  ```sql
  SELECT profile_id, product_id, COUNT(*) 
  FROM reviews 
  GROUP BY profile_id, product_id 
  HAVING COUNT(*) > 1;
  ```
- [ ] Check for invalid coupon data:
  ```sql
  SELECT * FROM coupons 
  WHERE discount_type NOT IN ('percentage', 'fixed')
     OR (discount_type = 'percentage' AND (discount_value <= 0 OR discount_value > 100))
     OR (discount_type = 'fixed' AND discount_value <= 0);
  ```
- [ ] Check for negative quantities:
  ```sql
  SELECT * FROM cart_items WHERE qty <= 0;
  SELECT * FROM order_items WHERE qty <= 0;
  ```
- [ ] Check for invalid ratings:
  ```sql
  SELECT * FROM reviews WHERE rating < 1 OR rating > 5;
  ```

## Post-Migration Verification

After running migration 010:

```sql
-- Verify indexes were created
SELECT schemaname, tablename, indexname 
FROM pg_indexes 
WHERE schemaname = 'public' 
AND indexname LIKE 'idx_%'
ORDER BY tablename, indexname;

-- Verify constraints were added
SELECT conname, contype, pg_get_constraintdef(oid) 
FROM pg_constraint 
WHERE connamespace = 'public'::regnamespace
AND conrelid::regclass::text IN (
  'addresses', 'carts', 'cart_items', 'orders', 'order_items',
  'products', 'product_variants', 'reviews', 'coupons'
)
ORDER BY conrelid::regclass::text, conname;

-- Verify unique constraint on reviews
SELECT COUNT(*), profile_id, product_id 
FROM reviews 
GROUP BY profile_id, product_id 
HAVING COUNT(*) > 1;
-- Should return 0 rows
```

## CodeRabbit Recommendations Addressed

✅ **Add indexes on foreign key columns** - All foreign keys now have indexes  
✅ **Define ON DELETE behavior** - All foreign keys have explicit behaviors  
✅ **Prevent duplicate cart items** - Handled in migration 009  
✅ **Coupon data integrity** - CHECK constraints added  
✅ **Circular FK dependency** - Made deferrable  
✅ **Prevent multiple reviews** - Unique constraint added  
✅ **Additional validation** - qty, prices, ratings, status validated  

## Notes

- **variant_id in orders table**: Not removed as it may be used for tracking. Review and uncomment removal in migration if not needed.
- **Sequences for brands/categories**: Auto-managed by PostgreSQL's SERIAL type, no manual definition needed.
- **Default values**: All default values are properly defined in the original schema.

## Support

For issues or questions about migrations, check:
1. Supabase logs for detailed error messages
2. Pre-migration checklist for data violations
3. Rollback script if migration causes issues
