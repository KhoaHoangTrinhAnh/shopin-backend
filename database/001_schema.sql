-- 1. Users / Profiles (Supabase Auth vẫn dùng, nhưng ta có bảng profile để mở rộng)
create table profiles (
  id uuid primary key default gen_random_uuid(),
  email text unique,
  full_name text,
  phone text,
  is_admin boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 2. Categories & Brands (đơn giản)
create table categories (
  id serial primary key,
  name text not null unique,
  slug text unique
);

create table brands (
  id serial primary key,
  name text not null unique,
  slug text unique
);

-- 3. Products (main table)
create table products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique not null, -- iphone-17-pro-max
  brand_id int references brands(id),
  category_id int references categories(id),
  description text,
  default_variant_id uuid not null, -- Luôn trỏ đến variant đầu tiên của sản phẩm
  meta jsonb,                   -- meta_title, meta_description, meta_keywords
  is_active boolean default true, -- True nếu có ít nhất 1 variant active
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 4. Product variants
create table product_variants (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references products(id) on delete cascade,
  sku text unique not null,
  attributes jsonb,          -- {"color":"Xám","storage" :"1TB"} tìm từ khoá độ đo (VD: MB, GB, TB,...) để biết group nào là bộ nhớ; Nếu sản phẩm nào đó không có variant/1 variant thì để trống
  variant_slug text unique not null,  -- Ví dụ iphone-17-pro-max-1tb-gray
  price numeric not null check (price >= 0),
  original_price numeric check (original_price >= 0),
  qty int default 0 check (qty >= 0), -- Số lượng tồn kho
  specifications jsonb,      /* dạng [
      {
        "Cấu hình & Bộ nhớ": {
          "Hệ điều hành": "iOS 26",
          "Chip xử lý (CPU)": "Apple A19 Pro 6 nhân",
          "Tốc độ CPU": "Hãng không công bố",
          "Chip đồ họa (GPU)": "Apple GPU 6 nhân",
          "RAM": "12 GB",
          "Dung lượng lưu trữ": "256 GB",
          "Dung lượng còn lại (khả dụng) khoảng": "241 GB",
          "Danh bạ": "Không giới hạn"
        }
      },
      {
        "Camera & Màn hình": {
          "Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 48 MP",
          "Quay phim camera sau": [
            "HD 720p@30fps",
            "FullHD 1080p@60fps",
            "FullHD 1080p@30fps",
            "FullHD 1080p@25fps",
            "FullHD 1080p@120fps",
            "4K 2160p@60fps",
            "4K 2160p@30fps",
            "4K 2160p@25fps",
            "4K 2160p@24fps",
            "4K 2160p@120fps",
            "4K 2160p@100fps",
            "2.8K 60fps"
          ],...*/
  image_filenames text[],       -- raw filenames (e.g. ["a.jpg","b.jpg"]) - tất cả ảnh bao gồm ảnh chính và ảnh phụ
  image_urls jsonb,             -- URL các ảnh phụ dạng array (VD: ["https://...jpg", "https://...jpg"])
  main_image text,              -- URL ảnh chính (VD: https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro/iphone-17-pro-cam-1.jpg)
  is_active boolean default true, -- Auto update: false nếu qty = 0
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 5. Carts + Cart items
create table carts (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid references profiles(id) on delete set null,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table cart_items (
  id uuid primary key default gen_random_uuid(),
  cart_id uuid references carts(id) on delete cascade,
  product_id uuid references products(id),
  variant_name text,            -- {"color":"Xám","storage" :"1TB"}
  qty int not null default 1,
  unit_price numeric,
  added_at timestamptz default now()
);

-- 6. Orders + order items
create table orders (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid references profiles(id) on delete set null,
  status text default 'pending', -- pending, paid, shipped, completed, cancelled
  subtotal numeric,
  shipping_fee numeric default 0,
  total numeric,
  address jsonb, -- snapshot shipping address
  coupon_code text,
  placed_at timestamptz default now(),
  updated_at timestamptz default now(),
  extra jsonb
);

create table order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid references orders(id) on delete cascade,
  product_id uuid references products(id),
  variant_name text,            -- "Đen", "Trắng", etc.
  product_name text,
  qty int not null,
  unit_price numeric not null,
  total_price numeric generated always as (qty * unit_price) stored
);

-- 7. Wishlist
create table wishlists (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid references profiles(id) on delete cascade,
  created_at timestamptz default now()
);

create table wishlist_items (
  wishlist_id uuid references wishlists(id) on delete cascade,
  product_id uuid references products(id) on delete cascade,
  added_at timestamptz default now(),
  primary key (wishlist_id, product_id)
);

-- 8. Reviews & Ratings
create table reviews (
  id uuid primary key default gen_random_uuid(),
  product_id uuid references products(id) on delete cascade,
  profile_id uuid references profiles(id) on delete set null,
  rating int check (rating >= 1 and rating <= 5),
  title text,
  body text,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  metadata jsonb
);

-- 9. Coupons / Vouchers
create table coupons (
  code text primary key,
  description text,
  discount_type text not null, -- 'percent' or 'fixed'
  discount_value numeric not null,
  min_order_amount numeric default 0,
  usage_limit int default null,
  used_count int default 0,
  starts_at timestamptz,
  expires_at timestamptz,
  active boolean default true
);

-- 10. Blog / Articles
create table articles (
  id uuid primary key default gen_random_uuid(),
  slug text unique,
  title text not null,
  body text,         -- markdown
  author_id uuid references profiles(id),
  tags text[],
  published_at timestamptz,
  is_published boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  meta jsonb
);

-- 11. Chat messages
create table chats (
  id uuid primary key default gen_random_uuid(),
  room_id text not null,   -- e.g. "order:{order_id}" or "user:{profile_id}"
  sender_id uuid references profiles(id),
  sender_role text,        -- 'user' or 'admin' or 'bot'
  message text,
  metadata jsonb,
  created_at timestamptz default now()
);

-- Indexes (performance & searching)
-- Create indexes only if the related tables/columns exist to avoid errors
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'products') THEN
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'idx_products_name') THEN
      EXECUTE 'CREATE INDEX idx_products_name ON products USING gin (to_tsvector(''simple'', name));';
    END IF;
  END IF;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'Skipping idx_products_name: %', SQLERRM;
