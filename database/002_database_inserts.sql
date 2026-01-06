-- ========================================
-- SHOPIN DATABASE - PRODUCT INSERTS
-- Generated: 2025-12-03T17:03:52.230038
-- Total Files: 20
-- ========================================

-- ========================================
-- BRANDS
-- ========================================

INSERT INTO brands (id, name, slug) VALUES (1, 'Asus', 'asus') ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, slug) VALUES (2, 'Dell', 'dell') ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, slug) VALUES (3, 'HP', 'hp') ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, slug) VALUES (4, 'iPhone', 'iphone') ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, slug) VALUES (5, 'Lenovo', 'lenovo') ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, slug) VALUES (6, 'MacBook', 'macbook') ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, slug) VALUES (7, 'OPPO', 'oppo') ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, slug) VALUES (8, 'Samsung', 'samsung') ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, slug) VALUES (9, 'vivo', 'vivo') ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, slug) VALUES (10, 'Xiaomi', 'xiaomi') ON CONFLICT (name) DO NOTHING;

-- ========================================
-- CATEGORIES
-- ========================================

INSERT INTO categories (id, name, slug) VALUES (1, 'Laptop', 'laptop') ON CONFLICT (name) DO NOTHING;
INSERT INTO categories (id, name, slug) VALUES (2, 'Điện thoại', 'dien-thoai') ON CONFLICT (name) DO NOTHING;

-- ========================================
-- PRODUCTS & VARIANTS
-- ========================================

