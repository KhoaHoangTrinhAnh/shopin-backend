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
  slug text unique,
  url text,
  brand_id int references brands(id),
  category_id int references categories(id),
  price numeric,
  original_price numeric,
  description text,        
  meta jsonb,                   -- meta_title, meta_description, meta_keywords
  image_filenames text[],       -- raw filenames (e.g. ["a.jpg","b.jpg"])
  image_urls jsonb,             -- public URLs array/object after upload
  main_image text,              -- url
  is_active boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 4. Product variants
create table product_variants (
  id uuid primary key default gen_random_uuid(),
  product_id uuid references products(id) on delete cascade,
  sku text unique,
  name text,             
  price numeric,
  old_price numeric,
  original_price numeric,
  qty int default 0,
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
          ],
          "Đèn Flash camera sau": "Có",
          "Tính năng camera sau": [
            "Ảnh Raw",
            "Điều khiển camera (Camera Control)",
            "Điều chỉnh khẩu độ",
            "Zoom quang học",
            "Zoom kỹ thuật số",
            "Xóa phông",
            "Tự động lấy nét (AF)",
            "Trôi nhanh thời gian (Time Lapse)",
            "Toàn cảnh (Panorama)",
            "Smart HDR 5",
            "Siêu độ phân giải",
            "Siêu cận (Macro)",
            "Quay video định dạng Log",
            "Quay video hiển thị kép",
            "Quay video ProRes",
            "Quay chậm (Slow Motion)",
            "Live Photos",
            "Gắn thẻ địa lý (Geotagging)",
            "Góc siêu rộng (Ultrawide)",
            "Dolby Vision HDR",
            "Deep Fusion",
            "Cinematic",
            "Chụp ảnh liên tục",
            "Chống rung điện tử kỹ thuật số (EIS)",
            "Chống rung quang học (OIS)",
            "Ban đêm (Night Mode)",
            "Chế độ hành động (Action Mode)",
            "Photonic Engine"
          ],
          "Độ phân giải camera trước": "18 MP",
          "Tính năng camera trước": [
            "Smart HDR 5",
            "Xóa phông",
            "Video hiển thị kép",
            "Tự động lấy nét (AF)",
            "Trôi nhanh thời gian (Time Lapse)",
            "Retina Flash",
            "Quay video HD",
            "Quay video Full HD",
            "Quay video 4K",
            "Quay chậm (Slow Motion)",
            "Nhãn dán (AR Stickers)",
            "Live Photos",
            "Deep Fusion",
            "Chụp ảnh Raw",
            "Chụp đêm",
            "Chống rung điện tử kỹ thuật số (EIS)",
            "Cinematic",
            "TrueDepth",
            "Photonic Engine"
          ],
          "Công nghệ màn hình": "OLED",
          "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)",
          "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz",
          "Độ sáng tối đa": "3000 nits",
          "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield 2"
        }
      },
      {
        "Pin & Sạc": {
          "Dung lượng pin": "37 giờ",
          "Loại pin": "Li-Ion",
          "Hỗ trợ sạc tối đa": "40 W",
          "Công nghệ pin": [
            "Tiết kiệm pin",
            "Sạc pin nhanh",
            "Sạc ngược qua cáp",
            "Sạc không dây MagSafe",
            "Sạc không dây"
          ]
        }
      },
      {
        "Tiện ích": {
          "Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID",
          "Tính năng đặc biệt": [
            "Âm thanh Dolby Atmos",
            "Xoá vật thể AI",
            "Viết AI",
            "Trung tâm màn hình (Center Stage)",
            "Phát hiện va chạm (Crash Detection)",
            "Màn hình luôn hiển thị AOD",
            "Khoanh tròn để tìm kiếm",
            "HDR10+",
            "HDR10",
            "DCI-P3",
            "Công nghệ âm thanh Dolby Digital Plus",
            "Công nghệ True Tone",
            "Công nghệ HLG",
            "Công nghê âm thanh Dolby Digital",
            "Chạm 2 lần sáng màn hình",
            "Apple Pay",
            "Loa kép"
          ],
          "Kháng nước, bụi": "IP68",
          "Ghi âm": [
            "Ghi âm mặc định",
            "Ghi âm cuộc gọi"
          ],
          "Xem phim": [
            "MP4",
            "AV1",
            "HEVC"
          ],
          "Nghe nhạc": [
            "MP3",
            "FLAC",
            "Apple Lossless",
            "APAC",
            "AAC"
          ]
        }
      },
      {
        "Kết nối": {
          "Mạng di động": "Hỗ trợ 5G",
          "SIM": "1 Nano SIM & 1 eSIM",
          "Wifi": "Wi-Fi MIMO",
          "GPS": [
            "iBeacon",
            "QZSS",
            "NavIC",
            "GPS",
            "GLONASS",
            "GALILEO",
            "BEIDOU"
          ],
          "Bluetooth": "v6.0",
          "Cổng kết nối/sạc": "Type-C",
          "Jack tai nghe": "Type-C",
          "Kết nối khác": "NFC"
        }
      },
      {
        "Thiết kế & Chất liệu": {
          "Thiết kế": "Nguyên khối",
          "Chất liệu": "Khung nhôm nguyên khối & Mặt lưng kính cường lực",
          "Kích thước, khối lượng": "Dài 163.4 mm - Ngang 78 mm - Dày 8.75 mm - Nặng 231 g",
          "Thời điểm ra mắt": "09/2025"
        }
      }
    ]*/
  is_active boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 5. Carts + Cart items (guest or logged-in)
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
  variant_name text,            -- "Đen", "Trắng", etc.
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
create index idx_products_name on products using gin (to_tsvector('simple', name));
create index idx_products_image_filenames on products using gin (image_filenames);
create index idx_articles_title on articles using gin (to_tsvector('simple', title));

-- Additional indexes for better query performance
create index idx_products_brand_id on products(brand_id);
create index idx_products_category_id on products(category_id);
create index idx_products_price on products(price);
create index idx_products_is_active on products(is_active);
create index idx_orders_profile_id on orders(profile_id);
create index idx_orders_status on orders(status);
create index idx_reviews_product_id on reviews(product_id);