END
$$;

DO $$
BEGIN
  IF EXISTS (
       SELECT 1 FROM information_schema.columns
       WHERE table_name = 'products' AND column_name = 'image_filenames'
     ) THEN
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'idx_products_image_filenames') THEN
      EXECUTE 'CREATE INDEX idx_products_image_filenames ON products USING gin (image_filenames);';
    END IF;
  END IF;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'Skipping idx_products_image_filenames: %', SQLERRM;
END
$$;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'articles') THEN
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'idx_articles_title') THEN
      EXECUTE 'CREATE INDEX idx_articles_title ON articles USING gin (to_tsvector(''simple'', title));';
    END IF;
  END IF;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'Skipping idx_articles_title: %', SQLERRM;
END
$$;

-- Additional indexes for better query performance
create index idx_products_brand_id on products(brand_id);
create index idx_products_category_id on products(category_id);
create index idx_products_is_active on products(is_active);
create index idx_products_slug on products(slug);
create index idx_product_variants_product_id on product_variants(product_id);
create index idx_product_variants_variant_slug on product_variants(variant_slug);
create index idx_product_variants_sku on product_variants(sku);
create index idx_product_variants_is_active on product_variants(is_active);
create index idx_product_variants_price on product_variants(price);
create index idx_orders_profile_id on orders(profile_id);
create index idx_orders_status on orders(status);
create index idx_reviews_product_id on reviews(product_id);

-- GIN indexes for JSONB columns (faster search)
create index idx_products_meta on products using gin (meta);
create index idx_product_variants_attributes on product_variants using gin (attributes);
create index idx_product_variants_specifications on product_variants using gin (specifications);

-- ==============================================
-- TRIGGERS & FUNCTIONS
-- ==============================================

-- Function: Auto update product_variants.is_active based on qty
create or replace function update_variant_active_status()
returns trigger as $$
begin
  -- Set is_active = false if qty = 0, true if qty > 0
  if NEW.qty = 0 then
    NEW.is_active = false;
  else
    NEW.is_active = true;
  end if;
  return NEW;
end;
$$ language plpgsql;

-- Trigger: Update variant is_active when qty changes
create trigger trigger_update_variant_active
  before insert or update of qty on product_variants
  for each row
  execute function update_variant_active_status();

-- Function: Auto update products.is_active based on variants
create or replace function update_product_active_status()
returns trigger as $$
begin
  -- Update parent product's is_active
  -- True if at least one variant is active, false if all variants are inactive
  update products
  set is_active = exists(
    select 1 from product_variants
    where product_id = COALESCE(NEW.product_id, OLD.product_id)
      and is_active = true
  ),
  updated_at = now()
  where id = COALESCE(NEW.product_id, OLD.product_id);
  
  return COALESCE(NEW, OLD);
end;
$$ language plpgsql;

-- Trigger: Update product is_active when variant is_active changes
create trigger trigger_update_product_active_after_variant
  after insert or update of is_active or delete on product_variants
  for each row
  execute function update_product_active_status();

-- Function: Auto update updated_at timestamp
create or replace function update_updated_at_column()
returns trigger as $$
begin
  NEW.updated_at = now();
  return NEW;
end;
$$ language plpgsql;

-- Triggers: Auto update updated_at for products and variants
create trigger trigger_products_updated_at
  before update on products
  for each row
  execute function update_updated_at_column();

create trigger trigger_product_variants_updated_at
  before update on product_variants
  for each row
  execute function update_updated_at_column();

-- ==============================================
-- FOREIGN KEY for default_variant_id (added after both tables exist)
-- ==============================================

-- Add foreign key constraint for products.default_variant_id
-- This is added separately to avoid circular reference during table creation
-- DEFERRABLE allows temporary invalid values within transaction
alter table products
  add constraint fk_products_default_variant
  foreign key (default_variant_id)
  references product_variants(id)
  on delete set null
  deferrable initially deferred;