-- Product: Laptop Asus Gaming ROG Strix G16 G614JU - N3509W (i7 13650HX, 32GB, 1TB, RTX 4050 6GB, Full HD+ 165Hz, Win11)
-- Slug: asus-rog-strix-g16-g614ju-i7-n3509w
-- Variants: 1

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Laptop Asus Gaming ROG Strix G16 G614JU - N3509W (i7 13650HX, 32GB, 1TB, RTX 4050 6GB, Full HD+ 165Hz, Win11)',
        'asus-rog-strix-g16-g614ju-i7-n3509w',
        1.0,
        1.0,
        'Khi nhắc đến laptop gaming, mẫu laptop Asus ROG Strix G16 G614JU i7 13650HX (N3509W) luôn nằm trong top danh sách những lựa chọn hàng đầu của nhiều game thủ bởi không chỉ nét cá tính mà còn là về trải nghiệm. Hiệu năng mạnh mẽ, chinh phục người dùng với màn hình sắc nét, hệ thống tản nhiệt hiệu quả và các tính năng tối ưu hoàn toàn đáp ứng và cân tuốt các tựa game hàng đầu.',
        '{"meta_title": "Laptop Asus ROG Strix G16 G614JU i7 13650HX (N3509W) - Chính hãng, giá tốt", "meta_description": "Laptop Asus ROG Strix G16 G614JU i7 13650HX (N3509W) giá rẻ, trả góp 0% lãi suất - Mua online, xét duyệt nhanh, giao hàng tận nơi trong 1 giờ, cà thẻ tại nhà. Bảo hành toàn quốc. Xem ngay!", "meta_keywords": "Asus ROG Strix G16 G614JU i7 13650HX/32GB/1TB/6GB RTX4050/165Hz/Win11 (N3509W), Asus ROG Strix G16 G614JU i7 13650HX (N3509W), Asus ROG Strix G16 G614JU i7 13650HX (N3509W), Laptop Asus ROG Strix G16 G614JU i7 13650HX/32GB/1TB/6GB RTX4050/165Hz/Win11 (N3509W), giá Asus ROG Strix G16 G614JU i7 13650HX/32GB/1TB/6GB RTX4050/165Hz/Win11 (N3509W), thông tin Asus ROG Strix G16 G614JU i7 13650HX/32GB/1TB/6GB RTX4050/165Hz/Win11 (N3509W)"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'ASUS_ROG_STRIX_G16_G614JU_I7_N3509W_DEFAULT',
        'asus-rog-strix-g16-g614ju-i7-n3509w-default',
        NULL,
        33190000.0,
        40190000.0,
        993,
        '[{"Bộ xử lý": {"Công nghệ CPU": "Intel Core i7 Raptor Lake - 13650HX", "Số nhân": "14", "Số luồng": "20", "Tốc độ CPU": "2.60 GHz (Lên đến 4.90 GHz khi tải nặng)"}}, {"Đồ hoạ (GPU)": {"Card màn hình": "Card rời- NVIDIA GeForce RTX 4050, 6 GB"}}, {"Bộ nhớ RAM, Ổ cứng": {"RAM": "32 GB", "Loại RAM": "DDR5 (1 khe 16 GB + 1 khe 16 GB)", "Tốc độ Bus RAM": "4800 MHz", "Hỗ trợ RAM tối đa": "32 GB", "Ổ cứng": "1 TB SSD NVMe PCIe Gen 4"}}, {"Màn hình": {"Kích thước màn hình": "16 inch", "Độ phân giải": "Full HD+ (1920 x 1200)", "Tấm nền": "IPS", "Tần số quét": "165 Hz", "Độ phủ màu": "100% sRGB", "Công nghệ màn hình": "G-Sync"}}, {"Cổng kết nối & tính năng mở rộng": {"Cổng giao tiếp": ["Jack tai nghe 3.5 mm", "1 x USB 3.2 Gen 2 Type-C (hỗ trợ DisplayPort, Power delivery, G-SYNC)", "2 x USB 3.2", "HDMI", "1 x Thunderbolt 4 (hỗ trợ DisplayPort)", "LAN (RJ45)"], "Kết nối không dây": "Wi-Fi 6E (802.11ax)", "Webcam": "HD webcam", "Đèn bàn phím": "Đèn chuyển màu RGB - 4 vùng", "Công nghệ âm thanh": "Hi-Res Audio", "Tản nhiệt": "Hãng không công bố", "Tính năng khác": ["MUX Switch", "NVIDIA Optimus"]}}, {"Kích thước - Khối lượng - Pin": {"Thông tin Pin": "4-cell Li-ion, 90 Wh", "Hệ điều hành": "Windows 11 Home SL", "Thời điểm ra mắt": "2024", "Kích thước": "Dài 354 mm - Rộng 264 mm - Dày 30.4 mm - 2.5 kg", "Chất liệu": "Vỏ nhựa - nắp lưng bằng kim loại"}}]'::jsonb,
        ARRAY['asus-rog-strix-g16-g614ju-i7-n3509w-1-638700328702961785.jpg', 'asus-rog-strix-g16-g614ju-i7-n3509w-2-638700328711158930.jpg', 'asus-rog-strix-g16-g614ju-i7-n3509w-3-638700328717053143.jpg', 'asus-rog-strix-g16-g614ju-i7-n3509w-4-638700328723555378.jpg', 'asus-rog-strix-g16-g614ju-i7-n3509w-5-638700328730471864.jpg', 'asus-rog-strix-g16-g614ju-i7-n3509w-6-638700328738284334.jpg', 'asus-rog-strix-g16-g614ju-i7-n3509w-7-638700328744827347.jpg', 'asus-rog-strix-g16-g614ju-i7-n3509w-8-638700328752364462.jpg', 'asus-rog-strix-g16-g614ju-i7-n3509w-9-638700328758460994.jpg', 'asus-rog-strix-g16-g614ju-i7-n3509w-10-638700328765697400.jpg', 'asus-rog-strix-g16-g614ju-i7-n3509w-30-638708076130755027.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-rog-strix-g16-g614ju-i7-n3509w/asus-rog-strix-g16-g614ju-i7-n3509w-2-638700328711158930.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-rog-strix-g16-g614ju-i7-n3509w/asus-rog-strix-g16-g614ju-i7-n3509w-3-638700328717053143.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-rog-strix-g16-g614ju-i7-n3509w/asus-rog-strix-g16-g614ju-i7-n3509w-4-638700328723555378.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-rog-strix-g16-g614ju-i7-n3509w/asus-rog-strix-g16-g614ju-i7-n3509w-5-638700328730471864.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-rog-strix-g16-g614ju-i7-n3509w/asus-rog-strix-g16-g614ju-i7-n3509w-6-638700328738284334.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-rog-strix-g16-g614ju-i7-n3509w/asus-rog-strix-g16-g614ju-i7-n3509w-7-638700328744827347.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-rog-strix-g16-g614ju-i7-n3509w/asus-rog-strix-g16-g614ju-i7-n3509w-8-638700328752364462.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-rog-strix-g16-g614ju-i7-n3509w/asus-rog-strix-g16-g614ju-i7-n3509w-9-638700328758460994.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-rog-strix-g16-g614ju-i7-n3509w/asus-rog-strix-g16-g614ju-i7-n3509w-10-638700328765697400.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-rog-strix-g16-g614ju-i7-n3509w/asus-rog-strix-g16-g614ju-i7-n3509w-30-638708076130755027.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-rog-strix-g16-g614ju-i7-n3509w/asus-rog-strix-g16-g614ju-i7-n3509w-1-638700328702961785.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Laptop Asus Vivobook Go 15 E1504FA - NJ776W (R5 7520U, 16GB, 512GB, Full HD, Win11)
-- Slug: asus-vivobook-go-15-e1504fa-r5-nj776w
-- Variants: 1

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Laptop Asus Vivobook Go 15 E1504FA - NJ776W (R5 7520U, 16GB, 512GB, Full HD, Win11)',
        'asus-vivobook-go-15-e1504fa-r5-nj776w',
        1.0,
        1.0,
        'Laptop Asus Vivobook Go 15 E1504FA R5 7520U (NJ776W) mang phong cách thiết kế sang trọng, hiệu năng mạnh mẽ cùng tính đa năng sử dụng, chắc chắn sẽ giúp bạn đáp ứng mọi tác vụ công việc và học tập hàng ngày một cách hiệu quả và chuyên nghiệp nhất.',
        '{"meta_title": "Asus Vivobook Go 15 E1504FA (R5 7520U) mỏng nhẹ, giá rẻ, góp 0%", "meta_description": "Laptop Asus Vivobook Go 15 E1504FA-NJ776W (R5 7520U, 16GB, 512GB) mỏng nhẹ, pin lâu, hiệu năng mạnh, giảm thêm 300K cho HSSV, góp 0%, BH 2 năm. Mua ngay tại Thegioididong", "meta_keywords": "Asus Vivobook Go 15 E1504FA R5 7520U/16GB/512GB/Chuột/Win11 (NJ776W), Asus Vivobook Go 15 E1504FA R5 7520U (NJ776W), Asus Vivobook Go 15 E1504FA R5 7520U (NJ776W), Laptop Asus Vivobook Go 15 E1504FA R5 7520U/16GB/512GB/Chuột/Win11 (NJ776W), giá Asus Vivobook Go 15 E1504FA R5 7520U/16GB/512GB/Chuột/Win11 (NJ776W), thông tin Asus Vivobook Go 15 E1504FA R5 7520U/16GB/512GB/Chuột/Win11 (NJ776W)"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'ASUS_VIVOBOOK_GO_15_E1504FA_R5_NJ776W_DEFAULT',
        'asus-vivobook-go-15-e1504fa-r5-nj776w-default',
        NULL,
        13590000.0,
        14190000.0,
        885,
        '[{"Bộ xử lý": {"Công nghệ CPU": "AMD Ryzen 5- 7520U", "Số nhân": "4", "Số luồng": "8", "Tốc độ CPU": "2.80 GHz (Lên đến 4.30 GHz khi tải nặng)"}}, {"Đồ hoạ (GPU)": {"Card màn hình": "Card tích hợp- AMD Radeon Graphics"}}, {"Bộ nhớ RAM, Ổ cứng": {"RAM": "16 GB", "Loại RAM": "LPDDR5 (Onboard)", "Tốc độ Bus RAM": "5500 MHz", "Hỗ trợ RAM tối đa": "Không hỗ trợ nâng cấp", "Ổ cứng": "512 GB SSD NVMe PCIe (Có thể tháo ra, lắp thanh khác tối đa 1 TB)"}}, {"Màn hình": {"Kích thước màn hình": "15.6 inch", "Độ phân giải": "Full HD (1920 x 1080)", "Tấm nền": "TN", "Tần số quét": "60Hz", "Độ phủ màu": "45% NTSC", "Công nghệ màn hình": ["Chống chói Anti Glare", "250 nits"]}}, {"Cổng kết nối & tính năng mở rộng": {"Cổng giao tiếp": ["1 x USB 2.0", "Jack tai nghe 3.5 mm", "1 x USB 3.2", "HDMI", "USB Type-C"], "Kết nối không dây": "Wi-Fi 6E (802.11ax)", "Webcam": "HD webcam", "Đèn bàn phím": "Không có đèn", "Bảo mật": ["Công tắc khoá camera", "Bảo mật vân tay"], "Công nghệ âm thanh": "SonicMaster audio", "Tản nhiệt": "Hãng không công bố", "Tính năng khác": ["Độ bền chuẩn quân đội MIL STD 810H", "Bản lề mở 180 độ"]}}, {"Kích thước - Khối lượng - Pin": {"Thông tin Pin": "3-cell Li-ion, 42 Wh", "Hệ điều hành": "Windows 11 Home SL", "Thời điểm ra mắt": "2023", "Kích thước": "Dài 360.3 mm - Rộng 232.5 mm - Dày 17.9 mm - 1.63 kg", "Chất liệu": "Vỏ nhựa"}}]'::jsonb,
        ARRAY['asus-vivobook-go-15-e1504fa-r5-nj776w-glr-1.jpg', 'asus-vivobook-go-15-e1504fa-r5-nj776w-glr-2.jpg', 'asus-vivobook-go-15-e1504fa-r5-nj776w-glr-3.jpg', 'asus-vivobook-go-15-e1504fa-r5-nj776w-glr-4.jpg', 'asus-vivobook-go-15-e1504fa-r5-nj776w-glr-5.jpg', 'asus-vivobook-go-15-e1504fa-r5-nj776w-glr-6.jpg', 'asus-vivobook-go-15-e1504fa-r5-nj776w-glr-7.jpg', 'asus-vivobook-go-15-e1504fa-r5-nj776w-glr-8.jpg', 'asus-vivobook-go-15-e1504fa-r5-nj776w-glr-9.jpg', 'asus-vivobook-go-15-e1504fa-r5-nj776w-glr-10.jpg', 'asus-vivobook-go-15-e1504fa-r5-nj776w-glr-11.jpg', 'asus-vivobook-go-15-e1504fa-r5-nj776w-glr-12.jpg', 'asus-vivobook-go-15-e1504fa-r5-nj776w-hinh-12.jpg', 'asus-vivobook-go-15-e1504fa-r5-nj776w-glr-13.jpg', 'asus-vivobook-go-15-e1504fa-r5-nj776w-glr-14.jpg', 'asus-vivobook-go-15-e1504fa-r5-nj776w-hinh-16.jpg', 'asus-vivobook-go-15-e1504fa-r5-nj776w-glr-acv-bbh-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-glr-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-glr-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-glr-4.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-glr-5.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-glr-6.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-glr-7.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-glr-8.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-glr-9.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-glr-10.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-glr-11.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-glr-12.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-hinh-12.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-glr-13.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-glr-14.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-hinh-16.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-glr-acv-bbh-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/asus-vivobook-go-15-e1504fa-r5-nj776w/asus-vivobook-go-15-e1504fa-r5-nj776w-glr-1.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Laptop Dell Inspiron 15 3530 - 71070372 (i5 1334U, 16GB, 512GB, Full HD 120Hz, OfficeH24+365, Win11)
-- Slug: dell-inspiron-15-3530-i5-71070372
-- Variants: 1

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Laptop Dell Inspiron 15 3530 - 71070372 (i5 1334U, 16GB, 512GB, Full HD 120Hz, OfficeH24+365, Win11)',
        'dell-inspiron-15-3530-i5-71070372',
        2.0,
        1.0,
        'Laptop Dell Inspiron 15 3530 i5 1334U (71070372) là chiếc laptop lý tưởng cho học sinh, sinh viên và nhân viên văn phòng, thậm chí đáp ứng tốt nhu cầu thiết kế đồ họa cơ bản. Với hiệu năng ổn định, thiết kế thanh lịch và màn hình sắc nét, chiếc laptop này hứa hẹn mang đến trải nghiệm làm việc và giải trí tuyệt vời. Đây là một lựa chọn đáng cân nhắc trong phân khúc laptop tầm trung, mang lại giá trị sử dụng cao.',
        '{"meta_title": "Dell Inspiron 15 3530 i5 1334U (71070372) - Chính hãng, giá tốt", "meta_description": "Dell Inspiron 15 3530 i5 1334U (71070372) giá rẻ, trả góp 0% lãi suất - Mua online, xét duyệt nhanh, giao hàng tận nơi trong 1 giờ, cà thẻ tại nhà. Bảo hành toàn quốc. Xem ngay!", "meta_keywords": "Dell Inspiron 15 3530 i5 1334U/16GB/512GB/120Hz/OfficeHS24+365/Win11 (71070372), Dell Inspiron 15 3530 i5 1334U (71070372), Dell Inspiron 15 3530 i5 1334U (71070372), Laptop Dell Inspiron 15 3530 i5 1334U/16GB/512GB/120Hz/OfficeHS24+365/Win11 (71070372), giá Dell Inspiron 15 3530 i5 1334U/16GB/512GB/120Hz/OfficeHS24+365/Win11 (71070372), thông tin Dell Inspiron 15 3530 i5 1334U/16GB/512GB/120Hz/OfficeHS24+365/Win11 (71070372)"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'DELL_INSPIRON_15_3530_I5_71070372_DEFAULT',
        'dell-inspiron-15-3530-i5-71070372-default',
        NULL,
        17490000.0,
        19390000.0,
        702,
        '[{"Bộ xử lý": {"Công nghệ CPU": "Intel Core i5 Raptor Lake - 1334U", "Số nhân": "10", "Số luồng": "12", "Tốc độ CPU": "1.30 GHz (Lên đến 4.60 GHz khi tải nặng)"}}, {"Đồ hoạ (GPU)": {"Card màn hình": "Card tích hợp-Intel Iris Xe Graphics"}}, {"Bộ nhớ RAM, Ổ cứng": {"RAM": "16 GB", "Loại RAM": "DDR4 (1 khe 8 GB + 1 khe 8 GB)", "Tốc độ Bus RAM": "3200 MHz", "Hỗ trợ RAM tối đa": "16 GB", "Ổ cứng": "512 GB SSD NVMe PCIe"}}, {"Màn hình": {"Kích thước màn hình": "15.6 inch", "Độ phân giải": "Full HD (1920 x 1080)", "Tần số quét": "120Hz", "Công nghệ màn hình": "WVA"}}, {"Cổng kết nối & tính năng mở rộng": {"Cổng giao tiếp": ["1 x USB 2.0", "Jack tai nghe 3.5 mm", "1 x USB 3.2", "HDMI", "USB Type-C"], "Kết nối không dây": "Wi-Fi 6 (802.11ax)", "Khe đọc thẻ nhớ": "SD", "Webcam": "HD webcam", "Đèn bàn phím": "Không có đèn", "Công nghệ âm thanh": "Realtek Audio", "Tản nhiệt": "Hãng không công bố"}}, {"Kích thước - Khối lượng - Pin": {"Thông tin Pin": "3-cell Li-ion, 41 Wh", "Hệ điều hành": "Windows 11 Home SL + Office Home 2024 vĩnh viễn + Microsoft 365 Basic", "Thời điểm ra mắt": "2025", "Kích thước": "Dài 358.5 mm - Rộng 235.56 mm - Dày 18.99 mm - 1.66 kg", "Chất liệu": "Vỏ nhựa"}}]'::jsonb,
        ARRAY['dell-inspiron-15-3530-i5-71070372-1-638881907568643473.jpg', 'dell-inspiron-15-3530-i5-71070372-2-638881907578147995.jpg', 'dell-inspiron-15-3530-i5-71070372-3-638881907585351995.jpg', 'dell-inspiron-15-3530-i5-71070372-4-638881907591348491.jpg', 'dell-inspiron-15-3530-i5-71070372-5-638881907597172816.jpg', 'dell-inspiron-15-3530-i5-71070372-6-638881907603072009.jpg', 'dell-inspiron-15-3530-i5-71070372-7-638881907608264641.jpg', 'dell-inspiron-15-3530-i5-71070372-8-638881907614564006.jpg', 'dell-inspiron-15-3530-i5-71070372-9-638881907620609593.jpg', 'dell-inspiron-15-3530-i5-71070372-10-638881907626247036.jpg', 'dell-inspiron-15-3530-i5-71070372-11-638881907632899902.jpg', 'dell-inspiron-15-3530-i5-71070372-12-638881907639079928.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-inspiron-15-3530-i5-71070372/dell-inspiron-15-3530-i5-71070372-2-638881907578147995.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-inspiron-15-3530-i5-71070372/dell-inspiron-15-3530-i5-71070372-3-638881907585351995.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-inspiron-15-3530-i5-71070372/dell-inspiron-15-3530-i5-71070372-4-638881907591348491.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-inspiron-15-3530-i5-71070372/dell-inspiron-15-3530-i5-71070372-5-638881907597172816.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-inspiron-15-3530-i5-71070372/dell-inspiron-15-3530-i5-71070372-6-638881907603072009.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-inspiron-15-3530-i5-71070372/dell-inspiron-15-3530-i5-71070372-7-638881907608264641.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-inspiron-15-3530-i5-71070372/dell-inspiron-15-3530-i5-71070372-8-638881907614564006.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-inspiron-15-3530-i5-71070372/dell-inspiron-15-3530-i5-71070372-9-638881907620609593.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-inspiron-15-3530-i5-71070372/dell-inspiron-15-3530-i5-71070372-10-638881907626247036.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-inspiron-15-3530-i5-71070372/dell-inspiron-15-3530-i5-71070372-11-638881907632899902.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-inspiron-15-3530-i5-71070372/dell-inspiron-15-3530-i5-71070372-12-638881907639079928.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-inspiron-15-3530-i5-71070372/dell-inspiron-15-3530-i5-71070372-1-638881907568643473.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Laptop Dell Latitude 3450 - L3450-1335U-16512WN (i5 1335U, 16GB, 512GB, Full HD, Win11)
-- Slug: dell-latitude-3450-i5-l34501335u16512wn
-- Variants: 1

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Laptop Dell Latitude 3450 - L3450-1335U-16512WN (i5 1335U, 16GB, 512GB, Full HD, Win11)',
        'dell-latitude-3450-i5-l34501335u16512wn',
        2.0,
        1.0,
        'Laptop Dell Latitude 3450 i5 1335U (L3450-1335U-16512WN) là chiếc laptop lý tưởng cho học sinh, sinh viên và nhân viên văn phòng, thậm chí đáp ứng tốt nhu cầu thiết kế đồ họa cơ bản. Với hiệu năng ổn định, thiết kế bền bỉ và tính di động cao, chiếc laptop này hứa hẹn sẽ là người bạn đồng hành đáng tin cậy trong công việc và học tập. Đây chắc chắn là một lựa chọn đáng cân nhắc trong phân khúc giá của nó.',
        '{"meta_title": "Dell Latitude 3450 i5 1335U (L3450-1335U-16512WN) - Chính hãng, giá tốt", "meta_description": "Dell Latitude 3450 i5 1335U (L3450-1335U-16512WN) giá rẻ, trả góp 0% lãi suất - Mua online, xét duyệt nhanh, giao hàng tận nơi trong 1 giờ, cà thẻ tại nhà. Bảo hành toàn quốc. Xem ngay!", "meta_keywords": "Dell Latitude 3450 i5 1335U/16GB/512GB/Win11 (L3450-1335U-16512WN), Dell Latitude 3450 i5 1335U (L3450-1335U-16512WN), Dell Latitude 3450 i5 1335U (L3450-1335U-16512WN), Laptop Dell Latitude 3450 i5 1335U/16GB/512GB/Win11 (L3450-1335U-16512WN), giá Dell Latitude 3450 i5 1335U/16GB/512GB/Win11 (L3450-1335U-16512WN), thông tin Dell Latitude 3450 i5 1335U/16GB/512GB/Win11 (L3450-1335U-16512WN)"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'DELL_LATITUDE_3450_I5_L34501335U16512WN_DEFAULT',
        'dell-latitude-3450-i5-l34501335u16512wn-default',
        NULL,
        18590000.0,
        19590000.0,
        18,
        '[{"Bộ xử lý": {"Công nghệ CPU": "Intel Core i5 Raptor Lake - 1335U", "Số nhân": "10", "Số luồng": "12", "Tốc độ CPU": "1.30 GHz (Lên đến 4.60 GHz khi tải nặng)"}}, {"Đồ hoạ (GPU)": {"Card màn hình": "Card tích hợp-Intel Iris Xe Graphics"}}, {"Bộ nhớ RAM, Ổ cứng": {"RAM": "16 GB", "Loại RAM": "DDR5 (1 khe 8 GB + 1 khe 8 GB)", "Tốc độ Bus RAM": "5200 MHz", "Hỗ trợ RAM tối đa": "64 GB", "Ổ cứng": "512 GB SSD NVMe PCIe (Có thể tháo ra, lắp thanh khác tối đa 1 TB)"}}, {"Màn hình": {"Kích thước màn hình": "14 inch", "Độ phân giải": "Full HD (1920 x 1080)", "Tấm nền": "IPS", "Tần số quét": "60Hz", "Độ phủ màu": "45% NTSC", "Công nghệ màn hình": ["Chống chói Anti Glare", "250 nits"]}}, {"Cổng kết nối & tính năng mở rộng": {"Cổng giao tiếp": ["Jack tai nghe 3.5 mm", "2 x USB 3.2", "HDMI", "1 x USB Type-C USB 4 (hỗ trợ DisplayPort và Power Delivery)", "1 x USB 3.2 (hỗ trợ PowerShare)", "LAN (RJ45)"], "Kết nối không dây": "Wi-Fi 6E (802.11ax)", "Webcam": "Full HD Webcam", "Đèn bàn phím": "Không có đèn", "Bảo mật": "Công tắc khoá camera", "Công nghệ âm thanh": "Realtek Audio", "Tản nhiệt": "Hãng không công bố", "Tính năng khác": "Bản lề mở 180 độ"}}, {"Kích thước - Khối lượng - Pin": {"Thông tin Pin": "3-cell Li-ion, 42 Wh", "Hệ điều hành": "Windows 11 Home SL", "Thời điểm ra mắt": "2024", "Kích thước": "Dài 322.17 mm - Rộng 219.43 mm - Dày 19.34 mm - 1.5 kg", "Chất liệu": "Vỏ nhựa"}}]'::jsonb,
        ARRAY['dell-latitude-3450-i5-l34501335u16512wn-1-638863820558749054.jpg', 'dell-latitude-3450-i5-l34501335u16512wn-2-638863820552684941.jpg', 'dell-latitude-3450-i5-l34501335u16512wn-3-638863820545732706.jpg', 'dell-latitude-3450-i5-l34501335u16512wn-4-638863820538677819.jpg', 'dell-latitude-3450-i5-l34501335u16512wn-5-638863820529134868.jpg', 'dell-latitude-3450-i5-l34501335u16512wn-7-638863820513582687.jpg', 'dell-latitude-3450-i5-l34501335u16512wn-8-638863820507508484.jpg', 'dell-latitude-3450-i5-l34501335u16512wn-30-638884560141912810.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-latitude-3450-i5-l34501335u16512wn/dell-latitude-3450-i5-l34501335u16512wn-2-638863820552684941.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-latitude-3450-i5-l34501335u16512wn/dell-latitude-3450-i5-l34501335u16512wn-3-638863820545732706.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-latitude-3450-i5-l34501335u16512wn/dell-latitude-3450-i5-l34501335u16512wn-4-638863820538677819.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-latitude-3450-i5-l34501335u16512wn/dell-latitude-3450-i5-l34501335u16512wn-5-638863820529134868.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-latitude-3450-i5-l34501335u16512wn/dell-latitude-3450-i5-l34501335u16512wn-7-638863820513582687.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-latitude-3450-i5-l34501335u16512wn/dell-latitude-3450-i5-l34501335u16512wn-8-638863820507508484.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-latitude-3450-i5-l34501335u16512wn/dell-latitude-3450-i5-l34501335u16512wn-30-638884560141912810.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/dell-latitude-3450-i5-l34501335u16512wn/dell-latitude-3450-i5-l34501335u16512wn-1-638863820558749054.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Laptop HP 15 fc0085AU - A6VV8PA (R5 7430U, 16GB, 512GB, Full HD, Win11)
-- Slug: hp-15-fc0085au-r5-a6vv8pa
-- Variants: 1

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Laptop HP 15 fc0085AU - A6VV8PA (R5 7430U, 16GB, 512GB, Full HD, Win11)',
        'hp-15-fc0085au-r5-a6vv8pa',
        3.0,
        1.0,
        'Nổi bật và quá thân quen trong phân khúc laptop học tập - văn phòng giá rẻ, chiếc laptop HP 15 fc0085AU R5 7430U (A6VV8PA) với cấu hình ổn định, vận hành hiệu quả mọi tác vụ từ làm việc đến giải trí đa phương tiện. Máy hội tụ đầy đủ các yếu tố để trở thành bạn trợ thủ lý tưởng cho người dùng.',
        '{"meta_title": "Laptop HP 15 fc0085AU R5 7430U (A6VV8PA) - Chính hãng, mua trả chậm", "meta_description": "Laptop HP 15 fc0085AU R5 7430U (A6VV8PA) giá rẻ, mua trả chậm - Mua online, xét duyệt nhanh, giao hàng tận nơi trong 1 giờ, cà thẻ tại nhà. Bảo hành toàn quốc. Xem ngay!", "meta_keywords": "HP 15 fc0085AU R5 7430U/16GB/512GB/Win11 (A6VV8PA), HP 15 fc0085AU R5 7430U (A6VV8PA), HP 15 fc0085AU R5 7430U (A6VV8PA), Laptop HP 15 fc0085AU R5 7430U/16GB/512GB/Win11 (A6VV8PA), giá HP 15 fc0085AU R5 7430U/16GB/512GB/Win11 (A6VV8PA), thông tin HP 15 fc0085AU R5 7430U/16GB/512GB/Win11 (A6VV8PA)"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'HP_15_FC0085AU_R5_A6VV8PA_DEFAULT',
        'hp-15-fc0085au-r5-a6vv8pa-default',
        NULL,
        14290000.0,
        14890000.0,
        97,
        '[{"Bộ xử lý": {"Công nghệ CPU": "AMD Ryzen 5- 7430U", "Số nhân": "6", "Số luồng": "12", "Tốc độ CPU": "2.30 GHz (Lên đến 4.30 GHz khi tải nặng)"}}, {"Đồ hoạ (GPU)": {"Card màn hình": "Card tích hợp- AMD Radeon Graphics"}}, {"Bộ nhớ RAM, Ổ cứng": {"RAM": "16 GB", "Loại RAM": "DDR4 (1 khe 8 GB + 1 khe 8 GB)", "Tốc độ Bus RAM": "3200 MHz", "Hỗ trợ RAM tối đa": "16 GB", "Ổ cứng": "512 GB SSD NVMe PCIe"}}, {"Màn hình": {"Kích thước màn hình": "15.6 inch", "Độ phân giải": "Full HD (1920 x 1080)", "Tần số quét": "60Hz", "Độ phủ màu": "45% NTSC", "Công nghệ màn hình": ["Chống chói Anti Glare", "250 nits"]}}, {"Cổng kết nối & tính năng mở rộng": {"Cổng giao tiếp": "2 x USB Type-A", "Kết nối không dây": "Wi-Fi 6 (802.11ax)", "Webcam": "HD webcam", "Đèn bàn phím": "Không có đèn", "Bảo mật": "Công tắc khoá camera", "Công nghệ âm thanh": "Loa kép (2 kênh)", "Tản nhiệt": "Hãng không công bố"}}, {"Kích thước - Khối lượng - Pin": {"Thông tin Pin": "3-cell Li-ion, 41 Wh", "Hệ điều hành": "Windows 11 Home SL", "Thời điểm ra mắt": "2023", "Kích thước": "Dài 359.8 mm - Rộng 236 mm - Dày 18.6 mm - 1.59 kg", "Chất liệu": "Vỏ nhựa"}}]'::jsonb,
        ARRAY['hp-15-fc0085au-r5-a6vv8pa-1-638996855872993354.jpg', 'hp-15-fc0085au-r5-a6vv8pa-2-638996855830393884.jpg', 'hp-15-fc0085au-r5-a6vv8pa-3-638996855837433053.jpg', 'hp-15-fc0085au-r5-a6vv8pa-4-638996855844747758.jpg', 'hp-15-fc0085au-r5-a6vv8pa-5-638996855908997237.jpg', 'hp-15-fc0085au-r5-a6vv8pa-6-638996855902939428.jpg', 'hp-15-fc0085au-r5-a6vv8pa-7-638996855896153975.jpg', 'hp-15-fc0085au-r5-a6vv8pa-8-638996855851707047.jpg', 'hp-15-fc0085au-r5-a6vv8pa-9-638996855888374386.jpg', 'hp-15-fc0085au-r5-a6vv8pa-10-638996855824290147.jpg', 'hp-15-fc0085au-r5-a6vv8pa-11-638996855864899821.jpg', 'hp-15-fc0085au-r5-a6vv8pa-12-638996855857990697.jpg', 'hp-15-fc0085au-r5-a6vv8pa-13-638996855816570417.jpg', 'hp-15-fc0085au-r5-a6vv8pa-14-638996855808234936.jpg', 'hp-15-fc0085au-r5-a6vv8pa-15-638996855795538391.jpg', 'hp-15-fc0085au-r5-a6vv8pa-16-638996855879867869.jpg', 'hp-15-fc0085au-r5-a6vv8pa-bbh-638624255268197876.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-2-638996855830393884.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-3-638996855837433053.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-4-638996855844747758.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-5-638996855908997237.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-6-638996855902939428.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-7-638996855896153975.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-8-638996855851707047.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-9-638996855888374386.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-10-638996855824290147.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-11-638996855864899821.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-12-638996855857990697.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-13-638996855816570417.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-14-638996855808234936.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-15-638996855795538391.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-16-638996855879867869.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-bbh-638624255268197876.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-15-fc0085au-r5-a6vv8pa/hp-15-fc0085au-r5-a6vv8pa-1-638996855872993354.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Laptop HP Gaming VICTUS 15 fa2731TX - B85LNPA (i5 13420H, 16GB, 512GB, RTX 3050 6GB, Full HD 144Hz, Win11)
-- Slug: hp-victus-15-fa2731tx-i5-b85lnpa
-- Variants: 1

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Laptop HP Gaming VICTUS 15 fa2731TX - B85LNPA (i5 13420H, 16GB, 512GB, RTX 3050 6GB, Full HD 144Hz, Win11)',
        'hp-victus-15-fa2731tx-i5-b85lnpa',
        3.0,
        1.0,
        'Laptop gaming đỉnh cao cho dân kỹ thuật, dựng video và game thủ chuyên nghiệp đã xuất hiện! HP VICTUS 15 fa2731TX i5 13420H (B85LNPA) chính là cỗ máy mạnh mẽ, cân mọi tác vụ từ thiết kế đồ họa, dựng phim đến chiến game AAA. Với hiệu năng vượt trội, thiết kế hầm hố và màn hình sắc nét, đây chắc chắn là một khoản đầu tư xứng đáng cho những ai tìm kiếm sự hoàn hảo.',
        '{"meta_title": "Laptop HP VICTUS 15 fa2731TX i5 13420H (B85LNPA) - Chính hãng, giá tốt", "meta_description": "Laptop HP VICTUS 15 fa2731TX i5 13420H (B85LNPA) giá rẻ, trả góp 0% lãi suất - Mua online, xét duyệt nhanh, giao hàng tận nơi trong 1 giờ, cà thẻ tại nhà. Bảo hành toàn quốc. Xem ngay!", "meta_keywords": "HP VICTUS 15 fa2731TX i5 13420H/16GB/512GB/6GB RTX3050/144Hz/Win11 (B85LNPA), HP VICTUS 15 fa2731TX i5 13420H (B85LNPA), HP VICTUS 15 fa2731TX i5 13420H (B85LNPA), Laptop HP VICTUS 15 fa2731TX i5 13420H/16GB/512GB/6GB RTX3050/144Hz/Win11 (B85LNPA), giá HP VICTUS 15 fa2731TX i5 13420H/16GB/512GB/6GB RTX3050/144Hz/Win11 (B85LNPA), thông tin HP VICTUS 15 fa2731TX i5 13420H/16GB/512GB/6GB RTX3050/144Hz/Win11 (B85LNPA)"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'HP_VICTUS_15_FA2731TX_I5_B85LNPA_DEFAULT',
        'hp-victus-15-fa2731tx-i5-b85lnpa-default',
        NULL,
        22490000.0,
        24090000.0,
        881,
        '[{"Bộ xử lý": {"Công nghệ CPU": "Intel Core i5 Raptor Lake - 13420H", "Số nhân": "8", "Số luồng": "12", "Tốc độ CPU": "2.10 GHz (Lên đến 4.60 GHz khi tải nặng)"}}, {"Đồ hoạ (GPU)": {"Card màn hình": "Card rời- NVIDIA GeForce RTX 3050, 6 GB", "Số nhân GPU": "2304 CUDA Cores", "Công suất đồ hoạ - TGP": "70 W"}}, {"Bộ nhớ RAM, Ổ cứng": {"RAM": "16 GB", "Loại RAM": "DDR4 (1 khe 16 GB + 1 khe rời)", "Tốc độ Bus RAM": "3200 MHz", "Hỗ trợ RAM tối đa": "32 GB", "Ổ cứng": "512 GB SSD NVMe PCIe (Có thể tháo ra, lắp thanh khác tối đa 2 TB)"}}, {"Màn hình": {"Kích thước màn hình": "15.6 inch", "Độ phân giải": "Full HD (1920 x 1080)", "Tấm nền": "IPS", "Tần số quét": "144Hz", "Độ phủ màu": "62.5% sRGB", "Công nghệ màn hình": ["Chống chói Anti Glare", "300 nits"]}}, {"Cổng kết nối & tính năng mở rộng": {"Cổng giao tiếp": ["2 x USB 3.2", "HDMI", "1 x USB Type-C (hỗ trợ DisplayPort 1.4)", "1 x Headphone/microphone combo", "LAN (RJ45)"], "Kết nối không dây": "Wi-Fi 6 (802.11ax)", "Webcam": "HD webcam", "Đèn bàn phím": "Đơn sắc - Màu trắng", "Công nghệ âm thanh": ["Audio by B&O", "Realtek High Definition Audio", "HP Audio Boost", "DTS:X ULTRA"], "Tản nhiệt": "Hãng không công bố"}}, {"Kích thước - Khối lượng - Pin": {"Thông tin Pin": "3-cell, 52.5Wh", "Hệ điều hành": "Windows 11 Home SL", "Thời điểm ra mắt": "2024", "Kích thước": "Dài 357.9 mm - Rộng 255 mm - Dày 23.5 mm - 2.29 kg", "Chất liệu": "Vỏ nhựa"}}]'::jsonb,
        ARRAY['hp-victus-15-fa2731tx-i5-b85lnpa-1-638833321397404079.jpg', 'hp-victus-15-fa2731tx-i5-b85lnpa-2-638833321390038301.jpg', 'hp-victus-15-fa2731tx-i5-b85lnpa-3-638833321384172635.jpg', 'hp-victus-15-fa2731tx-i5-b85lnpa-4-638833321377557129.jpg', 'hp-victus-15-fa2731tx-i5-b85lnpa-5-638833321370693381.jpg', 'hp-victus-15-fa2731tx-i5-b85lnpa-7-638833321358716668.jpg', 'hp-victus-15-fa2731tx-i5-b85lnpa-8-638833321352065653.jpg', 'hp-victus-15-fa2731tx-i5-b85lnpa-9-638833321345186612.jpg', 'hp-victus-15-fa2731tx-i5-b85lnpa-10-638833321339648513.jpg', 'hp-victus-15-fa2731tx-i5-b85lnpa-11-638833321333157800.jpg', 'hp-victus-15-fa2731tx-i5-b85lnpa-12-638833321327029712.jpg', 'hp-victus-15-fa2731tx-i5-b85lnpa-13-638833321321338350.jpg', 'hp-victus-15-fa2731tx-i5-b85lnpa-14-638833321312801989.jpg', 'hp-victus-15-fa2731tx-i5-b85lnpa-30-638851663102893742.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-victus-15-fa2731tx-i5-b85lnpa/hp-victus-15-fa2731tx-i5-b85lnpa-2-638833321390038301.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-victus-15-fa2731tx-i5-b85lnpa/hp-victus-15-fa2731tx-i5-b85lnpa-3-638833321384172635.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-victus-15-fa2731tx-i5-b85lnpa/hp-victus-15-fa2731tx-i5-b85lnpa-4-638833321377557129.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-victus-15-fa2731tx-i5-b85lnpa/hp-victus-15-fa2731tx-i5-b85lnpa-5-638833321370693381.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-victus-15-fa2731tx-i5-b85lnpa/hp-victus-15-fa2731tx-i5-b85lnpa-7-638833321358716668.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-victus-15-fa2731tx-i5-b85lnpa/hp-victus-15-fa2731tx-i5-b85lnpa-8-638833321352065653.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-victus-15-fa2731tx-i5-b85lnpa/hp-victus-15-fa2731tx-i5-b85lnpa-9-638833321345186612.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-victus-15-fa2731tx-i5-b85lnpa/hp-victus-15-fa2731tx-i5-b85lnpa-10-638833321339648513.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-victus-15-fa2731tx-i5-b85lnpa/hp-victus-15-fa2731tx-i5-b85lnpa-11-638833321333157800.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-victus-15-fa2731tx-i5-b85lnpa/hp-victus-15-fa2731tx-i5-b85lnpa-12-638833321327029712.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-victus-15-fa2731tx-i5-b85lnpa/hp-victus-15-fa2731tx-i5-b85lnpa-13-638833321321338350.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-victus-15-fa2731tx-i5-b85lnpa/hp-victus-15-fa2731tx-i5-b85lnpa-14-638833321312801989.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-victus-15-fa2731tx-i5-b85lnpa/hp-victus-15-fa2731tx-i5-b85lnpa-30-638851663102893742.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/hp-victus-15-fa2731tx-i5-b85lnpa/hp-victus-15-fa2731tx-i5-b85lnpa-1-638833321397404079.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Điện thoại iPhone 16 Pro Max 256GB
-- Slug: iphone-16-pro-max
-- Variants: 8

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Điện thoại iPhone 16 Pro Max 256GB',
        'iphone-16-pro-max',
        4.0,
        2.0,
        'Trong thế giới công nghệ phát triển không ngừng, iPhone 16 Pro Max khẳng định Apple là biểu tượng đổi mới và tiên phong. Với công nghệ tiên tiến, thiết kế tinh tế và hiệu năng mạnh mẽ, thiết bị này trở thành công cụ hỗ trợ đẳng cấp và phụ kiện thời thượng trong cuộc sống.',
        '{"meta_title": "iPhone 16 Pro Max giá tốt, giảm đến 4.2tr, BH 1 năm", "meta_description": "iPhone 16 Pro Max 256GB giá tốt, giảm ngay 4tr, thu cũ trợ giá đến 2tr, bảo hành chính hãng 1 năm, trả chậm 0% lãi suất, hư gì đổi nấy 12 tháng. Mua ngay!", "meta_keywords": "điện thoại iphone 16 pro max, iphone 16 pro max, iphone 16 pro max 256gb"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_16_PRO_MAX_256GB_TITAN_SA_MAC',
        'iphone-16-pro-max-256gb-titan-sa-mac',
        '{"color": "Titan Sa Mạc", "storage": "256GB"}'::jsonb,
        30590000.0,
        33990000.0,
        354,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 18", "Chip xử lý (CPU)": "Apple A18 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 12 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung quang học (OIS)", "Chế độ hành động (Action Mode)", "Chân dung đêm", "Bộ lọc màu", "Ban đêm (Night Mode)", "Photonic Engine"], "Độ phân giải camera trước": "12 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video định dạng Log", "Quay video ProRes", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Live Photos", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chụp ảnh Raw", "Chụp đêm", "Chống rung", "Bộ lọc màu", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "2000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield"}}, {"Pin & Sạc": {"Dung lượng pin": "33 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "20 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ hình ảnh Dolby Vision", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": "Ghi âm mặc định", "Xem phim": ["MP4", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung Titan & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163 mm - Ngang 77.6 mm - Dày 8.25 mm - Nặng 227 g", "Thời điểm ra mắt": "09/2024"}}]'::jsonb,
        ARRAY['iphone-16-pro-max-titan-sa-mac-1-638638962337813406.jpg', 'iphone-16-pro-max-titan-sa-mac-2-638638962343879149.jpg', 'iphone-16-pro-max-titan-sa-mac-3-638638962351331027.jpg', 'iphone-16-pro-max-titan-sa-mac-4-638638962357240755.jpg', 'iphone-16-pro-max-titan-sa-mac-5-638638962363556047.jpg', 'iphone-16-pro-max-titan-sa-mac-6-638638962370086021.jpg', 'iphone-16-pro-max-titan-sa-mac-7-638638962376712626.jpg', 'iphone-16-pro-max-titan-sa-mac-8-638638962382491273.jpg', 'iphone-16-pro-max-titan-sa-mac-9-638638962388943852.jpg', 'iphone-16-pro-max-tem-99-638645211537873999.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-2-638638962343879149.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-3-638638962351331027.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-4-638638962357240755.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-5-638638962363556047.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-6-638638962370086021.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-7-638638962376712626.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-8-638638962382491273.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-9-638638962388943852.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-tem-99-638645211537873999.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-1-638638962337813406.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    -- Insert variant 2
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_16_PRO_MAX_256GB_TITAN_TRANG',
        'iphone-16-pro-max-256gb-titan-trang',
        '{"color": "Titan trắng", "storage": "256GB"}'::jsonb,
        30590000.0,
        33990000.0,
        97,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 18", "Chip xử lý (CPU)": "Apple A18 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 12 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung quang học (OIS)", "Chế độ hành động (Action Mode)", "Chân dung đêm", "Bộ lọc màu", "Ban đêm (Night Mode)", "Photonic Engine"], "Độ phân giải camera trước": "12 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video định dạng Log", "Quay video ProRes", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Live Photos", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chụp ảnh Raw", "Chụp đêm", "Chống rung", "Bộ lọc màu", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "2000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield"}}, {"Pin & Sạc": {"Dung lượng pin": "33 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "20 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ hình ảnh Dolby Vision", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": "Ghi âm mặc định", "Xem phim": ["MP4", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung Titan & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163 mm - Ngang 77.6 mm - Dày 8.25 mm - Nặng 227 g", "Thời điểm ra mắt": "09/2024"}}]'::jsonb,
        ARRAY['iphone-16-pro-max-titan-trang-1-638638963299331292.jpg', 'iphone-16-pro-max-titan-trang-2-638638963307635718.jpg', 'iphone-16-pro-max-titan-trang-3-638638963367144182.jpg', 'iphone-16-pro-max-titan-trang-4-638638963373484383.jpg', 'iphone-16-pro-max-titan-trang-5-638638963379274524.jpg', 'iphone-16-pro-max-titan-trang-6-638638963385550825.jpg', 'iphone-16-pro-max-titan-trang-7-638638963391748561.jpg', 'iphone-16-pro-max-titan-trang-8-638638963398066182.jpg', 'iphone-16-pro-max-titan-trang-9-638638963404417204.jpg', 'iphone-16-pro-max-tem-99-638645212284642486.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-trang-2-638638963307635718.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-trang-3-638638963367144182.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-trang-4-638638963373484383.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-trang-5-638638963379274524.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-trang-6-638638963385550825.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-trang-7-638638963391748561.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-trang-8-638638963398066182.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-trang-9-638638963404417204.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-tem-99-638645212284642486.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-trang-1-638638963299331292.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 3
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_16_PRO_MAX_256GB_TITAN_DEN',
        'iphone-16-pro-max-256gb-titan-den',
        '{"color": "Titan đen", "storage": "256GB"}'::jsonb,
        30590000.0,
        33990000.0,
        71,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 18", "Chip xử lý (CPU)": "Apple A18 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 12 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung quang học (OIS)", "Chế độ hành động (Action Mode)", "Chân dung đêm", "Bộ lọc màu", "Ban đêm (Night Mode)", "Photonic Engine"], "Độ phân giải camera trước": "12 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video định dạng Log", "Quay video ProRes", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Live Photos", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chụp ảnh Raw", "Chụp đêm", "Chống rung", "Bộ lọc màu", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "2000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield"}}, {"Pin & Sạc": {"Dung lượng pin": "33 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "20 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ hình ảnh Dolby Vision", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": "Ghi âm mặc định", "Xem phim": ["MP4", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung Titan & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163 mm - Ngang 77.6 mm - Dày 8.25 mm - Nặng 227 g", "Thời điểm ra mắt": "09/2024"}}]'::jsonb,
        ARRAY['iphone-16-pro-max-titan-den-1-638638962017739954.jpg', 'iphone-16-pro-max-titan-den-2-638638962024629957.jpg', 'iphone-16-pro-max-titan-den-3-638638962030196121.jpg', 'iphone-16-pro-max-titan-den-4-638638962037014080.jpg', 'iphone-16-pro-max-titan-den-5-638638962043284415.jpg', 'iphone-16-pro-max-titan-den-6-638638962050046895.jpg', 'iphone-16-pro-max-titan-den-7-638638962055807974.jpg', 'iphone-16-pro-max-titan-den-8-638638962067473308.jpg', 'iphone-16-pro-max-titan-den-9-638638962074538425.jpg', 'iphone-16-pro-max-tem-99-638645211169359048.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-den-2-638638962024629957.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-den-3-638638962030196121.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-den-4-638638962037014080.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-den-5-638638962043284415.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-den-6-638638962050046895.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-den-7-638638962055807974.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-den-8-638638962067473308.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-den-9-638638962074538425.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-tem-99-638645211169359048.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-den-1-638638962017739954.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 4
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_16_PRO_MAX_256GB_TITAN_TU_NHIEN',
        'iphone-16-pro-max-256gb-titan-tu-nhien',
        '{"color": "Titan tự nhiên", "storage": "256GB"}'::jsonb,
        30590000.0,
        33990000.0,
        633,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 18", "Chip xử lý (CPU)": "Apple A18 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 12 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung quang học (OIS)", "Chế độ hành động (Action Mode)", "Chân dung đêm", "Bộ lọc màu", "Ban đêm (Night Mode)", "Photonic Engine"], "Độ phân giải camera trước": "12 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video định dạng Log", "Quay video ProRes", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Live Photos", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chụp ảnh Raw", "Chụp đêm", "Chống rung", "Bộ lọc màu", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "2000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield"}}, {"Pin & Sạc": {"Dung lượng pin": "33 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "20 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ hình ảnh Dolby Vision", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": "Ghi âm mặc định", "Xem phim": ["MP4", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung Titan & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163 mm - Ngang 77.6 mm - Dày 8.25 mm - Nặng 227 g", "Thời điểm ra mắt": "09/2024"}}]'::jsonb,
        ARRAY['iphone-16-pro-max-titan-tu-nhien-1-638638962808089301.jpg', 'iphone-16-pro-max-titan-tu-nhien-2-638638962819617092.jpg', 'iphone-16-pro-max-titan-tu-nhien-3-638638962826053903.jpg', 'iphone-16-pro-max-titan-tu-nhien-4-638638962832419545.jpg', 'iphone-16-pro-max-titan-tu-nhien-5-638638962838372819.jpg', 'iphone-16-pro-max-titan-tu-nhien-6-638638962844181367.jpg', 'iphone-16-pro-max-titan-tu-nhien-7-638638962850375580.jpg', 'iphone-16-pro-max-titan-tu-nhien-8-638638962856849059.jpg', 'iphone-16-pro-max-titan-tu-nhien-9-638638962863337185.jpg', 'iphone-16-pro-max-tem-99-638645211894245488.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-tu-nhien-2-638638962819617092.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-tu-nhien-3-638638962826053903.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-tu-nhien-4-638638962832419545.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-tu-nhien-5-638638962838372819.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-tu-nhien-6-638638962844181367.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-tu-nhien-7-638638962850375580.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-tu-nhien-8-638638962856849059.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-tu-nhien-9-638638962863337185.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-tem-99-638645211894245488.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-tu-nhien-1-638638962808089301.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 5
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_16_PRO_MAX_512GB_TITAN_SA_MAC',
        'iphone-16-pro-max-512gb-titan-sa-mac',
        '{"color": "Titan Sa Mạc", "storage": "512GB"}'::jsonb,
        36990000.0,
        39990000.0,
        328,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 18", "Chip xử lý (CPU)": "Apple A18 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "8 GB", "Dung lượng lưu trữ": "512 GB", "Dung lượng còn lại (khả dụng) khoảng": "497 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 12 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung quang học (OIS)", "Chế độ hành động (Action Mode)", "Chân dung đêm", "Bộ lọc màu", "Ban đêm (Night Mode)", "Photonic Engine"], "Độ phân giải camera trước": "12 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video định dạng Log", "Quay video ProRes", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Live Photos", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chụp ảnh Raw", "Chụp đêm", "Chống rung", "Bộ lọc màu", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "2000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield"}}, {"Pin & Sạc": {"Dung lượng pin": "33 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "20 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ hình ảnh Dolby Vision", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": "Ghi âm mặc định", "Xem phim": ["MP4", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung Titan & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163 mm - Ngang 77.6 mm - Dày 8.25 mm - Nặng 227 g", "Thời điểm ra mắt": "09/2024"}}]'::jsonb,
        ARRAY['iphone-16-pro-max-titan-sa-mac-1-638638962257326324.jpg', 'iphone-16-pro-max-titan-sa-mac-2-638638962263478577.jpg', 'iphone-16-pro-max-titan-sa-mac-3-638638962269719762.jpg', 'iphone-16-pro-max-titan-sa-mac-4-638638962276068934.jpg', 'iphone-16-pro-max-titan-sa-mac-5-638638962281768666.jpg', 'iphone-16-pro-max-titan-sa-mac-6-638638962288978578.jpg', 'iphone-16-pro-max-titan-sa-mac-7-638638962296156885.jpg', 'iphone-16-pro-max-titan-sa-mac-8-638638962302755319.jpg', 'iphone-16-pro-max-titan-sa-mac-9-638638962308646630.jpg', 'iphone-16-pro-max-tem-99-638645211415065962.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-2-638638962263478577.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-3-638638962269719762.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-4-638638962276068934.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-5-638638962281768666.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-6-638638962288978578.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-7-638638962296156885.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-8-638638962302755319.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-9-638638962308646630.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-tem-99-638645211415065962.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-1-638638962257326324.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 6
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_16_PRO_MAX_512GB_TITAN_TRANG',
        'iphone-16-pro-max-512gb-titan-trang',
        '{"color": "Titan trắng", "storage": "512GB"}'::jsonb,
        36990000.0,
        39990000.0,
        83,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 18", "Chip xử lý (CPU)": "Apple A18 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "8 GB", "Dung lượng lưu trữ": "512 GB", "Dung lượng còn lại (khả dụng) khoảng": "497 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 12 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung quang học (OIS)", "Chế độ hành động (Action Mode)", "Chân dung đêm", "Bộ lọc màu", "Ban đêm (Night Mode)", "Photonic Engine"], "Độ phân giải camera trước": "12 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video định dạng Log", "Quay video ProRes", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Live Photos", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chụp ảnh Raw", "Chụp đêm", "Chống rung", "Bộ lọc màu", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "2000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield"}}, {"Pin & Sạc": {"Dung lượng pin": "33 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "20 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ hình ảnh Dolby Vision", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": "Ghi âm mặc định", "Xem phim": ["MP4", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung Titan & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163 mm - Ngang 77.6 mm - Dày 8.25 mm - Nặng 227 g", "Thời điểm ra mắt": "09/2024"}}]'::jsonb,
        ARRAY['iphone-16-pro-max-titan-sa-mac-1-638638962257326324.jpg', 'iphone-16-pro-max-titan-sa-mac-2-638638962263478577.jpg', 'iphone-16-pro-max-titan-sa-mac-3-638638962269719762.jpg', 'iphone-16-pro-max-titan-sa-mac-4-638638962276068934.jpg', 'iphone-16-pro-max-titan-sa-mac-5-638638962281768666.jpg', 'iphone-16-pro-max-titan-sa-mac-6-638638962288978578.jpg', 'iphone-16-pro-max-titan-sa-mac-7-638638962296156885.jpg', 'iphone-16-pro-max-titan-sa-mac-8-638638962302755319.jpg', 'iphone-16-pro-max-titan-sa-mac-9-638638962308646630.jpg', 'iphone-16-pro-max-tem-99-638645211415065962.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-2-638638962263478577.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-3-638638962269719762.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-4-638638962276068934.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-5-638638962281768666.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-6-638638962288978578.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-7-638638962296156885.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-8-638638962302755319.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-9-638638962308646630.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-tem-99-638645211415065962.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-1-638638962257326324.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 7
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_16_PRO_MAX_512GB_TITAN_DEN',
        'iphone-16-pro-max-512gb-titan-den',
        '{"color": "Titan đen", "storage": "512GB"}'::jsonb,
        36990000.0,
        39990000.0,
        668,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 18", "Chip xử lý (CPU)": "Apple A18 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "8 GB", "Dung lượng lưu trữ": "512 GB", "Dung lượng còn lại (khả dụng) khoảng": "497 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 12 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung quang học (OIS)", "Chế độ hành động (Action Mode)", "Chân dung đêm", "Bộ lọc màu", "Ban đêm (Night Mode)", "Photonic Engine"], "Độ phân giải camera trước": "12 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video định dạng Log", "Quay video ProRes", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Live Photos", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chụp ảnh Raw", "Chụp đêm", "Chống rung", "Bộ lọc màu", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "2000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield"}}, {"Pin & Sạc": {"Dung lượng pin": "33 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "20 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ hình ảnh Dolby Vision", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": "Ghi âm mặc định", "Xem phim": ["MP4", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung Titan & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163 mm - Ngang 77.6 mm - Dày 8.25 mm - Nặng 227 g", "Thời điểm ra mắt": "09/2024"}}]'::jsonb,
        ARRAY['iphone-16-pro-max-titan-sa-mac-1-638638962257326324.jpg', 'iphone-16-pro-max-titan-sa-mac-2-638638962263478577.jpg', 'iphone-16-pro-max-titan-sa-mac-3-638638962269719762.jpg', 'iphone-16-pro-max-titan-sa-mac-4-638638962276068934.jpg', 'iphone-16-pro-max-titan-sa-mac-5-638638962281768666.jpg', 'iphone-16-pro-max-titan-sa-mac-6-638638962288978578.jpg', 'iphone-16-pro-max-titan-sa-mac-7-638638962296156885.jpg', 'iphone-16-pro-max-titan-sa-mac-8-638638962302755319.jpg', 'iphone-16-pro-max-titan-sa-mac-9-638638962308646630.jpg', 'iphone-16-pro-max-tem-99-638645211415065962.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-2-638638962263478577.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-3-638638962269719762.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-4-638638962276068934.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-5-638638962281768666.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-6-638638962288978578.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-7-638638962296156885.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-8-638638962302755319.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-9-638638962308646630.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-tem-99-638645211415065962.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-1-638638962257326324.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 8
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_16_PRO_MAX_512GB_TITAN_TU_NHIEN',
        'iphone-16-pro-max-512gb-titan-tu-nhien',
        '{"color": "Titan tự nhiên", "storage": "512GB"}'::jsonb,
        36990000.0,
        39990000.0,
        876,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 18", "Chip xử lý (CPU)": "Apple A18 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "8 GB", "Dung lượng lưu trữ": "512 GB", "Dung lượng còn lại (khả dụng) khoảng": "497 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 12 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung quang học (OIS)", "Chế độ hành động (Action Mode)", "Chân dung đêm", "Bộ lọc màu", "Ban đêm (Night Mode)", "Photonic Engine"], "Độ phân giải camera trước": "12 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video định dạng Log", "Quay video ProRes", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Live Photos", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chụp ảnh Raw", "Chụp đêm", "Chống rung", "Bộ lọc màu", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "2000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield"}}, {"Pin & Sạc": {"Dung lượng pin": "33 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "20 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ hình ảnh Dolby Vision", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": "Ghi âm mặc định", "Xem phim": ["MP4", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung Titan & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163 mm - Ngang 77.6 mm - Dày 8.25 mm - Nặng 227 g", "Thời điểm ra mắt": "09/2024"}}]'::jsonb,
        ARRAY['iphone-16-pro-max-titan-sa-mac-1-638638962257326324.jpg', 'iphone-16-pro-max-titan-sa-mac-2-638638962263478577.jpg', 'iphone-16-pro-max-titan-sa-mac-3-638638962269719762.jpg', 'iphone-16-pro-max-titan-sa-mac-4-638638962276068934.jpg', 'iphone-16-pro-max-titan-sa-mac-5-638638962281768666.jpg', 'iphone-16-pro-max-titan-sa-mac-6-638638962288978578.jpg', 'iphone-16-pro-max-titan-sa-mac-7-638638962296156885.jpg', 'iphone-16-pro-max-titan-sa-mac-8-638638962302755319.jpg', 'iphone-16-pro-max-titan-sa-mac-9-638638962308646630.jpg', 'iphone-16-pro-max-tem-99-638645211415065962.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-2-638638962263478577.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-3-638638962269719762.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-4-638638962276068934.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-5-638638962281768666.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-6-638638962288978578.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-7-638638962296156885.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-8-638638962302755319.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-9-638638962308646630.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-tem-99-638645211415065962.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-16-pro-max/iphone-16-pro-max-titan-sa-mac-1-638638962257326324.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Điện thoại iPhone 17 Pro Max 256GB
-- Slug: iphone-17-pro-max
-- Variants: 12

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Điện thoại iPhone 17 Pro Max 256GB',
        'iphone-17-pro-max',
        4.0,
        2.0,
        'iPhone 17 Pro Max là phiên bản cao cấp nhất trong dòng sản phẩm iPhone 17 series, được định vị là thiết bị tập trung vào công nghệ màn hình, hiệu năng xử lý và khả năng nhiếp ảnh. Phiên bản này giới thiệu một loạt nâng cấp về phần cứng và các tính năng đi kèm, hướng đến việc cung cấp một công cụ có cấu hình mạnh mẽ cho các nhu cầu sử dụng từ cơ bản đến chuyên sâu.',
        '{"meta_title": "Giá iPhone 17 Pro Max 256GB giảm đến 5tr khi thanh toán qua Kredivo", "meta_description": "iPhone 17 Pro Max (256GB, 512GB, 1TB, 2TB) giá tốt, có màu cam vũ trụ, xanh đậm, thu cũ giảm đến 3tr, giảm đến 5tr khi thanh toán qua Kredivo, trả chậm 0%. Mua ngay!", "meta_keywords": "iphone 17 pro max, iphone 17 pro max 2025, giá iphone 17 pro max, apple iphone 17 pro max, iphone 17 pro max 256gb"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_17_PRO_MAX_256GB_CAM_VU_TRU',
        'iphone-17-pro-max-256gb-cam-vu-tru',
        '{"color": "Cam Vũ Trụ", "storage": "256GB"}'::jsonb,
        37990000.0,
        NULL,
        617,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 26", "Chip xử lý (CPU)": "Apple A19 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "12 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 48 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Điều chỉnh khẩu độ", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video hiển thị kép", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý (Geotagging)", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung điện tử kỹ thuật số (EIS)", "Chống rung quang học (OIS)", "Ban đêm (Night Mode)", "Chế độ hành động (Action Mode)", "Photonic Engine"], "Độ phân giải camera trước": "18 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Video hiển thị kép", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Live Photos", "Deep Fusion", "Chụp ảnh Raw", "Chụp đêm", "Chống rung điện tử kỹ thuật số (EIS)", "Cinematic", "TrueDepth", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "3000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield 2"}}, {"Pin & Sạc": {"Dung lượng pin": "37 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "40 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Xoá vật thể AI", "Viết AI", "Trung tâm màn hình (Center Stage)", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "Khoanh tròn để tìm kiếm", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ True Tone", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AV1", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v6.0", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung nhôm nguyên khối & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163.4 mm - Ngang 78 mm - Dày 8.75 mm - Nặng 231 g", "Thời điểm ra mắt": "09/2025"}}]'::jsonb,
        ARRAY['iphone-17-pro-max-cam-1-638947383255964450.jpg', 'iphone-17-pro-max-cam-2-638947383212278277.jpg', 'iphone-17-pro-max-cam-3-638947383204771318.jpg', 'iphone-17-pro-max-cam-4-638947383197941667.jpg', 'iphone-17-pro-max-cam-5-638947383188256961.jpg', 'iphone-17-pro-max-cam-6-638947383176512375.jpg', 'iphone-17-pro-max-cam-7-638947383167025902.jpg', 'iphone-17-pro-max-cam-8-638947383157615674.jpg', 'iphone-17-pro-max-cam-9-638947383148725067.jpg', 'iphone-17-pro-max-cam-10-638947383249145014.jpg', 'iphone-17-pro-max-cam-11-638947383239982836.jpg', 'iphone-17-pro-max-cam-12-638947383232300582.jpg', 'iphone-17-pro-max-cam-13-638947383223664403.jpg', 'iphone-17-pro-max-tem-99-638947384407284478.jpg', 'iphone-17-pro-max-bbh-638947387866886959.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-2-638947383212278277.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-3-638947383204771318.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-4-638947383197941667.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-5-638947383188256961.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-6-638947383176512375.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-7-638947383167025902.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-8-638947383157615674.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-9-638947383148725067.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-10-638947383249145014.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-11-638947383239982836.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-12-638947383232300582.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-13-638947383223664403.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-tem-99-638947384407284478.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bbh-638947387866886959.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-1-638947383255964450.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    -- Insert variant 2
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_17_PRO_MAX_256GB_XANH_DAM',
        'iphone-17-pro-max-256gb-xanh-dam',
        '{"color": "Xanh đậm", "storage": "256GB"}'::jsonb,
        37990000.0,
        NULL,
        374,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 26", "Chip xử lý (CPU)": "Apple A19 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "12 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 48 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Điều chỉnh khẩu độ", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video hiển thị kép", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý (Geotagging)", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung điện tử kỹ thuật số (EIS)", "Chống rung quang học (OIS)", "Ban đêm (Night Mode)", "Chế độ hành động (Action Mode)", "Photonic Engine"], "Độ phân giải camera trước": "18 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Video hiển thị kép", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Live Photos", "Deep Fusion", "Chụp ảnh Raw", "Chụp đêm", "Chống rung điện tử kỹ thuật số (EIS)", "Cinematic", "TrueDepth", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "3000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield 2"}}, {"Pin & Sạc": {"Dung lượng pin": "37 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "40 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Xoá vật thể AI", "Viết AI", "Trung tâm màn hình (Center Stage)", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "Khoanh tròn để tìm kiếm", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ True Tone", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AV1", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v6.0", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung nhôm nguyên khối & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163.4 mm - Ngang 78 mm - Dày 8.75 mm - Nặng 231 g", "Thời điểm ra mắt": "09/2025"}}]'::jsonb,
        ARRAY['iphone-17-pro-max-xanh-1-638930821961455986.jpg', 'iphone-17-pro-max-xanh-2-638930821911831487.jpg', 'iphone-17-pro-max-xanh-3-638930821919278950.jpg', 'iphone-17-pro-max-xanh-4-638930821925723080.jpg', 'iphone-17-pro-max-xanh-5-638930821932174939.jpg', 'iphone-17-pro-max-xanh-6-638930821937708029.jpg', 'iphone-17-pro-max-xanh-7-638930821944136581.jpg', 'iphone-17-pro-max-xanh-8-638930821949332032.jpg', 'iphone-17-pro-max-xanh-9-638930821955481414.jpg', 'iphone-17-pro-max-15-638937139110894102.jpg', 'iphone-17-pro-max-tem-99-638947385068576233.jpg', 'iphone-17-pro-max-bbh-638947387866886959.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-xanh-2-638930821911831487.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-xanh-3-638930821919278950.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-xanh-4-638930821925723080.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-xanh-5-638930821932174939.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-xanh-6-638930821937708029.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-xanh-7-638930821944136581.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-xanh-8-638930821949332032.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-xanh-9-638930821955481414.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-15-638937139110894102.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-tem-99-638947385068576233.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bbh-638947387866886959.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-xanh-1-638930821961455986.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 3
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_17_PRO_MAX_256GB_BAC',
        'iphone-17-pro-max-256gb-bac',
        '{"color": "Bạc", "storage": "256GB"}'::jsonb,
        37990000.0,
        NULL,
        806,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 26", "Chip xử lý (CPU)": "Apple A19 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "12 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 48 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Điều chỉnh khẩu độ", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video hiển thị kép", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý (Geotagging)", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung điện tử kỹ thuật số (EIS)", "Chống rung quang học (OIS)", "Ban đêm (Night Mode)", "Chế độ hành động (Action Mode)", "Photonic Engine"], "Độ phân giải camera trước": "18 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Video hiển thị kép", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Live Photos", "Deep Fusion", "Chụp ảnh Raw", "Chụp đêm", "Chống rung điện tử kỹ thuật số (EIS)", "Cinematic", "TrueDepth", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "3000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield 2"}}, {"Pin & Sạc": {"Dung lượng pin": "37 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "40 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Xoá vật thể AI", "Viết AI", "Trung tâm màn hình (Center Stage)", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "Khoanh tròn để tìm kiếm", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ True Tone", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AV1", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v6.0", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung nhôm nguyên khối & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163.4 mm - Ngang 78 mm - Dày 8.75 mm - Nặng 231 g", "Thời điểm ra mắt": "09/2025"}}]'::jsonb,
        ARRAY['iphone-17-pro-max-bac-1-638930822443089519.jpg', 'iphone-17-pro-max-bac-2-638930822450486494.jpg', 'iphone-17-pro-max-bac-3-638930822456314589.jpg', 'iphone-17-pro-max-bac-4-638930822462552076.jpg', 'iphone-17-pro-max-bac-5-638930822469801896.jpg', 'iphone-17-pro-max-bac-6-638930822475721760.jpg', 'iphone-17-pro-max-bac-7-638930822481196185.jpg', 'iphone-17-pro-max-bac-8-638930822487112864.jpg', 'iphone-17-pro-max-bac-9-638930822492311786.jpg', 'iphone-17-pro-max-15-638937146743087891.jpg', 'iphone-17-pro-max-tem-99-638947383971618012.jpg', 'iphone-17-pro-max-bbh-638947387866886959.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bac-2-638930822450486494.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bac-3-638930822456314589.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bac-4-638930822462552076.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bac-5-638930822469801896.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bac-6-638930822475721760.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bac-7-638930822481196185.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bac-8-638930822487112864.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bac-9-638930822492311786.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-15-638937146743087891.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-tem-99-638947383971618012.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bbh-638947387866886959.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bac-1-638930822443089519.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 4
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_17_PRO_MAX_512GB_CAM_VU_TRU',
        'iphone-17-pro-max-512gb-cam-vu-tru',
        '{"color": "Cam Vũ Trụ", "storage": "512GB"}'::jsonb,
        44490000.0,
        NULL,
        18,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 26", "Chip xử lý (CPU)": "Apple A19 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "12 GB", "Dung lượng lưu trữ": "512 GB", "Dung lượng còn lại (khả dụng) khoảng": "497 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 48 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Điều chỉnh khẩu độ", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video hiển thị kép", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý (Geotagging)", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung điện tử kỹ thuật số (EIS)", "Chống rung quang học (OIS)", "Ban đêm (Night Mode)", "Chế độ hành động (Action Mode)", "Photonic Engine"], "Độ phân giải camera trước": "18 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Video hiển thị kép", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Live Photos", "Deep Fusion", "Chụp ảnh Raw", "Chụp đêm", "Chống rung điện tử kỹ thuật số (EIS)", "Cinematic", "TrueDepth", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "3000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield 2"}}, {"Pin & Sạc": {"Dung lượng pin": "37 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "40 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Xoá vật thể AI", "Viết AI", "Trung tâm màn hình (Center Stage)", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "Khoanh tròn để tìm kiếm", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ True Tone", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AV1", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v6.0", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung nhôm nguyên khối & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163.4 mm - Ngang 78 mm - Dày 8.75 mm - Nặng 231 g", "Thời điểm ra mắt": "09/2025"}}]'::jsonb,
        ARRAY['iphone-17-pro-max-cam-1-638947382913247361.jpg', 'iphone-17-pro-max-cam-2-638947382875162260.jpg', 'iphone-17-pro-max-cam-3-638947382867927851.jpg', 'iphone-17-pro-max-cam-4-638947382860454890.jpg', 'iphone-17-pro-max-cam-5-638947382853520922.jpg', 'iphone-17-pro-max-cam-6-638947382842888934.jpg', 'iphone-17-pro-max-cam-7-638947382836423757.jpg', 'iphone-17-pro-max-cam-8-638947382829347730.jpg', 'iphone-17-pro-max-cam-9-638947382822116501.jpg', 'iphone-17-pro-max-cam-10-638947382905599282.jpg', 'iphone-17-pro-max-cam-11-638947382897325354.jpg', 'iphone-17-pro-max-cam-12-638947382889666234.jpg', 'iphone-17-pro-max-cam-13-638947382882891600.jpg', 'iphone-17-pro-max-tem-99-638947383383934229.jpg', 'iphone-17-pro-max-bbh-638947387727679131.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-2-638947382875162260.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-3-638947382867927851.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-4-638947382860454890.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-5-638947382853520922.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-6-638947382842888934.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-7-638947382836423757.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-8-638947382829347730.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-9-638947382822116501.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-10-638947382905599282.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-11-638947382897325354.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-12-638947382889666234.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-13-638947382882891600.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-tem-99-638947383383934229.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bbh-638947387727679131.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-1-638947382913247361.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 5
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_17_PRO_MAX_512GB_XANH_DAM',
        'iphone-17-pro-max-512gb-xanh-dam',
        '{"color": "Xanh đậm", "storage": "512GB"}'::jsonb,
        44490000.0,
        NULL,
        98,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 26", "Chip xử lý (CPU)": "Apple A19 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "12 GB", "Dung lượng lưu trữ": "512 GB", "Dung lượng còn lại (khả dụng) khoảng": "497 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 48 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Điều chỉnh khẩu độ", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video hiển thị kép", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý (Geotagging)", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung điện tử kỹ thuật số (EIS)", "Chống rung quang học (OIS)", "Ban đêm (Night Mode)", "Chế độ hành động (Action Mode)", "Photonic Engine"], "Độ phân giải camera trước": "18 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Video hiển thị kép", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Live Photos", "Deep Fusion", "Chụp ảnh Raw", "Chụp đêm", "Chống rung điện tử kỹ thuật số (EIS)", "Cinematic", "TrueDepth", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "3000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield 2"}}, {"Pin & Sạc": {"Dung lượng pin": "37 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "40 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Xoá vật thể AI", "Viết AI", "Trung tâm màn hình (Center Stage)", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "Khoanh tròn để tìm kiếm", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ True Tone", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AV1", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v6.0", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung nhôm nguyên khối & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163.4 mm - Ngang 78 mm - Dày 8.75 mm - Nặng 231 g", "Thời điểm ra mắt": "09/2025"}}]'::jsonb,
        ARRAY['iphone-17-pro-max-cam-1-638947382913247361.jpg', 'iphone-17-pro-max-cam-2-638947382875162260.jpg', 'iphone-17-pro-max-cam-3-638947382867927851.jpg', 'iphone-17-pro-max-cam-4-638947382860454890.jpg', 'iphone-17-pro-max-cam-5-638947382853520922.jpg', 'iphone-17-pro-max-cam-6-638947382842888934.jpg', 'iphone-17-pro-max-cam-7-638947382836423757.jpg', 'iphone-17-pro-max-cam-8-638947382829347730.jpg', 'iphone-17-pro-max-cam-9-638947382822116501.jpg', 'iphone-17-pro-max-cam-10-638947382905599282.jpg', 'iphone-17-pro-max-cam-11-638947382897325354.jpg', 'iphone-17-pro-max-cam-12-638947382889666234.jpg', 'iphone-17-pro-max-cam-13-638947382882891600.jpg', 'iphone-17-pro-max-tem-99-638947383383934229.jpg', 'iphone-17-pro-max-bbh-638947387727679131.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-2-638947382875162260.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-3-638947382867927851.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-4-638947382860454890.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-5-638947382853520922.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-6-638947382842888934.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-7-638947382836423757.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-8-638947382829347730.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-9-638947382822116501.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-10-638947382905599282.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-11-638947382897325354.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-12-638947382889666234.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-13-638947382882891600.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-tem-99-638947383383934229.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bbh-638947387727679131.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-1-638947382913247361.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 6
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_17_PRO_MAX_512GB_BAC',
        'iphone-17-pro-max-512gb-bac',
        '{"color": "Bạc", "storage": "512GB"}'::jsonb,
        44490000.0,
        NULL,
        809,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 26", "Chip xử lý (CPU)": "Apple A19 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "12 GB", "Dung lượng lưu trữ": "512 GB", "Dung lượng còn lại (khả dụng) khoảng": "497 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 48 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Điều chỉnh khẩu độ", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video hiển thị kép", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý (Geotagging)", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung điện tử kỹ thuật số (EIS)", "Chống rung quang học (OIS)", "Ban đêm (Night Mode)", "Chế độ hành động (Action Mode)", "Photonic Engine"], "Độ phân giải camera trước": "18 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Video hiển thị kép", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Live Photos", "Deep Fusion", "Chụp ảnh Raw", "Chụp đêm", "Chống rung điện tử kỹ thuật số (EIS)", "Cinematic", "TrueDepth", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "3000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield 2"}}, {"Pin & Sạc": {"Dung lượng pin": "37 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "40 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Xoá vật thể AI", "Viết AI", "Trung tâm màn hình (Center Stage)", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "Khoanh tròn để tìm kiếm", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ True Tone", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AV1", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v6.0", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung nhôm nguyên khối & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163.4 mm - Ngang 78 mm - Dày 8.75 mm - Nặng 231 g", "Thời điểm ra mắt": "09/2025"}}]'::jsonb,
        ARRAY['iphone-17-pro-max-cam-1-638947382913247361.jpg', 'iphone-17-pro-max-cam-2-638947382875162260.jpg', 'iphone-17-pro-max-cam-3-638947382867927851.jpg', 'iphone-17-pro-max-cam-4-638947382860454890.jpg', 'iphone-17-pro-max-cam-5-638947382853520922.jpg', 'iphone-17-pro-max-cam-6-638947382842888934.jpg', 'iphone-17-pro-max-cam-7-638947382836423757.jpg', 'iphone-17-pro-max-cam-8-638947382829347730.jpg', 'iphone-17-pro-max-cam-9-638947382822116501.jpg', 'iphone-17-pro-max-cam-10-638947382905599282.jpg', 'iphone-17-pro-max-cam-11-638947382897325354.jpg', 'iphone-17-pro-max-cam-12-638947382889666234.jpg', 'iphone-17-pro-max-cam-13-638947382882891600.jpg', 'iphone-17-pro-max-tem-99-638947383383934229.jpg', 'iphone-17-pro-max-bbh-638947387727679131.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-2-638947382875162260.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-3-638947382867927851.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-4-638947382860454890.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-5-638947382853520922.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-6-638947382842888934.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-7-638947382836423757.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-8-638947382829347730.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-9-638947382822116501.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-10-638947382905599282.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-11-638947382897325354.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-12-638947382889666234.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-13-638947382882891600.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-tem-99-638947383383934229.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bbh-638947387727679131.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-1-638947382913247361.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 7
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_17_PRO_MAX_1TB_CAM_VU_TRU',
        'iphone-17-pro-max-1tb-cam-vu-tru',
        '{"color": "Cam Vũ Trụ", "storage": "1TB"}'::jsonb,
        50990000.0,
        NULL,
        326,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 26", "Chip xử lý (CPU)": "Apple A19 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "12 GB", "Dung lượng lưu trữ": "1 TB", "Dung lượng còn lại (khả dụng) khoảng": "1009 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 48 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Điều chỉnh khẩu độ", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video hiển thị kép", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý (Geotagging)", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung điện tử kỹ thuật số (EIS)", "Chống rung quang học (OIS)", "Ban đêm (Night Mode)", "Chế độ hành động (Action Mode)", "Photonic Engine"], "Độ phân giải camera trước": "18 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Video hiển thị kép", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Live Photos", "Deep Fusion", "Chụp ảnh Raw", "Chụp đêm", "Chống rung điện tử kỹ thuật số (EIS)", "Cinematic", "TrueDepth", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "3000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield 2"}}, {"Pin & Sạc": {"Dung lượng pin": "37 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "40 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Xoá vật thể AI", "Viết AI", "Trung tâm màn hình (Center Stage)", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "Khoanh tròn để tìm kiếm", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ True Tone", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AV1", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v6.0", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung nhôm nguyên khối & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163.4 mm - Ngang 78 mm - Dày 8.75 mm - Nặng 231 g", "Thời điểm ra mắt": "09/2025"}}]'::jsonb,
        ARRAY['iphone-17-pro-max-1tb-xanh-1-638930828343544558.jpg', 'iphone-17-pro-max-1tb-xanh-2-638930828357366804.jpg', 'iphone-17-pro-max-1tb-xanh-3-638930828365902662.jpg', 'iphone-17-pro-max-1tb-xanh-4-638930828371820820.jpg', 'iphone-17-pro-max-1tb-xanh-5-638930828378246286.jpg', 'iphone-17-pro-max-1tb-xanh-6-638930828384370197.jpg', 'iphone-17-pro-max-1tb-xanh-7-638930828389560515.jpg', 'iphone-17-pro-max-1tb-xanh-8-638930828395432834.jpg', 'iphone-17-pro-max-1tb-xanh-9-638930828401111666.jpg', 'iphone-17-pro-max-15-638937138905949320.jpg', 'iphone-17-pro-max-tem-99-638947384924725825.jpg', 'iphone-17-pro-max-bbh-638947387803947494.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-2-638930828357366804.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-3-638930828365902662.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-4-638930828371820820.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-5-638930828378246286.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-6-638930828384370197.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-7-638930828389560515.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-8-638930828395432834.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-9-638930828401111666.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-15-638937138905949320.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-tem-99-638947384924725825.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bbh-638947387803947494.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-1-638930828343544558.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 8
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_17_PRO_MAX_1TB_XANH_DAM',
        'iphone-17-pro-max-1tb-xanh-dam',
        '{"color": "Xanh đậm", "storage": "1TB"}'::jsonb,
        50990000.0,
        NULL,
        193,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 26", "Chip xử lý (CPU)": "Apple A19 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "12 GB", "Dung lượng lưu trữ": "1 TB", "Dung lượng còn lại (khả dụng) khoảng": "1009 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 48 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Điều chỉnh khẩu độ", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video hiển thị kép", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý (Geotagging)", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung điện tử kỹ thuật số (EIS)", "Chống rung quang học (OIS)", "Ban đêm (Night Mode)", "Chế độ hành động (Action Mode)", "Photonic Engine"], "Độ phân giải camera trước": "18 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Video hiển thị kép", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Live Photos", "Deep Fusion", "Chụp ảnh Raw", "Chụp đêm", "Chống rung điện tử kỹ thuật số (EIS)", "Cinematic", "TrueDepth", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "3000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield 2"}}, {"Pin & Sạc": {"Dung lượng pin": "37 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "40 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Xoá vật thể AI", "Viết AI", "Trung tâm màn hình (Center Stage)", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "Khoanh tròn để tìm kiếm", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ True Tone", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AV1", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v6.0", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung nhôm nguyên khối & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163.4 mm - Ngang 78 mm - Dày 8.75 mm - Nặng 231 g", "Thời điểm ra mắt": "09/2025"}}]'::jsonb,
        ARRAY['iphone-17-pro-max-1tb-xanh-1-638930828343544558.jpg', 'iphone-17-pro-max-1tb-xanh-2-638930828357366804.jpg', 'iphone-17-pro-max-1tb-xanh-3-638930828365902662.jpg', 'iphone-17-pro-max-1tb-xanh-4-638930828371820820.jpg', 'iphone-17-pro-max-1tb-xanh-5-638930828378246286.jpg', 'iphone-17-pro-max-1tb-xanh-6-638930828384370197.jpg', 'iphone-17-pro-max-1tb-xanh-7-638930828389560515.jpg', 'iphone-17-pro-max-1tb-xanh-8-638930828395432834.jpg', 'iphone-17-pro-max-1tb-xanh-9-638930828401111666.jpg', 'iphone-17-pro-max-15-638937138905949320.jpg', 'iphone-17-pro-max-tem-99-638947384924725825.jpg', 'iphone-17-pro-max-bbh-638947387803947494.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-2-638930828357366804.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-3-638930828365902662.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-4-638930828371820820.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-5-638930828378246286.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-6-638930828384370197.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-7-638930828389560515.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-8-638930828395432834.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-9-638930828401111666.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-15-638937138905949320.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-tem-99-638947384924725825.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bbh-638947387803947494.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-1-638930828343544558.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 9
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_17_PRO_MAX_1TB_BAC',
        'iphone-17-pro-max-1tb-bac',
        '{"color": "Bạc", "storage": "1TB"}'::jsonb,
        50990000.0,
        NULL,
        213,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 26", "Chip xử lý (CPU)": "Apple A19 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "12 GB", "Dung lượng lưu trữ": "1 TB", "Dung lượng còn lại (khả dụng) khoảng": "1009 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 48 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Điều chỉnh khẩu độ", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video hiển thị kép", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý (Geotagging)", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung điện tử kỹ thuật số (EIS)", "Chống rung quang học (OIS)", "Ban đêm (Night Mode)", "Chế độ hành động (Action Mode)", "Photonic Engine"], "Độ phân giải camera trước": "18 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Video hiển thị kép", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Live Photos", "Deep Fusion", "Chụp ảnh Raw", "Chụp đêm", "Chống rung điện tử kỹ thuật số (EIS)", "Cinematic", "TrueDepth", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "3000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield 2"}}, {"Pin & Sạc": {"Dung lượng pin": "37 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "40 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Xoá vật thể AI", "Viết AI", "Trung tâm màn hình (Center Stage)", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "Khoanh tròn để tìm kiếm", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ True Tone", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AV1", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v6.0", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung nhôm nguyên khối & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163.4 mm - Ngang 78 mm - Dày 8.75 mm - Nặng 231 g", "Thời điểm ra mắt": "09/2025"}}]'::jsonb,
        ARRAY['iphone-17-pro-max-1tb-xanh-1-638930828343544558.jpg', 'iphone-17-pro-max-1tb-xanh-2-638930828357366804.jpg', 'iphone-17-pro-max-1tb-xanh-3-638930828365902662.jpg', 'iphone-17-pro-max-1tb-xanh-4-638930828371820820.jpg', 'iphone-17-pro-max-1tb-xanh-5-638930828378246286.jpg', 'iphone-17-pro-max-1tb-xanh-6-638930828384370197.jpg', 'iphone-17-pro-max-1tb-xanh-7-638930828389560515.jpg', 'iphone-17-pro-max-1tb-xanh-8-638930828395432834.jpg', 'iphone-17-pro-max-1tb-xanh-9-638930828401111666.jpg', 'iphone-17-pro-max-15-638937138905949320.jpg', 'iphone-17-pro-max-tem-99-638947384924725825.jpg', 'iphone-17-pro-max-bbh-638947387803947494.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-2-638930828357366804.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-3-638930828365902662.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-4-638930828371820820.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-5-638930828378246286.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-6-638930828384370197.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-7-638930828389560515.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-8-638930828395432834.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-9-638930828401111666.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-15-638937138905949320.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-tem-99-638947384924725825.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bbh-638947387803947494.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-1tb-xanh-1-638930828343544558.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 10
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_17_PRO_MAX_2TB_CAM_VU_TRU',
        'iphone-17-pro-max-2tb-cam-vu-tru',
        '{"color": "Cam Vũ Trụ", "storage": "2TB"}'::jsonb,
        63990000.0,
        NULL,
        46,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 26", "Chip xử lý (CPU)": "Apple A19 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "12 GB", "Dung lượng lưu trữ": "2 TB", "Dung lượng còn lại (khả dụng) khoảng": "2009 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 48 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Điều chỉnh khẩu độ", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video hiển thị kép", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý (Geotagging)", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung điện tử kỹ thuật số (EIS)", "Chống rung quang học (OIS)", "Ban đêm (Night Mode)", "Chế độ hành động (Action Mode)", "Photonic Engine"], "Độ phân giải camera trước": "18 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Video hiển thị kép", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Live Photos", "Deep Fusion", "Chụp ảnh Raw", "Chụp đêm", "Chống rung điện tử kỹ thuật số (EIS)", "Cinematic", "TrueDepth", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "3000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield 2"}}, {"Pin & Sạc": {"Dung lượng pin": "37 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "40 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Xoá vật thể AI", "Viết AI", "Trung tâm màn hình (Center Stage)", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "Khoanh tròn để tìm kiếm", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ True Tone", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AV1", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v6.0", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung nhôm nguyên khối & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163.4 mm - Ngang 78 mm - Dày 8.75 mm - Nặng 231 g", "Thời điểm ra mắt": "09/2025"}}]'::jsonb,
        ARRAY['iphone-17-pro-max-cam-1-638947383136752800.jpg', 'iphone-17-pro-max-cam-2-638947383088583118.jpg', 'iphone-17-pro-max-cam-3-638947383078418562.jpg', 'iphone-17-pro-max-cam-4-638947383069327019.jpg', 'iphone-17-pro-max-cam-5-638947383061783965.jpg', 'iphone-17-pro-max-cam-6-638947383053435334.jpg', 'iphone-17-pro-max-cam-7-638947383044946916.jpg', 'iphone-17-pro-max-cam-8-638947383036185085.jpg', 'iphone-17-pro-max-cam-9-638947383027841812.jpg', 'iphone-17-pro-max-cam-10-638947383121729647.jpg', 'iphone-17-pro-max-cam-11-638947383113324563.jpg', 'iphone-17-pro-max-cam-12-638947383104156378.jpg', 'iphone-17-pro-max-cam-13-638947383096345536.jpg', 'iphone-17-pro-max-tem-99-638947383511245183.jpg', 'iphone-17-pro-max-bbh-638947387653624725.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-2-638947383088583118.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-3-638947383078418562.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-4-638947383069327019.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-5-638947383061783965.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-6-638947383053435334.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-7-638947383044946916.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-8-638947383036185085.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-9-638947383027841812.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-10-638947383121729647.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-11-638947383113324563.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-12-638947383104156378.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-13-638947383096345536.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-tem-99-638947383511245183.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bbh-638947387653624725.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-1-638947383136752800.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 11
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_17_PRO_MAX_2TB_XANH_DAM',
        'iphone-17-pro-max-2tb-xanh-dam',
        '{"color": "Xanh đậm", "storage": "2TB"}'::jsonb,
        63990000.0,
        NULL,
        444,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 26", "Chip xử lý (CPU)": "Apple A19 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "12 GB", "Dung lượng lưu trữ": "2 TB", "Dung lượng còn lại (khả dụng) khoảng": "2009 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 48 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Điều chỉnh khẩu độ", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video hiển thị kép", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý (Geotagging)", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung điện tử kỹ thuật số (EIS)", "Chống rung quang học (OIS)", "Ban đêm (Night Mode)", "Chế độ hành động (Action Mode)", "Photonic Engine"], "Độ phân giải camera trước": "18 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Video hiển thị kép", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Live Photos", "Deep Fusion", "Chụp ảnh Raw", "Chụp đêm", "Chống rung điện tử kỹ thuật số (EIS)", "Cinematic", "TrueDepth", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "3000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield 2"}}, {"Pin & Sạc": {"Dung lượng pin": "37 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "40 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Xoá vật thể AI", "Viết AI", "Trung tâm màn hình (Center Stage)", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "Khoanh tròn để tìm kiếm", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ True Tone", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AV1", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v6.0", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung nhôm nguyên khối & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163.4 mm - Ngang 78 mm - Dày 8.75 mm - Nặng 231 g", "Thời điểm ra mắt": "09/2025"}}]'::jsonb,
        ARRAY['iphone-17-pro-max-cam-1-638947383136752800.jpg', 'iphone-17-pro-max-cam-2-638947383088583118.jpg', 'iphone-17-pro-max-cam-3-638947383078418562.jpg', 'iphone-17-pro-max-cam-4-638947383069327019.jpg', 'iphone-17-pro-max-cam-5-638947383061783965.jpg', 'iphone-17-pro-max-cam-6-638947383053435334.jpg', 'iphone-17-pro-max-cam-7-638947383044946916.jpg', 'iphone-17-pro-max-cam-8-638947383036185085.jpg', 'iphone-17-pro-max-cam-9-638947383027841812.jpg', 'iphone-17-pro-max-cam-10-638947383121729647.jpg', 'iphone-17-pro-max-cam-11-638947383113324563.jpg', 'iphone-17-pro-max-cam-12-638947383104156378.jpg', 'iphone-17-pro-max-cam-13-638947383096345536.jpg', 'iphone-17-pro-max-tem-99-638947383511245183.jpg', 'iphone-17-pro-max-bbh-638947387653624725.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-2-638947383088583118.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-3-638947383078418562.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-4-638947383069327019.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-5-638947383061783965.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-6-638947383053435334.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-7-638947383044946916.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-8-638947383036185085.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-9-638947383027841812.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-10-638947383121729647.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-11-638947383113324563.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-12-638947383104156378.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-13-638947383096345536.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-tem-99-638947383511245183.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bbh-638947387653624725.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-1-638947383136752800.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 12
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'IPHONE_17_PRO_MAX_2TB_BAC',
        'iphone-17-pro-max-2tb-bac',
        '{"color": "Bạc", "storage": "2TB"}'::jsonb,
        63990000.0,
        NULL,
        919,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "iOS 26", "Chip xử lý (CPU)": "Apple A19 Pro 6 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ họa (GPU)": "Apple GPU 6 nhân", "RAM": "12 GB", "Dung lượng lưu trữ": "2 TB", "Dung lượng còn lại (khả dụng) khoảng": "2009 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 48 MP & Phụ 48 MP, 48 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@25fps", "4K 2160p@24fps", "4K 2160p@120fps", "4K 2160p@100fps", "2.8K 60fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Điều khiển camera (Camera Control)", "Điều chỉnh khẩu độ", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Smart HDR 5", "Siêu độ phân giải", "Siêu cận (Macro)", "Quay video định dạng Log", "Quay video hiển thị kép", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý (Geotagging)", "Góc siêu rộng (Ultrawide)", "Dolby Vision HDR", "Deep Fusion", "Cinematic", "Chụp ảnh liên tục", "Chống rung điện tử kỹ thuật số (EIS)", "Chống rung quang học (OIS)", "Ban đêm (Night Mode)", "Chế độ hành động (Action Mode)", "Photonic Engine"], "Độ phân giải camera trước": "18 MP", "Tính năng camera trước": ["Smart HDR 5", "Xóa phông", "Video hiển thị kép", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Retina Flash", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Live Photos", "Deep Fusion", "Chụp ảnh Raw", "Chụp đêm", "Chống rung điện tử kỹ thuật số (EIS)", "Cinematic", "TrueDepth", "Photonic Engine"], "Công nghệ màn hình": "OLED", "Độ phân giải màn hình": "Super Retina XDR (1320 x 2868 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "3000 nits", "Mặt kính cảm ứng": "Kính cường lực Ceramic Shield 2"}}, {"Pin & Sạc": {"Dung lượng pin": "37 giờ", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "40 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp", "Sạc không dây MagSafe", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt Face ID", "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Xoá vật thể AI", "Viết AI", "Trung tâm màn hình (Center Stage)", "Phát hiện va chạm (Crash Detection)", "Màn hình luôn hiển thị AOD", "Khoanh tròn để tìm kiếm", "HDR10+", "HDR10", "DCI-P3", "Công nghệ âm thanh Dolby Digital Plus", "Công nghệ True Tone", "Công nghệ HLG", "Công nghê âm thanh Dolby Digital", "Chạm 2 lần sáng màn hình", "Apple Pay", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AV1", "HEVC"], "Nghe nhạc": ["MP3", "FLAC", "Apple Lossless", "APAC", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "1 Nano SIM & 1 eSIM", "Wifi": "Wi-Fi MIMO", "GPS": ["iBeacon", "QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v6.0", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung nhôm nguyên khối & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 163.4 mm - Ngang 78 mm - Dày 8.75 mm - Nặng 231 g", "Thời điểm ra mắt": "09/2025"}}]'::jsonb,
        ARRAY['iphone-17-pro-max-cam-1-638947383136752800.jpg', 'iphone-17-pro-max-cam-2-638947383088583118.jpg', 'iphone-17-pro-max-cam-3-638947383078418562.jpg', 'iphone-17-pro-max-cam-4-638947383069327019.jpg', 'iphone-17-pro-max-cam-5-638947383061783965.jpg', 'iphone-17-pro-max-cam-6-638947383053435334.jpg', 'iphone-17-pro-max-cam-7-638947383044946916.jpg', 'iphone-17-pro-max-cam-8-638947383036185085.jpg', 'iphone-17-pro-max-cam-9-638947383027841812.jpg', 'iphone-17-pro-max-cam-10-638947383121729647.jpg', 'iphone-17-pro-max-cam-11-638947383113324563.jpg', 'iphone-17-pro-max-cam-12-638947383104156378.jpg', 'iphone-17-pro-max-cam-13-638947383096345536.jpg', 'iphone-17-pro-max-tem-99-638947383511245183.jpg', 'iphone-17-pro-max-bbh-638947387653624725.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-2-638947383088583118.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-3-638947383078418562.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-4-638947383069327019.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-5-638947383061783965.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-6-638947383053435334.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-7-638947383044946916.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-8-638947383036185085.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-9-638947383027841812.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-10-638947383121729647.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-11-638947383113324563.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-12-638947383104156378.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-13-638947383096345536.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-tem-99-638947383511245183.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-bbh-638947387653624725.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/iphone-17-pro-max/iphone-17-pro-max-cam-1-638947383136752800.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Laptop Lenovo Ideapad Slim 3 15AMN8 - 82XQ00J0VN (R5 7520U, 16GB, 512GB, Full HD, Win11)
-- Slug: lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn
-- Variants: 1

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Laptop Lenovo Ideapad Slim 3 15AMN8 - 82XQ00J0VN (R5 7520U, 16GB, 512GB, Full HD, Win11)',
        'lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn',
        5.0,
        1.0,
        'Trong thị trường laptop học tập - văn phòng , chiếc laptop Lenovo Ideapad Slim 3 15AMN8 R5 7520U (82XQ00J0VN) nhanh chóng thu hút sự chú ý của người dùng bởi nhiều ưu điểm nổi bật. Chiếc laptop này hội tụ đầy đủ các yếu tố để trở thành người bạn đồng hành lý tưởng cho học sinh, sinh viên và nhân viên văn phòng, đáp ứng mọi nhu cầu học tập, làm việc và giải trí một cách hiệu quả.',
        '{"meta_title": "Laptop Lenovo Ideapad Slim 3 15AMN8 R5 7520U (82XQ00J0VN) - Chính hãng, mua trả chậm", "meta_description": "Laptop Lenovo Ideapad Slim 3 15AMN8 R5 7520U (82XQ00J0VN) giá rẻ, mua trả chậm - Mua online, xét duyệt nhanh, giao hàng tận nơi trong 1 giờ, cà thẻ tại nhà. Bảo hành toàn quốc. Xem ngay!", "meta_keywords": "Lenovo Ideapad Slim 3 15AMN8 R5 7520U/16GB/512GB/Win11 (82XQ00J0VN), Lenovo Ideapad Slim 3 15AMN8 R5 7520U (82XQ00J0VN), Lenovo Ideapad Slim 3 15AMN8 R5 7520U (82XQ00J0VN), Laptop Lenovo Ideapad Slim 3 15AMN8 R5 7520U/16GB/512GB/Win11 (82XQ00J0VN), giá Lenovo Ideapad Slim 3 15AMN8 R5 7520U/16GB/512GB/Win11 (82XQ00J0VN), thông tin Lenovo Ideapad Slim 3 15AMN8 R5 7520U/16GB/512GB/Win11 (82XQ00J0VN)"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'LENOVO_IDEAPAD_SLIM_3_15AMN8_R5_82XQ00J0VN_DEFAULT',
        'lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-default',
        NULL,
        12990000.0,
        14390000.0,
        513,
        '[{"Bộ xử lý": {"Công nghệ CPU": "AMD Ryzen 5- 7520U", "Số nhân": "4", "Số luồng": "8", "Tốc độ CPU": "2.80 GHz (Lên đến 4.30 GHz khi tải nặng)"}}, {"Đồ hoạ (GPU)": {"Card màn hình": "Card tích hợp- AMD Radeon 610M Graphics"}}, {"Bộ nhớ RAM, Ổ cứng": {"RAM": "16 GB", "Loại RAM": "LPDDR5 (Onboard)", "Tốc độ Bus RAM": "5500 MHz", "Hỗ trợ RAM tối đa": "Không hỗ trợ nâng cấp", "Ổ cứng": "512 GB SSD NVMe M.2 PCIe Gen 4.0"}}, {"Màn hình": {"Kích thước màn hình": "15.6 inch", "Độ phân giải": "Full HD (1920 x 1080)", "Tấm nền": "IPS", "Tần số quét": "60Hz", "Công nghệ màn hình": ["Chống chói Anti Glare", "300 nits"]}}, {"Cổng kết nối & tính năng mở rộng": {"Cổng giao tiếp": ["Jack tai nghe 3.5 mm", "2 x USB 3.2", "HDMI", "1x USB-C 3.2 (hỗ trợ truyền dữ liệu, Power Delivery và DisplayPort 1.2)"], "Kết nối không dây": ["Bluetooth 5.2", "Wi-Fi 6 (802.11ax)"], "Khe đọc thẻ nhớ": "SD", "Webcam": "HD webcam", "Đèn bàn phím": "Không có đèn", "Bảo mật": ["TPM 2.0", "Công tắc khoá camera", "Bảo mật vân tay"], "Công nghệ âm thanh": "Dolby Audio", "Tản nhiệt": "Hãng không công bố", "Tính năng khác": ["Độ bền chuẩn quân đội MIL STD 810H", "Bản lề mở 180 độ"]}}, {"Kích thước - Khối lượng - Pin": {"Thông tin Pin": "47 Wh", "Hệ điều hành": "Windows 11 Home SL", "Thời điểm ra mắt": "2024", "Kích thước": "Dài 359.3 mm - Rộng 235 mm - Dày 17.9 mm - 1.62 kg", "Chất liệu": "Vỏ nhựa"}}]'::jsonb,
        ARRAY['lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-1.jpg', 'lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-2.jpg', 'lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-3.jpg', 'lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-4.jpg', 'lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-5.jpg', 'lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-6.jpg', 'lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-7.jpg', 'lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-9.jpg', 'lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-11.jpg', 'lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-12.jpg', 'lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-13.jpg', 'lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-14.jpg', 'lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-15.jpg', 'lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-30-638651062855809394.jpg', 'lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-bbh-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-4.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-5.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-6.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-7.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-9.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-11.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-12.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-13.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-14.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-15.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-30-638651062855809394.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-bbh-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn/lenovo-ideapad-slim-3-15amn8-r5-82xq00j0vn-1.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Laptop Lenovo Gaming LOQ 15IRX9 - 83DV00PSVN (i5 13450HX, 24GB, 512GB, RTX 3050 6GB, Full HD 144Hz, Win11)
-- Slug: lenovo-loq-15irx9-i5-83dv00psvn
-- Variants: 1

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Laptop Lenovo Gaming LOQ 15IRX9 - 83DV00PSVN (i5 13450HX, 24GB, 512GB, RTX 3050 6GB, Full HD 144Hz, Win11)',
        'lenovo-loq-15irx9-i5-83dv00psvn',
        5.0,
        1.0,
        'Laptop Lenovo LOQ 15IRX9 i5 13450HX (83DV00PSVN) là một chiếc laptop gaming mạnh mẽ, hướng đến các nhà thiết kế đồ họa, dựng video và kỹ sư. Với hiệu năng vượt trội, màn hình sắc nét và thiết kế bền bỉ, chiếc laptop đồ họa này sẽ là một công cụ đắc lực, giúp bạn chinh phục mọi thử thách trong công việc và giải trí.',
        '{"meta_title": "Laptop Lenovo LOQ 15IRX9 i5 13450HX (83DV00PSVN) - Chính hãng, giá tốt", "meta_description": "Laptop Lenovo LOQ 15IRX9 i5 13450HX (83DV00PSVN) giá rẻ, trả góp 0% lãi suất - Mua online, xét duyệt nhanh, giao hàng tận nơi trong 1 giờ, cà thẻ tại nhà. Bảo hành toàn quốc. Xem ngay!", "meta_keywords": "Lenovo LOQ 15IRX9 i5 13450HX/24GB/512GB/6GB RTX3050/144Hz/Win11 (83DV00PSVN), Lenovo LOQ 15IRX9 i5 13450HX (83DV00PSVN), Lenovo LOQ 15IRX9 i5 13450HX (83DV00PSVN), Laptop Lenovo LOQ 15IRX9 i5 13450HX/24GB/512GB/6GB RTX3050/144Hz/Win11 (83DV00PSVN), giá Lenovo LOQ 15IRX9 i5 13450HX/24GB/512GB/6GB RTX3050/144Hz/Win11 (83DV00PSVN), thông tin Lenovo LOQ 15IRX9 i5 13450HX/24GB/512GB/6GB RTX3050/144Hz/Win11 (83DV00PSVN)"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'LENOVO_LOQ_15IRX9_I5_83DV00PSVN_DEFAULT',
        'lenovo-loq-15irx9-i5-83dv00psvn-default',
        NULL,
        24990000.0,
        26990000.0,
        556,
        '[{"Bộ xử lý": {"Công nghệ CPU": "Intel Core i5 Raptor Lake - 13450HX", "Số nhân": "10", "Số luồng": "16", "Tốc độ CPU": "2.40 GHz (Lên đến 4.60 GHz khi tải nặng)"}}, {"Đồ hoạ (GPU)": {"Card màn hình": "Card rời- NVIDIA GeForce RTX 3050, 6 GB", "Số nhân GPU": "2040 CUDA Cores", "Công suất đồ hoạ - TGP": "95 W", "Hiệu năng xử lý AI (TOPS)": "Lên đến 142 TOPS"}}, {"Bộ nhớ RAM, Ổ cứng": {"RAM": "24 GB", "Loại RAM": "DDR5 (1 khe 12 GB + 1 khe 12 GB)", "Tốc độ Bus RAM": "4800 MHz", "Hỗ trợ RAM tối đa": "32 GB", "Ổ cứng": "512 GB SSD NVMe PCIe 4.0 (Có thể tháo ra, lắp thanh khác tối đa 1 TB)"}}, {"Màn hình": {"Kích thước màn hình": "15.6 inch", "Độ phân giải": "Full HD (1920 x 1080)", "Tần số quét": "144Hz", "Độ phủ màu": "100% sRGB", "Công nghệ màn hình": ["Low Blue Light", "G-Sync", "Chống chói Anti Glare"]}}, {"Cổng kết nối & tính năng mở rộng": {"Cổng giao tiếp": ["Jack tai nghe 3.5 mm", "3 x USB 3.2", "HDMI", "1 x USB-C 3.2 (hỗ trợ truyền dữ liệu, Power Delivery 140W và DisplayPort 1.4)", "LAN (RJ45)"], "Kết nối không dây": ["Bluetooth 5.2", "Wi-Fi 6 (802.11ax)"], "Webcam": "HD webcam", "Đèn bàn phím": "Đơn sắc - Màu trắng", "Bảo mật": ["TPM 2.0", "Công tắc khoá camera"], "Công nghệ âm thanh": "Nahimic Audio", "Tản nhiệt": "Hãng không công bố", "Tính năng khác": ["AI Chip LA1", "Độ bền chuẩn quân đội MIL STD 810H", "Bản lề mở 180 độ"]}}, {"Kích thước - Khối lượng - Pin": {"Thông tin Pin": "60 Wh", "Hệ điều hành": "Windows 11 Home SL", "Thời điểm ra mắt": "2024", "Kích thước": "Dài 359.86 mm - Rộng 258.7 mm - Dày 23.9 mm - 2.38 kg", "Chất liệu": "Vỏ nhựa"}}]'::jsonb,
        ARRAY['lenovo-loq-15irx9-i5-83dv00psvn-new-1-638839541392554081.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-new-2-638839541441235587.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-new-3-638839541435101175.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-new-4-638839541428670863.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-new-5-638839541381020508.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-new-6-638839541386683101.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-new-7-638839541422654379.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-new-8-638839541416378824.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-new-9-638839541410295627.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-new-10-638839541339247528.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-new-11-638839541404278951.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-new-12-638839541375438312.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-new-13-638839541398403189.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-new-14-638839541355729553.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-new-15-638839541346103647.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-new-16-638839541368705040.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-new-17-638839541362437008.jpg', 'lenovo-loq-15irx9-i5-83dv00psvn-bbh-638839541926880400.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-2-638839541441235587.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-3-638839541435101175.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-4-638839541428670863.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-5-638839541381020508.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-6-638839541386683101.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-7-638839541422654379.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-8-638839541416378824.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-9-638839541410295627.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-10-638839541339247528.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-11-638839541404278951.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-12-638839541375438312.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-13-638839541398403189.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-14-638839541355729553.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-15-638839541346103647.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-16-638839541368705040.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-17-638839541362437008.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-bbh-638839541926880400.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-loq-15irx9-i5-83dv00psvn/lenovo-loq-15irx9-i5-83dv00psvn-new-1-638839541392554081.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Laptop MacBook Air 13 inch M4 16GB/256GB
-- Slug: macbook-air-13-inch-m4-16gb-256gb
-- Variants: 4

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Laptop MacBook Air 13 inch M4 16GB/256GB',
        'macbook-air-13-inch-m4-16gb-256gb',
        6.0,
        1.0,
        'Không làm người dùng thất vọng, Apple đã cho ra mắt MacBook Air M4 16GB không chỉ là một chiếc laptop đồ họa siêu mỏng nhẹ mà còn mang đến hiệu suất mạnh mẽ với chip Apple M4 và RAM 16 GB, cùng màn hình Liquid Retina rực rỡ và thời lượng pin ấn tượng. Sản phẩm này là sự lựa chọn hoàn hảo cho mọi nhu cầu, phù hợp cho cả người dùng văn phòng, sinh viên, đặc biệt là nhà sáng tạo nội dung, thiết kế đồ hoạ.',
        '{"meta_title": "MacBook Air M4 13 inch 16GB/256GB giá tốt, chỉ từ 26.990tr", "meta_description": "MacBook Air M4 13 inch 16GB 256GB mới với chip M4 mạnh mẽ, chính hãng Apple, giá tốt, góp 0%, trả trước 0đ, 1 đổi 1 nếu lỗi, bảo hành 1 năm, giao nhanh. Mua ngay!", "meta_keywords": "MacBook Air 13 inch M4 16GB/256GB, MacBook Air 13 inch M4 16GB/256GB, MacBook Air 13 inch M4 16GB/256GB, Laptop MacBook Air 13 inch M4 16GB/256GB, giá MacBook Air 13 inch M4 16GB/256GB, thông tin MacBook Air 13 inch M4 16GB/256GB"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'MACBOOK_AIR_13_INCH_M4_16GB_256GB_XANH_DEN',
        'macbook-air-13-inch-m4-16gb-256gb-xanh-den',
        '{"color": "Xanh đen"}'::jsonb,
        1490000.0,
        NULL,
        508,
        '[{"Bộ xử lý": {"Công nghệ CPU": "Apple M4 - Hãng không công bố", "Số nhân": "10", "Số luồng": "Hãng không công bố", "Tốc độ CPU": "120 GB/s memory bandwidth"}}, {"Đồ hoạ (GPU)": {"Card màn hình": "Card tích hợp- 8 nhân GPU", "Số nhân GPU": "Hãng không công bố"}}, {"Bộ nhớ RAM, Ổ cứng": {"RAM": "16 GB", "Loại RAM": "Hãng không công bố", "Tốc độ Bus RAM": "Hãng không công bố", "Hỗ trợ RAM tối đa": "Không hỗ trợ nâng cấp", "Ổ cứng": "256 GB SSD"}}, {"Màn hình": {"Kích thước màn hình": "13.6 inch", "Độ phân giải": "Liquid Retina (2560 x 1664)", "Tấm nền": "IPS", "Tần số quét": "Hãng không công bố", "Công nghệ màn hình": ["Wide color (P3)", "500 nits brightness", "True Tone Technology", "1 tỷ màu"]}}, {"Cổng kết nối & tính năng mở rộng": {"Cổng giao tiếp": ["Jack tai nghe 3.5 mm", "MagSafe 3", "2 x  Thunderbolt 4.0 (hỗ trợ USB 4, USB Type-C, DisplayPort và Power Delivery)"], "Kết nối không dây": "Wi-Fi 6E (802.11ax)", "Webcam": "1080p FaceTime HD camera", "Đèn bàn phím": "Đơn sắc - Màu trắng", "Bảo mật": "Bảo mật vân tay", "Công nghệ âm thanh": ["3 microphones", "4 Loa", "Dolby Atmos"], "Tản nhiệt": "Hãng không công bố"}}, {"Kích thước - Khối lượng - Pin": {"Thông tin Pin": "Li-Po, 53.8 Wh", "Hệ điều hành": "macOS Sequoia", "Thời điểm ra mắt": "03/2025", "Kích thước": "Dài 304.1 mm - Rộng 215 mm - Dày 11.3 mm - 1.24 kg", "Chất liệu": "Vỏ nhôm tái chế 100%"}}]'::jsonb,
        ARRAY['macbook-air-13-inch-m4-16gb-256gb-tgdd-1-638768909105991664.jpg', 'macbook-air-13-inch-m4-16gb-256gb-tgdd-2-638768909112234928.jpg', 'macbook-air-13-inch-m4-16gb-256gb-tgdd-3-638768909124025605.jpg', 'macbook-air-13-inch-m4-16gb-256gb-tgdd-4-638768909132256608.jpg', 'macbook-air-13-inch-m4-16gb-256gb-tgdd-5-638768909140280124.jpg', 'macbook-air-13-inch-m4-16gb-256gb-tgdd-6-638768909146359381.jpg', 'macbook-air-13-inch-m4-16gb-256gb-tgdd-7-638768909152855442.jpg', 'macbook-air-13-inch-m4-16gb-256gb-tgdd-8-638768909159598909.jpg', 'macbook-air-13-inch-m4-16gb-256gb-tgdd-9-638768909168065944.jpg', 'macbook-air-13-inch-m4-16gb-256gb-tgdd-10-638768909176618410.jpg', 'macbook-air-13-inch-m4-16gb-256gb-11-638768909184266635.jpg', 'tem-mac-30-638823968600942373.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-16gb-256gb-tgdd-2-638768909112234928.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-16gb-256gb-tgdd-3-638768909124025605.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-16gb-256gb-tgdd-4-638768909132256608.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-16gb-256gb-tgdd-5-638768909140280124.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-16gb-256gb-tgdd-6-638768909146359381.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-16gb-256gb-tgdd-7-638768909152855442.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-16gb-256gb-tgdd-8-638768909159598909.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-16gb-256gb-tgdd-9-638768909168065944.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-16gb-256gb-tgdd-10-638768909176618410.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-16gb-256gb-11-638768909184266635.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/tem-mac-30-638823968600942373.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-16gb-256gb-tgdd-1-638768909105991664.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    -- Insert variant 2
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'MACBOOK_AIR_13_INCH_M4_16GB_256GB_VANG',
        'macbook-air-13-inch-m4-16gb-256gb-vang',
        '{"color": "Vàng"}'::jsonb,
        25290000.0,
        26490000.0,
        996,
        '[{"Bộ xử lý": {"Công nghệ CPU": "Apple M4 - Hãng không công bố", "Số nhân": "10", "Số luồng": "Hãng không công bố", "Tốc độ CPU": "120 GB/s memory bandwidth"}}, {"Đồ hoạ (GPU)": {"Card màn hình": "Card tích hợp- 8 nhân GPU", "Số nhân GPU": "Hãng không công bố"}}, {"Bộ nhớ RAM, Ổ cứng": {"RAM": "16 GB", "Loại RAM": "Hãng không công bố", "Tốc độ Bus RAM": "Hãng không công bố", "Hỗ trợ RAM tối đa": "Không hỗ trợ nâng cấp", "Ổ cứng": "256 GB SSD"}}, {"Màn hình": {"Kích thước màn hình": "13.6 inch", "Độ phân giải": "Liquid Retina (2560 x 1664)", "Tấm nền": "IPS", "Tần số quét": "Hãng không công bố", "Công nghệ màn hình": ["Wide color (P3)", "500 nits brightness", "True Tone Technology", "1 tỷ màu"]}}, {"Cổng kết nối & tính năng mở rộng": {"Cổng giao tiếp": ["Jack tai nghe 3.5 mm", "MagSafe 3", "2 x  Thunderbolt 4.0 (hỗ trợ USB 4, USB Type-C, DisplayPort và Power Delivery)"], "Kết nối không dây": "Wi-Fi 6E (802.11ax)", "Webcam": "1080p FaceTime HD camera", "Đèn bàn phím": "Đơn sắc - Màu trắng", "Bảo mật": "Bảo mật vân tay", "Công nghệ âm thanh": ["3 microphones", "4 Loa", "Dolby Atmos"], "Tản nhiệt": "Hãng không công bố"}}, {"Kích thước - Khối lượng - Pin": {"Thông tin Pin": "Li-Po, 53.8 Wh", "Hệ điều hành": "macOS Sequoia", "Thời điểm ra mắt": "03/2025", "Kích thước": "Dài 304.1 mm - Rộng 215 mm - Dày 11.3 mm - 1.24 kg", "Chất liệu": "Vỏ nhôm tái chế 100%"}}]'::jsonb,
        ARRAY['macbook-air-13-inch-m4-11-638769622719537641.jpg', 'macbook-air-13-inch-m4-12-638769622725138147.jpg', 'macbook-air-13-inch-m4-13-638769622730551585.jpg', 'macbook-air-13-inch-m4-14-638769622736438266.jpg', 'macbook-air-13-inch-m4-15-638769622741773706.jpg', 'macbook-air-13-inch-m4-16-638769622747666534.jpg', 'macbook-air-13-inch-m4-17-638769622756641158.jpg', 'macbook-air-13-inch-m4-18-638769622761645257.jpg', 'macbook-air-13-inch-m4-19-638769622767462393.jpg', 'macbook-air-13-inch-m4-20-638769622779909467.jpg', 'macbook-air-13-inch-m4-21-638769622773554586.jpg', 'tem-mac-30-638823967345206406.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-12-638769622725138147.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-13-638769622730551585.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-14-638769622736438266.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-15-638769622741773706.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-16-638769622747666534.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-17-638769622756641158.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-18-638769622761645257.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-19-638769622767462393.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-20-638769622779909467.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-21-638769622773554586.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/tem-mac-30-638823967345206406.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-11-638769622719537641.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 3
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'MACBOOK_AIR_13_INCH_M4_16GB_256GB_XANH_DA_TROI_NHAT',
        'macbook-air-13-inch-m4-16gb-256gb-xanh-da-troi-nhat',
        '{"color": "Xanh da trời nhạt"}'::jsonb,
        25290000.0,
        26490000.0,
        824,
        '[{"Bộ xử lý": {"Công nghệ CPU": "Apple M4 - Hãng không công bố", "Số nhân": "10", "Số luồng": "Hãng không công bố", "Tốc độ CPU": "120 GB/s memory bandwidth"}}, {"Đồ hoạ (GPU)": {"Card màn hình": "Card tích hợp- 8 nhân GPU", "Số nhân GPU": "Hãng không công bố"}}, {"Bộ nhớ RAM, Ổ cứng": {"RAM": "16 GB", "Loại RAM": "Hãng không công bố", "Tốc độ Bus RAM": "Hãng không công bố", "Hỗ trợ RAM tối đa": "Không hỗ trợ nâng cấp", "Ổ cứng": "256 GB SSD"}}, {"Màn hình": {"Kích thước màn hình": "13.6 inch", "Độ phân giải": "Liquid Retina (2560 x 1664)", "Tấm nền": "IPS", "Tần số quét": "Hãng không công bố", "Công nghệ màn hình": ["Wide color (P3)", "500 nits brightness", "True Tone Technology", "1 tỷ màu"]}}, {"Cổng kết nối & tính năng mở rộng": {"Cổng giao tiếp": ["Jack tai nghe 3.5 mm", "MagSafe 3", "2 x  Thunderbolt 4.0 (hỗ trợ USB 4, USB Type-C, DisplayPort và Power Delivery)"], "Kết nối không dây": "Wi-Fi 6E (802.11ax)", "Webcam": "1080p FaceTime HD camera", "Đèn bàn phím": "Đơn sắc - Màu trắng", "Bảo mật": "Bảo mật vân tay", "Công nghệ âm thanh": ["3 microphones", "4 Loa", "Dolby Atmos"], "Tản nhiệt": "Hãng không công bố"}}, {"Kích thước - Khối lượng - Pin": {"Thông tin Pin": "Li-Po, 53.8 Wh", "Hệ điều hành": "macOS Sequoia", "Thời điểm ra mắt": "03/2025", "Kích thước": "Dài 304.1 mm - Rộng 215 mm - Dày 11.3 mm - 1.24 kg", "Chất liệu": "Vỏ nhôm tái chế 100%"}}]'::jsonb,
        ARRAY['macbook-air-13-inch-m4-1-638769628427937821.jpg', 'macbook-air-13-inch-m4-2-638769628433757713.jpg', 'macbook-air-13-inch-m4-3-638769628444232798.jpg', 'macbook-air-13-inch-m4-4-638769628450203040.jpg', 'macbook-air-13-inch-m4-5-638769628455675261.jpg', 'macbook-air-13-inch-m4-6-638769628462432431.jpg', 'macbook-air-13-inch-m4-7-638769628468243979.jpg', 'macbook-air-13-inch-m4-8-638769628475685617.jpg', 'macbook-air-13-inch-m4-9-638769628480941661.jpg', 'macbook-air-13-inch-m4-10-638769628486648767.jpg', 'macbook-air-13-inch-m4-11-638769628494869363.jpg', 'tem-mac-30-638823966537659408.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-2-638769628433757713.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-3-638769628444232798.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-4-638769628450203040.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-5-638769628455675261.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-6-638769628462432431.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-7-638769628468243979.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-8-638769628475685617.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-9-638769628480941661.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-10-638769628486648767.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-11-638769628494869363.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/tem-mac-30-638823966537659408.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-1-638769628427937821.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 4
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'MACBOOK_AIR_13_INCH_M4_16GB_256GB_BAC',
        'macbook-air-13-inch-m4-16gb-256gb-bac',
        '{"color": "Bạc"}'::jsonb,
        25290000.0,
        26490000.0,
        34,
        '[{"Bộ xử lý": {"Công nghệ CPU": "Apple M4 - Hãng không công bố", "Số nhân": "10", "Số luồng": "Hãng không công bố", "Tốc độ CPU": "120 GB/s memory bandwidth"}}, {"Đồ hoạ (GPU)": {"Card màn hình": "Card tích hợp- 8 nhân GPU", "Số nhân GPU": "Hãng không công bố"}}, {"Bộ nhớ RAM, Ổ cứng": {"RAM": "16 GB", "Loại RAM": "Hãng không công bố", "Tốc độ Bus RAM": "Hãng không công bố", "Hỗ trợ RAM tối đa": "Không hỗ trợ nâng cấp", "Ổ cứng": "256 GB SSD"}}, {"Màn hình": {"Kích thước màn hình": "13.6 inch", "Độ phân giải": "Liquid Retina (2560 x 1664)", "Tấm nền": "IPS", "Tần số quét": "Hãng không công bố", "Công nghệ màn hình": ["Wide color (P3)", "500 nits brightness", "True Tone Technology", "1 tỷ màu"]}}, {"Cổng kết nối & tính năng mở rộng": {"Cổng giao tiếp": ["Jack tai nghe 3.5 mm", "MagSafe 3", "2 x  Thunderbolt 4.0 (hỗ trợ USB 4, USB Type-C, DisplayPort và Power Delivery)"], "Kết nối không dây": "Wi-Fi 6E (802.11ax)", "Webcam": "1080p FaceTime HD camera", "Đèn bàn phím": "Đơn sắc - Màu trắng", "Bảo mật": "Bảo mật vân tay", "Công nghệ âm thanh": ["3 microphones", "4 Loa", "Dolby Atmos"], "Tản nhiệt": "Hãng không công bố"}}, {"Kích thước - Khối lượng - Pin": {"Thông tin Pin": "Li-Po, 53.8 Wh", "Hệ điều hành": "macOS Sequoia", "Thời điểm ra mắt": "03/2025", "Kích thước": "Dài 304.1 mm - Rộng 215 mm - Dày 11.3 mm - 1.24 kg", "Chất liệu": "Vỏ nhôm tái chế 100%"}}]'::jsonb,
        ARRAY['macbook-air-13-inch-m4-1-638769626682783095.jpg', 'macbook-air-13-inch-m4-2-638769626688234958.jpg', 'macbook-air-13-inch-m4-3-638769626694872835.jpg', 'macbook-air-13-inch-m4-4-638769626700962520.jpg', 'macbook-air-13-inch-m4-5-638769626706738983.jpg', 'macbook-air-13-inch-m4-6-638769626714390856.jpg', 'macbook-air-13-inch-m4-7-638769626720421798.jpg', 'macbook-air-13-inch-m4-8-638769626725818781.jpg', 'macbook-air-13-inch-m4-9-638769626731656893.jpg', 'macbook-air-13-inch-m4-10-638769626739829579.jpg', 'macbook-air-13-inch-m4-11-638769626746070645.jpg', 'tem-mac-30-638823966925885886.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-2-638769626688234958.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-3-638769626694872835.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-4-638769626700962520.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-5-638769626706738983.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-6-638769626714390856.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-7-638769626720421798.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-8-638769626725818781.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-9-638769626731656893.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-10-638769626739829579.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-11-638769626746070645.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/tem-mac-30-638823966925885886.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-air-13-inch-m4-16gb-256gb/macbook-air-13-inch-m4-1-638769626682783095.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Laptop MacBook Pro 14 inch M4 Pro 24GB/512GB
-- Slug: macbook-pro-14-inch-m4-pro-24gb-512gb
-- Variants: 2

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Laptop MacBook Pro 14 inch M4 Pro 24GB/512GB',
        'macbook-pro-14-inch-m4-pro-24gb-512gb',
        6.0,
        1.0,
        'Khi nói đến máy tính xách tay cho các tác vụ đồ họa và kỹ thuật, Apple luôn giữ vững vị thế hàng đầu và Macbook Pro 14 inch M4 Pro 24GB/512GB - mẫu sản phẩm máy tính xách tay "mới toanh" từ nhà Táo trong năm nay là minh chứng rõ nhất. Với thiết kế sang trọng, hiệu năng vượt trội và các tính năng hiện đại, sản phẩm này được thiết kế đặc biệt cho những người dùng chuyên nghiệp, đòi hỏi sự mạnh mẽ và chuyên nghiệp nhất trong từng thao tác.',
        '{"meta_title": "Macbook Pro 14 inch M4 Pro 24GB/512GB | Chính hãng, giá tốt", "meta_description": "Macbook Pro 14 inch M4 Pro 24GB/512GB mang đến hiệu năng vượt trội, khả năng tiết kiệm năng lượng với chip M4 Pro. Đăng ký nhận thông tin tại TGDĐ!", "meta_keywords": "Apple Macbook Pro 14 inch M4 Pro 24GB/512GB, Macbook Pro 14 inch M4 Pro, Macbook Pro 14 inch M4 Pro, Laptop Apple Macbook Pro 14 inch M4 Pro 24GB/512GB, giá Apple Macbook Pro 14 inch M4 Pro 24GB/512GB, thông tin Apple Macbook Pro 14 inch M4 Pro 24GB/512GB"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'MACBOOK_PRO_14_INCH_M4_PRO_24GB_512GB_BAC',
        'macbook-pro-14-inch-m4-pro-24gb-512gb-bac',
        '{"color": "Bạc"}'::jsonb,
        49990000.0,
        51990000.0,
        477,
        '[{"Bộ xử lý": {"Công nghệ CPU": "Apple M4 Pro - Hãng không công bố", "Số nhân": "12", "Số luồng": "Hãng không công bố", "Tốc độ CPU": "273 GB/s memory bandwidth"}}, {"Đồ hoạ (GPU)": {"Card màn hình": "Card tích hợp- 16 nhân GPU", "Số nhân GPU": "Hãng không công bố"}}, {"Bộ nhớ RAM, Ổ cứng": {"RAM": "24 GB", "Loại RAM": "Hãng không công bố", "Tốc độ Bus RAM": "Hãng không công bố", "Hỗ trợ RAM tối đa": "Hãng không công bố", "Ổ cứng": "512 GB SSD"}}, {"Màn hình": {"Kích thước màn hình": "14.2 inch", "Độ phân giải": "Liquid Retina XDR display (3024 x 1964)", "Tần số quét": "up to 120 Hz", "Công nghệ màn hình": ["ProMotion", "Độ sáng XDR: toàn màn hình 1000 nits, cao nhất 1600 nits (chỉ nội dung HDR)", "Độ sáng SDR: lên đến 1000 nits", "Wide color (P3)", "True Tone Technology", "1 tỷ màu"]}}, {"Cổng kết nối & tính năng mở rộng": {"Cổng giao tiếp": ["Jack tai nghe 3.5 mm", "MagSafe 3", "HDMI", "3 x Thunderbolt 5 (USB-C) (hỗ trợ Charging, DisplayPort, Thunderbolt 4 và USB 4 (up to 40Gb/s))"], "Kết nối không dây": "Wi-Fi 6E (802.11ax)", "Khe đọc thẻ nhớ": "SD", "Webcam": "1080p FaceTime HD camera", "Đèn bàn phím": "Đơn sắc - Màu trắng", "Bảo mật": "Bảo mật vân tay", "Công nghệ âm thanh": ["Hệ thống âm thanh 6 loa", "Spatial Audio", "3 microphones", "Dolby Atmos"], "Tản nhiệt": "Hãng không công bố"}}, {"Kích thước - Khối lượng - Pin": {"Thông tin Pin": "Li-Po, 72.4 Wh", "Hệ điều hành": "macOS Sequoia", "Thời điểm ra mắt": "10/2024", "Kích thước": "Dài 312.6 mm - Rộng 221.2 mm - Dày 15.5 mm - 1.6 kg", "Chất liệu": "Vỏ nhôm tái chế 100%"}}]'::jsonb,
        ARRAY['macbook-pro-14-inch-m4-pro-tgdd-bac-1-638660162580702771.jpg', 'macbook-pro-14-inch-m4-pro-tgdd-bac-2-638660162593315383.jpg', 'macbook-pro-14-inch-m4-pro-tgdd-bac-3-638660162599048741.jpg', 'macbook-pro-14-inch-m4-pro-tgdd-bac-4-638660162604349935.jpg', 'macbook-pro-14-inch-m4-pro-tgdd-bac-5-638660162610525010.jpg', 'macbook-pro-14-inch-m4-pro-tgdd-bac-6-638660162615907468.jpg', 'macbook-pro-14-inch-m4-pro-tgdd-bac-7-638660162621493901.jpg', 'macbook-pro-14-inch-m4-pro-tgdd-bac-8-638660162629148894.jpg', 'macbook-pro-14-inch-m4-pro-24gb-512gb-30-638708303033246736.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-tgdd-bac-2-638660162593315383.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-tgdd-bac-3-638660162599048741.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-tgdd-bac-4-638660162604349935.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-tgdd-bac-5-638660162610525010.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-tgdd-bac-6-638660162615907468.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-tgdd-bac-7-638660162621493901.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-tgdd-bac-8-638660162629148894.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-24gb-512gb-30-638708303033246736.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-tgdd-bac-1-638660162580702771.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    -- Insert variant 2
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'MACBOOK_PRO_14_INCH_M4_PRO_24GB_512GB_DEN',
        'macbook-pro-14-inch-m4-pro-24gb-512gb-den',
        '{"color": "Đen"}'::jsonb,
        49990000.0,
        51990000.0,
        894,
        '[{"Bộ xử lý": {"Công nghệ CPU": "Apple M4 Pro - Hãng không công bố", "Số nhân": "12", "Số luồng": "Hãng không công bố", "Tốc độ CPU": "273 GB/s memory bandwidth"}}, {"Đồ hoạ (GPU)": {"Card màn hình": "Card tích hợp- 16 nhân GPU", "Số nhân GPU": "Hãng không công bố"}}, {"Bộ nhớ RAM, Ổ cứng": {"RAM": "24 GB", "Loại RAM": "Hãng không công bố", "Tốc độ Bus RAM": "Hãng không công bố", "Hỗ trợ RAM tối đa": "Hãng không công bố", "Ổ cứng": "512 GB SSD"}}, {"Màn hình": {"Kích thước màn hình": "14.2 inch", "Độ phân giải": "Liquid Retina XDR display (3024 x 1964)", "Tần số quét": "up to 120 Hz", "Công nghệ màn hình": ["ProMotion", "Độ sáng XDR: toàn màn hình 1000 nits, cao nhất 1600 nits (chỉ nội dung HDR)", "Độ sáng SDR: lên đến 1000 nits", "Wide color (P3)", "True Tone Technology", "1 tỷ màu"]}}, {"Cổng kết nối & tính năng mở rộng": {"Cổng giao tiếp": ["Jack tai nghe 3.5 mm", "MagSafe 3", "HDMI", "3 x Thunderbolt 5 (USB-C) (hỗ trợ Charging, DisplayPort, Thunderbolt 4 và USB 4 (up to 40Gb/s))"], "Kết nối không dây": "Wi-Fi 6E (802.11ax)", "Khe đọc thẻ nhớ": "SD", "Webcam": "1080p FaceTime HD camera", "Đèn bàn phím": "Đơn sắc - Màu trắng", "Bảo mật": "Bảo mật vân tay", "Công nghệ âm thanh": ["Hệ thống âm thanh 6 loa", "Spatial Audio", "3 microphones", "Dolby Atmos"], "Tản nhiệt": "Hãng không công bố"}}, {"Kích thước - Khối lượng - Pin": {"Thông tin Pin": "Li-Po, 72.4 Wh", "Hệ điều hành": "macOS Sequoia", "Thời điểm ra mắt": "10/2024", "Kích thước": "Dài 312.6 mm - Rộng 221.2 mm - Dày 15.5 mm - 1.6 kg", "Chất liệu": "Vỏ nhôm tái chế 100%"}}]'::jsonb,
        ARRAY['macbook-pro-14-inch-m4-pro-tgdd-den-1-638660162994303552.jpg', 'macbook-pro-14-inch-m4-pro-tgdd-den-2-638660163000098362.jpg', 'macbook-pro-14-inch-m4-pro-tgdd-den-3-638660163007248822.jpg', 'macbook-pro-14-inch-m4-pro-tgdd-den-4-638660163015098135.jpg', 'macbook-pro-14-inch-m4-pro-tgdd-den-5-638660163021209622.jpg', 'macbook-pro-14-inch-m4-pro-tgdd-den-6-638660163028142300.jpg', 'macbook-pro-14-inch-m4-pro-tgdd-den-7-638660163034002114.jpg', 'macbook-pro-14-inch-m4-pro-tgdd-den-8-638660163040434624.jpg', 'macbook-pro-14-inch-m4-pro-24gb-512gb-30-638708303157901424.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-tgdd-den-2-638660163000098362.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-tgdd-den-3-638660163007248822.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-tgdd-den-4-638660163015098135.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-tgdd-den-5-638660163021209622.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-tgdd-den-6-638660163028142300.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-tgdd-den-7-638660163034002114.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-tgdd-den-8-638660163040434624.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-24gb-512gb-30-638708303157901424.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/macbook-pro-14-inch-m4-pro-24gb-512gb/macbook-pro-14-inch-m4-pro-tgdd-den-1-638660162994303552.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Điện thoại OPPO Find X9 Pro 5G 16GB/512GB
-- Slug: oppo-find-x9-pro-16gb-512gb
-- Variants: 2

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Điện thoại OPPO Find X9 Pro 5G 16GB/512GB',
        'oppo-find-x9-pro-16gb-512gb',
        7.0,
        2.0,
        'Ra mắt vào tháng 10/2025, OPPO Find X9 Pro đánh dấu bước tiến lớn của hãng trong việc nâng tầm dòng Find X. Mọi chi tiết từ thiết kế, camera, hiệu năng cho đến pin đều được nâng cấp toàn diện. Đây là chiếc điện thoại không chỉ mạnh mẽ mà còn toát lên sự tinh tế, mang đến trải nghiệm xứng tầm người dùng cao cấp.',
        '{"meta_title": "OPPO Find X9 Pro giá tốt, tặng bộ quà trị giá 10 triệu", "meta_description": "Mua OPPO Find X9 Pro 16GB/512GB giá tốt, tặng bộ quà trị giá 10tr, thu cũ giảm đến 4tr, tặng gói Google One AI Premium 3 tháng, trả chậm 0%. Mua ngay đến 30/11!", "meta_keywords": "Mua OPPO Find X9 Pro 16GB/512GB giá tốt, tặng bộ quà trị giá 10tr, thu cũ giảm đến 4tr, tặng gói Google One AI Premium 3 tháng, trả chậm 0%. Mua ngay đến 30/11!"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'OPPO_FIND_X9_PRO_16GB_512GB_TRANG',
        'oppo-find-x9-pro-16gb-512gb-trang',
        '{"color": "Trắng"}'::jsonb,
        32990000.0,
        NULL,
        361,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 16", "Chip xử lý (CPU)": "MediaTek Dimensity 9500 8 nhân", "Tốc độ CPU": "4.21 GHz", "Chip đồ họa (GPU)": "Mali-G1 Ultra MC12", "RAM": "16 GB", "Dung lượng lưu trữ": "512 GB", "Dung lượng còn lại (khả dụng) khoảng": "452 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 200 MP, 50 MP, 2 MP", "Quay phim camera sau": ["HD 720p@480fps", "FullHD 1080p@30fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@120fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "XPAN", "Tự động lấy nét (AF)", "Toàn cảnh (Panorama)", "Quét tài liệu", "Quay chậm (Slow Motion)", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Chống rung quang học (OIS)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "50 MP", "Tính năng camera trước": ["Xóa phông", "Toàn cảnh (Panorama)", "Nhãn dán (AR Stickers)", "Làm đẹp", "Chụp đêm"], "Công nghệ màn hình": "AMOLED", "Độ phân giải màn hình": "1.5K+ (1272 x 2772 Pixels)", "Màn hình rộng": "6.78 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "1800 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass Victus 2"}}, {"Pin & Sạc": {"Dung lượng pin": "7500 mAh", "Loại pin": "Li-Po", "Hỗ trợ sạc tối đa": "80 W", "Sạc kèm theo máy": "80 W", "Công nghệ pin": ["Sạc siêu nhanh SuperVOOC", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Ứng dụng kép (Nhân bản ứng dụng)", "Đa cửa sổ (chia đôi màn hình)", "Thanh bên thông minh", "Mở rộng bộ nhớ RAM", "HDR10+", "Cử chỉ thông minh", "Công nghệ hình ảnh Dolby Vision", "Chụp hình dưới nước", "Chỉnh sửa ảnh AI", "Loa kép"], "Kháng nước, bụi": "IP66, IP68, IP69", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AVI"], "Nghe nhạc": ["OGG", "Midi", "MP3", "FLAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM hoặc 1 Nano SIM + 1 eSIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v6.0", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "NFC", "Hồng ngoại"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung hợp kim nhôm & Mặt lưng kính", "Kích thước, khối lượng": "Dài 161.26 mm - Ngang 76.46 mm - Dày 8.25 mm - Nặng 224 g", "Thời điểm ra mắt": "10/2025"}}]'::jsonb,
        ARRAY['oppo-find-x9-pro-trang-1-638978468756428611.jpg', 'oppo-find-x9-pro-trang-2-638978468720652214.jpg', 'oppo-find-x9-pro-trang-3-638978468714302787.jpg', 'oppo-find-x9-pro-trang-4-638978468707881890.jpg', 'oppo-find-x9-pro-trang-5-638978468697091484.jpg', 'oppo-find-x9-pro-trang-6-638978468689371619.jpg', 'oppo-find-x9-pro-trang-7-638978468682117928.jpg', 'oppo-find-x9-pro-trang-8-638978468674805756.jpg', 'oppo-find-x9-pro-trang-9-638978468668431477.jpg', 'oppo-find-x9-pro-trang-10-638978468748678771.jpg', 'oppo-find-x9-pro-trang-11-638978468742037593.jpg', 'oppo-find-x9-pro-trang-12-638978468735331928.jpg', 'oppo-find-x9-pro-trang-13-638978468728945259.jpg', 'oppo-find-x9-pro-trang-14-638978504104115722.jpg', 'oppo-find-x9-pro-bbh-638978502649676156.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-trang-2-638978468720652214.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-trang-3-638978468714302787.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-trang-4-638978468707881890.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-trang-5-638978468697091484.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-trang-6-638978468689371619.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-trang-7-638978468682117928.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-trang-8-638978468674805756.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-trang-9-638978468668431477.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-trang-10-638978468748678771.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-trang-11-638978468742037593.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-trang-12-638978468735331928.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-trang-13-638978468728945259.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-trang-14-638978504104115722.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-bbh-638978502649676156.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-trang-1-638978468756428611.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    -- Insert variant 2
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'OPPO_FIND_X9_PRO_16GB_512GB_XAM',
        'oppo-find-x9-pro-16gb-512gb-xam',
        '{"color": "Xám"}'::jsonb,
        32990000.0,
        NULL,
        690,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 16", "Chip xử lý (CPU)": "MediaTek Dimensity 9500 8 nhân", "Tốc độ CPU": "4.21 GHz", "Chip đồ họa (GPU)": "Mali-G1 Ultra MC12", "RAM": "16 GB", "Dung lượng lưu trữ": "512 GB", "Dung lượng còn lại (khả dụng) khoảng": "452 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 200 MP, 50 MP, 2 MP", "Quay phim camera sau": ["HD 720p@480fps", "FullHD 1080p@30fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@120fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "XPAN", "Tự động lấy nét (AF)", "Toàn cảnh (Panorama)", "Quét tài liệu", "Quay chậm (Slow Motion)", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Chống rung quang học (OIS)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "50 MP", "Tính năng camera trước": ["Xóa phông", "Toàn cảnh (Panorama)", "Nhãn dán (AR Stickers)", "Làm đẹp", "Chụp đêm"], "Công nghệ màn hình": "AMOLED", "Độ phân giải màn hình": "1.5K+ (1272 x 2772 Pixels)", "Màn hình rộng": "6.78 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "1800 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass Victus 2"}}, {"Pin & Sạc": {"Dung lượng pin": "7500 mAh", "Loại pin": "Li-Po", "Hỗ trợ sạc tối đa": "80 W", "Sạc kèm theo máy": "80 W", "Công nghệ pin": ["Sạc siêu nhanh SuperVOOC", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Ứng dụng kép (Nhân bản ứng dụng)", "Đa cửa sổ (chia đôi màn hình)", "Thanh bên thông minh", "Mở rộng bộ nhớ RAM", "HDR10+", "Cử chỉ thông minh", "Công nghệ hình ảnh Dolby Vision", "Chụp hình dưới nước", "Chỉnh sửa ảnh AI", "Loa kép"], "Kháng nước, bụi": "IP66, IP68, IP69", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AVI"], "Nghe nhạc": ["OGG", "Midi", "MP3", "FLAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM hoặc 1 Nano SIM + 1 eSIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "NavIC", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v6.0", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "NFC", "Hồng ngoại"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung hợp kim nhôm & Mặt lưng kính", "Kích thước, khối lượng": "Dài 161.26 mm - Ngang 76.46 mm - Dày 8.25 mm - Nặng 224 g", "Thời điểm ra mắt": "10/2025"}}]'::jsonb,
        ARRAY['oppo-find-x9-pro-titan-1-638978501248595512.jpg', 'oppo-find-x9-pro-titan-2-638978501238410027.jpg', 'oppo-find-x9-pro-titan-3-638978501230526558.jpg', 'oppo-find-x9-pro-bbh-638978502649676156.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-titan-2-638978501238410027.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-titan-3-638978501230526558.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-bbh-638978502649676156.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-find-x9-pro-16gb-512gb/oppo-find-x9-pro-titan-1-638978501248595512.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Điện thoại OPPO Reno14 5G 12GB/512GB
-- Slug: oppo-reno14-5g-512gb
-- Variants: 4

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Điện thoại OPPO Reno14 5G 12GB/512GB',
        'oppo-reno14-5g-512gb',
        7.0,
        2.0,
        'OPPO Reno 14 512GB là smartphone lý tưởng cho lối sống trẻ trung, năng động. Sở hữu thiết kế cuốn hút, máy trang bị camera sắc nét, pin khỏe, hiệu năng mượt mà cùng nhiều tính năng thông minh. Từ học tập, làm việc đến giải trí, Reno 14 giúp mọi trải nghiệm hàng ngày của bạn trở nên dễ dàng và thú vị hơn.',
        '{"meta_title": "OPPO Reno14 5G 12GB/512GB giá tốt, tặng gói Google One AI Premium", "meta_description": "Mua OPPO Reno 14 5G 12GB/512GB đặc quyền, giá tốt, tặng gói Google One AI Premium, giảm 300K hoặc tặng Loa INNO Sound S1, thu cũ trợ giá đến 2.5 triệu. Mua ngay!", "meta_keywords": "OPPO Reno14 5G 12GB/512GB, oppo reno14, oppo reno14 5g, reno14, reno 14 5g, opporeno 14 5g, reno 14, re no 14, smartphone reno14, điện thoại oppo 14, reno145g"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'OPPO_RENO14_5G_512GB_512GB_XANH_LA',
        'oppo-reno14-5g-512gb-512gb-xanh-la',
        '{"color": "Xanh lá", "storage": "512GB"}'::jsonb,
        16690000.0,
        NULL,
        293,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "MediaTek Dimensity 8350 5G 8 nhân", "Tốc độ CPU": "3.35 GHz", "Chip đồ họa (GPU)": "Mali-G615 MC6", "RAM": "12 GB", "Dung lượng lưu trữ": "512 GB", "Dung lượng còn lại (khả dụng) khoảng": "470 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 50 MP, 8 MP", "Quay phim camera sau": ["HD 720p@960fps", "HD 720p@30fps", "HD 720p@240fps", "FullHD 1080p@60fps", "FullHD 1080p@480fps", "FullHD 1080p@30fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu độ phân giải", "Quay video hiển thị kép", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Google Lens", "Chống rung quang học (OIS)", "Chuyên nghiệp (Pro)", "Bộ lọc màu", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "50 MP", "Tính năng camera trước": ["Xóa phông", "Video hiển thị kép", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Nhãn dán (AR Stickers)", "Làm đẹp", "Chụp đêm", "Bộ lọc màu"], "Công nghệ màn hình": "AMOLED", "Độ phân giải màn hình": "1.5K (1256 x 2760 Pixles)", "Màn hình rộng": "6.59 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "1200 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass 7i"}}, {"Pin & Sạc": {"Dung lượng pin": "6000 mAh", "Loại pin": "Li-Po", "Hỗ trợ sạc tối đa": "80 W", "Sạc kèm theo máy": "80 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc siêu nhanh SuperVOOC"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Ứng dụng kép (Nhân bản ứng dụng)", "Tóm tắt cuộc gọi AI", "Trợ lý ảo Google Gemini", "Thanh bên thông minh", "Phiên dịch trực tiếp", "Phiên dịch AI", "Mở mắt AI", "Màn hình cảm ứng siêu nhạy (chế độ găng tay)", "Hệ thống làm mát", "DCI-P3", "Cử chỉ thông minh", "Chụp hình dưới nước"], "Kháng nước, bụi": "IP66, IP68, IP69", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AVI"], "Nghe nhạc": ["OGG", "Midi", "MP3", "FLAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM hoặc 1 Nano SIM + 1 eSIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "NFC", "Hồng ngoại"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung hợp kim nhôm & Mặt lưng kính", "Kích thước, khối lượng": "Dài 157.9 mm - Ngang 74.73 mm - Dày 7.42 mm - Nặng 187 g", "Thời điểm ra mắt": "07/2025"}}]'::jsonb,
        ARRAY['oppo-reno14-5g-green-1-638882710616846956.jpg', 'oppo-reno14-5g-green-2-638882710623899540.jpg', 'oppo-reno14-5g-green-3-638882710629058855.jpg', 'oppo-reno14-5g-green-4-638882710634896264.jpg', 'oppo-reno14-5g-green-5-638882710640888577.jpg', 'oppo-reno14-5g-green-6-638882710647501445.jpg', 'oppo-reno14-5g-green-7-638882710652950288.jpg', 'oppo-reno14-5g-green-8-638882710659002384.jpg', 'oppo-reno14-5g-green-9-638882710664841842.jpg', 'oppo-reno14-5g-green-10-638882710671055232.jpg', 'oppo-reno14-5g-green-11-638882710677682092.jpg', 'oppo-reno14-5g-green-12-638882710683571554.jpg', 'reno14-5g-bbh-638882812950178133.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-green-2-638882710623899540.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-green-3-638882710629058855.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-green-4-638882710634896264.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-green-5-638882710640888577.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-green-6-638882710647501445.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-green-7-638882710652950288.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-green-8-638882710659002384.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-green-9-638882710664841842.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-green-10-638882710671055232.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-green-11-638882710677682092.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-green-12-638882710683571554.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/reno14-5g-bbh-638882812950178133.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-green-1-638882710616846956.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    -- Insert variant 2
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'OPPO_RENO14_5G_512GB_512GB_TRANG',
        'oppo-reno14-5g-512gb-512gb-trang',
        '{"color": "Trắng", "storage": "512GB"}'::jsonb,
        16690000.0,
        NULL,
        32,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "MediaTek Dimensity 8350 5G 8 nhân", "Tốc độ CPU": "3.35 GHz", "Chip đồ họa (GPU)": "Mali-G615 MC6", "RAM": "12 GB", "Dung lượng lưu trữ": "512 GB", "Dung lượng còn lại (khả dụng) khoảng": "470 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 50 MP, 8 MP", "Quay phim camera sau": ["HD 720p@960fps", "HD 720p@30fps", "HD 720p@240fps", "FullHD 1080p@60fps", "FullHD 1080p@480fps", "FullHD 1080p@30fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu độ phân giải", "Quay video hiển thị kép", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Google Lens", "Chống rung quang học (OIS)", "Chuyên nghiệp (Pro)", "Bộ lọc màu", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "50 MP", "Tính năng camera trước": ["Xóa phông", "Video hiển thị kép", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Nhãn dán (AR Stickers)", "Làm đẹp", "Chụp đêm", "Bộ lọc màu"], "Công nghệ màn hình": "AMOLED", "Độ phân giải màn hình": "1.5K (1256 x 2760 Pixles)", "Màn hình rộng": "6.59 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "1200 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass 7i"}}, {"Pin & Sạc": {"Dung lượng pin": "6000 mAh", "Loại pin": "Li-Po", "Hỗ trợ sạc tối đa": "80 W", "Sạc kèm theo máy": "80 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc siêu nhanh SuperVOOC"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Ứng dụng kép (Nhân bản ứng dụng)", "Tóm tắt cuộc gọi AI", "Trợ lý ảo Google Gemini", "Thanh bên thông minh", "Phiên dịch trực tiếp", "Phiên dịch AI", "Mở mắt AI", "Màn hình cảm ứng siêu nhạy (chế độ găng tay)", "Hệ thống làm mát", "DCI-P3", "Cử chỉ thông minh", "Chụp hình dưới nước"], "Kháng nước, bụi": "IP66, IP68, IP69", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AVI"], "Nghe nhạc": ["OGG", "Midi", "MP3", "FLAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM hoặc 1 Nano SIM + 1 eSIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "NFC", "Hồng ngoại"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung hợp kim nhôm & Mặt lưng kính", "Kích thước, khối lượng": "Dài 157.9 mm - Ngang 74.73 mm - Dày 7.42 mm - Nặng 187 g", "Thời điểm ra mắt": "07/2025"}}]'::jsonb,
        ARRAY['oppo-reno14-5g-white-1-638882710375348526.jpg', 'oppo-reno14-5g-white-2-638882710386474574.jpg', 'oppo-reno14-5g-white-3-638882710391828383.jpg', 'oppo-reno14-5g-white-4-638882710400457780.jpg', 'oppo-reno14-5g-white-5-638882710407058674.jpg', 'oppo-reno14-5g-white-6-638882710413425159.jpg', 'oppo-reno14-5g-white-7-638882710418910783.jpg', 'oppo-reno14-5g-white-8-638882710425087519.jpg', 'oppo-reno14-5g-white-9-638882710432072502.jpg', 'oppo-reno14-5g-white-10-638882710438387483.jpg', 'oppo-reno14-5g-white-11-638882710443623260.jpg', 'oppo-reno14-5g-white-12-638882710450905910.jpg', 'reno14-5g-bbh-638882812950178133.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-2-638882710386474574.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-3-638882710391828383.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-4-638882710400457780.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-5-638882710407058674.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-6-638882710413425159.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-7-638882710418910783.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-8-638882710425087519.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-9-638882710432072502.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-10-638882710438387483.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-11-638882710443623260.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-12-638882710450905910.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/reno14-5g-bbh-638882812950178133.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-1-638882710375348526.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 3
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'OPPO_RENO14_5G_512GB_256GB_XANH_LA',
        'oppo-reno14-5g-512gb-256gb-xanh-la',
        '{"color": "Xanh lá", "storage": "256GB"}'::jsonb,
        15500000.0,
        15700000.0,
        938,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "MediaTek Dimensity 8350 5G 8 nhân", "Tốc độ CPU": "3.35 GHz", "Chip đồ họa (GPU)": "Mali-G615 MC6", "RAM": "12 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "230 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 50 MP, 8 MP", "Quay phim camera sau": ["HD 720p@960fps", "HD 720p@30fps", "HD 720p@240fps", "FullHD 1080p@60fps", "FullHD 1080p@480fps", "FullHD 1080p@30fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu độ phân giải", "Quay video hiển thị kép", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Google Lens", "Chống rung quang học (OIS)", "Chuyên nghiệp (Pro)", "Bộ lọc màu", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "50 MP", "Tính năng camera trước": ["Xóa phông", "Video hiển thị kép", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Nhãn dán (AR Stickers)", "Làm đẹp", "Chụp đêm", "Bộ lọc màu"], "Công nghệ màn hình": "AMOLED", "Độ phân giải màn hình": "1.5K (1256 x 2760 Pixles)", "Màn hình rộng": "6.59 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "1200 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass 7i"}}, {"Pin & Sạc": {"Dung lượng pin": "6000 mAh", "Loại pin": "Li-Po", "Hỗ trợ sạc tối đa": "80 W", "Sạc kèm theo máy": "80 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc siêu nhanh SuperVOOC"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Ứng dụng kép (Nhân bản ứng dụng)", "Tóm tắt cuộc gọi AI", "Trợ lý ảo Google Gemini", "Thanh bên thông minh", "Phiên dịch trực tiếp", "Phiên dịch AI", "Mở mắt AI", "Màn hình cảm ứng siêu nhạy (chế độ găng tay)", "Hệ thống làm mát", "DCI-P3", "Cử chỉ thông minh", "Chụp hình dưới nước"], "Kháng nước, bụi": "IP66, IP68, IP69", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AVI"], "Nghe nhạc": ["OGG", "Midi", "MP3", "FLAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM hoặc 1 Nano SIM + 1 eSIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "NFC", "Hồng ngoại"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung hợp kim nhôm & Mặt lưng kính", "Kích thước, khối lượng": "Dài 157.9 mm - Ngang 74.73 mm - Dày 7.42 mm - Nặng 187 g", "Thời điểm ra mắt": "07/2025"}}]'::jsonb,
        ARRAY['oppo-reno14-5g-white-1-638882710187232653.jpg', 'oppo-reno14-5g-white-2-638882710193111466.jpg', 'oppo-reno14-5g-white-3-638882710201716195.jpg', 'oppo-reno14-5g-white-4-638882710207212190.jpg', 'oppo-reno14-5g-white-5-638882710218115579.jpg', 'oppo-reno14-5g-white-6-638882710223814638.jpg', 'oppo-reno14-5g-white-7-638882710230056671.jpg', 'oppo-reno14-5g-white-8-638882710235641886.jpg', 'oppo-reno14-5g-white-9-638882710241618458.jpg', 'oppo-reno14-5g-white-10-638882710247667591.jpg', 'oppo-reno14-5g-white-11-638882710254622403.jpg', 'oppo-reno14-5g-white-12-638882710260455598.jpg', 'reno14-5g-bbh-638882812992499483.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-2-638882710193111466.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-3-638882710201716195.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-4-638882710207212190.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-5-638882710218115579.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-6-638882710223814638.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-7-638882710230056671.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-8-638882710235641886.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-9-638882710241618458.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-10-638882710247667591.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-11-638882710254622403.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-12-638882710260455598.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/reno14-5g-bbh-638882812992499483.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-1-638882710187232653.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 4
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'OPPO_RENO14_5G_512GB_256GB_TRANG',
        'oppo-reno14-5g-512gb-256gb-trang',
        '{"color": "Trắng", "storage": "256GB"}'::jsonb,
        15500000.0,
        15700000.0,
        396,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "MediaTek Dimensity 8350 5G 8 nhân", "Tốc độ CPU": "3.35 GHz", "Chip đồ họa (GPU)": "Mali-G615 MC6", "RAM": "12 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "230 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 50 MP, 8 MP", "Quay phim camera sau": ["HD 720p@960fps", "HD 720p@30fps", "HD 720p@240fps", "FullHD 1080p@60fps", "FullHD 1080p@480fps", "FullHD 1080p@30fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu độ phân giải", "Quay video hiển thị kép", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Google Lens", "Chống rung quang học (OIS)", "Chuyên nghiệp (Pro)", "Bộ lọc màu", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "50 MP", "Tính năng camera trước": ["Xóa phông", "Video hiển thị kép", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Nhãn dán (AR Stickers)", "Làm đẹp", "Chụp đêm", "Bộ lọc màu"], "Công nghệ màn hình": "AMOLED", "Độ phân giải màn hình": "1.5K (1256 x 2760 Pixles)", "Màn hình rộng": "6.59 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "1200 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass 7i"}}, {"Pin & Sạc": {"Dung lượng pin": "6000 mAh", "Loại pin": "Li-Po", "Hỗ trợ sạc tối đa": "80 W", "Sạc kèm theo máy": "80 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc siêu nhanh SuperVOOC"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Ứng dụng kép (Nhân bản ứng dụng)", "Tóm tắt cuộc gọi AI", "Trợ lý ảo Google Gemini", "Thanh bên thông minh", "Phiên dịch trực tiếp", "Phiên dịch AI", "Mở mắt AI", "Màn hình cảm ứng siêu nhạy (chế độ găng tay)", "Hệ thống làm mát", "DCI-P3", "Cử chỉ thông minh", "Chụp hình dưới nước"], "Kháng nước, bụi": "IP66, IP68, IP69", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["MP4", "AVI"], "Nghe nhạc": ["OGG", "Midi", "MP3", "FLAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM hoặc 1 Nano SIM + 1 eSIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "NFC", "Hồng ngoại"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung hợp kim nhôm & Mặt lưng kính", "Kích thước, khối lượng": "Dài 157.9 mm - Ngang 74.73 mm - Dày 7.42 mm - Nặng 187 g", "Thời điểm ra mắt": "07/2025"}}]'::jsonb,
        ARRAY['oppo-reno14-5g-white-1-638882710187232653.jpg', 'oppo-reno14-5g-white-2-638882710193111466.jpg', 'oppo-reno14-5g-white-3-638882710201716195.jpg', 'oppo-reno14-5g-white-4-638882710207212190.jpg', 'oppo-reno14-5g-white-5-638882710218115579.jpg', 'oppo-reno14-5g-white-6-638882710223814638.jpg', 'oppo-reno14-5g-white-7-638882710230056671.jpg', 'oppo-reno14-5g-white-8-638882710235641886.jpg', 'oppo-reno14-5g-white-9-638882710241618458.jpg', 'oppo-reno14-5g-white-10-638882710247667591.jpg', 'oppo-reno14-5g-white-11-638882710254622403.jpg', 'oppo-reno14-5g-white-12-638882710260455598.jpg', 'reno14-5g-bbh-638882812992499483.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-2-638882710193111466.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-3-638882710201716195.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-4-638882710207212190.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-5-638882710218115579.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-6-638882710223814638.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-7-638882710230056671.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-8-638882710235641886.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-9-638882710241618458.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-10-638882710247667591.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-11-638882710254622403.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-12-638882710260455598.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/reno14-5g-bbh-638882812992499483.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/oppo-reno14-5g-512gb/oppo-reno14-5g-white-1-638882710187232653.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Điện thoại Samsung Galaxy A17 5G 8GB/128GB
-- Slug: samsung-galaxy-a17-5g-8gb-128gb
-- Variants: 6

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Điện thoại Samsung Galaxy A17 5G 8GB/128GB',
        'samsung-galaxy-a17-5g-8gb-128gb',
        8.0,
        2.0,
        'Không chỉ dừng lại ở vai trò liên lạc, smartphone giờ đây còn là phụ kiện thể hiện cá tính. Samsung Galaxy A17 5G được thiết kế để vừa đẹp mắt, vừa tiện lợi khi sử dụng, mang đến cho người dùng trải nghiệm trọn vẹn về cả nhìn lẫn cảm giác cầm nắm trong phân khúc giá của mình.',
        '{"meta_title": "Samsung Galaxy A17 5G 8GB/128GB giá tốt, tặng gói VieON VIP", "meta_description": "Samsung Galaxy A17 5G 8GB/128GB giá tốt, trả chậm 0% lãi suất - trả trước 0đ, hư gì đổi nấy 12 tháng, tặng phiếu mua hàng 200K mua phụ kiện Samsung. Mua ngay!", "meta_keywords": "Samsung Galaxy A17 5G 8GB/128GB, Samsung Galaxy A17 5G , Samsung Galaxy A17, glx a17, Samsung galaxy a 17, Samsung glx a17, A17, A 17, gâlaxy a17, smartphone galaxy a17"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'SAMSUNG_GALAXY_A17_5G_8GB_128GB_128GB_XAM',
        'samsung-galaxy-a17-5g-8gb-128gb-128gb-xam',
        '{"color": "Xám", "storage": "128GB"}'::jsonb,
        390000.0,
        NULL,
        414,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Exynos 1330", "Tốc độ CPU": "2 nhân 2.4 GHz & 6 nhân 2 GHz", "Chip đồ họa (GPU)": "Đang cập nhật", "RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "107 GB", "Thẻ nhớ": "MicroSD, hỗ trợ tối đa 2 TB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 5 MP, 2 MP", "Quay phim camera sau": ["HD 720p@120fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu cận (Macro)", "Quay chậm (Slow Motion)", "Làm đẹp", "Chống rung quang học (OIS)", "Chế độ thức ăn", "Chuyên nghiệp (Pro)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "13 MP", "Tính năng camera trước": ["Xóa phông", "Nhãn dán (AR Stickers)", "Làm đẹp"], "Công nghệ màn hình": "Super AMOLED", "Độ phân giải màn hình": "Full HD+ (1080 x 2340 Pixels)", "Màn hình rộng": "6.7 inch - Tần số quét  90 Hz", "Độ sáng tối đa": "800 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass Victus"}}, {"Pin & Sạc": {"Dung lượng pin": "5000 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "25 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay cạnh viền", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Trợ lý ảo Google Gemini", "Smart Switch (ứng dụng chuyển đổi dữ liệu)", "Khoanh tròn để tìm kiếm"], "Kháng nước, bụi": "IP54", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["WEBM", "MP4", "MKV", "M4V", "FLV", "AVI", "3GP", "3G2"], "Nghe nhạc": ["XMF", "WAV", "RTX", "RTTTL", "OTA", "OGG", "OGA", "Midi", "MXMF", "MP3", "M4A", "IMY", "FLAC", "AWB", "AMR", "AAC", "3GA"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 164.4 mm - Ngang 77.9 mm - Dày 7.5 mm - Nặng 192 g", "Thời điểm ra mắt": "08/2025"}}]'::jsonb,
        ARRAY['samsung-galaxy-a17-5g-gray-1-638925131547875229.jpg', 'samsung-galaxy-a17-5g-gray-2-638925131541619295.jpg', 'samsung-galaxy-a17-5g-gray-3-638925131535079597.jpg', 'samsung-galaxy-a17-5g-gray-4-638925131528503776.jpg', 'samsung-galaxy-a17-5g-gray-5-638925131519844861.jpg', 'samsung-galaxy-a17-5g-gray-6-638925131512486372.jpg', 'samsung-galaxy-a17-5g-gray-7-638925131505532821.jpg', 'samsung-galaxy-a17-5g-gray-8-638925131497911816.jpg', 'samsung-galaxy-a17-5g-gray-9-638925131491175268.jpg', 'samsung-galaxy-a17-5g-gray-10-638925131484367936.jpg', 'samsung-galaxy-a17-5g-gray-11-638925131477412712.jpg', 'samsung-galaxy-a17-5g-gray-12-638925131468522278.jpg', 'samsung-galaxy-a17-5g-gray-13-638925131460429115.jpg', 'galaxy-a17-5g-bbh-638925134410222538.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-gray-2-638925131541619295.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-gray-3-638925131535079597.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-gray-4-638925131528503776.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-gray-5-638925131519844861.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-gray-6-638925131512486372.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-gray-7-638925131505532821.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-gray-8-638925131497911816.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-gray-9-638925131491175268.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-gray-10-638925131484367936.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-gray-11-638925131477412712.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-gray-12-638925131468522278.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-gray-13-638925131460429115.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/galaxy-a17-5g-bbh-638925134410222538.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-gray-1-638925131547875229.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    -- Insert variant 2
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'SAMSUNG_GALAXY_A17_5G_8GB_128GB_128GB_XANH_DUONG',
        'samsung-galaxy-a17-5g-8gb-128gb-128gb-xanh-duong',
        '{"color": "Xanh Dương", "storage": "128GB"}'::jsonb,
        390000.0,
        NULL,
        932,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Exynos 1330", "Tốc độ CPU": "2 nhân 2.4 GHz & 6 nhân 2 GHz", "Chip đồ họa (GPU)": "Đang cập nhật", "RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "107 GB", "Thẻ nhớ": "MicroSD, hỗ trợ tối đa 2 TB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 5 MP, 2 MP", "Quay phim camera sau": ["HD 720p@120fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu cận (Macro)", "Quay chậm (Slow Motion)", "Làm đẹp", "Chống rung quang học (OIS)", "Chế độ thức ăn", "Chuyên nghiệp (Pro)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "13 MP", "Tính năng camera trước": ["Xóa phông", "Nhãn dán (AR Stickers)", "Làm đẹp"], "Công nghệ màn hình": "Super AMOLED", "Độ phân giải màn hình": "Full HD+ (1080 x 2340 Pixels)", "Màn hình rộng": "6.7 inch - Tần số quét  90 Hz", "Độ sáng tối đa": "800 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass Victus"}}, {"Pin & Sạc": {"Dung lượng pin": "5000 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "25 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay cạnh viền", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Trợ lý ảo Google Gemini", "Smart Switch (ứng dụng chuyển đổi dữ liệu)", "Khoanh tròn để tìm kiếm"], "Kháng nước, bụi": "IP54", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["WEBM", "MP4", "MKV", "M4V", "FLV", "AVI", "3GP", "3G2"], "Nghe nhạc": ["XMF", "WAV", "RTX", "RTTTL", "OTA", "OGG", "OGA", "Midi", "MXMF", "MP3", "M4A", "IMY", "FLAC", "AWB", "AMR", "AAC", "3GA"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 164.4 mm - Ngang 77.9 mm - Dày 7.5 mm - Nặng 192 g", "Thời điểm ra mắt": "08/2025"}}]'::jsonb,
        ARRAY['samsung-galaxy-a17-5g-blue-1-638925131873119876.jpg', 'samsung-galaxy-a17-5g-blue-2-638925131866696040.jpg', 'samsung-galaxy-a17-5g-blue-3-638925131861046207.jpg', 'samsung-galaxy-a17-5g-blue-4-638925131855524014.jpg', 'samsung-galaxy-a17-5g-blue-5-638925131847882039.jpg', 'samsung-galaxy-a17-5g-blue-6-638925131840784104.jpg', 'samsung-galaxy-a17-5g-blue-7-638925131834945049.jpg', 'samsung-galaxy-a17-5g-blue-8-638925131828389933.jpg', 'samsung-galaxy-a17-5g-blue-9-638925131821332690.jpg', 'samsung-galaxy-a17-5g-blue-10-638925131813596585.jpg', 'samsung-galaxy-a17-5g-blue-11-638925131806680726.jpg', 'samsung-galaxy-a17-5g-blue-12-638925131798459681.jpg', 'samsung-galaxy-a17-5g-blue-13-638925131791759472.jpg', 'galaxy-a17-5g-bbh-638925134410222538.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-2-638925131866696040.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-3-638925131861046207.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-4-638925131855524014.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-5-638925131847882039.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-6-638925131840784104.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-7-638925131834945049.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-8-638925131828389933.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-9-638925131821332690.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-10-638925131813596585.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-11-638925131806680726.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-12-638925131798459681.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-13-638925131791759472.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/galaxy-a17-5g-bbh-638925134410222538.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-1-638925131873119876.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 3
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'SAMSUNG_GALAXY_A17_5G_8GB_128GB_128GB_DEN',
        'samsung-galaxy-a17-5g-8gb-128gb-128gb-den',
        '{"color": "Đen", "storage": "128GB"}'::jsonb,
        390000.0,
        NULL,
        425,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Exynos 1330", "Tốc độ CPU": "2 nhân 2.4 GHz & 6 nhân 2 GHz", "Chip đồ họa (GPU)": "Đang cập nhật", "RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "107 GB", "Thẻ nhớ": "MicroSD, hỗ trợ tối đa 2 TB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 5 MP, 2 MP", "Quay phim camera sau": ["HD 720p@120fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu cận (Macro)", "Quay chậm (Slow Motion)", "Làm đẹp", "Chống rung quang học (OIS)", "Chế độ thức ăn", "Chuyên nghiệp (Pro)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "13 MP", "Tính năng camera trước": ["Xóa phông", "Nhãn dán (AR Stickers)", "Làm đẹp"], "Công nghệ màn hình": "Super AMOLED", "Độ phân giải màn hình": "Full HD+ (1080 x 2340 Pixels)", "Màn hình rộng": "6.7 inch - Tần số quét  90 Hz", "Độ sáng tối đa": "800 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass Victus"}}, {"Pin & Sạc": {"Dung lượng pin": "5000 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "25 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay cạnh viền", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Trợ lý ảo Google Gemini", "Smart Switch (ứng dụng chuyển đổi dữ liệu)", "Khoanh tròn để tìm kiếm"], "Kháng nước, bụi": "IP54", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["WEBM", "MP4", "MKV", "M4V", "FLV", "AVI", "3GP", "3G2"], "Nghe nhạc": ["XMF", "WAV", "RTX", "RTTTL", "OTA", "OGG", "OGA", "Midi", "MXMF", "MP3", "M4A", "IMY", "FLAC", "AWB", "AMR", "AAC", "3GA"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 164.4 mm - Ngang 77.9 mm - Dày 7.5 mm - Nặng 192 g", "Thời điểm ra mắt": "08/2025"}}]'::jsonb,
        ARRAY['samsung-galaxy-a17-5g-black-1-638925132751224442.jpg', 'samsung-galaxy-a17-5g-black-2-638925132743402799.jpg', 'samsung-galaxy-a17-5g-black-3-638925132737184982.jpg', 'samsung-galaxy-a17-5g-black-4-638925132728728379.jpg', 'samsung-galaxy-a17-5g-black-5-638925132721461911.jpg', 'samsung-galaxy-a17-5g-black-6-638925132711513906.jpg', 'samsung-galaxy-a17-5g-black-7-638925132704812691.jpg', 'samsung-galaxy-a17-5g-black-8-638925132698999095.jpg', 'samsung-galaxy-a17-5g-black-9-638925132692919103.jpg', 'samsung-galaxy-a17-5g-black-10-638925132686275641.jpg', 'samsung-galaxy-a17-5g-black-11-638925132680103204.jpg', 'samsung-galaxy-a17-5g-black-12-638925132673094152.jpg', 'samsung-galaxy-a17-5g-black-13-638925132666860181.jpg', 'galaxy-a17-5g-bbh-638925134410222538.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-black-2-638925132743402799.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-black-3-638925132737184982.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-black-4-638925132728728379.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-black-5-638925132721461911.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-black-6-638925132711513906.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-black-7-638925132704812691.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-black-8-638925132698999095.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-black-9-638925132692919103.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-black-10-638925132686275641.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-black-11-638925132680103204.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-black-12-638925132673094152.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-black-13-638925132666860181.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/galaxy-a17-5g-bbh-638925134410222538.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-black-1-638925132751224442.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 4
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'SAMSUNG_GALAXY_A17_5G_8GB_128GB_256GB_XAM',
        'samsung-galaxy-a17-5g-8gb-128gb-256gb-xam',
        '{"color": "Xám", "storage": "256GB"}'::jsonb,
        6690000.0,
        7090000.0,
        884,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Exynos 1330", "Tốc độ CPU": "2 nhân 2.4 GHz & 6 nhân 2 GHz", "Chip đồ họa (GPU)": "Đang cập nhật", "RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "232 GB", "Thẻ nhớ": "MicroSD, hỗ trợ tối đa 2 TB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 5 MP, 2 MP", "Quay phim camera sau": ["HD 720p@120fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu cận (Macro)", "Quay chậm (Slow Motion)", "Làm đẹp", "Chống rung quang học (OIS)", "Chế độ thức ăn", "Chuyên nghiệp (Pro)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "13 MP", "Tính năng camera trước": ["Xóa phông", "Nhãn dán (AR Stickers)", "Làm đẹp"], "Công nghệ màn hình": "Super AMOLED", "Độ phân giải màn hình": "Full HD+ (1080 x 2340 Pixels)", "Màn hình rộng": "6.7 inch - Tần số quét  90 Hz", "Độ sáng tối đa": "800 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass Victus"}}, {"Pin & Sạc": {"Dung lượng pin": "5000 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "25 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay cạnh viền", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Trợ lý ảo Google Gemini", "Smart Switch (ứng dụng chuyển đổi dữ liệu)", "Khoanh tròn để tìm kiếm"], "Kháng nước, bụi": "IP54", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["WEBM", "MP4", "MKV", "M4V", "FLV", "AVI", "3GP", "3G2"], "Nghe nhạc": ["XMF", "WAV", "RTX", "RTTTL", "OTA", "OGG", "OGA", "Midi", "MXMF", "MP3", "M4A", "IMY", "FLAC", "AWB", "AMR", "AAC", "3GA"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 164.4 mm - Ngang 77.9 mm - Dày 7.5 mm - Nặng 192 g", "Thời điểm ra mắt": "08/2025"}}]'::jsonb,
        ARRAY['samsung-galaxy-a17-5g-blue-1-638925131696656582.jpg', 'samsung-galaxy-a17-5g-blue-2-638925131690626481.jpg', 'samsung-galaxy-a17-5g-blue-3-638925131684708037.jpg', 'samsung-galaxy-a17-5g-blue-4-638925131678564503.jpg', 'samsung-galaxy-a17-5g-blue-5-638925131671039031.jpg', 'samsung-galaxy-a17-5g-blue-6-638925131662985667.jpg', 'samsung-galaxy-a17-5g-blue-7-638925131656322668.jpg', 'samsung-galaxy-a17-5g-blue-8-638925131649869976.jpg', 'samsung-galaxy-a17-5g-blue-9-638925131642723426.jpg', 'samsung-galaxy-a17-5g-blue-10-638925131635801477.jpg', 'samsung-galaxy-a17-5g-blue-11-638925131626715565.jpg', 'samsung-galaxy-a17-5g-blue-12-638925131620135711.jpg', 'samsung-galaxy-a17-5g-blue-13-638925131613762964.jpg', 'galaxy-a17-5g-bbh-638925134517932426.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-2-638925131690626481.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-3-638925131684708037.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-4-638925131678564503.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-5-638925131671039031.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-6-638925131662985667.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-7-638925131656322668.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-8-638925131649869976.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-9-638925131642723426.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-10-638925131635801477.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-11-638925131626715565.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-12-638925131620135711.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-13-638925131613762964.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/galaxy-a17-5g-bbh-638925134517932426.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-1-638925131696656582.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 5
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'SAMSUNG_GALAXY_A17_5G_8GB_128GB_256GB_XANH_DUONG',
        'samsung-galaxy-a17-5g-8gb-128gb-256gb-xanh-duong',
        '{"color": "Xanh Dương", "storage": "256GB"}'::jsonb,
        6690000.0,
        7090000.0,
        807,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Exynos 1330", "Tốc độ CPU": "2 nhân 2.4 GHz & 6 nhân 2 GHz", "Chip đồ họa (GPU)": "Đang cập nhật", "RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "232 GB", "Thẻ nhớ": "MicroSD, hỗ trợ tối đa 2 TB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 5 MP, 2 MP", "Quay phim camera sau": ["HD 720p@120fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu cận (Macro)", "Quay chậm (Slow Motion)", "Làm đẹp", "Chống rung quang học (OIS)", "Chế độ thức ăn", "Chuyên nghiệp (Pro)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "13 MP", "Tính năng camera trước": ["Xóa phông", "Nhãn dán (AR Stickers)", "Làm đẹp"], "Công nghệ màn hình": "Super AMOLED", "Độ phân giải màn hình": "Full HD+ (1080 x 2340 Pixels)", "Màn hình rộng": "6.7 inch - Tần số quét  90 Hz", "Độ sáng tối đa": "800 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass Victus"}}, {"Pin & Sạc": {"Dung lượng pin": "5000 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "25 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay cạnh viền", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Trợ lý ảo Google Gemini", "Smart Switch (ứng dụng chuyển đổi dữ liệu)", "Khoanh tròn để tìm kiếm"], "Kháng nước, bụi": "IP54", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["WEBM", "MP4", "MKV", "M4V", "FLV", "AVI", "3GP", "3G2"], "Nghe nhạc": ["XMF", "WAV", "RTX", "RTTTL", "OTA", "OGG", "OGA", "Midi", "MXMF", "MP3", "M4A", "IMY", "FLAC", "AWB", "AMR", "AAC", "3GA"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 164.4 mm - Ngang 77.9 mm - Dày 7.5 mm - Nặng 192 g", "Thời điểm ra mắt": "08/2025"}}]'::jsonb,
        ARRAY['samsung-galaxy-a17-5g-blue-1-638925131696656582.jpg', 'samsung-galaxy-a17-5g-blue-2-638925131690626481.jpg', 'samsung-galaxy-a17-5g-blue-3-638925131684708037.jpg', 'samsung-galaxy-a17-5g-blue-4-638925131678564503.jpg', 'samsung-galaxy-a17-5g-blue-5-638925131671039031.jpg', 'samsung-galaxy-a17-5g-blue-6-638925131662985667.jpg', 'samsung-galaxy-a17-5g-blue-7-638925131656322668.jpg', 'samsung-galaxy-a17-5g-blue-8-638925131649869976.jpg', 'samsung-galaxy-a17-5g-blue-9-638925131642723426.jpg', 'samsung-galaxy-a17-5g-blue-10-638925131635801477.jpg', 'samsung-galaxy-a17-5g-blue-11-638925131626715565.jpg', 'samsung-galaxy-a17-5g-blue-12-638925131620135711.jpg', 'samsung-galaxy-a17-5g-blue-13-638925131613762964.jpg', 'galaxy-a17-5g-bbh-638925134517932426.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-2-638925131690626481.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-3-638925131684708037.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-4-638925131678564503.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-5-638925131671039031.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-6-638925131662985667.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-7-638925131656322668.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-8-638925131649869976.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-9-638925131642723426.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-10-638925131635801477.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-11-638925131626715565.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-12-638925131620135711.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-13-638925131613762964.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/galaxy-a17-5g-bbh-638925134517932426.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-1-638925131696656582.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 6
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'SAMSUNG_GALAXY_A17_5G_8GB_128GB_256GB_DEN',
        'samsung-galaxy-a17-5g-8gb-128gb-256gb-den',
        '{"color": "Đen", "storage": "256GB"}'::jsonb,
        6690000.0,
        7090000.0,
        632,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Exynos 1330", "Tốc độ CPU": "2 nhân 2.4 GHz & 6 nhân 2 GHz", "Chip đồ họa (GPU)": "Đang cập nhật", "RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "232 GB", "Thẻ nhớ": "MicroSD, hỗ trợ tối đa 2 TB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 5 MP, 2 MP", "Quay phim camera sau": ["HD 720p@120fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom kỹ thuật số", "Xóa phông", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu cận (Macro)", "Quay chậm (Slow Motion)", "Làm đẹp", "Chống rung quang học (OIS)", "Chế độ thức ăn", "Chuyên nghiệp (Pro)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "13 MP", "Tính năng camera trước": ["Xóa phông", "Nhãn dán (AR Stickers)", "Làm đẹp"], "Công nghệ màn hình": "Super AMOLED", "Độ phân giải màn hình": "Full HD+ (1080 x 2340 Pixels)", "Màn hình rộng": "6.7 inch - Tần số quét  90 Hz", "Độ sáng tối đa": "800 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass Victus"}}, {"Pin & Sạc": {"Dung lượng pin": "5000 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "25 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay cạnh viền", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Trợ lý ảo Google Gemini", "Smart Switch (ứng dụng chuyển đổi dữ liệu)", "Khoanh tròn để tìm kiếm"], "Kháng nước, bụi": "IP54", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["WEBM", "MP4", "MKV", "M4V", "FLV", "AVI", "3GP", "3G2"], "Nghe nhạc": ["XMF", "WAV", "RTX", "RTTTL", "OTA", "OGG", "OGA", "Midi", "MXMF", "MP3", "M4A", "IMY", "FLAC", "AWB", "AMR", "AAC", "3GA"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 164.4 mm - Ngang 77.9 mm - Dày 7.5 mm - Nặng 192 g", "Thời điểm ra mắt": "08/2025"}}]'::jsonb,
        ARRAY['samsung-galaxy-a17-5g-blue-1-638925131696656582.jpg', 'samsung-galaxy-a17-5g-blue-2-638925131690626481.jpg', 'samsung-galaxy-a17-5g-blue-3-638925131684708037.jpg', 'samsung-galaxy-a17-5g-blue-4-638925131678564503.jpg', 'samsung-galaxy-a17-5g-blue-5-638925131671039031.jpg', 'samsung-galaxy-a17-5g-blue-6-638925131662985667.jpg', 'samsung-galaxy-a17-5g-blue-7-638925131656322668.jpg', 'samsung-galaxy-a17-5g-blue-8-638925131649869976.jpg', 'samsung-galaxy-a17-5g-blue-9-638925131642723426.jpg', 'samsung-galaxy-a17-5g-blue-10-638925131635801477.jpg', 'samsung-galaxy-a17-5g-blue-11-638925131626715565.jpg', 'samsung-galaxy-a17-5g-blue-12-638925131620135711.jpg', 'samsung-galaxy-a17-5g-blue-13-638925131613762964.jpg', 'galaxy-a17-5g-bbh-638925134517932426.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-2-638925131690626481.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-3-638925131684708037.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-4-638925131678564503.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-5-638925131671039031.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-6-638925131662985667.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-7-638925131656322668.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-8-638925131649869976.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-9-638925131642723426.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-10-638925131635801477.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-11-638925131626715565.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-12-638925131620135711.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-13-638925131613762964.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/galaxy-a17-5g-bbh-638925134517932426.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-a17-5g-8gb-128gb/samsung-galaxy-a17-5g-blue-1-638925131696656582.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Điện thoại Samsung Galaxy S24 5G 8GB/256GB
-- Slug: samsung-galaxy-s24-256gb-5g
-- Variants: 4

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Điện thoại Samsung Galaxy S24 5G 8GB/256GB',
        'samsung-galaxy-s24-256gb-5g',
        8.0,
        2.0,
        'Trong sự kiện Unpacked 2024 diễn ra vào ngày 18/01, Samsung đã chính thức ra mắt chiếc điện thoại Samsung Galaxy S24 . Sản phẩm này mang đến nhiều cải tiến độc đáo, bao gồm việc sử dụng chip mới của Samsung, tích hợp nhiều tính năng thông minh sử dụng trí tuệ nhân tạo và cải thiện đáng kể hiệu suất chụp ảnh từ hệ thống camera.',
        '{"meta_title": "Samsung Galaxy S24 ưu đãi đến 7.5 triệu, thu cũ, mua trả chậm 0% lãi suất", "meta_description": "Samsung Galaxy S24 chính hãng giảm đến 3 tr hoặc thu cũ đến 5 tr.  Tặng Samsung Care+ 1 năm, Ốp lưng chính hãng, mua trả chậm 0% lãi suất. Mua ngay tại Thegioididong !", "meta_keywords": "Samsung Galaxy S24 chính hãng giảm đến 3 tr hoặc thu cũ đến 5 tr.  Tặng Samsung Care+ 1 năm, Ốp lưng chính hãng, mua trả chậm 0% lãi suất. Mua ngay tại Thegioididong !"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'SAMSUNG_GALAXY_S24_256GB_5G_VANG',
        'samsung-galaxy-s24-256gb-5g-vang',
        '{"color": "Vàng"}'::jsonb,
        16610000.0,
        20610000.0,
        834,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 14", "Chip xử lý (CPU)": "Exynos 2400 10 nhân", "Tốc độ CPU": "3.2 GHz", "Chip đồ họa (GPU)": "Xclipse 940", "RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "231.2 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 12 MP, 10 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "8K 4320p@30fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@120fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Video chân dung", "Video chuyên nghiệp", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu độ phân giải", "Quét mã QR", "Quay video hiển thị kép", "Quay chậm (Slow Motion)", "Quay Siêu chậm (Super Slow Motion)", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Chụp ảnh chuyển động", "Chụp một chạm", "Chụp hẹn giờ", "Chống rung quang học (OIS)", "Chống rung kỹ thuật số (VDIS)", "Chuyên nghiệp (Pro)", "Bộ lọc màu", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "12 MP", "Tính năng camera trước": ["Xóa phông", "Video chân dung", "Video chuyên nghiệp", "Trôi nhanh thời gian (Time Lapse)", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Làm đẹp", "Góc rộng (Wide)", "Flash màn hình", "Chụp ảnh chuyển động", "Chụp đêm", "Chụp hẹn giờ", "Chụp bằng cử chỉ", "Chân dung đêm", "Chuyên nghiệp (Pro)", "Bộ lọc màu"], "Công nghệ màn hình": "Dynamic AMOLED 2X", "Độ phân giải màn hình": "Full HD+ (1080 x 2340 Pixels)", "Màn hình rộng": "6.2 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "2600 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass Victus 2"}}, {"Pin & Sạc": {"Dung lượng pin": "4000 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "25 W", "Công nghệ pin": ["Sạc pin nhanh", "Sạc ngược không dây", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Ứng dụng kép (Dual Messenger)", "Đa cửa sổ (chia đôi màn hình)", "Âm thanh Dolby Atmos", "Âm thanh AKG", "Vision Booster", "Tối ưu game (Game Booster)", "Trợ lý ảo Samsung Bixby", "Trợ lý ảo Google Assistant", "Trợ lý note thông minh", "Trợ lý chỉnh ảnh", "Trợ lý chat thông minh", "Thu nhỏ màn hình sử dụng một tay", "Samsung Pay", "Samsung DeX (Kết nối màn hình sử dụng giao diện tương tự PC)", "Ray Tracing", "Phiên dịch trực tiếp", "Mở rộng bộ nhớ RAM", "Màn hình luôn hiển thị AOD", "Khoanh vùng search đa năng", "Hệ thống tản nhiệt Vapor Chamber", "DCI-P3", "Cử chỉ thông minh", "Chế độ đơn giản (Giao diện đơn giản)", "Chặn tin nhắn", "Chặn cuộc gọi", "Chạm 2 lần tắt/sáng màn hình", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["WEBM", "MP4", "MKV", "M4V", "FLV", "AV1", "3GP", "3G2"], "Nghe nhạc": ["XMF", "WAV", "RTX", "RTTTL", "OTA", "OGG", "OGA", "Midi", "MXMF", "MP3", "M4A", "IMY", "FLAC", "AWB", "APE", "AMR", "AAC", "3GA"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM hoặc 2 eSIM hoặc 1 Nano SIM + 1 eSIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung nhôm & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 147 mm - Ngang 70.6 mm - Dày 7.6 mm - Nặng 167 g", "Thời điểm ra mắt": "01/2024"}}]'::jsonb,
        ARRAY['samsung-galaxy-s24-vang-1.jpg', 'samsung-galaxy-s24-vang-2.jpg', 'samsung-galaxy-s24-vang-3.jpg', 'samsung-galaxy-s24-vang-4.jpg', 'samsung-galaxy-s24-vang-5.jpg', 'samsung-galaxy-s24-vang-6.jpg', 'samsung-galaxy-s24-vang-7.jpg', 'samsung-galaxy-s24-vang-8.jpg', 'samsung-galaxy-s24-vang-9.jpg', 'samsung-galaxy-s24-vang-10.jpg', 'samsung-galaxy-s24-vang-11.jpg', 'samsung-galaxy-s24-vang-12.jpg', 'samsung-galaxy-s24-5g-tem-99-638602867263937538.jpg', 'samsung-galaxy-s24-bbh-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-vang-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-vang-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-vang-4.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-vang-5.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-vang-6.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-vang-7.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-vang-8.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-vang-9.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-vang-10.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-vang-11.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-vang-12.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-5g-tem-99-638602867263937538.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-bbh-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-vang-1.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    -- Insert variant 2
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'SAMSUNG_GALAXY_S24_256GB_5G_XAM',
        'samsung-galaxy-s24-256gb-5g-xam',
        '{"color": "Xám"}'::jsonb,
        16610000.0,
        20610000.0,
        543,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 14", "Chip xử lý (CPU)": "Exynos 2400 10 nhân", "Tốc độ CPU": "3.2 GHz", "Chip đồ họa (GPU)": "Xclipse 940", "RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "231.2 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 12 MP, 10 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "8K 4320p@30fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@120fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Video chân dung", "Video chuyên nghiệp", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu độ phân giải", "Quét mã QR", "Quay video hiển thị kép", "Quay chậm (Slow Motion)", "Quay Siêu chậm (Super Slow Motion)", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Chụp ảnh chuyển động", "Chụp một chạm", "Chụp hẹn giờ", "Chống rung quang học (OIS)", "Chống rung kỹ thuật số (VDIS)", "Chuyên nghiệp (Pro)", "Bộ lọc màu", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "12 MP", "Tính năng camera trước": ["Xóa phông", "Video chân dung", "Video chuyên nghiệp", "Trôi nhanh thời gian (Time Lapse)", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Làm đẹp", "Góc rộng (Wide)", "Flash màn hình", "Chụp ảnh chuyển động", "Chụp đêm", "Chụp hẹn giờ", "Chụp bằng cử chỉ", "Chân dung đêm", "Chuyên nghiệp (Pro)", "Bộ lọc màu"], "Công nghệ màn hình": "Dynamic AMOLED 2X", "Độ phân giải màn hình": "Full HD+ (1080 x 2340 Pixels)", "Màn hình rộng": "6.2 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "2600 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass Victus 2"}}, {"Pin & Sạc": {"Dung lượng pin": "4000 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "25 W", "Công nghệ pin": ["Sạc pin nhanh", "Sạc ngược không dây", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Ứng dụng kép (Dual Messenger)", "Đa cửa sổ (chia đôi màn hình)", "Âm thanh Dolby Atmos", "Âm thanh AKG", "Vision Booster", "Tối ưu game (Game Booster)", "Trợ lý ảo Samsung Bixby", "Trợ lý ảo Google Assistant", "Trợ lý note thông minh", "Trợ lý chỉnh ảnh", "Trợ lý chat thông minh", "Thu nhỏ màn hình sử dụng một tay", "Samsung Pay", "Samsung DeX (Kết nối màn hình sử dụng giao diện tương tự PC)", "Ray Tracing", "Phiên dịch trực tiếp", "Mở rộng bộ nhớ RAM", "Màn hình luôn hiển thị AOD", "Khoanh vùng search đa năng", "Hệ thống tản nhiệt Vapor Chamber", "DCI-P3", "Cử chỉ thông minh", "Chế độ đơn giản (Giao diện đơn giản)", "Chặn tin nhắn", "Chặn cuộc gọi", "Chạm 2 lần tắt/sáng màn hình", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["WEBM", "MP4", "MKV", "M4V", "FLV", "AV1", "3GP", "3G2"], "Nghe nhạc": ["XMF", "WAV", "RTX", "RTTTL", "OTA", "OGG", "OGA", "Midi", "MXMF", "MP3", "M4A", "IMY", "FLAC", "AWB", "APE", "AMR", "AAC", "3GA"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM hoặc 2 eSIM hoặc 1 Nano SIM + 1 eSIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung nhôm & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 147 mm - Ngang 70.6 mm - Dày 7.6 mm - Nặng 167 g", "Thời điểm ra mắt": "01/2024"}}]'::jsonb,
        ARRAY['samsung-galaxy-s24-xam-1.jpg', 'samsung-galaxy-s24-xam-2.jpg', 'samsung-galaxy-s24-xam-3.jpg', 'samsung-galaxy-s24-5g-tem-99-638602866857377522.jpg', 'samsung-galaxy-s24-bbh-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-xam-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-xam-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-5g-tem-99-638602866857377522.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-bbh-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-xam-1.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 3
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'SAMSUNG_GALAXY_S24_256GB_5G_DEN',
        'samsung-galaxy-s24-256gb-5g-den',
        '{"color": "Đen"}'::jsonb,
        16610000.0,
        20610000.0,
        820,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 14", "Chip xử lý (CPU)": "Exynos 2400 10 nhân", "Tốc độ CPU": "3.2 GHz", "Chip đồ họa (GPU)": "Xclipse 940", "RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "231.2 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 12 MP, 10 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "8K 4320p@30fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@120fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Video chân dung", "Video chuyên nghiệp", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu độ phân giải", "Quét mã QR", "Quay video hiển thị kép", "Quay chậm (Slow Motion)", "Quay Siêu chậm (Super Slow Motion)", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Chụp ảnh chuyển động", "Chụp một chạm", "Chụp hẹn giờ", "Chống rung quang học (OIS)", "Chống rung kỹ thuật số (VDIS)", "Chuyên nghiệp (Pro)", "Bộ lọc màu", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "12 MP", "Tính năng camera trước": ["Xóa phông", "Video chân dung", "Video chuyên nghiệp", "Trôi nhanh thời gian (Time Lapse)", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Làm đẹp", "Góc rộng (Wide)", "Flash màn hình", "Chụp ảnh chuyển động", "Chụp đêm", "Chụp hẹn giờ", "Chụp bằng cử chỉ", "Chân dung đêm", "Chuyên nghiệp (Pro)", "Bộ lọc màu"], "Công nghệ màn hình": "Dynamic AMOLED 2X", "Độ phân giải màn hình": "Full HD+ (1080 x 2340 Pixels)", "Màn hình rộng": "6.2 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "2600 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass Victus 2"}}, {"Pin & Sạc": {"Dung lượng pin": "4000 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "25 W", "Công nghệ pin": ["Sạc pin nhanh", "Sạc ngược không dây", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Ứng dụng kép (Dual Messenger)", "Đa cửa sổ (chia đôi màn hình)", "Âm thanh Dolby Atmos", "Âm thanh AKG", "Vision Booster", "Tối ưu game (Game Booster)", "Trợ lý ảo Samsung Bixby", "Trợ lý ảo Google Assistant", "Trợ lý note thông minh", "Trợ lý chỉnh ảnh", "Trợ lý chat thông minh", "Thu nhỏ màn hình sử dụng một tay", "Samsung Pay", "Samsung DeX (Kết nối màn hình sử dụng giao diện tương tự PC)", "Ray Tracing", "Phiên dịch trực tiếp", "Mở rộng bộ nhớ RAM", "Màn hình luôn hiển thị AOD", "Khoanh vùng search đa năng", "Hệ thống tản nhiệt Vapor Chamber", "DCI-P3", "Cử chỉ thông minh", "Chế độ đơn giản (Giao diện đơn giản)", "Chặn tin nhắn", "Chặn cuộc gọi", "Chạm 2 lần tắt/sáng màn hình", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["WEBM", "MP4", "MKV", "M4V", "FLV", "AV1", "3GP", "3G2"], "Nghe nhạc": ["XMF", "WAV", "RTX", "RTTTL", "OTA", "OGG", "OGA", "Midi", "MXMF", "MP3", "M4A", "IMY", "FLAC", "AWB", "APE", "AMR", "AAC", "3GA"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM hoặc 2 eSIM hoặc 1 Nano SIM + 1 eSIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung nhôm & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 147 mm - Ngang 70.6 mm - Dày 7.6 mm - Nặng 167 g", "Thời điểm ra mắt": "01/2024"}}]'::jsonb,
        ARRAY['samsung-galaxy-s24-den-1.jpg', 'samsung-galaxy-s24-den-2.jpg', 'samsung-galaxy-s24-den-3.jpg', 'samsung-galaxy-s24-5g-tem-99-638602865590894653.jpg', 'samsung-galaxy-s24-bbh-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-den-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-den-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-5g-tem-99-638602865590894653.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-bbh-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-den-1.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 4
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'SAMSUNG_GALAXY_S24_256GB_5G_TIM',
        'samsung-galaxy-s24-256gb-5g-tim',
        '{"color": "Tím"}'::jsonb,
        16610000.0,
        20610000.0,
        470,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 14", "Chip xử lý (CPU)": "Exynos 2400 10 nhân", "Tốc độ CPU": "3.2 GHz", "Chip đồ họa (GPU)": "Xclipse 940", "RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "231.2 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 12 MP, 10 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "8K 4320p@30fps", "4K 2160p@60fps", "4K 2160p@30fps", "4K 2160p@120fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Ảnh Raw", "Zoom quang học", "Zoom kỹ thuật số", "Xóa phông", "Video chân dung", "Video chuyên nghiệp", "Tự động lấy nét (AF)", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu độ phân giải", "Quét mã QR", "Quay video hiển thị kép", "Quay chậm (Slow Motion)", "Quay Siêu chậm (Super Slow Motion)", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Chụp ảnh chuyển động", "Chụp một chạm", "Chụp hẹn giờ", "Chống rung quang học (OIS)", "Chống rung kỹ thuật số (VDIS)", "Chuyên nghiệp (Pro)", "Bộ lọc màu", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "12 MP", "Tính năng camera trước": ["Xóa phông", "Video chân dung", "Video chuyên nghiệp", "Trôi nhanh thời gian (Time Lapse)", "Quay video HD", "Quay video Full HD", "Quay video 4K", "Quay chậm (Slow Motion)", "Nhãn dán (AR Stickers)", "Làm đẹp", "Góc rộng (Wide)", "Flash màn hình", "Chụp ảnh chuyển động", "Chụp đêm", "Chụp hẹn giờ", "Chụp bằng cử chỉ", "Chân dung đêm", "Chuyên nghiệp (Pro)", "Bộ lọc màu"], "Công nghệ màn hình": "Dynamic AMOLED 2X", "Độ phân giải màn hình": "Full HD+ (1080 x 2340 Pixels)", "Màn hình rộng": "6.2 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "2600 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass Victus 2"}}, {"Pin & Sạc": {"Dung lượng pin": "4000 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "25 W", "Công nghệ pin": ["Sạc pin nhanh", "Sạc ngược không dây", "Sạc không dây"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Ứng dụng kép (Dual Messenger)", "Đa cửa sổ (chia đôi màn hình)", "Âm thanh Dolby Atmos", "Âm thanh AKG", "Vision Booster", "Tối ưu game (Game Booster)", "Trợ lý ảo Samsung Bixby", "Trợ lý ảo Google Assistant", "Trợ lý note thông minh", "Trợ lý chỉnh ảnh", "Trợ lý chat thông minh", "Thu nhỏ màn hình sử dụng một tay", "Samsung Pay", "Samsung DeX (Kết nối màn hình sử dụng giao diện tương tự PC)", "Ray Tracing", "Phiên dịch trực tiếp", "Mở rộng bộ nhớ RAM", "Màn hình luôn hiển thị AOD", "Khoanh vùng search đa năng", "Hệ thống tản nhiệt Vapor Chamber", "DCI-P3", "Cử chỉ thông minh", "Chế độ đơn giản (Giao diện đơn giản)", "Chặn tin nhắn", "Chặn cuộc gọi", "Chạm 2 lần tắt/sáng màn hình", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["WEBM", "MP4", "MKV", "M4V", "FLV", "AV1", "3GP", "3G2"], "Nghe nhạc": ["XMF", "WAV", "RTX", "RTTTL", "OTA", "OGG", "OGA", "Midi", "MXMF", "MP3", "M4A", "IMY", "FLAC", "AWB", "APE", "AMR", "AAC", "3GA"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM hoặc 2 eSIM hoặc 1 Nano SIM + 1 eSIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Kết nối khác": "NFC"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung nhôm & Mặt lưng kính cường lực", "Kích thước, khối lượng": "Dài 147 mm - Ngang 70.6 mm - Dày 7.6 mm - Nặng 167 g", "Thời điểm ra mắt": "01/2024"}}]'::jsonb,
        ARRAY['samsung-galaxy-s24-tim-1.jpg', 'samsung-galaxy-s24-tim-2.jpg', 'samsung-galaxy-s24-tim-3.jpg', 'samsung-galaxy-s24-5g-tem-99-638602866247247706.jpg', 'samsung-galaxy-s24-bbh-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-tim-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-tim-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-5g-tem-99-638602866247247706.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-bbh-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-s24-256gb-5g/samsung-galaxy-s24-tim-1.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Điện thoại vivo V50 Lite 5G 8GB/256GB
-- Slug: vivo-v50-lite-5g
-- Variants: 6

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Điện thoại vivo V50 Lite 5G 8GB/256GB',
        'vivo-v50-lite-5g',
        9.0,
        2.0,
        'vivo V50 Lite 5G là sự hòa quyện tinh tế giữa vẻ ngoài thanh lịch và sức mạnh hiệu năng bên trong, khi được trang bị viên pin khủng 6500 mAh, CPU MediaTek mạnh mẽ, hệ thống camera sắc nét, màn hình hiển thị ấn tượng,... hứa hẹn mang đến một trải nghiệm công nghệ toàn diện, đáp ứng trọn vẹn mọi yêu cầu của người dùng hiện đại.',
        '{"meta_title": "vivo V50 Lite 5G chính hãng, thu cũ trợ giá đến 1 triệu", "meta_description": "vivo V50 Lite 5G 8GB/256GB chính hãng, đặc quyền, giá tốt, thu cũ đổi mới trợ giá đến 1 triệu, giảm ngay 300K hoặc tặng PMH mua phụ kiện, bảo hành 24 tháng. Mua ngay!", "meta_keywords": "vivo v50, vivo v50 lite, vivo v50 lite 5g, v50, v50 lite"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'VIVO_V50_LITE_5G_8GB_VANG',
        'vivo-v50-lite-5g-8gb-vang',
        '{"color": "Vàng", "memory": "8GB"}'::jsonb,
        9810000.0,
        NULL,
        580,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "MediaTek Dimensity 6300 5G 8 nhân", "Tốc độ CPU": "2 nhân 2.4 GHz & 6 nhân 2 GHz", "Chip đồ họa (GPU)": "Mali-G57", "RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 8 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu độ phân giải", "Siêu trăng", "Quét tài liệu", "Quay video hiển thị kép", "Quay chậm (Slow Motion)", "Làm đẹp", "Live Photos", "Chuyên nghiệp (Pro)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "32 MP", "Tính năng camera trước": ["Xóa phông", "Video hiển thị kép", "Quay video Full HD", "Làm đẹp", "Live Photos", "Chụp đêm"], "Công nghệ màn hình": "AMOLED", "Độ phân giải màn hình": "Full HD+ (1080 x 2392 Pixels)", "Màn hình rộng": "6.77 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "1800 nits", "Mặt kính cảm ứng": "Kính cường lực Shield"}}, {"Pin & Sạc": {"Dung lượng pin": "6500 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "90 W", "Sạc kèm theo máy": "90 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Ứng dụng kép (Nhân bản ứng dụng)", "Độ bền chuẩn quân đội MIL-STD 810H", "Đạt chuẩn chống va đập 5 sao SGS", "Âm thanh Hi-Res Audio", "Âm thanh AKG", "Xoá vật thể AI", "Tăng cường hình ảnh AI", "Phiên dịch AI", "Mở rộng bộ nhớ RAM", "Khoanh tròn để tìm kiếm", "DCI-P3", "Công nghệ tản nhiệt LiquidCool", "Loa kép"], "Kháng nước, bụi": "IP65", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["WEBM", "TS", "MP4", "MKV", "FLV", "AVI", "ASF", "3GP"], "Nghe nhạc": ["WAV", "Vorbis", "OGG", "Midi", "MP3", "FLAC", "APE", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["GPS", "GLONASS", "BEIDOU"], "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "NFC"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 163.77 mm - Ngang 76.28 mm - Dày 7.79 mm - Nặng 197 g", "Thời điểm ra mắt": "05/2025"}}]'::jsonb,
        ARRAY['vivo-v50-lite-vang-1-638802429895880879.jpg', 'vivo-v50-lite-vang-2-638802429902531062.jpg', 'vivo-v50-lite-vang-3-638802429908016713.jpg', 'vivo-v50-lite-vang-4-638802429913419804.jpg', 'vivo-v50-lite-vang-5-638802429919526811.jpg', 'vivo-v50-lite-vang-6-638802429925608889.jpg', 'vivo-v50-lite-vang-7-638802429931408167.jpg', 'vivo-v50-lite-vang-8-638802429938328353.jpg', 'vivo-v50-lite-vang-9-638802429944134979.jpg', 'vivo-v50-lite-vang-10-638802429954419957.jpg', 'vivo-v50-lite-vang-11-638802429960773493.jpg', 'vivo-v50-lite-vang-12-638802429967599591.jpg', 'vivo-v50-lite-tem-99-638802432912212984.jpg', 'vivo-v50-lite-mohop-638802436632910834.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-vang-2-638802429902531062.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-vang-3-638802429908016713.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-vang-4-638802429913419804.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-vang-5-638802429919526811.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-vang-6-638802429925608889.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-vang-7-638802429931408167.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-vang-8-638802429938328353.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-vang-9-638802429944134979.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-vang-10-638802429954419957.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-vang-11-638802429960773493.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-vang-12-638802429967599591.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-tem-99-638802432912212984.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-mohop-638802436632910834.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-vang-1-638802429895880879.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    -- Insert variant 2
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'VIVO_V50_LITE_5G_8GB_DEN',
        'vivo-v50-lite-5g-8gb-den',
        '{"color": "Đen", "memory": "8GB"}'::jsonb,
        9810000.0,
        NULL,
        828,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "MediaTek Dimensity 6300 5G 8 nhân", "Tốc độ CPU": "2 nhân 2.4 GHz & 6 nhân 2 GHz", "Chip đồ họa (GPU)": "Mali-G57", "RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 8 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu độ phân giải", "Siêu trăng", "Quét tài liệu", "Quay video hiển thị kép", "Quay chậm (Slow Motion)", "Làm đẹp", "Live Photos", "Chuyên nghiệp (Pro)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "32 MP", "Tính năng camera trước": ["Xóa phông", "Video hiển thị kép", "Quay video Full HD", "Làm đẹp", "Live Photos", "Chụp đêm"], "Công nghệ màn hình": "AMOLED", "Độ phân giải màn hình": "Full HD+ (1080 x 2392 Pixels)", "Màn hình rộng": "6.77 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "1800 nits", "Mặt kính cảm ứng": "Kính cường lực Shield"}}, {"Pin & Sạc": {"Dung lượng pin": "6500 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "90 W", "Sạc kèm theo máy": "90 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Ứng dụng kép (Nhân bản ứng dụng)", "Độ bền chuẩn quân đội MIL-STD 810H", "Đạt chuẩn chống va đập 5 sao SGS", "Âm thanh Hi-Res Audio", "Âm thanh AKG", "Xoá vật thể AI", "Tăng cường hình ảnh AI", "Phiên dịch AI", "Mở rộng bộ nhớ RAM", "Khoanh tròn để tìm kiếm", "DCI-P3", "Công nghệ tản nhiệt LiquidCool", "Loa kép"], "Kháng nước, bụi": "IP65", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["WEBM", "TS", "MP4", "MKV", "FLV", "AVI", "ASF", "3GP"], "Nghe nhạc": ["WAV", "Vorbis", "OGG", "Midi", "MP3", "FLAC", "APE", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["GPS", "GLONASS", "BEIDOU"], "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "NFC"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 163.77 mm - Ngang 76.28 mm - Dày 7.79 mm - Nặng 197 g", "Thời điểm ra mắt": "05/2025"}}]'::jsonb,
        ARRAY['vivo-v50-lite-black-purple-1-638802428867069645.jpg', 'vivo-v50-lite-black-purple-2-638802428873498326.jpg', 'vivo-v50-lite-black-purple-3-638802428879327760.jpg', 'vivo-v50-lite-black-purple-4-638802428885220866.jpg', 'vivo-v50-lite-black-purple-5-638802428890399992.jpg', 'vivo-v50-lite-black-purple-6-638802428896536117.jpg', 'vivo-v50-lite-black-purple-7-638802428902209171.jpg', 'vivo-v50-lite-black-purple-8-638802428908758867.jpg', 'vivo-v50-lite-black-purple-9-638802428914673060.jpg', 'vivo-v50-lite-black-purple-10-638802428922853198.jpg', 'vivo-v50-lite-black-purple-11-638802428929231789.jpg', 'vivo-v50-lite-black-purple-12-638802428934542046.jpg', 'vivo-v50-lite-tem-99-638802433109877082.jpg', 'vivo-v50-lite-mohop-638802436632910834.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-2-638802428873498326.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-3-638802428879327760.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-4-638802428885220866.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-5-638802428890399992.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-6-638802428896536117.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-7-638802428902209171.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-8-638802428908758867.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-9-638802428914673060.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-10-638802428922853198.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-11-638802428929231789.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-12-638802428934542046.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-tem-99-638802433109877082.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-mohop-638802436632910834.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-1-638802428867069645.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 3
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'VIVO_V50_LITE_5G_8GB_TIM',
        'vivo-v50-lite-5g-8gb-tim',
        '{"color": "Tím", "memory": "8GB"}'::jsonb,
        9810000.0,
        NULL,
        802,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "MediaTek Dimensity 6300 5G 8 nhân", "Tốc độ CPU": "2 nhân 2.4 GHz & 6 nhân 2 GHz", "Chip đồ họa (GPU)": "Mali-G57", "RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 8 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu độ phân giải", "Siêu trăng", "Quét tài liệu", "Quay video hiển thị kép", "Quay chậm (Slow Motion)", "Làm đẹp", "Live Photos", "Chuyên nghiệp (Pro)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "32 MP", "Tính năng camera trước": ["Xóa phông", "Video hiển thị kép", "Quay video Full HD", "Làm đẹp", "Live Photos", "Chụp đêm"], "Công nghệ màn hình": "AMOLED", "Độ phân giải màn hình": "Full HD+ (1080 x 2392 Pixels)", "Màn hình rộng": "6.77 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "1800 nits", "Mặt kính cảm ứng": "Kính cường lực Shield"}}, {"Pin & Sạc": {"Dung lượng pin": "6500 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "90 W", "Sạc kèm theo máy": "90 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Ứng dụng kép (Nhân bản ứng dụng)", "Độ bền chuẩn quân đội MIL-STD 810H", "Đạt chuẩn chống va đập 5 sao SGS", "Âm thanh Hi-Res Audio", "Âm thanh AKG", "Xoá vật thể AI", "Tăng cường hình ảnh AI", "Phiên dịch AI", "Mở rộng bộ nhớ RAM", "Khoanh tròn để tìm kiếm", "DCI-P3", "Công nghệ tản nhiệt LiquidCool", "Loa kép"], "Kháng nước, bụi": "IP65", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["WEBM", "TS", "MP4", "MKV", "FLV", "AVI", "ASF", "3GP"], "Nghe nhạc": ["WAV", "Vorbis", "OGG", "Midi", "MP3", "FLAC", "APE", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["GPS", "GLONASS", "BEIDOU"], "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "NFC"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 163.77 mm - Ngang 76.28 mm - Dày 7.79 mm - Nặng 197 g", "Thời điểm ra mắt": "05/2025"}}]'::jsonb,
        ARRAY['vivo-v50-lite-purple-1-638802423130694433.jpg', 'vivo-v50-lite-purple-2-638802423140083452.jpg', 'vivo-v50-lite-purple-3-638802423146473312.jpg', 'vivo-v50-lite-purple-4-638802423153169910.jpg', 'vivo-v50-lite-purple-5-638802423159729896.jpg', 'vivo-v50-lite-purple-6-638802423165684357.jpg', 'vivo-v50-lite-purple-7-638802423172280706.jpg', 'vivo-v50-lite-purple-8-638802423179426602.jpg', 'vivo-v50-lite-purple-9-638802423185513179.jpg', 'vivo-v50-lite-purple-10-638802423192104290.jpg', 'vivo-v50-lite-purple-11-638802423198808231.jpg', 'vivo-v50-lite-purple-12-638802423205475106.jpg', 'vivo-v50-lite-tem-99-638802433349305304.jpg', 'vivo-v50-lite-mohop-638802436632910834.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-purple-2-638802423140083452.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-purple-3-638802423146473312.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-purple-4-638802423153169910.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-purple-5-638802423159729896.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-purple-6-638802423165684357.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-purple-7-638802423172280706.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-purple-8-638802423179426602.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-purple-9-638802423185513179.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-purple-10-638802423192104290.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-purple-11-638802423198808231.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-purple-12-638802423205475106.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-tem-99-638802433349305304.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-mohop-638802436632910834.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-purple-1-638802423130694433.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 4
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'VIVO_V50_LITE_5G_12GB_VANG',
        'vivo-v50-lite-5g-12gb-vang',
        '{"color": "Vàng", "memory": "12GB"}'::jsonb,
        10800000.0,
        NULL,
        81,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "MediaTek Dimensity 6300 5G 8 nhân", "Tốc độ CPU": "2 nhân 2.4 GHz & 6 nhân 2 GHz", "Chip đồ họa (GPU)": "Mali-G57", "RAM": "12 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 8 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu độ phân giải", "Siêu trăng", "Quét tài liệu", "Quay video hiển thị kép", "Quay chậm (Slow Motion)", "Làm đẹp", "Live Photos", "Chuyên nghiệp (Pro)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "32 MP", "Tính năng camera trước": ["Xóa phông", "Video hiển thị kép", "Quay video Full HD", "Làm đẹp", "Live Photos", "Chụp đêm"], "Công nghệ màn hình": "AMOLED", "Độ phân giải màn hình": "Full HD+ (1080 x 2392 Pixels)", "Màn hình rộng": "6.77 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "1800 nits", "Mặt kính cảm ứng": "Kính cường lực Shield"}}, {"Pin & Sạc": {"Dung lượng pin": "6500 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "90 W", "Sạc kèm theo máy": "90 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Ứng dụng kép (Nhân bản ứng dụng)", "Độ bền chuẩn quân đội MIL-STD 810H", "Đạt chuẩn chống va đập 5 sao SGS", "Âm thanh Hi-Res Audio", "Âm thanh AKG", "Xoá vật thể AI", "Tăng cường hình ảnh AI", "Phiên dịch AI", "Mở rộng bộ nhớ RAM", "Khoanh tròn để tìm kiếm", "DCI-P3", "Công nghệ tản nhiệt LiquidCool", "Loa kép"], "Kháng nước, bụi": "IP65", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["WEBM", "TS", "MP4", "MKV", "FLV", "AVI", "ASF", "3GP"], "Nghe nhạc": ["WAV", "Vorbis", "OGG", "Midi", "MP3", "FLAC", "APE", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["GPS", "GLONASS", "BEIDOU"], "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "NFC"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 163.77 mm - Ngang 76.28 mm - Dày 7.79 mm - Nặng 197 g", "Thời điểm ra mắt": "05/2025"}}]'::jsonb,
        ARRAY['vivo-v50-lite-black-purple-1-638802429034116542.jpg', 'vivo-v50-lite-black-purple-2-638802429040901979.jpg', 'vivo-v50-lite-black-purple-3-638802429047771840.jpg', 'vivo-v50-lite-black-purple-4-638802429055611623.jpg', 'vivo-v50-lite-black-purple-5-638802429061428961.jpg', 'vivo-v50-lite-black-purple-6-638802429067533664.jpg', 'vivo-v50-lite-black-purple-7-638802429076727865.jpg', 'vivo-v50-lite-black-purple-8-638802429082949298.jpg', 'vivo-v50-lite-black-purple-9-638802429089169414.jpg', 'vivo-v50-lite-black-purple-10-638802429095453606.jpg', 'vivo-v50-lite-black-purple-11-638802429102633027.jpg', 'vivo-v50-lite-black-purple-12-638802429109568320.jpg', 'vivo-v50-lite-tem-99-638802433022737236.jpg', 'vivo-v50-lite-mohop-638802500336722864.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-2-638802429040901979.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-3-638802429047771840.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-4-638802429055611623.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-5-638802429061428961.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-6-638802429067533664.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-7-638802429076727865.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-8-638802429082949298.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-9-638802429089169414.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-10-638802429095453606.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-11-638802429102633027.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-12-638802429109568320.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-tem-99-638802433022737236.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-mohop-638802500336722864.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-1-638802429034116542.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 5
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'VIVO_V50_LITE_5G_12GB_DEN',
        'vivo-v50-lite-5g-12gb-den',
        '{"color": "Đen", "memory": "12GB"}'::jsonb,
        10800000.0,
        NULL,
        495,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "MediaTek Dimensity 6300 5G 8 nhân", "Tốc độ CPU": "2 nhân 2.4 GHz & 6 nhân 2 GHz", "Chip đồ họa (GPU)": "Mali-G57", "RAM": "12 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 8 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu độ phân giải", "Siêu trăng", "Quét tài liệu", "Quay video hiển thị kép", "Quay chậm (Slow Motion)", "Làm đẹp", "Live Photos", "Chuyên nghiệp (Pro)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "32 MP", "Tính năng camera trước": ["Xóa phông", "Video hiển thị kép", "Quay video Full HD", "Làm đẹp", "Live Photos", "Chụp đêm"], "Công nghệ màn hình": "AMOLED", "Độ phân giải màn hình": "Full HD+ (1080 x 2392 Pixels)", "Màn hình rộng": "6.77 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "1800 nits", "Mặt kính cảm ứng": "Kính cường lực Shield"}}, {"Pin & Sạc": {"Dung lượng pin": "6500 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "90 W", "Sạc kèm theo máy": "90 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Ứng dụng kép (Nhân bản ứng dụng)", "Độ bền chuẩn quân đội MIL-STD 810H", "Đạt chuẩn chống va đập 5 sao SGS", "Âm thanh Hi-Res Audio", "Âm thanh AKG", "Xoá vật thể AI", "Tăng cường hình ảnh AI", "Phiên dịch AI", "Mở rộng bộ nhớ RAM", "Khoanh tròn để tìm kiếm", "DCI-P3", "Công nghệ tản nhiệt LiquidCool", "Loa kép"], "Kháng nước, bụi": "IP65", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["WEBM", "TS", "MP4", "MKV", "FLV", "AVI", "ASF", "3GP"], "Nghe nhạc": ["WAV", "Vorbis", "OGG", "Midi", "MP3", "FLAC", "APE", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["GPS", "GLONASS", "BEIDOU"], "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "NFC"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 163.77 mm - Ngang 76.28 mm - Dày 7.79 mm - Nặng 197 g", "Thời điểm ra mắt": "05/2025"}}]'::jsonb,
        ARRAY['vivo-v50-lite-black-purple-1-638802429034116542.jpg', 'vivo-v50-lite-black-purple-2-638802429040901979.jpg', 'vivo-v50-lite-black-purple-3-638802429047771840.jpg', 'vivo-v50-lite-black-purple-4-638802429055611623.jpg', 'vivo-v50-lite-black-purple-5-638802429061428961.jpg', 'vivo-v50-lite-black-purple-6-638802429067533664.jpg', 'vivo-v50-lite-black-purple-7-638802429076727865.jpg', 'vivo-v50-lite-black-purple-8-638802429082949298.jpg', 'vivo-v50-lite-black-purple-9-638802429089169414.jpg', 'vivo-v50-lite-black-purple-10-638802429095453606.jpg', 'vivo-v50-lite-black-purple-11-638802429102633027.jpg', 'vivo-v50-lite-black-purple-12-638802429109568320.jpg', 'vivo-v50-lite-tem-99-638802433022737236.jpg', 'vivo-v50-lite-mohop-638802500336722864.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-2-638802429040901979.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-3-638802429047771840.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-4-638802429055611623.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-5-638802429061428961.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-6-638802429067533664.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-7-638802429076727865.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-8-638802429082949298.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-9-638802429089169414.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-10-638802429095453606.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-11-638802429102633027.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-12-638802429109568320.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-tem-99-638802433022737236.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-mohop-638802500336722864.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-1-638802429034116542.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 6
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'VIVO_V50_LITE_5G_12GB_TIM',
        'vivo-v50-lite-5g-12gb-tim',
        '{"color": "Tím", "memory": "12GB"}'::jsonb,
        10800000.0,
        NULL,
        964,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "MediaTek Dimensity 6300 5G 8 nhân", "Tốc độ CPU": "2 nhân 2.4 GHz & 6 nhân 2 GHz", "Chip đồ họa (GPU)": "Mali-G57", "RAM": "12 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ 8 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu độ phân giải", "Siêu trăng", "Quét tài liệu", "Quay video hiển thị kép", "Quay chậm (Slow Motion)", "Làm đẹp", "Live Photos", "Chuyên nghiệp (Pro)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "32 MP", "Tính năng camera trước": ["Xóa phông", "Video hiển thị kép", "Quay video Full HD", "Làm đẹp", "Live Photos", "Chụp đêm"], "Công nghệ màn hình": "AMOLED", "Độ phân giải màn hình": "Full HD+ (1080 x 2392 Pixels)", "Màn hình rộng": "6.77 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "1800 nits", "Mặt kính cảm ứng": "Kính cường lực Shield"}}, {"Pin & Sạc": {"Dung lượng pin": "6500 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "90 W", "Sạc kèm theo máy": "90 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Ứng dụng kép (Nhân bản ứng dụng)", "Độ bền chuẩn quân đội MIL-STD 810H", "Đạt chuẩn chống va đập 5 sao SGS", "Âm thanh Hi-Res Audio", "Âm thanh AKG", "Xoá vật thể AI", "Tăng cường hình ảnh AI", "Phiên dịch AI", "Mở rộng bộ nhớ RAM", "Khoanh tròn để tìm kiếm", "DCI-P3", "Công nghệ tản nhiệt LiquidCool", "Loa kép"], "Kháng nước, bụi": "IP65", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": ["WEBM", "TS", "MP4", "MKV", "FLV", "AVI", "ASF", "3GP"], "Nghe nhạc": ["WAV", "Vorbis", "OGG", "Midi", "MP3", "FLAC", "APE", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["GPS", "GLONASS", "BEIDOU"], "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "NFC"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 163.77 mm - Ngang 76.28 mm - Dày 7.79 mm - Nặng 197 g", "Thời điểm ra mắt": "05/2025"}}]'::jsonb,
        ARRAY['vivo-v50-lite-black-purple-1-638802429034116542.jpg', 'vivo-v50-lite-black-purple-2-638802429040901979.jpg', 'vivo-v50-lite-black-purple-3-638802429047771840.jpg', 'vivo-v50-lite-black-purple-4-638802429055611623.jpg', 'vivo-v50-lite-black-purple-5-638802429061428961.jpg', 'vivo-v50-lite-black-purple-6-638802429067533664.jpg', 'vivo-v50-lite-black-purple-7-638802429076727865.jpg', 'vivo-v50-lite-black-purple-8-638802429082949298.jpg', 'vivo-v50-lite-black-purple-9-638802429089169414.jpg', 'vivo-v50-lite-black-purple-10-638802429095453606.jpg', 'vivo-v50-lite-black-purple-11-638802429102633027.jpg', 'vivo-v50-lite-black-purple-12-638802429109568320.jpg', 'vivo-v50-lite-tem-99-638802433022737236.jpg', 'vivo-v50-lite-mohop-638802500336722864.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-2-638802429040901979.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-3-638802429047771840.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-4-638802429055611623.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-5-638802429061428961.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-6-638802429067533664.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-7-638802429076727865.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-8-638802429082949298.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-9-638802429089169414.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-10-638802429095453606.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-11-638802429102633027.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-12-638802429109568320.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-tem-99-638802433022737236.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-mohop-638802500336722864.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-v50-lite-5g/vivo-v50-lite-black-purple-1-638802429034116542.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Điện thoại vivo Y03 4GB/128GB
-- Slug: vivo-y03
-- Variants: 2

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Điện thoại vivo Y03 4GB/128GB',
        'vivo-y03',
        9.0,
        2.0,
        'vivo Y03 tiếp tục là một mẫu điện thoại giá rẻ được vivo ra mắt tại thị trường Việt Nam. Sản phẩm lần này mang đến một diện mạo đẹp mắt hơn các phiên bản trước đó, tiếp đến là cấu hình nâng cấp cùng viên pin lớn 5000 mAh.',
        '{"meta_title": "vivo Y03 128GB mới giá rẻ, chính hãng, hư gì đổi nấy 1 năm, giao nhanh", "meta_description": "Điện thoại vivo Y03 128GB giá rẻ, có mua trả chậm, bảo hành chính hãng 1 năm hư gì đổi nấy, dung lượng lưu trữ và pin lớn, cấu hình vượt tầm giá, giao hàng nhanh. Mua ngay!", "meta_keywords": "Điện thoại vivo Y03 128GB giá rẻ, có mua trả chậm, bảo hành chính hãng 1 năm hư gì đổi nấy, dung lượng lưu trữ và pin lớn, cấu hình vượt tầm giá, giao hàng nhanh. Mua ngay!"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'VIVO_Y03_XANH',
        'vivo-y03-xanh',
        '{"color": "Xanh"}'::jsonb,
        3240000.0,
        NULL,
        559,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 14", "Chip xử lý (CPU)": "MediaTek Helio G85", "Tốc độ CPU": "2 nhân 2.0 GHz & 6 nhân 1.8 GHz", "Chip đồ họa (GPU)": "Mali-G52", "RAM": "4 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "111 GB", "Thẻ nhớ": "MicroSD, hỗ trợ tối đa 1 TB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 13 MP & Phụ 0.08 MP", "Quay phim camera sau": ["HD 720p@30fps", "HD 720p@120fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Quét tài liệu", "Quay chậm (Slow Motion)", "Làm đẹp", "HDR", "Google Lens", "Chụp ảnh chuyển động", "Chụp hẹn giờ", "Chuyên nghiệp (Pro)", "Bộ lọc màu", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "5 MP", "Tính năng camera trước": ["Xóa phông", "Quay video HD", "Quay video Full HD", "Làm đẹp", "HDR", "Flash màn hình", "Chụp đêm", "Chụp hẹn giờ", "Bộ lọc màu"], "Công nghệ màn hình": "IPS LCD", "Độ phân giải màn hình": "HD+ (720 x 1612 Pixels)", "Màn hình rộng": "6.56 inch - Tần số quét  90 Hz", "Độ sáng tối đa": "528 nits", "Mặt kính cảm ứng": "Kính cường lực CSG"}}, {"Pin & Sạc": {"Dung lượng pin": "5000 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "15 W", "Sạc kèm theo máy": "15 W", "Công nghệ pin": "Tiết kiệm pin"}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt", "Tính năng đặc biệt": ["Ứng dụng kép (Nhân bản ứng dụng)", "Đa cửa sổ (chia đôi màn hình)", "Tối ưu game (Siêu trò chơi)", "Trợ lý ảo Jovi", "Thu nhỏ màn hình sử dụng một tay", "Thanh bên thông minh", "Mở rộng bộ nhớ RAM", "Không gian thứ hai", "Cử chỉ thông minh", "Chế độ đơn giản (Giao diện đơn giản)", "Chặn tin nhắn", "Chặn cuộc gọi", "Chạm 2 lần tắt/sáng màn hình"], "Kháng nước, bụi": "IP54", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Radio": "Có", "Xem phim": ["WEBM", "TS", "MP4", "MKV", "FLV", "AV1", "ASF", "3GP"], "Nghe nhạc": ["WAV", "Vorbis", "Midi", "MP3", "FLAC", "APE", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 4G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.0", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "3.5 mm", "Kết nối khác": "OTG"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 163.63 mm - Ngang 75.58 mm - Dày 8.39 mm - Nặng 185 g", "Thời điểm ra mắt": "03/2024"}}]'::jsonb,
        ARRAY['vivo-y03-xanh-1-1.jpg', 'vivo-y03-xanh-2-1.jpg', 'vivo-y03-xanh-3-1.jpg', 'vivo-y03-xanh-4-1.jpg', 'vivo-y03-xanh-5-1.jpg', 'vivo-y03-xanh-6.jpg', 'vivo-y03-xanh-7.jpg', 'vivo-y03-xanh-8.jpg', 'vivo-y03-xanh-9.jpg', 'vivo-y03-xanh-10.jpg', 'vivo-y03-xanh-11.jpg', 'vivo-y03-xanh-12.jpg', 'vivo-y03-bbh-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-xanh-2-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-xanh-3-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-xanh-4-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-xanh-5-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-xanh-6.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-xanh-7.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-xanh-8.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-xanh-9.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-xanh-10.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-xanh-11.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-xanh-12.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-bbh-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-xanh-1-1.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    -- Insert variant 2
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'VIVO_Y03_DEN',
        'vivo-y03-den',
        '{"color": "Đen"}'::jsonb,
        3240000.0,
        NULL,
        509,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 14", "Chip xử lý (CPU)": "MediaTek Helio G85", "Tốc độ CPU": "2 nhân 2.0 GHz & 6 nhân 1.8 GHz", "Chip đồ họa (GPU)": "Mali-G52", "RAM": "4 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "111 GB", "Thẻ nhớ": "MicroSD, hỗ trợ tối đa 1 TB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 13 MP & Phụ 0.08 MP", "Quay phim camera sau": ["HD 720p@30fps", "HD 720p@120fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Quét tài liệu", "Quay chậm (Slow Motion)", "Làm đẹp", "HDR", "Google Lens", "Chụp ảnh chuyển động", "Chụp hẹn giờ", "Chuyên nghiệp (Pro)", "Bộ lọc màu", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "5 MP", "Tính năng camera trước": ["Xóa phông", "Quay video HD", "Quay video Full HD", "Làm đẹp", "HDR", "Flash màn hình", "Chụp đêm", "Chụp hẹn giờ", "Bộ lọc màu"], "Công nghệ màn hình": "IPS LCD", "Độ phân giải màn hình": "HD+ (720 x 1612 Pixels)", "Màn hình rộng": "6.56 inch - Tần số quét  90 Hz", "Độ sáng tối đa": "528 nits", "Mặt kính cảm ứng": "Kính cường lực CSG"}}, {"Pin & Sạc": {"Dung lượng pin": "5000 mAh", "Loại pin": "Li-Ion", "Hỗ trợ sạc tối đa": "15 W", "Sạc kèm theo máy": "15 W", "Công nghệ pin": "Tiết kiệm pin"}}, {"Tiện ích": {"Bảo mật nâng cao": "Mở khoá khuôn mặt", "Tính năng đặc biệt": ["Ứng dụng kép (Nhân bản ứng dụng)", "Đa cửa sổ (chia đôi màn hình)", "Tối ưu game (Siêu trò chơi)", "Trợ lý ảo Jovi", "Thu nhỏ màn hình sử dụng một tay", "Thanh bên thông minh", "Mở rộng bộ nhớ RAM", "Không gian thứ hai", "Cử chỉ thông minh", "Chế độ đơn giản (Giao diện đơn giản)", "Chặn tin nhắn", "Chặn cuộc gọi", "Chạm 2 lần tắt/sáng màn hình"], "Kháng nước, bụi": "IP54", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Radio": "Có", "Xem phim": ["WEBM", "TS", "MP4", "MKV", "FLV", "AV1", "ASF", "3GP"], "Nghe nhạc": ["WAV", "Vorbis", "Midi", "MP3", "FLAC", "APE", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 4G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.0", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "3.5 mm", "Kết nối khác": "OTG"}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 163.63 mm - Ngang 75.58 mm - Dày 8.39 mm - Nặng 185 g", "Thời điểm ra mắt": "03/2024"}}]'::jsonb,
        ARRAY['vivo-y03-den-1.jpg', 'vivo-y03-den-2.jpg', 'vivo-y03-den-3.jpg', 'vivo-y03-den-4.jpg', 'vivo-y03-den-5.jpg', 'vivo-y03-den-6.jpg', 'vivo-y03-den-7.jpg', 'vivo-y03-den-8.jpg', 'vivo-y03-den-9.jpg', 'vivo-y03-den-10.jpg', 'vivo-y03-den-11.jpg', 'vivo-y03-den-12.jpg', 'vivo-y03-bbh-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-den-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-den-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-den-4.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-den-5.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-den-6.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-den-7.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-den-8.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-den-9.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-den-10.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-den-11.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-den-12.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-bbh-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/vivo-y03/vivo-y03-den-1.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Điện thoại Xiaomi Redmi 15 8GB/128GB
-- Slug: xiaomi-redmi-15-8gb-128gb
-- Variants: 6

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Điện thoại Xiaomi Redmi 15 8GB/128GB',
        'xiaomi-redmi-15-8gb-128gb',
        10.0,
        2.0,
        'Xiaomi Redmi 15 8GB 128GB đã chính thức ra mắt, nhanh chóng trở thành cái tên nổi bật trong thị trường smartphone tầm trung. Với pin dung lượng lớn, màn hình 144 Hz siêu mượt và loạt công nghệ tiên tiến, máy mang đến trải nghiệm toàn diện cho người dùng. Từ giải trí, công việc cho đến chụp ảnh, Redmi 15 đều đáp ứng mượt mà và đáng tin cậy.',
        '{"meta_title": "Xiaomi Redmi 15 8GB/128GB giá tốt, ưu đãi đến 300K", "meta_description": "Mua điện thoại Xiaomi Redmi 15 8GB/128GB giá rẻ, ưu đãi đến 300K, trả góp 0% lãi suất, bảo hành 18 tháng, giảm 100K cho HSSV/Tài xế công nghệ. Mua ngay!", "meta_keywords": "Xiaomi Redmi 15 8GB/128GB, redmi 15, redmi15, xiaomiredmi15, xiaomi redmi15, 15, red mi 15, xiaomi red mi 15, mi 15, xiaomi mi 15"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'XIAOMI_REDMI_15_8GB_128GB_6GB_XAM',
        'xiaomi-redmi-15-8gb-128gb-6gb-xam',
        '{"color": "Xám", "memory": "6GB"}'::jsonb,
        4790000.0,
        NULL,
        435,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Snapdragon 685 8 nhân", "Tốc độ CPU": "4 nhân 2.8 GHz & 4 nhân 1.9 GHz", "Chip đồ họa (GPU)": "Adreno 610", "RAM": "6 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "115 GB", "Thẻ nhớ": "MicroSD, hỗ trợ tối đa 2 TB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ QVGA", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Toàn cảnh (Panorama)", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "8 MP", "Tính năng camera trước": ["Xóa phông", "Làm đẹp"], "Công nghệ màn hình": "IPS LCD", "Độ phân giải màn hình": "Full HD+ (1080 x 2340 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét  144 Hz", "Độ sáng tối đa": "850 nits", "Mặt kính cảm ứng": "Đang cập nhật"}}, {"Pin & Sạc": {"Dung lượng pin": "7000 mAh", "Loại pin": "Silicon-Carbon", "Hỗ trợ sạc tối đa": "33 W", "Sạc kèm theo máy": "33 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay cạnh viền", "Mở khoá khuôn mặt"], "Kháng nước, bụi": "IP64", "Ghi âm": "Ghi âm mặc định", "Radio": "FM không cần tai nghe", "Xem phim": ["Xvid", "WMV", "WEBM", "TS", "MP4", "MOV", "MKV", "M4V", "FLV", "DivX", "AVI", "ASF", "3GP", "3G2"], "Nghe nhạc": ["XMF", "WAV", "RTX", "OTA", "OGG", "OGA", "Midi", "MP3", "M4A", "IMY", "FLAC", "AWB", "AMR", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 4G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["GPS", "GLONASS", "BEIDOU"], "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "Hồng ngoại"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung hợp kim nhôm & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 169.48 mm - Ngang 80.45 mm - Dày 8.4 mm - Nặng 214 g", "Thời điểm ra mắt": "08/2025"}}]'::jsonb,
        ARRAY['xiaomi-redmi-15-purple-1-638925070471906551.jpg', 'xiaomi-redmi-15-purple-2-638925070479929325.jpg', 'xiaomi-redmi-15-purple-3-638925070486438855.jpg', 'xiaomi-redmi-15-purple-4-638925070492658064.jpg', 'xiaomi-redmi-15-purple-5-638925070498844025.jpg', 'xiaomi-redmi-15-purple-6-638925070505465465.jpg', 'xiaomi-redmi-15-purple-7-638925070512241680.jpg', 'xiaomi-redmi-15-purple-8-638925070519258550.jpg', 'xiaomi-redmi-15-purple-9-638925070526616668.jpg', 'xiaomi-redmi-15-purple-10-638925070532969442.jpg', 'xiaomi-redmi-15-purple-11-638925070539564867.jpg', 'xiaomi-redmi-15-purple-12-638925070546030932.jpg', 'xiaomi-redmi-15-purple-13-638925070552897720.jpg', 'xiaomi-redmi-15-purple-14-638925070558370731.jpg', 'xiaomi-redmi-15-bbh-638925073123091612.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-2-638925070479929325.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-3-638925070486438855.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-4-638925070492658064.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-5-638925070498844025.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-6-638925070505465465.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-7-638925070512241680.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-8-638925070519258550.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-9-638925070526616668.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-10-638925070532969442.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-11-638925070539564867.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-12-638925070546030932.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-13-638925070552897720.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-14-638925070558370731.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-bbh-638925073123091612.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-1-638925070471906551.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    -- Insert variant 2
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'XIAOMI_REDMI_15_8GB_128GB_6GB_TIM',
        'xiaomi-redmi-15-8gb-128gb-6gb-tim',
        '{"color": "Tím", "memory": "6GB"}'::jsonb,
        4790000.0,
        NULL,
        61,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Snapdragon 685 8 nhân", "Tốc độ CPU": "4 nhân 2.8 GHz & 4 nhân 1.9 GHz", "Chip đồ họa (GPU)": "Adreno 610", "RAM": "6 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "115 GB", "Thẻ nhớ": "MicroSD, hỗ trợ tối đa 2 TB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ QVGA", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Toàn cảnh (Panorama)", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "8 MP", "Tính năng camera trước": ["Xóa phông", "Làm đẹp"], "Công nghệ màn hình": "IPS LCD", "Độ phân giải màn hình": "Full HD+ (1080 x 2340 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét  144 Hz", "Độ sáng tối đa": "850 nits", "Mặt kính cảm ứng": "Đang cập nhật"}}, {"Pin & Sạc": {"Dung lượng pin": "7000 mAh", "Loại pin": "Silicon-Carbon", "Hỗ trợ sạc tối đa": "33 W", "Sạc kèm theo máy": "33 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay cạnh viền", "Mở khoá khuôn mặt"], "Kháng nước, bụi": "IP64", "Ghi âm": "Ghi âm mặc định", "Radio": "FM không cần tai nghe", "Xem phim": ["Xvid", "WMV", "WEBM", "TS", "MP4", "MOV", "MKV", "M4V", "FLV", "DivX", "AVI", "ASF", "3GP", "3G2"], "Nghe nhạc": ["XMF", "WAV", "RTX", "OTA", "OGG", "OGA", "Midi", "MP3", "M4A", "IMY", "FLAC", "AWB", "AMR", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 4G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["GPS", "GLONASS", "BEIDOU"], "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "Hồng ngoại"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung hợp kim nhôm & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 169.48 mm - Ngang 80.45 mm - Dày 8.4 mm - Nặng 214 g", "Thời điểm ra mắt": "08/2025"}}]'::jsonb,
        ARRAY['xiaomi-redmi-15-purple-1-638925070471906551.jpg', 'xiaomi-redmi-15-purple-2-638925070479929325.jpg', 'xiaomi-redmi-15-purple-3-638925070486438855.jpg', 'xiaomi-redmi-15-purple-4-638925070492658064.jpg', 'xiaomi-redmi-15-purple-5-638925070498844025.jpg', 'xiaomi-redmi-15-purple-6-638925070505465465.jpg', 'xiaomi-redmi-15-purple-7-638925070512241680.jpg', 'xiaomi-redmi-15-purple-8-638925070519258550.jpg', 'xiaomi-redmi-15-purple-9-638925070526616668.jpg', 'xiaomi-redmi-15-purple-10-638925070532969442.jpg', 'xiaomi-redmi-15-purple-11-638925070539564867.jpg', 'xiaomi-redmi-15-purple-12-638925070546030932.jpg', 'xiaomi-redmi-15-purple-13-638925070552897720.jpg', 'xiaomi-redmi-15-purple-14-638925070558370731.jpg', 'xiaomi-redmi-15-bbh-638925073123091612.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-2-638925070479929325.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-3-638925070486438855.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-4-638925070492658064.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-5-638925070498844025.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-6-638925070505465465.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-7-638925070512241680.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-8-638925070519258550.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-9-638925070526616668.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-10-638925070532969442.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-11-638925070539564867.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-12-638925070546030932.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-13-638925070552897720.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-14-638925070558370731.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-bbh-638925073123091612.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-1-638925070471906551.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 3
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'XIAOMI_REDMI_15_8GB_128GB_6GB_DEN',
        'xiaomi-redmi-15-8gb-128gb-6gb-den',
        '{"color": "Đen", "memory": "6GB"}'::jsonb,
        4790000.0,
        NULL,
        565,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Snapdragon 685 8 nhân", "Tốc độ CPU": "4 nhân 2.8 GHz & 4 nhân 1.9 GHz", "Chip đồ họa (GPU)": "Adreno 610", "RAM": "6 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "115 GB", "Thẻ nhớ": "MicroSD, hỗ trợ tối đa 2 TB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ QVGA", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Toàn cảnh (Panorama)", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "8 MP", "Tính năng camera trước": ["Xóa phông", "Làm đẹp"], "Công nghệ màn hình": "IPS LCD", "Độ phân giải màn hình": "Full HD+ (1080 x 2340 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét  144 Hz", "Độ sáng tối đa": "850 nits", "Mặt kính cảm ứng": "Đang cập nhật"}}, {"Pin & Sạc": {"Dung lượng pin": "7000 mAh", "Loại pin": "Silicon-Carbon", "Hỗ trợ sạc tối đa": "33 W", "Sạc kèm theo máy": "33 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay cạnh viền", "Mở khoá khuôn mặt"], "Kháng nước, bụi": "IP64", "Ghi âm": "Ghi âm mặc định", "Radio": "FM không cần tai nghe", "Xem phim": ["Xvid", "WMV", "WEBM", "TS", "MP4", "MOV", "MKV", "M4V", "FLV", "DivX", "AVI", "ASF", "3GP", "3G2"], "Nghe nhạc": ["XMF", "WAV", "RTX", "OTA", "OGG", "OGA", "Midi", "MP3", "M4A", "IMY", "FLAC", "AWB", "AMR", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 4G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["GPS", "GLONASS", "BEIDOU"], "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "Hồng ngoại"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung hợp kim nhôm & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 169.48 mm - Ngang 80.45 mm - Dày 8.4 mm - Nặng 214 g", "Thời điểm ra mắt": "08/2025"}}]'::jsonb,
        ARRAY['xiaomi-redmi-15-purple-1-638925070471906551.jpg', 'xiaomi-redmi-15-purple-2-638925070479929325.jpg', 'xiaomi-redmi-15-purple-3-638925070486438855.jpg', 'xiaomi-redmi-15-purple-4-638925070492658064.jpg', 'xiaomi-redmi-15-purple-5-638925070498844025.jpg', 'xiaomi-redmi-15-purple-6-638925070505465465.jpg', 'xiaomi-redmi-15-purple-7-638925070512241680.jpg', 'xiaomi-redmi-15-purple-8-638925070519258550.jpg', 'xiaomi-redmi-15-purple-9-638925070526616668.jpg', 'xiaomi-redmi-15-purple-10-638925070532969442.jpg', 'xiaomi-redmi-15-purple-11-638925070539564867.jpg', 'xiaomi-redmi-15-purple-12-638925070546030932.jpg', 'xiaomi-redmi-15-purple-13-638925070552897720.jpg', 'xiaomi-redmi-15-purple-14-638925070558370731.jpg', 'xiaomi-redmi-15-bbh-638925073123091612.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-2-638925070479929325.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-3-638925070486438855.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-4-638925070492658064.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-5-638925070498844025.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-6-638925070505465465.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-7-638925070512241680.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-8-638925070519258550.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-9-638925070526616668.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-10-638925070532969442.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-11-638925070539564867.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-12-638925070546030932.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-13-638925070552897720.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-14-638925070558370731.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-bbh-638925073123091612.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-1-638925070471906551.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 4
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'XIAOMI_REDMI_15_8GB_128GB_8GB_XAM',
        'xiaomi-redmi-15-8gb-128gb-8gb-xam',
        '{"color": "Xám", "memory": "8GB"}'::jsonb,
        5190000.0,
        NULL,
        90,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Snapdragon 685 8 nhân", "Tốc độ CPU": "4 nhân 2.8 GHz & 4 nhân 1.9 GHz", "Chip đồ họa (GPU)": "Adreno 610", "RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "115 GB", "Thẻ nhớ": "MicroSD, hỗ trợ tối đa 2 TB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ QVGA", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Toàn cảnh (Panorama)", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "8 MP", "Tính năng camera trước": ["Xóa phông", "Làm đẹp"], "Công nghệ màn hình": "IPS LCD", "Độ phân giải màn hình": "Full HD+ (1080 x 2340 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét  144 Hz", "Độ sáng tối đa": "850 nits", "Mặt kính cảm ứng": "Đang cập nhật"}}, {"Pin & Sạc": {"Dung lượng pin": "7000 mAh", "Loại pin": "Silicon-Carbon", "Hỗ trợ sạc tối đa": "33 W", "Sạc kèm theo máy": "33 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay cạnh viền", "Mở khoá khuôn mặt"], "Kháng nước, bụi": "IP64", "Ghi âm": "Ghi âm mặc định", "Radio": "FM không cần tai nghe", "Xem phim": ["Xvid", "WMV", "WEBM", "TS", "MP4", "MOV", "MKV", "M4V", "FLV", "DivX", "AVI", "ASF", "3GP", "3G2"], "Nghe nhạc": ["XMF", "WAV", "RTX", "OTA", "OGG", "OGA", "Midi", "MP3", "M4A", "IMY", "FLAC", "AWB", "AMR", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 4G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["GPS", "GLONASS", "BEIDOU"], "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "Hồng ngoại"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung hợp kim nhôm & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 169.48 mm - Ngang 80.45 mm - Dày 8.4 mm - Nặng 214 g", "Thời điểm ra mắt": "08/2025"}}]'::jsonb,
        ARRAY['xiaomi-redmi-15-gray-1-638925080376108612.jpg', 'xiaomi-redmi-15-gray-2-638925080382135706.jpg', 'xiaomi-redmi-15-gray-3-638925080387688607.jpg', 'xiaomi-redmi-15-gray-4-638925080393755977.jpg', 'xiaomi-redmi-15-gray-5-638925080401095263.jpg', 'xiaomi-redmi-15-gray-6-638925080407241552.jpg', 'xiaomi-redmi-15-gray-7-638925080414295143.jpg', 'xiaomi-redmi-15-gray-8-638925080424213969.jpg', 'xiaomi-redmi-15-gray-9-638925080430816757.jpg', 'xiaomi-redmi-15-gray-10-638925080438294419.jpg', 'xiaomi-redmi-15-gray-11-638925080444391335.jpg', 'xiaomi-redmi-15-gray-12-638925080451748507.jpg', 'xiaomi-redmi-15-gray-13-638925080459906826.jpg', 'xiaomi-redmi-15-gray-14-638925080466117235.jpg', 'xiaomi-redmi-15-bbh-638925082268590899.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-gray-2-638925080382135706.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-gray-3-638925080387688607.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-gray-4-638925080393755977.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-gray-5-638925080401095263.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-gray-6-638925080407241552.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-gray-7-638925080414295143.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-gray-8-638925080424213969.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-gray-9-638925080430816757.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-gray-10-638925080438294419.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-gray-11-638925080444391335.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-gray-12-638925080451748507.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-gray-13-638925080459906826.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-gray-14-638925080466117235.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-bbh-638925082268590899.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-gray-1-638925080376108612.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 5
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'XIAOMI_REDMI_15_8GB_128GB_8GB_TIM',
        'xiaomi-redmi-15-8gb-128gb-8gb-tim',
        '{"color": "Tím", "memory": "8GB"}'::jsonb,
        5190000.0,
        NULL,
        147,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Snapdragon 685 8 nhân", "Tốc độ CPU": "4 nhân 2.8 GHz & 4 nhân 1.9 GHz", "Chip đồ họa (GPU)": "Adreno 610", "RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "115 GB", "Thẻ nhớ": "MicroSD, hỗ trợ tối đa 2 TB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ QVGA", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Toàn cảnh (Panorama)", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "8 MP", "Tính năng camera trước": ["Xóa phông", "Làm đẹp"], "Công nghệ màn hình": "IPS LCD", "Độ phân giải màn hình": "Full HD+ (1080 x 2340 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét  144 Hz", "Độ sáng tối đa": "850 nits", "Mặt kính cảm ứng": "Đang cập nhật"}}, {"Pin & Sạc": {"Dung lượng pin": "7000 mAh", "Loại pin": "Silicon-Carbon", "Hỗ trợ sạc tối đa": "33 W", "Sạc kèm theo máy": "33 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay cạnh viền", "Mở khoá khuôn mặt"], "Kháng nước, bụi": "IP64", "Ghi âm": "Ghi âm mặc định", "Radio": "FM không cần tai nghe", "Xem phim": ["Xvid", "WMV", "WEBM", "TS", "MP4", "MOV", "MKV", "M4V", "FLV", "DivX", "AVI", "ASF", "3GP", "3G2"], "Nghe nhạc": ["XMF", "WAV", "RTX", "OTA", "OGG", "OGA", "Midi", "MP3", "M4A", "IMY", "FLAC", "AWB", "AMR", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 4G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["GPS", "GLONASS", "BEIDOU"], "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "Hồng ngoại"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung hợp kim nhôm & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 169.48 mm - Ngang 80.45 mm - Dày 8.4 mm - Nặng 214 g", "Thời điểm ra mắt": "08/2025"}}]'::jsonb,
        ARRAY['xiaomi-redmi-15-purple-1-638925080059583102.jpg', 'xiaomi-redmi-15-purple-2-638925080066458632.jpg', 'xiaomi-redmi-15-purple-3-638925080074032916.jpg', 'xiaomi-redmi-15-purple-4-638925080082133926.jpg', 'xiaomi-redmi-15-purple-5-638925080088934387.jpg', 'xiaomi-redmi-15-purple-6-638925080095455860.jpg', 'xiaomi-redmi-15-purple-7-638925080103314910.jpg', 'xiaomi-redmi-15-purple-8-638925080109236965.jpg', 'xiaomi-redmi-15-purple-9-638925080117215233.jpg', 'xiaomi-redmi-15-purple-10-638925080123766510.jpg', 'xiaomi-redmi-15-purple-11-638925080134766835.jpg', 'xiaomi-redmi-15-purple-12-638925080141350280.jpg', 'xiaomi-redmi-15-purple-13-638925080149115108.jpg', 'xiaomi-redmi-15-purple-14-638925080156040367.jpg', 'xiaomi-redmi-15-bbh-638925082268590899.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-2-638925080066458632.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-3-638925080074032916.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-4-638925080082133926.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-5-638925080088934387.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-6-638925080095455860.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-7-638925080103314910.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-8-638925080109236965.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-9-638925080117215233.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-10-638925080123766510.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-11-638925080134766835.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-12-638925080141350280.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-13-638925080149115108.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-14-638925080156040367.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-bbh-638925082268590899.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-purple-1-638925080059583102.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    -- Insert variant 6
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'XIAOMI_REDMI_15_8GB_128GB_8GB_DEN',
        'xiaomi-redmi-15-8gb-128gb-8gb-den',
        '{"color": "Đen", "memory": "8GB"}'::jsonb,
        5190000.0,
        NULL,
        212,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Snapdragon 685 8 nhân", "Tốc độ CPU": "4 nhân 2.8 GHz & 4 nhân 1.9 GHz", "Chip đồ họa (GPU)": "Adreno 610", "RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "115 GB", "Thẻ nhớ": "MicroSD, hỗ trợ tối đa 2 TB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 50 MP & Phụ QVGA", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Toàn cảnh (Panorama)", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "8 MP", "Tính năng camera trước": ["Xóa phông", "Làm đẹp"], "Công nghệ màn hình": "IPS LCD", "Độ phân giải màn hình": "Full HD+ (1080 x 2340 Pixels)", "Màn hình rộng": "6.9 inch - Tần số quét  144 Hz", "Độ sáng tối đa": "850 nits", "Mặt kính cảm ứng": "Đang cập nhật"}}, {"Pin & Sạc": {"Dung lượng pin": "7000 mAh", "Loại pin": "Silicon-Carbon", "Hỗ trợ sạc tối đa": "33 W", "Sạc kèm theo máy": "33 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "Sạc ngược qua cáp"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay cạnh viền", "Mở khoá khuôn mặt"], "Kháng nước, bụi": "IP64", "Ghi âm": "Ghi âm mặc định", "Radio": "FM không cần tai nghe", "Xem phim": ["Xvid", "WMV", "WEBM", "TS", "MP4", "MOV", "MKV", "M4V", "FLV", "DivX", "AVI", "ASF", "3GP", "3G2"], "Nghe nhạc": ["XMF", "WAV", "RTX", "OTA", "OGG", "OGA", "Midi", "MP3", "M4A", "IMY", "FLAC", "AWB", "AMR", "AAC"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 4G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["GPS", "GLONASS", "BEIDOU"], "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["OTG", "Hồng ngoại"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung hợp kim nhôm & Mặt lưng nhựa", "Kích thước, khối lượng": "Dài 169.48 mm - Ngang 80.45 mm - Dày 8.4 mm - Nặng 214 g", "Thời điểm ra mắt": "08/2025"}}]'::jsonb,
        ARRAY['xiaomi-redmi-15-black-1-638925080932934474.jpg', 'xiaomi-redmi-15-black-2-638925080938441262.jpg', 'xiaomi-redmi-15-black-3-638925080948119054.jpg', 'xiaomi-redmi-15-black-4-638925080954768561.jpg', 'xiaomi-redmi-15-black-5-638925080961050197.jpg', 'xiaomi-redmi-15-black-6-638925080967009436.jpg', 'xiaomi-redmi-15-black-7-638925080974451392.jpg', 'xiaomi-redmi-15-black-8-638925080981696690.jpg', 'xiaomi-redmi-15-black-9-638925080987959780.jpg', 'xiaomi-redmi-15-black-10-638925080993717163.jpg', 'xiaomi-redmi-15-black-11-638925081000851131.jpg', 'xiaomi-redmi-15-black-12-638925081006687606.jpg', 'xiaomi-redmi-15-black-13-638925081013478699.jpg', 'xiaomi-redmi-15-bbh-638925082268590899.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-black-2-638925080938441262.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-black-3-638925080948119054.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-black-4-638925080954768561.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-black-5-638925080961050197.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-black-6-638925080967009436.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-black-7-638925080974451392.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-black-8-638925080981696690.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-black-9-638925080987959780.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-black-10-638925080993717163.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-black-11-638925081000851131.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-black-12-638925081006687606.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-black-13-638925081013478699.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-bbh-638925082268590899.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-15-8gb-128gb/xiaomi-redmi-15-black-1-638925080932934474.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now();
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------

-- Product: Điện thoại Xiaomi Redmi Note 14 Pro+ 5G 12GB/512GB
-- Slug: xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb
-- Variants: 1

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
BEGIN
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Điện thoại Xiaomi Redmi Note 14 Pro+ 5G 12GB/512GB',
        'xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb',
        10.0,
        2.0,
        'Xiaomi Redmi Note 14 Pro Plus 5G 12GB/512GB nổi bật với màn hình siêu sáng 3000 nits, mang lại khả năng hiển thị rõ nét ngay cả dưới ánh nắng gắt. Kết hợp với chip Snapdragon 7s Gen 3 hiệu năng cao và hệ thống tản nhiệt tiên tiến, thiết bị đáp ứng mượt mà mọi nhu cầu từ làm việc đến giải trí, đảm bảo trải nghiệm ổn định và thoải mái.',
        '{"meta_title": "Xiaomi Redmi Note 14 Pro Plus 5G 12GB/512GB thu cũ giảm đến 2.5tr", "meta_description": "Điện thoại Xiaomi Redmi Note 14 Pro+ (Plus) 5G 12GB/512GB chính hãng, giá tốt, thu cũ giảm đến 2.5tr, bảo hành 18 tháng, trả chậm 0% lãi suất. Mua ngay!", "meta_keywords": "note14, note14 pro, 14pro,redmi note14 pro, note 14 pro+, 14pro+, note pro+, Xiaomi Redmi Note 14 Pro+ 5G 12GB/512GB, redmi note 14pro+"}'::jsonb,
        '00000000-0000-0000-0000-000000000000'::uuid  -- Temporary placeholder
    )
    ON CONFLICT (slug) DO UPDATE SET
        description = EXCLUDED.description,
        meta = EXCLUDED.meta,
        updated_at = now()
    RETURNING id INTO v_product_id;
    
    -- Insert first variant
    INSERT INTO product_variants (
        product_id, sku, variant_slug, attributes, price, original_price, qty,
        specifications, image_filenames, image_urls, main_image
    ) VALUES (
        v_product_id,
        'XIAOMI_REDMI_NOTE_14_PRO_PLUS_5G_12GB_512GB_VANG',
        'xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb-vang',
        '{"color": "Vàng"}'::jsonb,
        10160000.0,
        12760000.0,
        354,
        '[{"Cấu hình & Bộ nhớ": {"Hệ điều hành": "Android 14", "Chip xử lý (CPU)": "Snapdragon 7s Gen 3 5G 8 nhân", "Tốc độ CPU": "1 nhân 2.5 GHz, 3 nhân 2.4 GHz & 4 nhân 1.8 GHz", "Chip đồ họa (GPU)": "Adreno 810", "RAM": "12 GB", "Dung lượng lưu trữ": "512 GB", "Dung lượng còn lại (khả dụng) khoảng": "484 GB", "Danh bạ": "Không giới hạn"}}, {"Camera & Màn hình": {"Độ phân giải camera sau": "Chính 200 MP & Phụ 8 MP, 2 MP", "Quay phim camera sau": ["HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "4K 2160p@30fps", "4K 2160p@24fps"], "Đèn Flash camera sau": "Có", "Tính năng camera sau": ["Zoom kỹ thuật số", "Xóa phông", "Trôi nhanh thời gian (Time Lapse)", "Toàn cảnh (Panorama)", "Siêu độ phân giải", "Siêu cận (Macro)", "Quét tài liệu", "Làm đẹp", "HDR", "Góc siêu rộng (Ultrawide)", "Google Lens", "Dolby Vision HDR", "Chụp hẹn giờ", "Chống rung điện tử kỹ thuật số (EIS)", "Chống rung quang học (OIS)", "Bộ lọc màu", "Ban đêm (Night Mode)"], "Độ phân giải camera trước": "20 MP", "Tính năng camera trước": ["Xóa phông", "Quay video HD", "Quay video Full HD", "Làm đẹp", "Flash màn hình", "Chụp đêm", "Chụp hẹn giờ", "Chụp bằng cử chỉ", "Bộ lọc màu"], "Công nghệ màn hình": "AMOLED", "Độ phân giải màn hình": "1.5K (1220 x 2712 Pixels)", "Màn hình rộng": "6.67 inch - Tần số quét 120 Hz", "Độ sáng tối đa": "3000 nits", "Mặt kính cảm ứng": "Kính cường lực Corning Gorilla Glass Victus 2"}}, {"Pin & Sạc": {"Dung lượng pin": "5110 mAh", "Loại pin": "Li-Po", "Hỗ trợ sạc tối đa": "120 W", "Sạc kèm theo máy": "120 W", "Công nghệ pin": ["Tiết kiệm pin", "Sạc pin nhanh", "HyperCharge"]}}, {"Tiện ích": {"Bảo mật nâng cao": ["Mở khoá vân tay dưới màn hình", "Mở khoá khuôn mặt"], "Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Xoá vật thể AI", "Trợ lý ảo Google Gemini", "Phụ đề AI", "Phiên dịch viên", "Mở rộng ảnh AI", "Làm phim AI", "Khoanh tròn để tìm kiếm", "Ghi âm AI", "Ghi chú AI", "Công nghệ tản nhiệt LiquidCool", "Loa kép"], "Kháng nước, bụi": "IP68", "Ghi âm": ["Ghi âm mặc định", "Ghi âm cuộc gọi"], "Xem phim": "Có", "Nghe nhạc": "Có"}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 5G", "SIM": "2 Nano SIM", "Wifi": "Wi-Fi hotspot", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BEIDOU"], "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C", "Kết nối khác": ["NFC", "Hồng ngoại"]}}, {"Thiết kế & Chất liệu": {"Thiết kế": "Nguyên khối", "Chất liệu": "Khung kim loại & Mặt lưng kính (Đen, Xanh, Vàng) | Da nhân tạo (Tím)", "Kích thước, khối lượng": "Dài 162.53 mm - Ngang 74.67 mm - Dày 8.75 mm (Đen, Xanh, Vàng) | 8.85 mm (Tím) - Nặng 210.14g (Đen, Xanh, Vàng) | 205.13g (Tím)", "Thời điểm ra mắt": "01/2025"}}]'::jsonb,
        ARRAY['xiaomi-redmi-note-14-pro-plus-vang-1-638844834009328743.jpg', 'xiaomi-redmi-note-14-pro-plus-vang-2-638844834016472492.jpg', 'xiaomi-redmi-note-14-pro-plus-vang-3-638844834022604860.jpg', 'xiaomi-redmi-note-14-pro-plus-vang-4-638844834028769752.jpg', 'xiaomi-redmi-note-14-pro-plus-vang-5-638844834040424824.jpg', 'xiaomi-redmi-note-14-pro-plus-vang-6-638844834046395430.jpg', 'xiaomi-redmi-note-14-pro-plus-vang-7-638844834055521506.jpg', 'xiaomi-redmi-note-14-pro-plus-vang-8-638844834061675415.jpg', 'xiaomi-redmi-note-14-pro-plus-vang-9-638844834068427045.jpg', 'xiaomi-redmi-note-14-pro-plus-vang-10-638844834075794335.jpg', 'xiaomi-redmi-note-14-pro-plus-vang-11-638844834082142268.jpg', 'xiaomi-redmi-note-14-pro-plus-vang-12-638844834088652412.jpg', 'xiaomi-redmi-note-14-pro-plus-tem-99-638844840153361006.jpg', 'xiaomi-redmi-note-14-pro-plus-bbh-638844839264442950.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb/xiaomi-redmi-note-14-pro-plus-vang-2-638844834016472492.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb/xiaomi-redmi-note-14-pro-plus-vang-3-638844834022604860.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb/xiaomi-redmi-note-14-pro-plus-vang-4-638844834028769752.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb/xiaomi-redmi-note-14-pro-plus-vang-5-638844834040424824.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb/xiaomi-redmi-note-14-pro-plus-vang-6-638844834046395430.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb/xiaomi-redmi-note-14-pro-plus-vang-7-638844834055521506.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb/xiaomi-redmi-note-14-pro-plus-vang-8-638844834061675415.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb/xiaomi-redmi-note-14-pro-plus-vang-9-638844834068427045.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb/xiaomi-redmi-note-14-pro-plus-vang-10-638844834075794335.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb/xiaomi-redmi-note-14-pro-plus-vang-11-638844834082142268.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb/xiaomi-redmi-note-14-pro-plus-vang-12-638844834088652412.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb/xiaomi-redmi-note-14-pro-plus-tem-99-638844840153361006.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb/xiaomi-redmi-note-14-pro-plus-bbh-638844839264442950.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-redmi-note-14-pro-plus-5g-12gb-512gb/xiaomi-redmi-note-14-pro-plus-vang-1-638844834009328743.jpg'
    )
    ON CONFLICT (sku) DO UPDATE SET
        price = EXCLUDED.price,
        original_price = EXCLUDED.original_price,
        qty = EXCLUDED.qty,
        specifications = EXCLUDED.specifications,
        image_filenames = EXCLUDED.image_filenames,
        image_urls = EXCLUDED.image_urls,
        main_image = EXCLUDED.main_image,
        updated_at = now()
    RETURNING id INTO v_variant_id;
    
    -- Update product's default_variant_id to first variant
    UPDATE products
    SET default_variant_id = v_variant_id
    WHERE id = v_product_id;
END $$;

COMMIT;

-- ----------------------------------------------------------------------------
