-- ========================================
-- SHOPIN DATABASE - PRODUCT INSERTS
-- Generated: 2025-12-03T17:33:16.131213
-- Total Files: 20
-- ========================================

-- ========================================
-- BRANDS
-- ========================================

-- Reset sequence to avoid ID conflicts
SELECT setval('brands_id_seq', (SELECT COALESCE(MAX(id), 0) FROM brands));

INSERT INTO brands (name, slug) VALUES ('Apple', 'apple') ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (name, slug) VALUES ('Garmin', 'garmin') ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (name, slug) VALUES ('Huawei', 'huawei') ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (name, slug) VALUES ('Lenovo', 'lenovo') ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (name, slug) VALUES ('Samsung', 'samsung') ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (name, slug) VALUES ('Xiaomi', 'xiaomi') ON CONFLICT (name) DO NOTHING;

-- ========================================
-- CATEGORIES
-- ========================================

-- Reset sequence to avoid ID conflicts
SELECT setval('categories_id_seq', (SELECT COALESCE(MAX(id), 0) FROM categories));

INSERT INTO categories (name, slug) VALUES ('Máy tính bảng', 'may-tinh-bang') ON CONFLICT (name) DO NOTHING;
INSERT INTO categories (name, slug) VALUES ('Đồng hồ thông minh', 'dong-ho-thong-minh') ON CONFLICT (name) DO NOTHING;

-- ========================================
-- PRODUCTS & VARIANTS
-- ========================================

-- Product: Apple Watch Series 11 GPS 42mm viền nhôm dây thể thao
-- Slug: apple-watch-series-11-42mm-vien-nhom-day-the-thao
-- Variants: 8

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Apple';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Đồng hồ thông minh';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Apple Watch Series 11 GPS 42mm viền nhôm dây thể thao',
        'apple-watch-series-11-42mm-vien-nhom-day-the-thao',
        v_brand_id,
        v_category_id,
        'Trong sự kiện công nghệ “Awe Dropping” tháng 9/2025, bên cạnh dòng iPhone 17, Apple đã chính thức trình làng Apple Watch Series 11 GPS 42mm - phiên bản smartwatch mới nhất hứa hẹn sẽ nâng tầm trải nghiệm người dùng. Với sự kết hợp giữa thiết kế tối giản sang trọng, các tính năng mới hữu ích,... sản phẩm tiếp tục khẳng định vị thế dẫn đầu của Apple trong lĩnh vực thiết bị đeo thông minh.',
        '{"meta_title": "Apple Watch Series 11 GPS 42mm viền nhôm dây thể thao - giá rẻ", "meta_description": "Apple Watch Series 11 GPS 42mm viền nhôm dây thể thao chính hãng, giá rẻ. Mua online giao nhanh toàn quốc 1 giờ, xem hàng không mua không sao. Click ngay!", "meta_keywords": "Mua Apple Watch Series 11 GPS 42mm viền nhôm dây thể thao, mua online Apple Watch Series 11 GPS 42mm viền nhôm dây thể thao, Apple Watch Series 11 GPS 42mm viền nhôm dây thể thao"}'::jsonb,
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
        'APPLE_WATCH_SERIES_11_42MM_VIEN_NHOM_DAY_THE_THAO_42MM_VANG_HONG',
        'apple-watch-series-11-42mm-vien-nhom-day-the-thao-42mm-vang-hong',
        '{"color": "Vàng Hồng", "size": "42mm"}'::jsonb,
        10990000.0,
        11490000.0,
        942,
        '[{"Màn hình": {"Công nghệ màn hình": "OLED", "Kích thước màn hình": "Hãng không công bố", "Độ phân giải": "374 x 446 pixels", "Kích thước mặt": "42 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Ion-X strengthened glass", "Chất liệu khung viền": "Nhôm", "Chất liệu dây": "Silicone", "Độ rộng dây": "Hãng không công bố", "Chu vi cổ tay phù hợp": "13 - 20 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 42 mm - Ngang 36 mm - Dày 9.7 mm - Nặng 30.3 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Chạy bộ", "Bơi lội", "Đạp xe", "Ba môn phối hợp (Triathlon)", "Golf", "Trượt tuyết", "Chèo thuyền"], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe"], "Chống nước / Kháng nước": "Chống nước 5 ATM - ISO 22810:2010 (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ", "Đo nồng độ oxy (SpO2)", "Ước tính ngày rụng trứng", "Vùng nhịp tim", "Theo dõi nhịp thở 24/7", "Theo dõi Nồng độ oxy trong máu 24h", "Cảnh báo tăng huyết áp", "Cảnh báo ngưng thở khi ngủ", "Chấm điểm giấc ngủ", "Tính quãng đường chạy", "Theo dõi nhịp tim 24h", "Theo dõi mức độ căng thẳng 24h", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tính năng Family Setup", "Trợ lý giọng nói", "Nâng cổ tay sáng màn hình", "Màn hình cảm ứng", "Đồng hồ bấm giờ", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Thay mặt đồng hồ", "Rung thông báo", "Dự báo thời tiết", "Cuộc gọi khẩn cấp SOS", "Báo thức", "Đèn pin", "Ứng dụng Tiếng Ồn", "Ứng dụng Thuốc", "Ứng dụng Sinh Hiệu", "Ứng dụng Chú Tâm (Mindfulness)", "Vòng hoạt động", "Tính năng Workout Buddy", "Thủy triều", "Phát hiện va chạm", "Loa và mic thế hệ thứ hai", "Khối lượng tập luyện", "Cử chỉ lắc cổ tay", "Chống bụi IP6X", "Chạm hai lần (Double Tap)", "Bản đồ ngoại tuyến", "Bài tập Gym và Fitness (Cardio, HIIT, Pilates,...)", "Apple Pay", "Ngăn xếp thông minh (Smart Stack)", "Sạc nhanh"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Viber", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 24 giờ sử dụng cơ bản", "Khoảng 38 giờ ở chế độ nguồn điện thấp"], "Thời gian sạc": "Hãng không công bố", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Apple S10", "Bộ nhớ trong": "64 GB", "Hệ điều hành": "watchOS phiên bản mới nhất", "Kết nối được với hệ điều hành": "iPhone 11 trở lên, bao gồm iPhone SE (thế hệ thứ 2 trở lên), chạy iOS 26 trở lên", "Ứng dụng quản lý": "Watch", "Kết nối": ["Bluetooth v5.3", "Kết nối 5G", "Wifi"], "Cảm biến": ["Cảm biến nhiệt độ nước", "Cảm biến ánh sáng môi trường", "Gia tốc kế lực G cao", "Cảm biến nhiệt độ", "Con quay hồi chuyển dải động cao", "Cảm biến điện học (ECG)", "Cảm biến độ sâu", "Cảm biến nhịp tim quang học thế hệ 3", "Cao áp kế", "La bàn", "Đo SpO2"], "Định vị": ["Beidou", "GLONASS", "GPS", "QZSS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Đang cập nhật", "Thời gian ra mắt": "09/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh"]}}]'::jsonb,
        ARRAY['apple-watch-series-11-vien-nhom-day-the-thao-hong-1-638931878401695857.jpg', 'apple-watch-series-11-vien-nhom-day-the-thao-hong-2-638931878408718797.jpg', 'apple-watch-series-11-vien-nhom-day-the-thao-hong-3-638931878416947380.jpg', 'apple-watch-series-11-42mm-vien-nhom-day-the-thao-40-638976216616007512.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-hong-2-638931878408718797.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-hong-3-638931878416947380.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-42mm-vien-nhom-day-the-thao-40-638976216616007512.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-hong-1-638931878401695857.jpg'
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
        'APPLE_WATCH_SERIES_11_42MM_VIEN_NHOM_DAY_THE_THAO_42MM_DEN_BONG',
        'apple-watch-series-11-42mm-vien-nhom-day-the-thao-42mm-den-bong',
        '{"color": "Đen bóng", "size": "42mm"}'::jsonb,
        10990000.0,
        11490000.0,
        94,
        '[{"Màn hình": {"Công nghệ màn hình": "OLED", "Kích thước màn hình": "Hãng không công bố", "Độ phân giải": "374 x 446 pixels", "Kích thước mặt": "42 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Ion-X strengthened glass", "Chất liệu khung viền": "Nhôm", "Chất liệu dây": "Silicone", "Độ rộng dây": "Hãng không công bố", "Chu vi cổ tay phù hợp": "13 - 20 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 42 mm - Ngang 36 mm - Dày 9.7 mm - Nặng 30.3 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Chạy bộ", "Bơi lội", "Đạp xe", "Ba môn phối hợp (Triathlon)", "Golf", "Trượt tuyết", "Chèo thuyền"], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe"], "Chống nước / Kháng nước": "Chống nước 5 ATM - ISO 22810:2010 (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ", "Đo nồng độ oxy (SpO2)", "Ước tính ngày rụng trứng", "Vùng nhịp tim", "Theo dõi nhịp thở 24/7", "Theo dõi Nồng độ oxy trong máu 24h", "Cảnh báo tăng huyết áp", "Cảnh báo ngưng thở khi ngủ", "Chấm điểm giấc ngủ", "Tính quãng đường chạy", "Theo dõi nhịp tim 24h", "Theo dõi mức độ căng thẳng 24h", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tính năng Family Setup", "Trợ lý giọng nói", "Nâng cổ tay sáng màn hình", "Màn hình cảm ứng", "Đồng hồ bấm giờ", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Thay mặt đồng hồ", "Rung thông báo", "Dự báo thời tiết", "Cuộc gọi khẩn cấp SOS", "Báo thức", "Đèn pin", "Ứng dụng Tiếng Ồn", "Ứng dụng Thuốc", "Ứng dụng Sinh Hiệu", "Ứng dụng Chú Tâm (Mindfulness)", "Vòng hoạt động", "Tính năng Workout Buddy", "Thủy triều", "Phát hiện va chạm", "Loa và mic thế hệ thứ hai", "Khối lượng tập luyện", "Cử chỉ lắc cổ tay", "Chống bụi IP6X", "Chạm hai lần (Double Tap)", "Bản đồ ngoại tuyến", "Bài tập Gym và Fitness (Cardio, HIIT, Pilates,...)", "Apple Pay", "Ngăn xếp thông minh (Smart Stack)", "Sạc nhanh"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Viber", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 24 giờ sử dụng cơ bản", "Khoảng 38 giờ ở chế độ nguồn điện thấp"], "Thời gian sạc": "Hãng không công bố", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Apple S10", "Bộ nhớ trong": "64 GB", "Hệ điều hành": "watchOS phiên bản mới nhất", "Kết nối được với hệ điều hành": "iPhone 11 trở lên, bao gồm iPhone SE (thế hệ thứ 2 trở lên), chạy iOS 26 trở lên", "Ứng dụng quản lý": "Watch", "Kết nối": ["Bluetooth v5.3", "Kết nối 5G", "Wifi"], "Cảm biến": ["Cảm biến nhiệt độ nước", "Cảm biến ánh sáng môi trường", "Gia tốc kế lực G cao", "Cảm biến nhiệt độ", "Con quay hồi chuyển dải động cao", "Cảm biến điện học (ECG)", "Cảm biến độ sâu", "Cảm biến nhịp tim quang học thế hệ 3", "Cao áp kế", "La bàn", "Đo SpO2"], "Định vị": ["Beidou", "GLONASS", "GPS", "QZSS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Đang cập nhật", "Thời gian ra mắt": "09/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh"]}}]'::jsonb,
        ARRAY['apple-watch-series-11-vien-nhom-day-the-thao-hong-1-638931878401695857.jpg', 'apple-watch-series-11-vien-nhom-day-the-thao-hong-2-638931878408718797.jpg', 'apple-watch-series-11-vien-nhom-day-the-thao-hong-3-638931878416947380.jpg', 'apple-watch-series-11-42mm-vien-nhom-day-the-thao-40-638976216616007512.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-hong-2-638931878408718797.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-hong-3-638931878416947380.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-42mm-vien-nhom-day-the-thao-40-638976216616007512.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-hong-1-638931878401695857.jpg'
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
        'APPLE_WATCH_SERIES_11_42MM_VIEN_NHOM_DAY_THE_THAO_42MM_BAC',
        'apple-watch-series-11-42mm-vien-nhom-day-the-thao-42mm-bac',
        '{"color": "Bạc", "size": "42mm"}'::jsonb,
        10990000.0,
        11490000.0,
        823,
        '[{"Màn hình": {"Công nghệ màn hình": "OLED", "Kích thước màn hình": "Hãng không công bố", "Độ phân giải": "374 x 446 pixels", "Kích thước mặt": "42 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Ion-X strengthened glass", "Chất liệu khung viền": "Nhôm", "Chất liệu dây": "Silicone", "Độ rộng dây": "Hãng không công bố", "Chu vi cổ tay phù hợp": "13 - 20 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 42 mm - Ngang 36 mm - Dày 9.7 mm - Nặng 30.3 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Chạy bộ", "Bơi lội", "Đạp xe", "Ba môn phối hợp (Triathlon)", "Golf", "Trượt tuyết", "Chèo thuyền"], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe"], "Chống nước / Kháng nước": "Chống nước 5 ATM - ISO 22810:2010 (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ", "Đo nồng độ oxy (SpO2)", "Ước tính ngày rụng trứng", "Vùng nhịp tim", "Theo dõi nhịp thở 24/7", "Theo dõi Nồng độ oxy trong máu 24h", "Cảnh báo tăng huyết áp", "Cảnh báo ngưng thở khi ngủ", "Chấm điểm giấc ngủ", "Tính quãng đường chạy", "Theo dõi nhịp tim 24h", "Theo dõi mức độ căng thẳng 24h", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tính năng Family Setup", "Trợ lý giọng nói", "Nâng cổ tay sáng màn hình", "Màn hình cảm ứng", "Đồng hồ bấm giờ", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Thay mặt đồng hồ", "Rung thông báo", "Dự báo thời tiết", "Cuộc gọi khẩn cấp SOS", "Báo thức", "Đèn pin", "Ứng dụng Tiếng Ồn", "Ứng dụng Thuốc", "Ứng dụng Sinh Hiệu", "Ứng dụng Chú Tâm (Mindfulness)", "Vòng hoạt động", "Tính năng Workout Buddy", "Thủy triều", "Phát hiện va chạm", "Loa và mic thế hệ thứ hai", "Khối lượng tập luyện", "Cử chỉ lắc cổ tay", "Chống bụi IP6X", "Chạm hai lần (Double Tap)", "Bản đồ ngoại tuyến", "Bài tập Gym và Fitness (Cardio, HIIT, Pilates,...)", "Apple Pay", "Ngăn xếp thông minh (Smart Stack)", "Sạc nhanh"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Viber", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 24 giờ sử dụng cơ bản", "Khoảng 38 giờ ở chế độ nguồn điện thấp"], "Thời gian sạc": "Hãng không công bố", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Apple S10", "Bộ nhớ trong": "64 GB", "Hệ điều hành": "watchOS phiên bản mới nhất", "Kết nối được với hệ điều hành": "iPhone 11 trở lên, bao gồm iPhone SE (thế hệ thứ 2 trở lên), chạy iOS 26 trở lên", "Ứng dụng quản lý": "Watch", "Kết nối": ["Bluetooth v5.3", "Kết nối 5G", "Wifi"], "Cảm biến": ["Cảm biến nhiệt độ nước", "Cảm biến ánh sáng môi trường", "Gia tốc kế lực G cao", "Cảm biến nhiệt độ", "Con quay hồi chuyển dải động cao", "Cảm biến điện học (ECG)", "Cảm biến độ sâu", "Cảm biến nhịp tim quang học thế hệ 3", "Cao áp kế", "La bàn", "Đo SpO2"], "Định vị": ["Beidou", "GLONASS", "GPS", "QZSS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Đang cập nhật", "Thời gian ra mắt": "09/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh"]}}]'::jsonb,
        ARRAY['apple-watch-series-11-vien-nhom-day-the-thao-hong-1-638931878401695857.jpg', 'apple-watch-series-11-vien-nhom-day-the-thao-hong-2-638931878408718797.jpg', 'apple-watch-series-11-vien-nhom-day-the-thao-hong-3-638931878416947380.jpg', 'apple-watch-series-11-42mm-vien-nhom-day-the-thao-40-638976216616007512.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-hong-2-638931878408718797.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-hong-3-638931878416947380.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-42mm-vien-nhom-day-the-thao-40-638976216616007512.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-hong-1-638931878401695857.jpg'
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
        'APPLE_WATCH_SERIES_11_42MM_VIEN_NHOM_DAY_THE_THAO_42MM_XAM',
        'apple-watch-series-11-42mm-vien-nhom-day-the-thao-42mm-xam',
        '{"color": "Xám", "size": "42mm"}'::jsonb,
        10990000.0,
        11490000.0,
        946,
        '[{"Màn hình": {"Công nghệ màn hình": "OLED", "Kích thước màn hình": "Hãng không công bố", "Độ phân giải": "374 x 446 pixels", "Kích thước mặt": "42 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Ion-X strengthened glass", "Chất liệu khung viền": "Nhôm", "Chất liệu dây": "Silicone", "Độ rộng dây": "Hãng không công bố", "Chu vi cổ tay phù hợp": "13 - 20 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 42 mm - Ngang 36 mm - Dày 9.7 mm - Nặng 30.3 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Chạy bộ", "Bơi lội", "Đạp xe", "Ba môn phối hợp (Triathlon)", "Golf", "Trượt tuyết", "Chèo thuyền"], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe"], "Chống nước / Kháng nước": "Chống nước 5 ATM - ISO 22810:2010 (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ", "Đo nồng độ oxy (SpO2)", "Ước tính ngày rụng trứng", "Vùng nhịp tim", "Theo dõi nhịp thở 24/7", "Theo dõi Nồng độ oxy trong máu 24h", "Cảnh báo tăng huyết áp", "Cảnh báo ngưng thở khi ngủ", "Chấm điểm giấc ngủ", "Tính quãng đường chạy", "Theo dõi nhịp tim 24h", "Theo dõi mức độ căng thẳng 24h", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tính năng Family Setup", "Trợ lý giọng nói", "Nâng cổ tay sáng màn hình", "Màn hình cảm ứng", "Đồng hồ bấm giờ", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Thay mặt đồng hồ", "Rung thông báo", "Dự báo thời tiết", "Cuộc gọi khẩn cấp SOS", "Báo thức", "Đèn pin", "Ứng dụng Tiếng Ồn", "Ứng dụng Thuốc", "Ứng dụng Sinh Hiệu", "Ứng dụng Chú Tâm (Mindfulness)", "Vòng hoạt động", "Tính năng Workout Buddy", "Thủy triều", "Phát hiện va chạm", "Loa và mic thế hệ thứ hai", "Khối lượng tập luyện", "Cử chỉ lắc cổ tay", "Chống bụi IP6X", "Chạm hai lần (Double Tap)", "Bản đồ ngoại tuyến", "Bài tập Gym và Fitness (Cardio, HIIT, Pilates,...)", "Apple Pay", "Ngăn xếp thông minh (Smart Stack)", "Sạc nhanh"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Viber", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 24 giờ sử dụng cơ bản", "Khoảng 38 giờ ở chế độ nguồn điện thấp"], "Thời gian sạc": "Hãng không công bố", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Apple S10", "Bộ nhớ trong": "64 GB", "Hệ điều hành": "watchOS phiên bản mới nhất", "Kết nối được với hệ điều hành": "iPhone 11 trở lên, bao gồm iPhone SE (thế hệ thứ 2 trở lên), chạy iOS 26 trở lên", "Ứng dụng quản lý": "Watch", "Kết nối": ["Bluetooth v5.3", "Kết nối 5G", "Wifi"], "Cảm biến": ["Cảm biến nhiệt độ nước", "Cảm biến ánh sáng môi trường", "Gia tốc kế lực G cao", "Cảm biến nhiệt độ", "Con quay hồi chuyển dải động cao", "Cảm biến điện học (ECG)", "Cảm biến độ sâu", "Cảm biến nhịp tim quang học thế hệ 3", "Cao áp kế", "La bàn", "Đo SpO2"], "Định vị": ["Beidou", "GLONASS", "GPS", "QZSS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Đang cập nhật", "Thời gian ra mắt": "09/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh"]}}]'::jsonb,
        ARRAY['apple-watch-series-11-vien-nhom-day-the-thao-hong-1-638931878401695857.jpg', 'apple-watch-series-11-vien-nhom-day-the-thao-hong-2-638931878408718797.jpg', 'apple-watch-series-11-vien-nhom-day-the-thao-hong-3-638931878416947380.jpg', 'apple-watch-series-11-42mm-vien-nhom-day-the-thao-40-638976216616007512.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-hong-2-638931878408718797.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-hong-3-638931878416947380.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-42mm-vien-nhom-day-the-thao-40-638976216616007512.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-hong-1-638931878401695857.jpg'
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
        'APPLE_WATCH_SERIES_11_42MM_VIEN_NHOM_DAY_THE_THAO_46MM_VANG_HONG',
        'apple-watch-series-11-42mm-vien-nhom-day-the-thao-46mm-vang-hong',
        '{"color": "Vàng Hồng", "size": "46mm"}'::jsonb,
        12090000.0,
        12350000.0,
        291,
        '[{"Màn hình": {"Công nghệ màn hình": "OLED", "Kích thước màn hình": "Hãng không công bố", "Độ phân giải": "416 x 496 pixels", "Kích thước mặt": "46 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Ion-X strengthened glass", "Chất liệu khung viền": "Nhôm", "Chất liệu dây": "Silicone", "Độ rộng dây": "Hãng không công bố", "Chu vi cổ tay phù hợp": "14 - 24.5 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 46 mm - Ngang 39 mm - Dày 9.7 mm - Nặng 37.8 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Chạy bộ", "Bơi lội", "Đạp xe", "Ba môn phối hợp (Triathlon)", "Golf", "Trượt tuyết", "Chèo thuyền"], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe"], "Chống nước / Kháng nước": "Chống nước 5 ATM - ISO 22810:2010 (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ", "Đo nồng độ oxy (SpO2)", "Ước tính ngày rụng trứng", "Vùng nhịp tim", "Theo dõi nhịp thở 24/7", "Theo dõi Nồng độ oxy trong máu 24h", "Cảnh báo tăng huyết áp", "Cảnh báo ngưng thở khi ngủ", "Chấm điểm giấc ngủ", "Tính quãng đường chạy", "Theo dõi nhịp tim 24h", "Theo dõi mức độ căng thẳng 24h", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tính năng Family Setup", "Trợ lý giọng nói", "Nâng cổ tay sáng màn hình", "Màn hình cảm ứng", "Đồng hồ bấm giờ", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Thay mặt đồng hồ", "Rung thông báo", "Dự báo thời tiết", "Cuộc gọi khẩn cấp SOS", "Báo thức", "Đèn pin", "Ứng dụng Tiếng Ồn", "Ứng dụng Thuốc", "Ứng dụng Sinh Hiệu", "Ứng dụng Chú Tâm (Mindfulness)", "Vòng hoạt động", "Tính năng Workout Buddy", "Thủy triều", "Phát hiện va chạm", "Loa và mic thế hệ thứ hai", "Khối lượng tập luyện", "Cử chỉ lắc cổ tay", "Chống bụi IP6X", "Chạm hai lần (Double Tap)", "Bản đồ ngoại tuyến", "Bài tập Gym và Fitness (Cardio, HIIT, Pilates,...)", "Apple Pay", "Ngăn xếp thông minh (Smart Stack)", "Sạc nhanh"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Viber", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 24 giờ sử dụng cơ bản", "Khoảng 38 giờ ở chế độ nguồn điện thấp"], "Thời gian sạc": "Hãng không công bố", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Apple S10", "Bộ nhớ trong": "64 GB", "Hệ điều hành": "watchOS phiên bản mới nhất", "Kết nối được với hệ điều hành": "iPhone 11 trở lên, bao gồm iPhone SE (thế hệ thứ 2 trở lên), chạy iOS 26 trở lên", "Ứng dụng quản lý": "Watch", "Kết nối": ["Bluetooth v5.3", "Kết nối 5G", "Wifi"], "Cảm biến": ["Cảm biến nhiệt độ nước", "Cảm biến ánh sáng môi trường", "Gia tốc kế lực G cao", "Cảm biến nhiệt độ", "Con quay hồi chuyển dải động cao", "Cảm biến điện học (ECG)", "Cảm biến độ sâu", "Cảm biến nhịp tim quang học thế hệ 3", "Cao áp kế", "La bàn", "Đo SpO2"], "Định vị": ["Beidou", "GLONASS", "GPS", "QZSS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Đang cập nhật", "Thời gian ra mắt": "09/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh"]}}]'::jsonb,
        ARRAY['apple-watch-series-11-vien-nhom-day-the-thao-xam-1-638931878756012872.jpg', 'apple-watch-series-11-vien-nhom-day-the-thao-xam-2-638931878762811736.jpg', 'apple-watch-series-11-vien-nhom-day-the-thao-xam-3-638931878769208409.jpg', 'apple-watch-series-11-46mm-vien-nhom-day-the-thao-40-638976216559297370.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-xam-2-638931878762811736.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-xam-3-638931878769208409.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-46mm-vien-nhom-day-the-thao-40-638976216559297370.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-xam-1-638931878756012872.jpg'
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
        'APPLE_WATCH_SERIES_11_42MM_VIEN_NHOM_DAY_THE_THAO_46MM_DEN_BONG',
        'apple-watch-series-11-42mm-vien-nhom-day-the-thao-46mm-den-bong',
        '{"color": "Đen bóng", "size": "46mm"}'::jsonb,
        12090000.0,
        12350000.0,
        70,
        '[{"Màn hình": {"Công nghệ màn hình": "OLED", "Kích thước màn hình": "Hãng không công bố", "Độ phân giải": "416 x 496 pixels", "Kích thước mặt": "46 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Ion-X strengthened glass", "Chất liệu khung viền": "Nhôm", "Chất liệu dây": "Silicone", "Độ rộng dây": "Hãng không công bố", "Chu vi cổ tay phù hợp": "14 - 24.5 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 46 mm - Ngang 39 mm - Dày 9.7 mm - Nặng 37.8 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Chạy bộ", "Bơi lội", "Đạp xe", "Ba môn phối hợp (Triathlon)", "Golf", "Trượt tuyết", "Chèo thuyền"], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe"], "Chống nước / Kháng nước": "Chống nước 5 ATM - ISO 22810:2010 (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ", "Đo nồng độ oxy (SpO2)", "Ước tính ngày rụng trứng", "Vùng nhịp tim", "Theo dõi nhịp thở 24/7", "Theo dõi Nồng độ oxy trong máu 24h", "Cảnh báo tăng huyết áp", "Cảnh báo ngưng thở khi ngủ", "Chấm điểm giấc ngủ", "Tính quãng đường chạy", "Theo dõi nhịp tim 24h", "Theo dõi mức độ căng thẳng 24h", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tính năng Family Setup", "Trợ lý giọng nói", "Nâng cổ tay sáng màn hình", "Màn hình cảm ứng", "Đồng hồ bấm giờ", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Thay mặt đồng hồ", "Rung thông báo", "Dự báo thời tiết", "Cuộc gọi khẩn cấp SOS", "Báo thức", "Đèn pin", "Ứng dụng Tiếng Ồn", "Ứng dụng Thuốc", "Ứng dụng Sinh Hiệu", "Ứng dụng Chú Tâm (Mindfulness)", "Vòng hoạt động", "Tính năng Workout Buddy", "Thủy triều", "Phát hiện va chạm", "Loa và mic thế hệ thứ hai", "Khối lượng tập luyện", "Cử chỉ lắc cổ tay", "Chống bụi IP6X", "Chạm hai lần (Double Tap)", "Bản đồ ngoại tuyến", "Bài tập Gym và Fitness (Cardio, HIIT, Pilates,...)", "Apple Pay", "Ngăn xếp thông minh (Smart Stack)", "Sạc nhanh"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Viber", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 24 giờ sử dụng cơ bản", "Khoảng 38 giờ ở chế độ nguồn điện thấp"], "Thời gian sạc": "Hãng không công bố", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Apple S10", "Bộ nhớ trong": "64 GB", "Hệ điều hành": "watchOS phiên bản mới nhất", "Kết nối được với hệ điều hành": "iPhone 11 trở lên, bao gồm iPhone SE (thế hệ thứ 2 trở lên), chạy iOS 26 trở lên", "Ứng dụng quản lý": "Watch", "Kết nối": ["Bluetooth v5.3", "Kết nối 5G", "Wifi"], "Cảm biến": ["Cảm biến nhiệt độ nước", "Cảm biến ánh sáng môi trường", "Gia tốc kế lực G cao", "Cảm biến nhiệt độ", "Con quay hồi chuyển dải động cao", "Cảm biến điện học (ECG)", "Cảm biến độ sâu", "Cảm biến nhịp tim quang học thế hệ 3", "Cao áp kế", "La bàn", "Đo SpO2"], "Định vị": ["Beidou", "GLONASS", "GPS", "QZSS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Đang cập nhật", "Thời gian ra mắt": "09/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh"]}}]'::jsonb,
        ARRAY['apple-watch-series-11-vien-nhom-day-the-thao-xam-1-638931878756012872.jpg', 'apple-watch-series-11-vien-nhom-day-the-thao-xam-2-638931878762811736.jpg', 'apple-watch-series-11-vien-nhom-day-the-thao-xam-3-638931878769208409.jpg', 'apple-watch-series-11-46mm-vien-nhom-day-the-thao-40-638976216559297370.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-xam-2-638931878762811736.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-xam-3-638931878769208409.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-46mm-vien-nhom-day-the-thao-40-638976216559297370.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-xam-1-638931878756012872.jpg'
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
        'APPLE_WATCH_SERIES_11_42MM_VIEN_NHOM_DAY_THE_THAO_46MM_BAC',
        'apple-watch-series-11-42mm-vien-nhom-day-the-thao-46mm-bac',
        '{"color": "Bạc", "size": "46mm"}'::jsonb,
        12090000.0,
        12350000.0,
        149,
        '[{"Màn hình": {"Công nghệ màn hình": "OLED", "Kích thước màn hình": "Hãng không công bố", "Độ phân giải": "416 x 496 pixels", "Kích thước mặt": "46 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Ion-X strengthened glass", "Chất liệu khung viền": "Nhôm", "Chất liệu dây": "Silicone", "Độ rộng dây": "Hãng không công bố", "Chu vi cổ tay phù hợp": "14 - 24.5 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 46 mm - Ngang 39 mm - Dày 9.7 mm - Nặng 37.8 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Chạy bộ", "Bơi lội", "Đạp xe", "Ba môn phối hợp (Triathlon)", "Golf", "Trượt tuyết", "Chèo thuyền"], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe"], "Chống nước / Kháng nước": "Chống nước 5 ATM - ISO 22810:2010 (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ", "Đo nồng độ oxy (SpO2)", "Ước tính ngày rụng trứng", "Vùng nhịp tim", "Theo dõi nhịp thở 24/7", "Theo dõi Nồng độ oxy trong máu 24h", "Cảnh báo tăng huyết áp", "Cảnh báo ngưng thở khi ngủ", "Chấm điểm giấc ngủ", "Tính quãng đường chạy", "Theo dõi nhịp tim 24h", "Theo dõi mức độ căng thẳng 24h", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tính năng Family Setup", "Trợ lý giọng nói", "Nâng cổ tay sáng màn hình", "Màn hình cảm ứng", "Đồng hồ bấm giờ", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Thay mặt đồng hồ", "Rung thông báo", "Dự báo thời tiết", "Cuộc gọi khẩn cấp SOS", "Báo thức", "Đèn pin", "Ứng dụng Tiếng Ồn", "Ứng dụng Thuốc", "Ứng dụng Sinh Hiệu", "Ứng dụng Chú Tâm (Mindfulness)", "Vòng hoạt động", "Tính năng Workout Buddy", "Thủy triều", "Phát hiện va chạm", "Loa và mic thế hệ thứ hai", "Khối lượng tập luyện", "Cử chỉ lắc cổ tay", "Chống bụi IP6X", "Chạm hai lần (Double Tap)", "Bản đồ ngoại tuyến", "Bài tập Gym và Fitness (Cardio, HIIT, Pilates,...)", "Apple Pay", "Ngăn xếp thông minh (Smart Stack)", "Sạc nhanh"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Viber", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 24 giờ sử dụng cơ bản", "Khoảng 38 giờ ở chế độ nguồn điện thấp"], "Thời gian sạc": "Hãng không công bố", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Apple S10", "Bộ nhớ trong": "64 GB", "Hệ điều hành": "watchOS phiên bản mới nhất", "Kết nối được với hệ điều hành": "iPhone 11 trở lên, bao gồm iPhone SE (thế hệ thứ 2 trở lên), chạy iOS 26 trở lên", "Ứng dụng quản lý": "Watch", "Kết nối": ["Bluetooth v5.3", "Kết nối 5G", "Wifi"], "Cảm biến": ["Cảm biến nhiệt độ nước", "Cảm biến ánh sáng môi trường", "Gia tốc kế lực G cao", "Cảm biến nhiệt độ", "Con quay hồi chuyển dải động cao", "Cảm biến điện học (ECG)", "Cảm biến độ sâu", "Cảm biến nhịp tim quang học thế hệ 3", "Cao áp kế", "La bàn", "Đo SpO2"], "Định vị": ["Beidou", "GLONASS", "GPS", "QZSS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Đang cập nhật", "Thời gian ra mắt": "09/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh"]}}]'::jsonb,
        ARRAY['apple-watch-series-11-vien-nhom-day-the-thao-xam-1-638931878756012872.jpg', 'apple-watch-series-11-vien-nhom-day-the-thao-xam-2-638931878762811736.jpg', 'apple-watch-series-11-vien-nhom-day-the-thao-xam-3-638931878769208409.jpg', 'apple-watch-series-11-46mm-vien-nhom-day-the-thao-40-638976216559297370.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-xam-2-638931878762811736.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-xam-3-638931878769208409.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-46mm-vien-nhom-day-the-thao-40-638976216559297370.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-xam-1-638931878756012872.jpg'
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
        'APPLE_WATCH_SERIES_11_42MM_VIEN_NHOM_DAY_THE_THAO_46MM_XAM',
        'apple-watch-series-11-42mm-vien-nhom-day-the-thao-46mm-xam',
        '{"color": "Xám", "size": "46mm"}'::jsonb,
        12090000.0,
        12350000.0,
        154,
        '[{"Màn hình": {"Công nghệ màn hình": "OLED", "Kích thước màn hình": "Hãng không công bố", "Độ phân giải": "416 x 496 pixels", "Kích thước mặt": "46 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Ion-X strengthened glass", "Chất liệu khung viền": "Nhôm", "Chất liệu dây": "Silicone", "Độ rộng dây": "Hãng không công bố", "Chu vi cổ tay phù hợp": "14 - 24.5 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 46 mm - Ngang 39 mm - Dày 9.7 mm - Nặng 37.8 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Chạy bộ", "Bơi lội", "Đạp xe", "Ba môn phối hợp (Triathlon)", "Golf", "Trượt tuyết", "Chèo thuyền"], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe"], "Chống nước / Kháng nước": "Chống nước 5 ATM - ISO 22810:2010 (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ", "Đo nồng độ oxy (SpO2)", "Ước tính ngày rụng trứng", "Vùng nhịp tim", "Theo dõi nhịp thở 24/7", "Theo dõi Nồng độ oxy trong máu 24h", "Cảnh báo tăng huyết áp", "Cảnh báo ngưng thở khi ngủ", "Chấm điểm giấc ngủ", "Tính quãng đường chạy", "Theo dõi nhịp tim 24h", "Theo dõi mức độ căng thẳng 24h", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tính năng Family Setup", "Trợ lý giọng nói", "Nâng cổ tay sáng màn hình", "Màn hình cảm ứng", "Đồng hồ bấm giờ", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Thay mặt đồng hồ", "Rung thông báo", "Dự báo thời tiết", "Cuộc gọi khẩn cấp SOS", "Báo thức", "Đèn pin", "Ứng dụng Tiếng Ồn", "Ứng dụng Thuốc", "Ứng dụng Sinh Hiệu", "Ứng dụng Chú Tâm (Mindfulness)", "Vòng hoạt động", "Tính năng Workout Buddy", "Thủy triều", "Phát hiện va chạm", "Loa và mic thế hệ thứ hai", "Khối lượng tập luyện", "Cử chỉ lắc cổ tay", "Chống bụi IP6X", "Chạm hai lần (Double Tap)", "Bản đồ ngoại tuyến", "Bài tập Gym và Fitness (Cardio, HIIT, Pilates,...)", "Apple Pay", "Ngăn xếp thông minh (Smart Stack)", "Sạc nhanh"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Viber", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 24 giờ sử dụng cơ bản", "Khoảng 38 giờ ở chế độ nguồn điện thấp"], "Thời gian sạc": "Hãng không công bố", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Apple S10", "Bộ nhớ trong": "64 GB", "Hệ điều hành": "watchOS phiên bản mới nhất", "Kết nối được với hệ điều hành": "iPhone 11 trở lên, bao gồm iPhone SE (thế hệ thứ 2 trở lên), chạy iOS 26 trở lên", "Ứng dụng quản lý": "Watch", "Kết nối": ["Bluetooth v5.3", "Kết nối 5G", "Wifi"], "Cảm biến": ["Cảm biến nhiệt độ nước", "Cảm biến ánh sáng môi trường", "Gia tốc kế lực G cao", "Cảm biến nhiệt độ", "Con quay hồi chuyển dải động cao", "Cảm biến điện học (ECG)", "Cảm biến độ sâu", "Cảm biến nhịp tim quang học thế hệ 3", "Cao áp kế", "La bàn", "Đo SpO2"], "Định vị": ["Beidou", "GLONASS", "GPS", "QZSS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Đang cập nhật", "Thời gian ra mắt": "09/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh"]}}]'::jsonb,
        ARRAY['apple-watch-series-11-vien-nhom-day-the-thao-xam-1-638931878756012872.jpg', 'apple-watch-series-11-vien-nhom-day-the-thao-xam-2-638931878762811736.jpg', 'apple-watch-series-11-vien-nhom-day-the-thao-xam-3-638931878769208409.jpg', 'apple-watch-series-11-46mm-vien-nhom-day-the-thao-40-638976216559297370.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-xam-2-638931878762811736.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-xam-3-638931878769208409.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-46mm-vien-nhom-day-the-thao-40-638976216559297370.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-series-11-42mm-vien-nhom-day-the-thao/apple-watch-series-11-vien-nhom-day-the-thao-xam-1-638931878756012872.jpg'
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

-- Product: Apple Watch Ultra 3 GPS + Cellular 49mm viền Titanium dây Alpine
-- Slug: apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine
-- Variants: 2

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Apple';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Đồng hồ thông minh';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Apple Watch Ultra 3 GPS + Cellular 49mm viền Titanium dây Alpine',
        'apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine',
        v_brand_id,
        v_category_id,
        'Sự kiện “Awe-Dropping” tháng 9/2025 không chỉ gây ấn tượng mạnh với iPhone 17 Series mà còn đánh dấu sự ra mắt của Apple Watch Ultra 3 GPS + Cellular 49mm viền Titanium dây Alpine . Với thiết kế bền bỉ, màn hình cải tiến, chip xử lý thế hệ mới cùng nhiều tính năng thông minh, chiếc smartwatch này tiếp tục khẳng định vị thế dẫn đầu trong phân khúc cao cấp, trở thành người bạn đồng hành đáng tin cậy cho cả thể thao chuyên nghiệp lẫn cuộc sống thường ngày.',
        '{"meta_title": "Apple Watch Ultra 3 GPS + Cellular 49mm viền Titanium dây Alpine - giá rẻ", "meta_description": "Apple Watch Ultra 3 GPS + Cellular 49mm viền Titanium dây Alpine chính hãng, giá rẻ. Mua online giao nhanh toàn quốc 1 giờ, xem hàng không mua không sao. Click ngay!", "meta_keywords": "Mua Apple Watch Ultra 3 GPS + Cellular 49mm viền Titanium dây Alpine, mua online Apple Watch Ultra 3 GPS + Cellular 49mm viền Titanium dây Alpine, Apple Watch Ultra 3 GPS + Cellular 49mm viền Titanium dây Alpine"}'::jsonb,
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
        'APPLE_WATCH_ULTRA_3_GPS_CELLULAR_49MM_VIEN_TITANIUM_DAY_ALPINE_TITAN_DEN',
        'apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-titan-den',
        '{"color": "Titan đen"}'::jsonb,
        23790000.0,
        23990000.0,
        442,
        '[{"Màn hình": {"Công nghệ màn hình": "OLED", "Kích thước màn hình": "1.92 inch", "Độ phân giải": "422 x 514 pixels", "Kích thước mặt": "49 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Kính Sapphire", "Chất liệu khung viền": "Titanium", "Chất liệu dây": "Dây vải", "Độ rộng dây": "Hãng không công bố", "Chu vi cổ tay phù hợp": "13 - 21 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 49 mm - Ngang 44 mm - Dày 12 mm - Nặng Đang cập nhật"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Chạy bộ", "Bơi lội", "Đạp xe", "Lặn"], "Sim": "eSIM", "Hỗ trợ nghe gọi": "Nghe gọi độc lập", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe"], "Chống nước / Kháng nước": "Chống nước 10 ATM (Bơi, lặn vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ", "Gửi thông báo khi có tai nạn", "Đo nồng độ oxy (SpO2)", "Ước tính ngày rụng trứng", "Vùng nhịp tim", "Theo dõi nhịp thở 24/7", "Theo dõi Nồng độ oxy trong máu 24h", "Cảnh báo tăng huyết áp", "Cảnh báo ngưng thở khi ngủ", "Chấm điểm giấc ngủ", "Tính quãng đường chạy", "Theo dõi nhịp tim 24h", "Theo dõi mức độ căng thẳng 24h", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tính năng Family Setup", "Trợ lý giọng nói", "Nâng cổ tay sáng màn hình", "Màn hình cảm ứng", "Chứng nhận độ bền MIL-STD-810H", "Chế độ tiết kiệm năng lượng", "Đồng hồ bấm giờ", "Điều khiển chụp ảnh", "Từ chối cuộc gọi", "Tìm điện thoại", "Thay mặt đồng hồ", "Dự báo thời tiết", "Cuộc gọi khẩn cấp SOS", "Báo thức", "Đèn pin", "Always On Display", "Ứng dụng Sinh Hiệu", "Ứng dụng Chú Tâm (Mindfulness)", "Vòng hoạt động", "Tính năng Workout Buddy", "Thủy triều", "Phát hiện va chạm", "Loa kép và 3 micro tích hợp", "Khối lượng tập luyện", "Cử chỉ lắc cổ tay", "Chống bụi IP6X", "Chạm hai lần (Double Tap)", "Chuẩn quốc tế EN13319 cho phụ kiện lặn", "Bản đồ ngoại tuyến", "Bài tập Gym và Fitness (Cardio, HIIT, Pilates,...)", "Apple Pay", "Ngăn xếp thông minh (Smart Stack)", "Sạc nhanh"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Viber", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 42 giờ sử dụng cơ bản", "Khoảng 72 giờ ở chế độ tiết kiệm pin"], "Thời gian sạc": "Khoảng 1.5 giờ", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Cáp sạc nhanh từ tính USB-C"}}, {"Cấu hình & Kết nối": {"CPU": "Apple S10", "Bộ nhớ trong": "64 GB", "Hệ điều hành": "watchOS phiên bản mới nhất", "Kết nối được với hệ điều hành": "iPhone 11 trở lên, bao gồm iPhone SE (thế hệ thứ 2 trở lên), chạy iOS 26 trở lên", "Ứng dụng quản lý": "Watch", "Kết nối": ["Bluetooth v5.3", "Wi-Fi 4", "Kết nối 5G"], "Cảm biến": ["Cảm biến nhiệt độ nước", "Cảm biến ánh sáng môi trường", "Cảm biến nhiệt độ", "Con quay hồi chuyển dải động cao", "Cảm biến điện học (ECG)", "Cảm biến độ sâu", "Cảm biến nhịp tim quang học thế hệ 3", "Cao áp kế", "Gia tốc kế", "La bàn", "Đo SpO2"], "Định vị": ["Beidou", "GLONASS", "GPS", "QZSS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Trung Quốc", "Thời gian ra mắt": "09/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh"]}}]'::jsonb,
        ARRAY['apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-den-1-638931951069126312.jpg', 'apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-den-2-638931951080308579.jpg', 'apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-den-3-638931951086590572.jpg', 'apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-40-638976225700019574.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine/apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-den-2-638931951080308579.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine/apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-den-3-638931951086590572.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine/apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-40-638976225700019574.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine/apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-den-1-638931951069126312.jpg'
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
        'APPLE_WATCH_ULTRA_3_GPS_CELLULAR_49MM_VIEN_TITANIUM_DAY_ALPINE_TITAN_TU_NHIEN',
        'apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-titan-tu-nhien',
        '{"color": "Titan tự nhiên"}'::jsonb,
        23790000.0,
        23990000.0,
        575,
        '[{"Màn hình": {"Công nghệ màn hình": "OLED", "Kích thước màn hình": "1.92 inch", "Độ phân giải": "422 x 514 pixels", "Kích thước mặt": "49 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Kính Sapphire", "Chất liệu khung viền": "Titanium", "Chất liệu dây": "Dây vải", "Độ rộng dây": "Hãng không công bố", "Chu vi cổ tay phù hợp": "13 - 21 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 49 mm - Ngang 44 mm - Dày 12 mm - Nặng Đang cập nhật"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Chạy bộ", "Bơi lội", "Đạp xe", "Lặn"], "Sim": "eSIM", "Hỗ trợ nghe gọi": "Nghe gọi độc lập", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe"], "Chống nước / Kháng nước": "Chống nước 10 ATM (Bơi, lặn vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ", "Gửi thông báo khi có tai nạn", "Đo nồng độ oxy (SpO2)", "Ước tính ngày rụng trứng", "Vùng nhịp tim", "Theo dõi nhịp thở 24/7", "Theo dõi Nồng độ oxy trong máu 24h", "Cảnh báo tăng huyết áp", "Cảnh báo ngưng thở khi ngủ", "Chấm điểm giấc ngủ", "Tính quãng đường chạy", "Theo dõi nhịp tim 24h", "Theo dõi mức độ căng thẳng 24h", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tính năng Family Setup", "Trợ lý giọng nói", "Nâng cổ tay sáng màn hình", "Màn hình cảm ứng", "Chứng nhận độ bền MIL-STD-810H", "Chế độ tiết kiệm năng lượng", "Đồng hồ bấm giờ", "Điều khiển chụp ảnh", "Từ chối cuộc gọi", "Tìm điện thoại", "Thay mặt đồng hồ", "Dự báo thời tiết", "Cuộc gọi khẩn cấp SOS", "Báo thức", "Đèn pin", "Always On Display", "Ứng dụng Sinh Hiệu", "Ứng dụng Chú Tâm (Mindfulness)", "Vòng hoạt động", "Tính năng Workout Buddy", "Thủy triều", "Phát hiện va chạm", "Loa kép và 3 micro tích hợp", "Khối lượng tập luyện", "Cử chỉ lắc cổ tay", "Chống bụi IP6X", "Chạm hai lần (Double Tap)", "Chuẩn quốc tế EN13319 cho phụ kiện lặn", "Bản đồ ngoại tuyến", "Bài tập Gym và Fitness (Cardio, HIIT, Pilates,...)", "Apple Pay", "Ngăn xếp thông minh (Smart Stack)", "Sạc nhanh"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Viber", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 42 giờ sử dụng cơ bản", "Khoảng 72 giờ ở chế độ tiết kiệm pin"], "Thời gian sạc": "Khoảng 1.5 giờ", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Cáp sạc nhanh từ tính USB-C"}}, {"Cấu hình & Kết nối": {"CPU": "Apple S10", "Bộ nhớ trong": "64 GB", "Hệ điều hành": "watchOS phiên bản mới nhất", "Kết nối được với hệ điều hành": "iPhone 11 trở lên, bao gồm iPhone SE (thế hệ thứ 2 trở lên), chạy iOS 26 trở lên", "Ứng dụng quản lý": "Watch", "Kết nối": ["Bluetooth v5.3", "Wi-Fi 4", "Kết nối 5G"], "Cảm biến": ["Cảm biến nhiệt độ nước", "Cảm biến ánh sáng môi trường", "Cảm biến nhiệt độ", "Con quay hồi chuyển dải động cao", "Cảm biến điện học (ECG)", "Cảm biến độ sâu", "Cảm biến nhịp tim quang học thế hệ 3", "Cao áp kế", "Gia tốc kế", "La bàn", "Đo SpO2"], "Định vị": ["Beidou", "GLONASS", "GPS", "QZSS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Trung Quốc", "Thời gian ra mắt": "09/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh"]}}]'::jsonb,
        ARRAY['apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-tu-nhien-1-638931884914954580.jpg', 'apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-tu-nhien-2-638931884921907079.jpg', 'apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-tu-nhien-3-638931884927316053.jpg', 'apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-40-638976225508058826.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine/apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-tu-nhien-2-638931884921907079.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine/apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-tu-nhien-3-638931884927316053.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine/apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-40-638976225508058826.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine/apple-watch-ultra-3-gps-cellular-49mm-vien-titanium-day-alpine-tu-nhien-1-638931884914954580.jpg'
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

-- Product: Garmin Forerunner 965 47.2mm dây silicone
-- Slug: garmin-forerunner-965-day-silicone
-- Variants: 3

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Garmin';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Đồng hồ thông minh';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Garmin Forerunner 965 47.2mm dây silicone',
        'garmin-forerunner-965-day-silicone',
        v_brand_id,
        v_category_id,
        'Hãng đồng hồ thông minh thể thao lớn nhất thế giới Garmin đã trình làng thế hệ smartwatch dành cho người chạy bộ mới nhất trong năm của mình mang tên Garmin Forerunner 965 . Với việc nâng cấp mạnh mẽ về màn hình và thời lượng pin, đây hứa hẹn là thế hệ Forerunner mang lại trải nghiệm tối ưu nhất dành cho các tín đồ của môn chạy bộ.',
        '{"meta_title": "Đồng hồ Garmin Forerunner 965 | Trả góp 0%, thu cũ đổi mới", "meta_description": "Mua đồng hồ thông minh Garmin Forerunner 965 chính hãng, giảm hơn 3 triệu, theo dõi chạy bộ, sức khỏe, chống nước khi bơi lội. Trả góp 0%, thu cũ đổi mới. Mua ngay!", "meta_keywords": "Mua đồng hồ thông minh Garmin Forerunner 965 chính hãng, giảm hơn 3 triệu, theo dõi chạy bộ, sức khỏe, chống nước khi bơi lội. Trả góp 0%, thu cũ đổi mới. Mua ngay!"}'::jsonb,
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
        'GARMIN_FORERUNNER_965_DAY_SILICONE_DEN',
        'garmin-forerunner-965-day-silicone-den',
        '{"color": "Đen"}'::jsonb,
        12950000.0,
        12990000.0,
        237,
        '[{"Màn hình": {"Công nghệ màn hình": "AMOLED", "Kích thước màn hình": "1.4 inch", "Độ phân giải": "454 x 454 pixels", "Kích thước mặt": "47.2 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Gorilla Glass 3 DX", "Chất liệu khung viền": "Titanium", "Chất liệu dây": "Silicone", "Độ rộng dây": "2.2 cm", "Chu vi cổ tay phù hợp": "13.5 - 20.5 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 47.2 mm - Ngang 47.2 mm - Dày 13.2 mm - Nặng 53 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ đường dài", "Đi bộ", "Quần vợt", "Yoga", "Leo núi", "Chạy địa hình (trail)", "Bóng rổ", "Chạy bộ", "Bơi lội", "Đạp xe", "Ba môn phối hợp (Triathlon)", "Golf", "Khúc côn cầu", "Bóng chày", "Trượt tuyết", "Chèo thuyền"], "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Nghe nhạc"], "Chống nước / Kháng nước": "Kháng nước 5 ATM (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Đo lượng tiêu thụ oxy tối đa (VO2 Max)", "Đo nồng độ oxy (SpO2)", "Tính quãng đường chạy", "Đo chỉ số năng lượng cơ thể (Body Battery)", "Đánh giá chỉ số trẻ hóa của cơ thể (Fitness Age)", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi mức độ stress", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tìm đồng hồ", "Theo dõi trực tuyến (LiveTrack)", "Màn hình cảm ứng", "Đồng hồ bấm giờ", "Điều khiển chơi nhạc", "Từ chối cuộc gọi bằng tin nhắn soạn sẵn (chỉ hoạt động trên Android)", "Tìm điện thoại", "Trả lời nhanh tin nhắn có sẵn (chỉ hoạt động trên Android)", "Dự báo thời tiết", "Báo thức", "Công nghệ SATIQ", "Bài tập Gym và Fitness (Cardio, HIIT, Pilates,...)", "Lưu trữ nhạc"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 23 ngày (ở chế độ đồng hồ thông minh)", "Khoảng 31 giờ (ở chế độ GPS)"], "Thời gian sạc": "Khoảng 2 giờ", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Cổng sạc Universal"}}, {"Cấu hình & Kết nối": {"CPU": "Hãng không công bố", "Bộ nhớ trong": "32 GB", "Hệ điều hành": "Hãng không công bố", "Kết nối được với hệ điều hành": ["Android 6.0 trở lên", "iOS 11 trở lên"], "Ứng dụng quản lý": "Garmin Connect", "Kết nối": ["Bluetooth", "NFC", "Wifi"], "Cảm biến": ["Cảm biến ánh sáng môi trường", "Con quay hồi chuyển", "Gia tốc kế", "La bàn", "Pulse Ox", "Theo dõi nhịp tim ở cổ tay Garmin Elevate"], "Định vị": ["GLONASS", "GPS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Đài Loan", "Thời gian ra mắt": "4/2023", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh"]}}]'::jsonb,
        ARRAY['garmin-forerunner-965-den-1.jpg', 'garmin-forerunner-965-den-2.jpg', 'garmin-forerunner-965-den-3.jpg', 'garmin-forerunner-965-day-silicone-den-45.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-forerunner-965-day-silicone/garmin-forerunner-965-den-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-forerunner-965-day-silicone/garmin-forerunner-965-den-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-forerunner-965-day-silicone/garmin-forerunner-965-day-silicone-den-45.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-forerunner-965-day-silicone/garmin-forerunner-965-den-1.jpg'
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
        'GARMIN_FORERUNNER_965_DAY_SILICONE_VANG',
        'garmin-forerunner-965-day-silicone-vang',
        '{"color": "Vàng"}'::jsonb,
        12950000.0,
        12990000.0,
        453,
        '[{"Màn hình": {"Công nghệ màn hình": "AMOLED", "Kích thước màn hình": "1.4 inch", "Độ phân giải": "454 x 454 pixels", "Kích thước mặt": "47.2 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Gorilla Glass 3 DX", "Chất liệu khung viền": "Titanium", "Chất liệu dây": "Silicone", "Độ rộng dây": "2.2 cm", "Chu vi cổ tay phù hợp": "13.5 - 20.5 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 47.2 mm - Ngang 47.2 mm - Dày 13.2 mm - Nặng 53 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ đường dài", "Đi bộ", "Quần vợt", "Yoga", "Leo núi", "Chạy địa hình (trail)", "Bóng rổ", "Chạy bộ", "Bơi lội", "Đạp xe", "Ba môn phối hợp (Triathlon)", "Golf", "Khúc côn cầu", "Bóng chày", "Trượt tuyết", "Chèo thuyền"], "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Nghe nhạc"], "Chống nước / Kháng nước": "Kháng nước 5 ATM (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Đo lượng tiêu thụ oxy tối đa (VO2 Max)", "Đo nồng độ oxy (SpO2)", "Tính quãng đường chạy", "Đo chỉ số năng lượng cơ thể (Body Battery)", "Đánh giá chỉ số trẻ hóa của cơ thể (Fitness Age)", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi mức độ stress", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tìm đồng hồ", "Theo dõi trực tuyến (LiveTrack)", "Màn hình cảm ứng", "Đồng hồ bấm giờ", "Điều khiển chơi nhạc", "Từ chối cuộc gọi bằng tin nhắn soạn sẵn (chỉ hoạt động trên Android)", "Tìm điện thoại", "Trả lời nhanh tin nhắn có sẵn (chỉ hoạt động trên Android)", "Dự báo thời tiết", "Báo thức", "Công nghệ SATIQ", "Bài tập Gym và Fitness (Cardio, HIIT, Pilates,...)", "Lưu trữ nhạc"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 23 ngày (ở chế độ đồng hồ thông minh)", "Khoảng 31 giờ (ở chế độ GPS)"], "Thời gian sạc": "Khoảng 2 giờ", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Cổng sạc Universal"}}, {"Cấu hình & Kết nối": {"CPU": "Hãng không công bố", "Bộ nhớ trong": "32 GB", "Hệ điều hành": "Hãng không công bố", "Kết nối được với hệ điều hành": ["Android 6.0 trở lên", "iOS 11 trở lên"], "Ứng dụng quản lý": "Garmin Connect", "Kết nối": ["Bluetooth", "NFC", "Wifi"], "Cảm biến": ["Cảm biến ánh sáng môi trường", "Con quay hồi chuyển", "Gia tốc kế", "La bàn", "Pulse Ox", "Theo dõi nhịp tim ở cổ tay Garmin Elevate"], "Định vị": ["GLONASS", "GPS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Đài Loan", "Thời gian ra mắt": "4/2023", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh"]}}]'::jsonb,
        ARRAY['garmin-forerunner-965-vang-1.jpg', 'garmin-forerunner-965-vang-2.jpg', 'garmin-forerunner-965-vang-3.jpg', 'garmin-forerunner-965-day-silicone-vang-45.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-forerunner-965-day-silicone/garmin-forerunner-965-vang-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-forerunner-965-day-silicone/garmin-forerunner-965-vang-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-forerunner-965-day-silicone/garmin-forerunner-965-day-silicone-vang-45.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-forerunner-965-day-silicone/garmin-forerunner-965-vang-1.jpg'
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
        'GARMIN_FORERUNNER_965_DAY_SILICONE_TRANG',
        'garmin-forerunner-965-day-silicone-trang',
        '{"color": "Trắng"}'::jsonb,
        12950000.0,
        12990000.0,
        117,
        '[{"Màn hình": {"Công nghệ màn hình": "AMOLED", "Kích thước màn hình": "1.4 inch", "Độ phân giải": "454 x 454 pixels", "Kích thước mặt": "47.2 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Gorilla Glass 3 DX", "Chất liệu khung viền": "Titanium", "Chất liệu dây": "Silicone", "Độ rộng dây": "2.2 cm", "Chu vi cổ tay phù hợp": "13.5 - 20.5 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 47.2 mm - Ngang 47.2 mm - Dày 13.2 mm - Nặng 53 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ đường dài", "Đi bộ", "Quần vợt", "Yoga", "Leo núi", "Chạy địa hình (trail)", "Bóng rổ", "Chạy bộ", "Bơi lội", "Đạp xe", "Ba môn phối hợp (Triathlon)", "Golf", "Khúc côn cầu", "Bóng chày", "Trượt tuyết", "Chèo thuyền"], "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Nghe nhạc"], "Chống nước / Kháng nước": "Kháng nước 5 ATM (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Đo lượng tiêu thụ oxy tối đa (VO2 Max)", "Đo nồng độ oxy (SpO2)", "Tính quãng đường chạy", "Đo chỉ số năng lượng cơ thể (Body Battery)", "Đánh giá chỉ số trẻ hóa của cơ thể (Fitness Age)", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi mức độ stress", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tìm đồng hồ", "Theo dõi trực tuyến (LiveTrack)", "Màn hình cảm ứng", "Đồng hồ bấm giờ", "Điều khiển chơi nhạc", "Từ chối cuộc gọi bằng tin nhắn soạn sẵn (chỉ hoạt động trên Android)", "Tìm điện thoại", "Trả lời nhanh tin nhắn có sẵn (chỉ hoạt động trên Android)", "Dự báo thời tiết", "Báo thức", "Công nghệ SATIQ", "Bài tập Gym và Fitness (Cardio, HIIT, Pilates,...)", "Lưu trữ nhạc"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 23 ngày (ở chế độ đồng hồ thông minh)", "Khoảng 31 giờ (ở chế độ GPS)"], "Thời gian sạc": "Khoảng 2 giờ", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Cổng sạc Universal"}}, {"Cấu hình & Kết nối": {"CPU": "Hãng không công bố", "Bộ nhớ trong": "32 GB", "Hệ điều hành": "Hãng không công bố", "Kết nối được với hệ điều hành": ["Android 6.0 trở lên", "iOS 11 trở lên"], "Ứng dụng quản lý": "Garmin Connect", "Kết nối": ["Bluetooth", "NFC", "Wifi"], "Cảm biến": ["Cảm biến ánh sáng môi trường", "Con quay hồi chuyển", "Gia tốc kế", "La bàn", "Pulse Ox", "Theo dõi nhịp tim ở cổ tay Garmin Elevate"], "Định vị": ["GLONASS", "GPS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Đài Loan", "Thời gian ra mắt": "4/2023", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh"]}}]'::jsonb,
        ARRAY['garmin-forerunner-965-trang-1.jpg', 'garmin-forerunner-965-trang-2.jpg', 'garmin-forerunner-965-trang-3.jpg', 'garmin-forerunner-965-day-silicone-trang-45.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-forerunner-965-day-silicone/garmin-forerunner-965-trang-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-forerunner-965-day-silicone/garmin-forerunner-965-trang-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-forerunner-965-day-silicone/garmin-forerunner-965-day-silicone-trang-45.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-forerunner-965-day-silicone/garmin-forerunner-965-trang-1.jpg'
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

-- Product: Garmin Venu 4 41mm dây silicone
-- Slug: garmin-venu-4-41mm-day-silicone
-- Variants: 3

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Garmin';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Đồng hồ thông minh';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Garmin Venu 4 41mm dây silicone',
        'garmin-venu-4-41mm-day-silicone',
        v_brand_id,
        v_category_id,
        'Garmin Venu 4 là thế hệ smartwatch mới nhất của Garmin, được nâng cấp mạnh mẽ về thiết kế, cảm biến và tính năng theo dõi sức khỏe. Đây sẽ là lựa chọn lý tưởng cho những ai muốn sở hữu một chiếc đồng hồ vừa thời trang, vừa có khả năng hỗ trợ luyện tập và chăm sóc sức khỏe hằng ngày.',
        '{"meta_title": "Garmin Venu 4 41mm dây Silicone giá rẻ, tặng bảo hiểm rơi vỡ", "meta_description": "Garmin Venu 4 41mm dây Silicone giá rẻ. Thiết kế mạnh mẽ, hỗ trợ tập luyện và chăm sóc sức khỏe. Giao nhanh toàn quốc 1 giờ, xem hàng không mua không sao. Click ngay!", "meta_keywords": "Garmin Venu 4 41mm dây Silicone, Đồng hồ thông minh Garmin Venu 4 41mm dây Silicone,Đồng hồ thông minh Garmin,Đồng hồ thông minh Garmin Venu,Đồng hồ thông minh Garmin Venu 4,Đồng hồ thông minh Garmin Venu 4 41,Đồng hồ thông minh Garmin Venu 4 41mm,Venu 4,Venu 4 41mm,Venu 4 41mm dây Silicone,0232391002790,0232391002791,0232391002792"}'::jsonb,
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
        'GARMIN_VENU_4_41MM_DAY_SILICONE_TRANG_STARLIGHT',
        'garmin-venu-4-41mm-day-silicone-trang-starlight',
        '{"color": "Trắng Starlight"}'::jsonb,
        14990000.0,
        NULL,
        311,
        '[{"Màn hình": {"Công nghệ màn hình": "AMOLED", "Kích thước màn hình": "1.2 inch", "Độ phân giải": "390 x 390 pixels", "Kích thước mặt": "41 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Kính cường lực Gorilla Glass 3", "Chất liệu khung viền": "Khung Polyme cốt sợi - Viền thép không gỉ", "Chất liệu dây": "Silicone", "Độ rộng dây": "1.8 cm", "Chu vi cổ tay phù hợp": "11 - 17.5 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 41 mm - Ngang 41 mm - Dày 12 mm - Nặng 33 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Quần vợt", "Yoga", "Lướt ván diều", "Lướt ván buồm", "Leo núi", "Chạy bộ", "Bơi lội", "Đạp xe", "Ba môn phối hợp (Triathlon)", "Trượt tuyết", "Lướt sóng", "Chèo thuyền", "Thêm nhiều môn khác,..."], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": "Màn hình luôn hiển thị", "Chống nước / Kháng nước": "Kháng nước 5 ATM (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Tính tuổi thể chất", "Theo dõi nhịp thở 24/7", "Hẹn giờ thở thư giãn", "Cảnh báo nhịp tim (HR Alert)", "Đo chỉ số năng lượng cơ thể (Body Battery)", "Theo dõi nhịp tim 24h", "Theo dõi giấc ngủ", "Theo dõi mức độ stress", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Nhắc nhở uống nước", "Bài tập thở"], "Tiện ích khác": ["Tìm đồng hồ", "Chế độ tiết kiệm năng lượng", "Điều khiển chơi nhạc", "Từ chối cuộc gọi bằng tin nhắn soạn sẵn (chỉ hoạt động trên Android)", "Tìm điện thoại", "Trả lời nhanh tin nhắn có sẵn (chỉ hoạt động trên Android)", "Thay mặt đồng hồ", "Dự báo thời tiết", "Điều khiển từ xa VIRB", "Health Snapshot", "Garmin Pay", "Báo cáo buổi sáng (Morning Report)", "Theo dõi hoạt động (Activity Tracking)", "Lịch", "Loa và mic tích hợp"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 10 ngày (sử dụng cơ bản)", "Khoảng 15 giờ khi sử dụng GPS"], "Thời gian sạc": "Hãng không công bố", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Cổng sạc Universal đầu vào Type-C"}}, {"Cấu hình & Kết nối": {"CPU": "Hãng không công bố", "Bộ nhớ trong": "8 GB", "Hệ điều hành": "Hãng không công bố", "Kết nối được với hệ điều hành": ["Android 6.0 trở lên", "iOS 11 trở lên"], "Ứng dụng quản lý": ["Connect IQ Store", "Garmin Connect"], "Kết nối": ["ANT+", "Bluetooth v5.2", "NFC", "Wifi"], "Cảm biến": ["Cảm biến ánh sáng môi trường", "Khí áp kế", "Con quay hồi chuyển", "Gia tốc kế", "La bàn", "Nhiệt kế", "Pulse Ox", "Theo dõi nhịp tim ở cổ tay Garmin Elevate"], "Định vị": ["Beidou", "GLONASS", "GPS", "QZSS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Đài Loan", "Thời gian ra mắt": "09/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh", "Tiếng Trung", "Ngôn ngữ khác"]}}]'::jsonb,
        ARRAY['garmin-venu-4-41mm-day-silicone-trang-1-638943908398967689.jpg', 'garmin-venu-4-41mm-day-silicone-trang-2-638943908407963654.jpg', 'garmin-venu-4-41mm-day-silicone-trang-3-638943908414912049.jpg', 'garmin-venu-4-41mm-day-silicone-trang-4-638943908423698545.jpg', 'garmin-venu-4-41mm-day-silicone-trang-5-638943908430689650.jpg', 'garmin-venu-4-41mm-day-silicone-trang-99-638943225080398956.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-trang-2-638943908407963654.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-trang-3-638943908414912049.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-trang-4-638943908423698545.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-trang-5-638943908430689650.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-trang-99-638943225080398956.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-trang-1-638943908398967689.jpg'
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
        'GARMIN_VENU_4_41MM_DAY_SILICONE_TIM_BAC',
        'garmin-venu-4-41mm-day-silicone-tim-bac',
        '{"color": "Tím bạc"}'::jsonb,
        14990000.0,
        NULL,
        516,
        '[{"Màn hình": {"Công nghệ màn hình": "AMOLED", "Kích thước màn hình": "1.2 inch", "Độ phân giải": "390 x 390 pixels", "Kích thước mặt": "41 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Kính cường lực Gorilla Glass 3", "Chất liệu khung viền": "Khung Polyme cốt sợi - Viền thép không gỉ", "Chất liệu dây": "Silicone", "Độ rộng dây": "1.8 cm", "Chu vi cổ tay phù hợp": "11 - 17.5 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 41 mm - Ngang 41 mm - Dày 12 mm - Nặng 33 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Quần vợt", "Yoga", "Lướt ván diều", "Lướt ván buồm", "Leo núi", "Chạy bộ", "Bơi lội", "Đạp xe", "Ba môn phối hợp (Triathlon)", "Trượt tuyết", "Lướt sóng", "Chèo thuyền", "Thêm nhiều môn khác,..."], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": "Màn hình luôn hiển thị", "Chống nước / Kháng nước": "Kháng nước 5 ATM (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Tính tuổi thể chất", "Theo dõi nhịp thở 24/7", "Hẹn giờ thở thư giãn", "Cảnh báo nhịp tim (HR Alert)", "Đo chỉ số năng lượng cơ thể (Body Battery)", "Theo dõi nhịp tim 24h", "Theo dõi giấc ngủ", "Theo dõi mức độ stress", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Nhắc nhở uống nước", "Bài tập thở"], "Tiện ích khác": ["Tìm đồng hồ", "Chế độ tiết kiệm năng lượng", "Điều khiển chơi nhạc", "Từ chối cuộc gọi bằng tin nhắn soạn sẵn (chỉ hoạt động trên Android)", "Tìm điện thoại", "Trả lời nhanh tin nhắn có sẵn (chỉ hoạt động trên Android)", "Thay mặt đồng hồ", "Dự báo thời tiết", "Điều khiển từ xa VIRB", "Health Snapshot", "Garmin Pay", "Báo cáo buổi sáng (Morning Report)", "Theo dõi hoạt động (Activity Tracking)", "Lịch", "Loa và mic tích hợp"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 10 ngày (sử dụng cơ bản)", "Khoảng 15 giờ khi sử dụng GPS"], "Thời gian sạc": "Hãng không công bố", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Cổng sạc Universal đầu vào Type-C"}}, {"Cấu hình & Kết nối": {"CPU": "Hãng không công bố", "Bộ nhớ trong": "8 GB", "Hệ điều hành": "Hãng không công bố", "Kết nối được với hệ điều hành": ["Android 6.0 trở lên", "iOS 11 trở lên"], "Ứng dụng quản lý": ["Connect IQ Store", "Garmin Connect"], "Kết nối": ["ANT+", "Bluetooth v5.2", "NFC", "Wifi"], "Cảm biến": ["Cảm biến ánh sáng môi trường", "Khí áp kế", "Con quay hồi chuyển", "Gia tốc kế", "La bàn", "Nhiệt kế", "Pulse Ox", "Theo dõi nhịp tim ở cổ tay Garmin Elevate"], "Định vị": ["Beidou", "GLONASS", "GPS", "QZSS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Đài Loan", "Thời gian ra mắt": "09/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh", "Tiếng Trung", "Ngôn ngữ khác"]}}]'::jsonb,
        ARRAY['garmin-venu-4-41mm-day-silicone-tim-1-638943908565421667.jpg', 'garmin-venu-4-41mm-day-silicone-tim-2-638943908573659004.jpg', 'garmin-venu-4-41mm-day-silicone-tim-3-638943908581023879.jpg', 'garmin-venu-4-41mm-day-silicone-tim-4-638943908588410841.jpg', 'garmin-venu-4-41mm-day-silicone-tim-5-638943908595104414.jpg', 'garmin-venu-4-41mm-day-silicone-bactim-99-638943226419358139.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-tim-2-638943908573659004.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-tim-3-638943908581023879.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-tim-4-638943908588410841.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-tim-5-638943908595104414.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-bactim-99-638943226419358139.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-tim-1-638943908565421667.jpg'
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
        'GARMIN_VENU_4_41MM_DAY_SILICONE_DEN',
        'garmin-venu-4-41mm-day-silicone-den',
        '{"color": "Đen"}'::jsonb,
        14990000.0,
        NULL,
        257,
        '[{"Màn hình": {"Công nghệ màn hình": "AMOLED", "Kích thước màn hình": "1.2 inch", "Độ phân giải": "390 x 390 pixels", "Kích thước mặt": "41 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Kính cường lực Gorilla Glass 3", "Chất liệu khung viền": "Khung Polyme cốt sợi - Viền thép không gỉ", "Chất liệu dây": "Silicone", "Độ rộng dây": "1.8 cm", "Chu vi cổ tay phù hợp": "11 - 17.5 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 41 mm - Ngang 41 mm - Dày 12 mm - Nặng 33 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Quần vợt", "Yoga", "Lướt ván diều", "Lướt ván buồm", "Leo núi", "Chạy bộ", "Bơi lội", "Đạp xe", "Ba môn phối hợp (Triathlon)", "Trượt tuyết", "Lướt sóng", "Chèo thuyền", "Thêm nhiều môn khác,..."], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": "Màn hình luôn hiển thị", "Chống nước / Kháng nước": "Kháng nước 5 ATM (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Tính tuổi thể chất", "Theo dõi nhịp thở 24/7", "Hẹn giờ thở thư giãn", "Cảnh báo nhịp tim (HR Alert)", "Đo chỉ số năng lượng cơ thể (Body Battery)", "Theo dõi nhịp tim 24h", "Theo dõi giấc ngủ", "Theo dõi mức độ stress", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Nhắc nhở uống nước", "Bài tập thở"], "Tiện ích khác": ["Tìm đồng hồ", "Chế độ tiết kiệm năng lượng", "Điều khiển chơi nhạc", "Từ chối cuộc gọi bằng tin nhắn soạn sẵn (chỉ hoạt động trên Android)", "Tìm điện thoại", "Trả lời nhanh tin nhắn có sẵn (chỉ hoạt động trên Android)", "Thay mặt đồng hồ", "Dự báo thời tiết", "Điều khiển từ xa VIRB", "Health Snapshot", "Garmin Pay", "Báo cáo buổi sáng (Morning Report)", "Theo dõi hoạt động (Activity Tracking)", "Lịch", "Loa và mic tích hợp"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 10 ngày (sử dụng cơ bản)", "Khoảng 15 giờ khi sử dụng GPS"], "Thời gian sạc": "Hãng không công bố", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Cổng sạc Universal đầu vào Type-C"}}, {"Cấu hình & Kết nối": {"CPU": "Hãng không công bố", "Bộ nhớ trong": "8 GB", "Hệ điều hành": "Hãng không công bố", "Kết nối được với hệ điều hành": ["Android 6.0 trở lên", "iOS 11 trở lên"], "Ứng dụng quản lý": ["Connect IQ Store", "Garmin Connect"], "Kết nối": ["ANT+", "Bluetooth v5.2", "NFC", "Wifi"], "Cảm biến": ["Cảm biến ánh sáng môi trường", "Khí áp kế", "Con quay hồi chuyển", "Gia tốc kế", "La bàn", "Nhiệt kế", "Pulse Ox", "Theo dõi nhịp tim ở cổ tay Garmin Elevate"], "Định vị": ["Beidou", "GLONASS", "GPS", "QZSS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Đài Loan", "Thời gian ra mắt": "09/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh", "Tiếng Trung", "Ngôn ngữ khác"]}}]'::jsonb,
        ARRAY['garmin-venu-4-41mm-day-silicone-den-1-638943908993087643.jpg', 'garmin-venu-4-41mm-day-silicone-den-2-638943909003679491.jpg', 'garmin-venu-4-41mm-day-silicone-den-3-638943909016878549.jpg', 'garmin-venu-4-41mm-day-silicone-den-4-638943909024933877.jpg', 'garmin-venu-4-41mm-day-silicone-den-5-638943909034765560.jpg', 'garmin-venu-4-41mm-day-silicone-bacden-99-638943227210156419.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-den-2-638943909003679491.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-den-3-638943909016878549.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-den-4-638943909024933877.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-den-5-638943909034765560.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-bacden-99-638943227210156419.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/garmin-venu-4-41mm-day-silicone/garmin-venu-4-41mm-day-silicone-den-1-638943908993087643.jpg'
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

-- Product: Huawei Watch GT 6 Pro 46mm viền Titanium dây cao su
-- Slug: huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su
-- Variants: 1

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Huawei';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Đồng hồ thông minh';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Huawei Watch GT 6 Pro 46mm viền Titanium dây cao su',
        'huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su',
        v_brand_id,
        v_category_id,
        'Huawei - hãng công nghệ hàng đầu Trung Quốc, đã chính thức ra mắt siêu phẩm đồng hồ thông minh Huawei Watch GT 6 Pro 46mm . Sản phẩm không chỉ sở hữu thiết kế hiện đại, tinh tế mà còn tích hợp một loạt các tính năng thông minh, từ theo dõi sức khỏe đến hỗ trợ tập luyện thể thao hiệu quả, sẵn sàng đồng hành cùng người dùng trong mọi hoạt động hàng ngày.',
        '{"meta_title": "Huawei Watch GT 6 Pro với khung Titan, cảm biến thế hệ mới", "meta_description": "Đồng hồ Huawei Watch GT 6 Pro dự kiến ra mắt 29/09, khung Titan, kính Sapphire cong, cảm biến TruSense 2.0 mới, vật liệu cao cấp,khả năng đo ECG chính xác.", "meta_keywords": "Đồng hồ Huawei Watch GT 6 Pro dự kiến ra mắt 29/09, khung Titan, kính Sapphire cong, cảm biến TruSense 2.0 mới, vật liệu cao cấp,khả năng đo ECG chính xác."}'::jsonb,
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
        'HUAWEI_WATCH_GT_6_PRO_46MM_VIEN_TITANIUM_DAY_CAO_SU_DEFAULT',
        'huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-default',
        NULL,
        7690000.0,
        8490000.0,
        846,
        '[{"Màn hình": {"Công nghệ màn hình": "AMOLED", "Kích thước màn hình": "1.47 inch", "Độ phân giải": "466 x 466 pixels", "Kích thước mặt": "45.6 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Kính Sapphire", "Chất liệu khung viền": "Hợp kim Titanium", "Chất liệu dây": "Cao su", "Độ rộng dây": "2.2 cm", "Chu vi cổ tay phù hợp": "14 - 21 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 45.6 mm - Ngang 45.6 mm - Dày 11.25 mm - Nặng 54.7 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Quần vợt", "Nhảy dây", "Leo núi", "Bóng rổ", "Chạy bộ", "Bơi lội", "Đạp xe", "Golf", "Lặn", "Trượt tuyết", "Trượt băng"], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": ["Nghe nhạc", "Kết nối bluetooth với tai nghe"], "Chống nước / Kháng nước": "Chống nước 5 ATM - ISO 22810:2010 (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Sức khỏe cảm xúc", "Phân tích rối loạn nhịp tim", "Theo dõi giấc ngủ", "Đếm số bước chân"], "Tiện ích khác": ["Tìm đồng hồ", "Màn hình cảm ứng", "Đồng hồ bấm giờ", "Điều khiển chơi nhạc", "Tìm điện thoại", "Trả lời nhanh tin nhắn có sẵn", "Thay mặt đồng hồ", "Dự báo thời tiết", "Báo thức", "Tiêu chuẩn IP69"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 7 ngày (khi bật Always On Display)", "Khoảng 12 ngày (ở chế độ sử dụng thông thường)"], "Thời gian sạc": "Khoảng 45 phút", "Dung lượng pin": "Hãng không công bố", "Cổng sạc": "Sạc không dây"}}, {"Cấu hình & Kết nối": {"CPU": "Hãng không công bố", "Bộ nhớ trong": "Hãng không công bố", "Hệ điều hành": "Harmony OS", "Kết nối được với hệ điều hành": ["iOS 13 trở lên", "Android 9 trở lên"], "Ứng dụng quản lý": "Huawei Health", "Kết nối": ["Bluetooth v6.0", "NFC"], "Cảm biến": ["Cảm biến ánh sáng môi trường", "Khí áp kế", "Cảm biến nhiệt độ", "Cảm biến điện học (ECG)", "Cảm biến độ sâu", "Cảm biến nhịp tim quang học (PPG)", "Cảm biến từ", "Con quay hồi chuyển", "Gia tốc kế"], "Định vị": ["Beidou", "GLONASS", "GPS", "QZSS", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Trung Quốc", "Thời gian ra mắt": "10/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh", "Tiếng Trung"]}}]'::jsonb,
        ARRAY['huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-1-638950123986842453.jpg', 'huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-2-638950123992826830.jpg', 'huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-3-638950123998929132.jpg', 'huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-4-638950124008613955.jpg', 'huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-5-638950124014722804.jpg', 'huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-6-638950124021428835.jpg', 'huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-7-638950124028004137.jpg', 'huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-8-638950124034767907.jpg', 'huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-9-638950124042464658.jpg', 'huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-den-99-638950106105726810.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-2-638950123992826830.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-3-638950123998929132.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-4-638950124008613955.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-5-638950124014722804.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-6-638950124021428835.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-7-638950124028004137.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-8-638950124034767907.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-9-638950124042464658.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-den-99-638950106105726810.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su/huawei-watch-gt-6-pro-46mm-vien-titanium-day-cao-su-hc-1-638950123986842453.jpg'
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

-- Product: Máy tính bảng iPad A16 WiFi 128GB
-- Slug: ipad-11-wifi-128gb
-- Variants: 8

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Apple';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Máy tính bảng';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Máy tính bảng iPad A16 WiFi 128GB',
        'ipad-11-wifi-128gb',
        v_brand_id,
        v_category_id,
        'Với chip A16 mạnh mẽ, iPad A16 không chỉ mang lại hiệu năng vượt trội mà còn tích hợp nhiều công nghệ tiên tiến, giúp nâng cao trải nghiệm người dùng. Màn hình Liquid Retina 11 inch sắc nét, hỗ trợ Apple Pencil kết hợp với bộ nhớ khởi điểm 128GB, đảm bảo khả năng làm việc và giải trí mượt mà.',
        '{"meta_title": "iPad A16 (Gen 11) WiFi 128GB giá rẻ, thu cũ trợ giá đến 2.5tr", "meta_description": "Mua máy tính bảng iPad A16 (Gen 11th) 11 inch WiFi 128GB giá rẻ, chính hãng Apple, trả chậm 0% lãi suất, thu cũ đổi mới trợ giá 2.5tr, BH 1 năm. Mua ngay!", "meta_keywords": "Mua máy tính bảng iPad A16 (Gen 11th) 11 inch WiFi 128GB giá rẻ, chính hãng Apple, trả chậm 0% lãi suất, thu cũ đổi mới trợ giá 2.5tr, BH 1 năm. Mua ngay!"}'::jsonb,
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
        'IPAD_11_WIFI_128GB_128GB_BAC',
        'ipad-11-wifi-128gb-128gb-bac',
        '{"color": "Bạc", "storage": "128GB"}'::jsonb,
        2190000.0,
        NULL,
        830,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "1640 x 2360 Pixels", "Màn hình rộng": "11 inch - Tần số quét 60 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple A16 5 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 4 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "6 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "113 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@60fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Gắn thẻ địa lý", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Quay video HD", "Quay video Full HD", "Góc siêu rộng", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil 1", "HDR10", "Dolby Vision", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "28.93 Wh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 248.6 mm - Ngang 179.5 mm - Dày 7 mm - Nặng 477 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-11-a16-silver-1-638772855744663903.jpg', 'ipad-11-a16-silver-2-638772855751556499.jpg', 'ipad-11-a16-silver-3-638772855757811751.jpg', 'ipad-11-a16-silver-4-638772855763983932.jpg', 'ipad-11-a16-silver-5-638772855772056275.jpg', 'ipad-11-a16-silver-6-638772855778617106.jpg', 'ipad-11-a16-silver-7-638772855786740064.jpg', 'ipad-11-tem-99-638834177235289545.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-silver-2-638772855751556499.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-silver-3-638772855757811751.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-silver-4-638772855763983932.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-silver-5-638772855772056275.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-silver-6-638772855778617106.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-silver-7-638772855786740064.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-tem-99-638834177235289545.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-silver-1-638772855744663903.jpg'
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
        'IPAD_11_WIFI_128GB_128GB_XANH_DUONG',
        'ipad-11-wifi-128gb-128gb-xanh-duong',
        '{"color": "Xanh Dương", "storage": "128GB"}'::jsonb,
        2190000.0,
        NULL,
        151,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "1640 x 2360 Pixels", "Màn hình rộng": "11 inch - Tần số quét 60 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple A16 5 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 4 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "6 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "113 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@60fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Gắn thẻ địa lý", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Quay video HD", "Quay video Full HD", "Góc siêu rộng", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil 1", "HDR10", "Dolby Vision", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "28.93 Wh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 248.6 mm - Ngang 179.5 mm - Dày 7 mm - Nặng 477 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-11-a16-blue-1-638772856431636956.jpg', 'ipad-11-a16-blue-2-638772856437909099.jpg', 'ipad-11-a16-blue-3-638772856445234430.jpg', 'ipad-11-a16-blue-4-638772856422892713.jpg', 'ipad-11-a16-blue-5-638772856451409517.jpg', 'ipad-11-a16-blue-6-638772856457400477.jpg', 'ipad-11-a16-blue-7-638772856463605356.jpg', 'ipad-11-tem-99-638834177467458856.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-2-638772856437909099.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-3-638772856445234430.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-4-638772856422892713.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-5-638772856451409517.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-6-638772856457400477.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-7-638772856463605356.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-tem-99-638834177467458856.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-1-638772856431636956.jpg'
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
        'IPAD_11_WIFI_128GB_128GB_HONG',
        'ipad-11-wifi-128gb-128gb-hong',
        '{"color": "Hồng", "storage": "128GB"}'::jsonb,
        2190000.0,
        NULL,
        36,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "1640 x 2360 Pixels", "Màn hình rộng": "11 inch - Tần số quét 60 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple A16 5 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 4 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "6 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "113 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@60fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Gắn thẻ địa lý", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Quay video HD", "Quay video Full HD", "Góc siêu rộng", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil 1", "HDR10", "Dolby Vision", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "28.93 Wh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 248.6 mm - Ngang 179.5 mm - Dày 7 mm - Nặng 477 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-11-a16-pink-1-638772857014689247.jpg', 'ipad-11-a16-pink-2-638772857021348779.jpg', 'ipad-11-a16-pink-3-638772857027961124.jpg', 'ipad-11-a16-pink-4-638772857034136524.jpg', 'ipad-11-a16-pink-5-638772857008475683.jpg', 'ipad-11-a16-pink-6-638772857043867099.jpg', 'ipad-11-a16-pink-7-638772857050152094.jpg', 'ipad-11-tem-99-638834177857312312.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-pink-2-638772857021348779.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-pink-3-638772857027961124.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-pink-4-638772857034136524.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-pink-5-638772857008475683.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-pink-6-638772857043867099.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-pink-7-638772857050152094.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-tem-99-638834177857312312.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-pink-1-638772857014689247.jpg'
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
        'IPAD_11_WIFI_128GB_128GB_VANG',
        'ipad-11-wifi-128gb-128gb-vang',
        '{"color": "Vàng", "storage": "128GB"}'::jsonb,
        2190000.0,
        NULL,
        18,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "1640 x 2360 Pixels", "Màn hình rộng": "11 inch - Tần số quét 60 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple A16 5 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 4 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "6 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "113 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@60fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Gắn thẻ địa lý", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Quay video HD", "Quay video Full HD", "Góc siêu rộng", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil 1", "HDR10", "Dolby Vision", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "28.93 Wh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 248.6 mm - Ngang 179.5 mm - Dày 7 mm - Nặng 477 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-11-a16-yellow-1-638772857426381648.jpg', 'ipad-11-a16-yellow-2-638772857433075009.jpg', 'ipad-11-a16-yellow-3-638772857439435955.jpg', 'ipad-11-a16-yellow-4-638772857446450873.jpg', 'ipad-11-a16-yellow-5-638772857418464212.jpg', 'ipad-11-a16-yellow-6-638772857452239606.jpg', 'ipad-11-a16-yellow-7-638772857459157546.jpg', 'ipad-11-tem-99-638834177663264646.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-yellow-2-638772857433075009.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-yellow-3-638772857439435955.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-yellow-4-638772857446450873.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-yellow-5-638772857418464212.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-yellow-6-638772857452239606.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-yellow-7-638772857459157546.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-tem-99-638834177663264646.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-yellow-1-638772857426381648.jpg'
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
        'IPAD_11_WIFI_128GB_256GB_BAC',
        'ipad-11-wifi-128gb-256gb-bac',
        '{"color": "Bạc", "storage": "256GB"}'::jsonb,
        2190000.0,
        NULL,
        371,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "1640 x 2360 Pixels", "Màn hình rộng": "11 inch - Tần số quét 60 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple A16 5 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 4 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "6 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@60fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Gắn thẻ địa lý", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Quay video HD", "Quay video Full HD", "Góc siêu rộng", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil 1", "HDR10", "Dolby Vision", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "28.93 Wh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 248.6 mm - Ngang 179.5 mm - Dày 7 mm - Nặng 477 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-11-a16-blue-1-638772856342083366.jpg', 'ipad-11-a16-blue-2-638772856348147985.jpg', 'ipad-11-a16-blue-3-638772856354161849.jpg', 'ipad-11-a16-blue-4-638772856360368992.jpg', 'ipad-11-a16-blue-5-638772856366858024.jpg', 'ipad-11-a16-blue-6-638772856372806207.jpg', 'ipad-11-a16-blue-7-638772856336069050.jpg', 'ipad-11-tem-99-638834177568010332.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-2-638772856348147985.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-3-638772856354161849.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-4-638772856360368992.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-5-638772856366858024.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-6-638772856372806207.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-7-638772856336069050.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-tem-99-638834177568010332.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-1-638772856342083366.jpg'
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
        'IPAD_11_WIFI_128GB_256GB_XANH_DUONG',
        'ipad-11-wifi-128gb-256gb-xanh-duong',
        '{"color": "Xanh Dương", "storage": "256GB"}'::jsonb,
        2190000.0,
        NULL,
        193,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "1640 x 2360 Pixels", "Màn hình rộng": "11 inch - Tần số quét 60 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple A16 5 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 4 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "6 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@60fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Gắn thẻ địa lý", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Quay video HD", "Quay video Full HD", "Góc siêu rộng", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil 1", "HDR10", "Dolby Vision", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "28.93 Wh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 248.6 mm - Ngang 179.5 mm - Dày 7 mm - Nặng 477 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-11-a16-blue-1-638772856342083366.jpg', 'ipad-11-a16-blue-2-638772856348147985.jpg', 'ipad-11-a16-blue-3-638772856354161849.jpg', 'ipad-11-a16-blue-4-638772856360368992.jpg', 'ipad-11-a16-blue-5-638772856366858024.jpg', 'ipad-11-a16-blue-6-638772856372806207.jpg', 'ipad-11-a16-blue-7-638772856336069050.jpg', 'ipad-11-tem-99-638834177568010332.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-2-638772856348147985.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-3-638772856354161849.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-4-638772856360368992.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-5-638772856366858024.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-6-638772856372806207.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-7-638772856336069050.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-tem-99-638834177568010332.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-1-638772856342083366.jpg'
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
        'IPAD_11_WIFI_128GB_256GB_HONG',
        'ipad-11-wifi-128gb-256gb-hong',
        '{"color": "Hồng", "storage": "256GB"}'::jsonb,
        2190000.0,
        NULL,
        878,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "1640 x 2360 Pixels", "Màn hình rộng": "11 inch - Tần số quét 60 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple A16 5 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 4 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "6 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@60fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Gắn thẻ địa lý", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Quay video HD", "Quay video Full HD", "Góc siêu rộng", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil 1", "HDR10", "Dolby Vision", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "28.93 Wh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 248.6 mm - Ngang 179.5 mm - Dày 7 mm - Nặng 477 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-11-a16-blue-1-638772856342083366.jpg', 'ipad-11-a16-blue-2-638772856348147985.jpg', 'ipad-11-a16-blue-3-638772856354161849.jpg', 'ipad-11-a16-blue-4-638772856360368992.jpg', 'ipad-11-a16-blue-5-638772856366858024.jpg', 'ipad-11-a16-blue-6-638772856372806207.jpg', 'ipad-11-a16-blue-7-638772856336069050.jpg', 'ipad-11-tem-99-638834177568010332.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-2-638772856348147985.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-3-638772856354161849.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-4-638772856360368992.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-5-638772856366858024.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-6-638772856372806207.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-7-638772856336069050.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-tem-99-638834177568010332.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-1-638772856342083366.jpg'
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
        'IPAD_11_WIFI_128GB_256GB_VANG',
        'ipad-11-wifi-128gb-256gb-vang',
        '{"color": "Vàng", "storage": "256GB"}'::jsonb,
        2190000.0,
        NULL,
        973,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "1640 x 2360 Pixels", "Màn hình rộng": "11 inch - Tần số quét 60 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple A16 5 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 4 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "6 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@60fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Gắn thẻ địa lý", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Quay video HD", "Quay video Full HD", "Góc siêu rộng", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil 1", "HDR10", "Dolby Vision", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "28.93 Wh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 248.6 mm - Ngang 179.5 mm - Dày 7 mm - Nặng 477 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-11-a16-blue-1-638772856342083366.jpg', 'ipad-11-a16-blue-2-638772856348147985.jpg', 'ipad-11-a16-blue-3-638772856354161849.jpg', 'ipad-11-a16-blue-4-638772856360368992.jpg', 'ipad-11-a16-blue-5-638772856366858024.jpg', 'ipad-11-a16-blue-6-638772856372806207.jpg', 'ipad-11-a16-blue-7-638772856336069050.jpg', 'ipad-11-tem-99-638834177568010332.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-2-638772856348147985.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-3-638772856354161849.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-4-638772856360368992.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-5-638772856366858024.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-6-638772856372806207.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-7-638772856336069050.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-tem-99-638834177568010332.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-11-wifi-128gb/ipad-11-a16-blue-1-638772856342083366.jpg'
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

-- Product: Máy tính bảng iPad Air M3 11 inch WiFi 128GB
-- Slug: ipad-air-m3-11-inch-wifi-128gb
-- Variants: 8

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Apple';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Máy tính bảng';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Máy tính bảng iPad Air M3 11 inch WiFi 128GB',
        'ipad-air-m3-11-inch-wifi-128gb',
        v_brand_id,
        v_category_id,
        'iPad Air M3 11 inch WiFi vừa được Apple ra mắt trong tháng 03/2025 cùng iPad A16 , sẽ đem đến cho người dùng sức mạnh phần cứng tốt hơn, với con chip M3 tiên tiến, màn hình Liquid Retina rực rỡ và khả năng hỗ trợ Apple Pencil Pro, thiết bị này mang đến trải nghiệm tuyệt vời cho công việc, học tập và sáng tạo nội dung.',
        '{"meta_title": "iPad Air M3 11 inch WiFi 128GB chính hãng Apple, trả chậm 0% lãi suất", "meta_description": "Mua máy tính bảng iPad Air M3 11 inch WiFi 128GB chính hãng Apple, giá tốt, mua trả chậm 0% lãi suất, tặng phiếu mua hàng trị giá 300K, bảo hành 1 năm. Xem ngay!", "meta_keywords": "Mua máy tính bảng iPad Air M3 11 inch WiFi 128GB chính hãng Apple, giá tốt, mua trả chậm 0% lãi suất, tặng phiếu mua hàng trị giá 300K, bảo hành 1 năm. Xem ngay!"}'::jsonb,
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
        'IPAD_AIR_M3_11_INCH_WIFI_128GB_128GB_XANH_DUONG',
        'ipad-air-m3-11-inch-wifi-128gb-128gb-xanh-duong',
        '{"color": "Xanh Dương", "storage": "128GB"}'::jsonb,
        3290000.0,
        NULL,
        689,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "1640 x 2360 Pixels", "Màn hình rộng": "11 inch - Tần số quét  Hãng không công bố"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple M3 8 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 9 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "113 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý", "Chụp ảnh hàng loạt", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Smart HDR 4", "Quay video Full HD", "Live Photos", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6E", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil Pro", "HDR10+", "HDR10", "Dolby Vision", "DCI-P3", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "28.93 Wh", "Loại pin": "Li-Po", "Công nghệ pin": "Sạc pin nhanh", "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 247.6 mm - Ngang 178.5 mm - Dày 6.1 mm - Nặng 460 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-air-m3-11-inch-wifi-blue-1-638771976490685761.jpg', 'ipad-air-m3-11-inch-wifi-blue-2-638771976497318014.jpg', 'ipad-air-m3-11-inch-wifi-blue-3-638771976504741418.jpg', 'ipad-air-m3-11-inch-wifi-blue-4-638771976510464572.jpg', 'ipad-air-m3-11-inch-wifi-blue-5-638771976516944238.jpg', 'ipad-air-m3-11-inch-wifi-blue-6-638771976523671852.jpg', 'ipad-air-m3-11-inch-wifi-blue-7-638771976529860071.jpg', 'ipad-air-m3-11-inch-wifi-blue-8-638771976535277490.jpg', 'ipad-air-m3-11-inch-wifi-blue-9-638771976542709850.jpg', 'ipad-air-m3-11-inch-wifi-tem-99-638834190022439649.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-blue-2-638771976497318014.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-blue-3-638771976504741418.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-blue-4-638771976510464572.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-blue-5-638771976516944238.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-blue-6-638771976523671852.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-blue-7-638771976529860071.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-blue-8-638771976535277490.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-blue-9-638771976542709850.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-tem-99-638834190022439649.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-blue-1-638771976490685761.jpg'
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
        'IPAD_AIR_M3_11_INCH_WIFI_128GB_128GB_DEN_XAM',
        'ipad-air-m3-11-inch-wifi-128gb-128gb-den-xam',
        '{"color": "Đen - Xám", "storage": "128GB"}'::jsonb,
        3290000.0,
        NULL,
        964,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "1640 x 2360 Pixels", "Màn hình rộng": "11 inch - Tần số quét  Hãng không công bố"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple M3 8 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 9 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "113 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý", "Chụp ảnh hàng loạt", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Smart HDR 4", "Quay video Full HD", "Live Photos", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6E", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil Pro", "HDR10+", "HDR10", "Dolby Vision", "DCI-P3", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "28.93 Wh", "Loại pin": "Li-Po", "Công nghệ pin": "Sạc pin nhanh", "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 247.6 mm - Ngang 178.5 mm - Dày 6.1 mm - Nặng 460 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-air-m3-11-inch-wifi-gray-1-638771975634914257.jpg', 'ipad-air-m3-11-inch-wifi-gray-2-638771975640406577.jpg', 'ipad-air-m3-11-inch-wifi-gray-3-638771975646511344.jpg', 'ipad-air-m3-11-inch-wifi-gray-4-638771975652231477.jpg', 'ipad-air-m3-11-inch-wifi-gray-5-638771975660182105.jpg', 'ipad-air-m3-11-inch-wifi-gray-6-638771975666340200.jpg', 'ipad-air-m3-11-inch-wifi-gray-7-638771975675631938.jpg', 'ipad-air-m3-11-inch-wifi-gray-8-638771975681575427.jpg', 'ipad-air-m3-11-inch-wifi-gray-9-638771975688350142.jpg', 'ipad-air-m3-11-inch-wifi-tem-99-638834189411495391.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-gray-2-638771975640406577.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-gray-3-638771975646511344.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-gray-4-638771975652231477.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-gray-5-638771975660182105.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-gray-6-638771975666340200.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-gray-7-638771975675631938.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-gray-8-638771975681575427.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-gray-9-638771975688350142.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-tem-99-638834189411495391.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-gray-1-638771975634914257.jpg'
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
        'IPAD_AIR_M3_11_INCH_WIFI_128GB_128GB_TRANG_STARLIGHT',
        'ipad-air-m3-11-inch-wifi-128gb-128gb-trang-starlight',
        '{"color": "Trắng Starlight", "storage": "128GB"}'::jsonb,
        3290000.0,
        NULL,
        37,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "1640 x 2360 Pixels", "Màn hình rộng": "11 inch - Tần số quét  Hãng không công bố"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple M3 8 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 9 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "113 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý", "Chụp ảnh hàng loạt", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Smart HDR 4", "Quay video Full HD", "Live Photos", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6E", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil Pro", "HDR10+", "HDR10", "Dolby Vision", "DCI-P3", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "28.93 Wh", "Loại pin": "Li-Po", "Công nghệ pin": "Sạc pin nhanh", "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 247.6 mm - Ngang 178.5 mm - Dày 6.1 mm - Nặng 460 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-air-m3-11-inch-wifi-starlight-1-638771976884999774.jpg', 'ipad-air-m3-11-inch-wifi-starlight-2-638771976891575738.jpg', 'ipad-air-m3-11-inch-wifi-starlight-3-638771976897750584.jpg', 'ipad-air-m3-11-inch-wifi-starlight-4-638771976904223098.jpg', 'ipad-air-m3-11-inch-wifi-starlight-5-638771976912824617.jpg', 'ipad-air-m3-11-inch-wifi-starlight-6-638771976918321735.jpg', 'ipad-air-m3-11-inch-wifi-starlight-7-638771976925497584.jpg', 'ipad-air-m3-11-inch-wifi-starlight-8-638771976932224109.jpg', 'ipad-air-m3-11-inch-wifi-starlight-9-638771976938361531.jpg', 'ipad-air-m3-11-inch-wifi-tem-99-638834190391061978.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-2-638771976891575738.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-3-638771976897750584.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-4-638771976904223098.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-5-638771976912824617.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-6-638771976918321735.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-7-638771976925497584.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-8-638771976932224109.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-9-638771976938361531.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-tem-99-638834190391061978.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-1-638771976884999774.jpg'
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
        'IPAD_AIR_M3_11_INCH_WIFI_128GB_128GB_TIM',
        'ipad-air-m3-11-inch-wifi-128gb-128gb-tim',
        '{"color": "Tím", "storage": "128GB"}'::jsonb,
        3290000.0,
        NULL,
        540,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "1640 x 2360 Pixels", "Màn hình rộng": "11 inch - Tần số quét  Hãng không công bố"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple M3 8 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 9 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "113 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý", "Chụp ảnh hàng loạt", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Smart HDR 4", "Quay video Full HD", "Live Photos", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6E", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil Pro", "HDR10+", "HDR10", "Dolby Vision", "DCI-P3", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "28.93 Wh", "Loại pin": "Li-Po", "Công nghệ pin": "Sạc pin nhanh", "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 247.6 mm - Ngang 178.5 mm - Dày 6.1 mm - Nặng 460 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-air-m3-11-inch-wifi-purple-1-638771977158309740.jpg', 'ipad-air-m3-11-inch-wifi-purple-2-638771977167028342.jpg', 'ipad-air-m3-11-inch-wifi-purple-3-638771977172673833.jpg', 'ipad-air-m3-11-inch-wifi-purple-4-638771977179034689.jpg', 'ipad-air-m3-11-inch-wifi-purple-5-638771977184599944.jpg', 'ipad-air-m3-11-inch-wifi-purple-6-638771977190616790.jpg', 'ipad-air-m3-11-inch-wifi-purple-7-638771977197753564.jpg', 'ipad-air-m3-11-inch-wifi-purple-8-638771977204778080.jpg', 'ipad-air-m3-11-inch-wifi-purple-9-638771977210888065.jpg', 'ipad-air-m3-11-inch-wifi-tem-99-638834190631928308.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-purple-2-638771977167028342.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-purple-3-638771977172673833.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-purple-4-638771977179034689.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-purple-5-638771977184599944.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-purple-6-638771977190616790.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-purple-7-638771977197753564.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-purple-8-638771977204778080.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-purple-9-638771977210888065.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-tem-99-638834190631928308.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-purple-1-638771977158309740.jpg'
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
        'IPAD_AIR_M3_11_INCH_WIFI_128GB_512GB_XANH_DUONG',
        'ipad-air-m3-11-inch-wifi-128gb-512gb-xanh-duong',
        '{"color": "Xanh Dương", "storage": "512GB"}'::jsonb,
        24590000.0,
        24990000.0,
        495,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "1640 x 2360 Pixels", "Màn hình rộng": "11 inch - Tần số quét  Hãng không công bố"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple M3 8 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 9 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "512 GB", "Dung lượng còn lại (khả dụng) khoảng": "497 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý", "Chụp ảnh hàng loạt", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Smart HDR 4", "Quay video Full HD", "Live Photos", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6E", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil Pro", "HDR10+", "HDR10", "Dolby Vision", "DCI-P3", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "28.93 Wh", "Loại pin": "Li-Po", "Công nghệ pin": "Sạc pin nhanh", "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 247.6 mm - Ngang 178.5 mm - Dày 6.1 mm - Nặng 460 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-air-m3-11-inch-wifi-starlight-1-638771976221454108.jpg', 'ipad-air-m3-11-inch-wifi-starlight-2-638771976227409752.jpg', 'ipad-air-m3-11-inch-wifi-starlight-3-638771976233850353.jpg', 'ipad-air-m3-11-inch-wifi-starlight-4-638771976242833242.jpg', 'ipad-air-m3-11-inch-wifi-starlight-5-638771976249430924.jpg', 'ipad-air-m3-11-inch-wifi-starlight-6-638771976255692491.jpg', 'ipad-air-m3-11-inch-wifi-starlight-7-638771976262102836.jpg', 'ipad-air-m3-11-inch-wifi-starlight-8-638771976268476086.jpg', 'ipad-air-m3-11-inch-wifi-starlight-9-638771976276299225.jpg', 'ipad-air-m3-11-inch-wifi-tem-99-638834189895289023.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-2-638771976227409752.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-3-638771976233850353.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-4-638771976242833242.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-5-638771976249430924.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-6-638771976255692491.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-7-638771976262102836.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-8-638771976268476086.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-9-638771976276299225.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-tem-99-638834189895289023.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-1-638771976221454108.jpg'
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
        'IPAD_AIR_M3_11_INCH_WIFI_128GB_512GB_DEN_XAM',
        'ipad-air-m3-11-inch-wifi-128gb-512gb-den-xam',
        '{"color": "Đen - Xám", "storage": "512GB"}'::jsonb,
        24590000.0,
        24990000.0,
        161,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "1640 x 2360 Pixels", "Màn hình rộng": "11 inch - Tần số quét  Hãng không công bố"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple M3 8 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 9 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "512 GB", "Dung lượng còn lại (khả dụng) khoảng": "497 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý", "Chụp ảnh hàng loạt", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Smart HDR 4", "Quay video Full HD", "Live Photos", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6E", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil Pro", "HDR10+", "HDR10", "Dolby Vision", "DCI-P3", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "28.93 Wh", "Loại pin": "Li-Po", "Công nghệ pin": "Sạc pin nhanh", "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 247.6 mm - Ngang 178.5 mm - Dày 6.1 mm - Nặng 460 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-air-m3-11-inch-wifi-starlight-1-638771976221454108.jpg', 'ipad-air-m3-11-inch-wifi-starlight-2-638771976227409752.jpg', 'ipad-air-m3-11-inch-wifi-starlight-3-638771976233850353.jpg', 'ipad-air-m3-11-inch-wifi-starlight-4-638771976242833242.jpg', 'ipad-air-m3-11-inch-wifi-starlight-5-638771976249430924.jpg', 'ipad-air-m3-11-inch-wifi-starlight-6-638771976255692491.jpg', 'ipad-air-m3-11-inch-wifi-starlight-7-638771976262102836.jpg', 'ipad-air-m3-11-inch-wifi-starlight-8-638771976268476086.jpg', 'ipad-air-m3-11-inch-wifi-starlight-9-638771976276299225.jpg', 'ipad-air-m3-11-inch-wifi-tem-99-638834189895289023.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-2-638771976227409752.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-3-638771976233850353.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-4-638771976242833242.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-5-638771976249430924.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-6-638771976255692491.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-7-638771976262102836.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-8-638771976268476086.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-9-638771976276299225.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-tem-99-638834189895289023.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-1-638771976221454108.jpg'
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
        'IPAD_AIR_M3_11_INCH_WIFI_128GB_512GB_TRANG_STARLIGHT',
        'ipad-air-m3-11-inch-wifi-128gb-512gb-trang-starlight',
        '{"color": "Trắng Starlight", "storage": "512GB"}'::jsonb,
        24590000.0,
        24990000.0,
        158,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "1640 x 2360 Pixels", "Màn hình rộng": "11 inch - Tần số quét  Hãng không công bố"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple M3 8 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 9 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "512 GB", "Dung lượng còn lại (khả dụng) khoảng": "497 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý", "Chụp ảnh hàng loạt", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Smart HDR 4", "Quay video Full HD", "Live Photos", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6E", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil Pro", "HDR10+", "HDR10", "Dolby Vision", "DCI-P3", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "28.93 Wh", "Loại pin": "Li-Po", "Công nghệ pin": "Sạc pin nhanh", "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 247.6 mm - Ngang 178.5 mm - Dày 6.1 mm - Nặng 460 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-air-m3-11-inch-wifi-starlight-1-638771976221454108.jpg', 'ipad-air-m3-11-inch-wifi-starlight-2-638771976227409752.jpg', 'ipad-air-m3-11-inch-wifi-starlight-3-638771976233850353.jpg', 'ipad-air-m3-11-inch-wifi-starlight-4-638771976242833242.jpg', 'ipad-air-m3-11-inch-wifi-starlight-5-638771976249430924.jpg', 'ipad-air-m3-11-inch-wifi-starlight-6-638771976255692491.jpg', 'ipad-air-m3-11-inch-wifi-starlight-7-638771976262102836.jpg', 'ipad-air-m3-11-inch-wifi-starlight-8-638771976268476086.jpg', 'ipad-air-m3-11-inch-wifi-starlight-9-638771976276299225.jpg', 'ipad-air-m3-11-inch-wifi-tem-99-638834189895289023.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-2-638771976227409752.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-3-638771976233850353.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-4-638771976242833242.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-5-638771976249430924.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-6-638771976255692491.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-7-638771976262102836.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-8-638771976268476086.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-9-638771976276299225.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-tem-99-638834189895289023.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-1-638771976221454108.jpg'
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
        'IPAD_AIR_M3_11_INCH_WIFI_128GB_512GB_TIM',
        'ipad-air-m3-11-inch-wifi-128gb-512gb-tim',
        '{"color": "Tím", "storage": "512GB"}'::jsonb,
        24590000.0,
        24990000.0,
        445,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "1640 x 2360 Pixels", "Màn hình rộng": "11 inch - Tần số quét  Hãng không công bố"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple M3 8 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 9 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "512 GB", "Dung lượng còn lại (khả dụng) khoảng": "497 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý", "Chụp ảnh hàng loạt", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Smart HDR 4", "Quay video Full HD", "Live Photos", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6E", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil Pro", "HDR10+", "HDR10", "Dolby Vision", "DCI-P3", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "28.93 Wh", "Loại pin": "Li-Po", "Công nghệ pin": "Sạc pin nhanh", "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 247.6 mm - Ngang 178.5 mm - Dày 6.1 mm - Nặng 460 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-air-m3-11-inch-wifi-starlight-1-638771976221454108.jpg', 'ipad-air-m3-11-inch-wifi-starlight-2-638771976227409752.jpg', 'ipad-air-m3-11-inch-wifi-starlight-3-638771976233850353.jpg', 'ipad-air-m3-11-inch-wifi-starlight-4-638771976242833242.jpg', 'ipad-air-m3-11-inch-wifi-starlight-5-638771976249430924.jpg', 'ipad-air-m3-11-inch-wifi-starlight-6-638771976255692491.jpg', 'ipad-air-m3-11-inch-wifi-starlight-7-638771976262102836.jpg', 'ipad-air-m3-11-inch-wifi-starlight-8-638771976268476086.jpg', 'ipad-air-m3-11-inch-wifi-starlight-9-638771976276299225.jpg', 'ipad-air-m3-11-inch-wifi-tem-99-638834189895289023.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-2-638771976227409752.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-3-638771976233850353.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-4-638771976242833242.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-5-638771976249430924.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-6-638771976255692491.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-7-638771976262102836.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-8-638771976268476086.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-9-638771976276299225.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-tem-99-638834189895289023.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-11-inch-wifi-128gb/ipad-air-m3-11-inch-wifi-starlight-1-638771976221454108.jpg'
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

-- Product: Máy tính bảng iPad Air M3 13 inch 5G 128GB
-- Slug: ipad-air-m3-13-inch-5g-128gb
-- Variants: 4

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Apple';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Máy tính bảng';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Máy tính bảng iPad Air M3 13 inch 5G 128GB',
        'ipad-air-m3-13-inch-5g-128gb',
        v_brand_id,
        v_category_id,
        'iPad Air M3 13 inch 5G là một thiết bị di động với cấu hình được tính toán kỹ lưỡng, phù hợp với nhiều mục đích sử dụng. Được trang bị chip M3, một bộ vi xử lý có hiệu năng cao, thiết bị này cho phép xử lý mượt mà các tác vụ đòi hỏi khả năng tính toán lớn, từ chỉnh sửa video độ phân giải cao đến chạy các ứng dụng đồ họa phức tạp.',
        '{"meta_title": "iPad Air M3 13 inch 5G 128GB chính hãng Apple, trả góp 0%", "meta_description": "Mua máy tính bảng iPad Air M3 13 inch 5G 128GB chính hãng Apple, giá tốt, thu cũ đổi mới trợ giá đến 2tr, trả chậm 0% lãi suất, HSSV giảm thêm 400K, BH 1 năm. Xem ngay!", "meta_keywords": "Mua máy tính bảng iPad Air M3 13 inch 5G 128GB chính hãng Apple, giá tốt, thu cũ đổi mới trợ giá đến 2tr, trả chậm 0% lãi suất, HSSV giảm thêm 400K, BH 1 năm. Xem ngay!"}'::jsonb,
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
        'IPAD_AIR_M3_13_INCH_5G_128GB_TIM',
        'ipad-air-m3-13-inch-5g-128gb-tim',
        '{"color": "Tím"}'::jsonb,
        3290000.0,
        NULL,
        622,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "2048 x 2732 Pixels", "Màn hình rộng": "13 inch - Tần số quét  Hãng không công bố"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple M3 8 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 9 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "113 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý", "Chụp ảnh hàng loạt", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Smart HDR 4", "Quay video Full HD", "Live Photos", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Mạng di động": "5G", "SIM": "eSIM", "Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6E", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil Pro", "HDR10+", "HDR10", "Dolby Vision", "DCI-P3", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "36.59 Wh", "Loại pin": "Li-Po", "Công nghệ pin": "Sạc pin nhanh", "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 280.6 mm - Ngang 214.9 mm - Dày 6.1 mm - Nặng 617 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-air-m3-13-inch-5g-purple-1-638772002398398923.jpg', 'ipad-air-m3-13-inch-5g-purple-2-638772002404520888.jpg', 'ipad-air-m3-13-inch-5g-purple-3-638772002410123122.jpg', 'ipad-air-m3-13-inch-5g-purple-4-638772002416480216.jpg', 'ipad-air-m3-13-inch-5g-purple-5-638772002423141913.jpg', 'ipad-air-m3-13-inch-5g-purple-6-638772002430366547.jpg', 'ipad-air-m3-13-inch-5g-purple-7-638772002436113518.jpg', 'ipad-air-m3-13-inch-5g-purple-8-638772002442794210.jpg', 'ipad-air-m3-13-inch-5g-purple-9-638772002448349867.jpg', 'ipad-air-m3-13-inch-5g-tem-99-638834186070272740.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-purple-2-638772002404520888.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-purple-3-638772002410123122.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-purple-4-638772002416480216.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-purple-5-638772002423141913.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-purple-6-638772002430366547.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-purple-7-638772002436113518.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-purple-8-638772002442794210.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-purple-9-638772002448349867.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-tem-99-638834186070272740.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-purple-1-638772002398398923.jpg'
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
        'IPAD_AIR_M3_13_INCH_5G_128GB_XANH_DUONG',
        'ipad-air-m3-13-inch-5g-128gb-xanh-duong',
        '{"color": "Xanh Dương"}'::jsonb,
        25990000.0,
        26190000.0,
        202,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "2048 x 2732 Pixels", "Màn hình rộng": "13 inch - Tần số quét  Hãng không công bố"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple M3 8 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 9 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "113 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý", "Chụp ảnh hàng loạt", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Smart HDR 4", "Quay video Full HD", "Live Photos", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Mạng di động": "5G", "SIM": "eSIM", "Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6E", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil Pro", "HDR10+", "HDR10", "Dolby Vision", "DCI-P3", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "36.59 Wh", "Loại pin": "Li-Po", "Công nghệ pin": "Sạc pin nhanh", "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 280.6 mm - Ngang 214.9 mm - Dày 6.1 mm - Nặng 617 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-air-m3-13-inch-5g-blue-1-638772001135851250.jpg', 'ipad-air-m3-13-inch-5g-blue-2-638772001141597230.jpg', 'ipad-air-m3-13-inch-5g-blue-3-638772001147696365.jpg', 'ipad-air-m3-13-inch-5g-blue-4-638772001152952568.jpg', 'ipad-air-m3-13-inch-5g-blue-5-638772001158712453.jpg', 'ipad-air-m3-13-inch-5g-blue-6-638772001164443144.jpg', 'ipad-air-m3-13-inch-5g-blue-7-638772001170247794.jpg', 'ipad-air-m3-13-inch-5g-blue-8-638772001176190658.jpg', 'ipad-air-m3-13-inch-5g-blue-9-638772001182112645.jpg', 'ipad-air-m3-13-inch-5g-tem-99-638834185571647170.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-blue-2-638772001141597230.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-blue-3-638772001147696365.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-blue-4-638772001152952568.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-blue-5-638772001158712453.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-blue-6-638772001164443144.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-blue-7-638772001170247794.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-blue-8-638772001176190658.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-blue-9-638772001182112645.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-tem-99-638834185571647170.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-blue-1-638772001135851250.jpg'
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
        'IPAD_AIR_M3_13_INCH_5G_128GB_DEN_XAM',
        'ipad-air-m3-13-inch-5g-128gb-den-xam',
        '{"color": "Đen - Xám"}'::jsonb,
        25990000.0,
        26190000.0,
        176,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "2048 x 2732 Pixels", "Màn hình rộng": "13 inch - Tần số quét  Hãng không công bố"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple M3 8 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 9 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "113 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý", "Chụp ảnh hàng loạt", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Smart HDR 4", "Quay video Full HD", "Live Photos", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Mạng di động": "5G", "SIM": "eSIM", "Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6E", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil Pro", "HDR10+", "HDR10", "Dolby Vision", "DCI-P3", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "36.59 Wh", "Loại pin": "Li-Po", "Công nghệ pin": "Sạc pin nhanh", "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 280.6 mm - Ngang 214.9 mm - Dày 6.1 mm - Nặng 617 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-air-m3-13-inch-5g-gray-1-638772000767539637.jpg', 'ipad-air-m3-13-inch-5g-gray-2-638772000773854435.jpg', 'ipad-air-m3-13-inch-5g-gray-3-638772000779315109.jpg', 'ipad-air-m3-13-inch-5g-gray-4-638772000785911960.jpg', 'ipad-air-m3-13-inch-5g-gray-5-638772000792231282.jpg', 'ipad-air-m3-13-inch-5g-gray-6-638772000800943042.jpg', 'ipad-air-m3-13-inch-5g-gray-7-638772000807473924.jpg', 'ipad-air-m3-13-inch-5g-gray-8-638772000814552166.jpg', 'ipad-air-m3-13-inch-5g-gray-9-638772000823080013.jpg', 'ipad-air-m3-13-inch-5g-tem-99-638834185345346879.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-gray-2-638772000773854435.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-gray-3-638772000779315109.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-gray-4-638772000785911960.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-gray-5-638772000792231282.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-gray-6-638772000800943042.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-gray-7-638772000807473924.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-gray-8-638772000814552166.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-gray-9-638772000823080013.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-tem-99-638834185345346879.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-gray-1-638772000767539637.jpg'
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
        'IPAD_AIR_M3_13_INCH_5G_128GB_TRANG_STARLIGHT',
        'ipad-air-m3-13-inch-5g-128gb-trang-starlight',
        '{"color": "Trắng Starlight"}'::jsonb,
        25990000.0,
        26190000.0,
        522,
        '[{"Màn hình": {"Công nghệ màn hình": "Retina IPS LCD", "Độ phân giải": "2048 x 2732 Pixels", "Màn hình rộng": "13 inch - Tần số quét  Hãng không công bố"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 18", "Chip xử lý (CPU)": "Apple M3 8 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 9 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "113 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý", "Chụp ảnh hàng loạt", "Chế độ điện ảnh", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Smart HDR 4", "Quay video Full HD", "Live Photos", "Flash Retina", "Chế độ điện ảnh"]}}, {"Kết nối": {"Mạng di động": "5G", "SIM": "eSIM", "Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6E", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Mở khóa bằng vân tay Touch ID", "Kết nối bàn phím rời", "Kết nối Apple Pencil Pro", "HDR10+", "HDR10", "Dolby Vision", "DCI-P3", "Micro kép"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "36.59 Wh", "Loại pin": "Li-Po", "Công nghệ pin": "Sạc pin nhanh", "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 280.6 mm - Ngang 214.9 mm - Dày 6.1 mm - Nặng 617 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['ipad-air-m3-13-inch-5g-starlight-1-638772001483698411.jpg', 'ipad-air-m3-13-inch-5g-starlight-2-638772001493733699.jpg', 'ipad-air-m3-13-inch-5g-starlight-3-638772001500594428.jpg', 'ipad-air-m3-13-inch-5g-starlight-4-638772001506274094.jpg', 'ipad-air-m3-13-inch-5g-starlight-5-638772001511898458.jpg', 'ipad-air-m3-13-inch-5g-starlight-6-638772001520548747.jpg', 'ipad-air-m3-13-inch-5g-starlight-7-638772001526316759.jpg', 'ipad-air-m3-13-inch-5g-starlight-8-638772001533754617.jpg', 'ipad-air-m3-13-inch-5g-starlight-9-638772001542938681.jpg', 'ipad-air-m3-13-inch-5g-tem-99-638834185814646708.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-starlight-2-638772001493733699.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-starlight-3-638772001500594428.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-starlight-4-638772001506274094.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-starlight-5-638772001511898458.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-starlight-6-638772001520548747.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-starlight-7-638772001526316759.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-starlight-8-638772001533754617.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-starlight-9-638772001542938681.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-tem-99-638834185814646708.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-air-m3-13-inch-5g-128gb/ipad-air-m3-13-inch-5g-starlight-1-638772001483698411.jpg'
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

-- Product: Máy tính bảng iPad Pro M4 11 inch WiFi 1TB
-- Slug: ipad-pro-m4-11-inch-wifi-1tb
-- Variants: 2

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Apple';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Máy tính bảng';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Máy tính bảng iPad Pro M4 11 inch WiFi 1TB',
        'ipad-pro-m4-11-inch-wifi-1tb',
        v_brand_id,
        v_category_id,
        'Siêu phẩm máy tính bảng mạnh mẽ hàng đầu thị trường hiện tại mang tên iPad Pro M4 1TB được Apple trình làng trong sự kiện Let Loose. Với bộ vi xử lý Apple M4 tối tân, màn hình Ultra Retina XDR siêu sống động, tương thích với Apple Pencil Pro, hệ thống camera đa tiện ích,... đây sẽ là lựa chọn hàng đầu cho người dùng sáng tạo.',
        '{"meta_title": "iPad Pro M4 11 inch WiFi 1TB chính hãng, giá rẻ, giảm ngay 2.5tr", "meta_description": "Mua máy tính bảng iPad Pro M4 11 inch WiFi 1TB giá rẻ, chính hãng, giảm ngay 2.5 triệu, mua trả chậm 0% lãi suất, thu cũ đổi mới trợ giá lên đến 2tr. Mua ngay!", "meta_keywords": "Mua máy tính bảng iPad Pro M4 11 inch WiFi 1TB giá rẻ, chính hãng, giảm ngay 2.5 triệu, mua trả chậm 0% lãi suất, thu cũ đổi mới trợ giá lên đến 2tr. Mua ngay!"}'::jsonb,
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
        'IPAD_PRO_M4_11_INCH_WIFI_1TB_DEN',
        'ipad-pro-m4-11-inch-wifi-1tb-den',
        '{"color": "Đen"}'::jsonb,
        13590000.0,
        NULL,
        443,
        '[{"Màn hình": {"Công nghệ màn hình": "Ultra Retina XDR", "Độ phân giải": "1668 x 2420 Pixels", "Màn hình rộng": "11 inch - Tần số quét 120 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 17", "Chip xử lý (CPU)": "Apple M4 10 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 10 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "16 GB", "Dung lượng lưu trữ": "1 TB", "Dung lượng còn lại (khả dụng) khoảng": "1009 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Xóa phông", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý", "Góc rộng", "Chụp ảnh hàng loạt", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Xóa phông", "Smart HDR 4", "Quay video Full HD", "Live Photos", "Góc siêu rộng", "Flash màn hình", "Chụp ảnh hàng loạt"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6E", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Nam châm & sạc cho Apple Pencil Pro", "Mở khóa bằng khuôn mặt (Face ID)", "Kết nối bàn phím rời", "Kết nối Apple Pencil Pro", "HDR10", "Dolby Vision", "DCI-P3", "Công nghệ True Tone", "4 micro", "4 loa stereo"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "31.29 Wh", "Loại pin": "Li-Po", "Công nghệ pin": "Sạc pin nhanh", "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 249.7 mm - Ngang 177.5 mm - Dày 5.3 mm - Nặng 444 g", "Thời điểm ra mắt": "05/2024"}}]'::jsonb,
        ARRAY['ipad-pro-11-inch-m4-wifi-black-1.jpg', 'ipad-pro-11-inch-m4-wifi-black-2.jpg', 'ipad-pro-11-inch-m4-wifi-black-3.jpg', 'ipad-pro-m4-11-inch-wifi-1tb-tem-99.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-pro-m4-11-inch-wifi-1tb/ipad-pro-11-inch-m4-wifi-black-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-pro-m4-11-inch-wifi-1tb/ipad-pro-11-inch-m4-wifi-black-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-pro-m4-11-inch-wifi-1tb/ipad-pro-m4-11-inch-wifi-1tb-tem-99.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-pro-m4-11-inch-wifi-1tb/ipad-pro-11-inch-m4-wifi-black-1.jpg'
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
        'IPAD_PRO_M4_11_INCH_WIFI_1TB_BAC',
        'ipad-pro-m4-11-inch-wifi-1tb-bac',
        '{"color": "Bạc"}'::jsonb,
        41990000.0,
        45190000.0,
        936,
        '[{"Màn hình": {"Công nghệ màn hình": "Ultra Retina XDR", "Độ phân giải": "1668 x 2420 Pixels", "Màn hình rộng": "11 inch - Tần số quét 120 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "iPadOS 17", "Chip xử lý (CPU)": "Apple M4 10 nhân", "Tốc độ CPU": "Hãng không công bố", "Chip đồ hoạ (GPU)": "Apple GPU 10 nhân"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "16 GB", "Dung lượng lưu trữ": "1 TB", "Dung lượng còn lại (khả dụng) khoảng": "1009 GB"}}, {"Camera sau": {"Độ phân giải": "12 MP", "Quay phim": ["4K 2160p@30fps", "HD 720p@30fps", "FullHD 1080p@60fps", "FullHD 1080p@30fps", "FullHD 1080p@25fps", "FullHD 1080p@240fps", "FullHD 1080p@120fps", "4K 2160p@60fps", "4K 2160p@25fps", "4K 2160p@24fps"], "Tính năng": ["Zoom kỹ thuật số", "Xóa phông", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Smart HDR 4", "Quay video ProRes", "Quay chậm (Slow Motion)", "Live Photos", "Gắn thẻ địa lý", "Góc rộng", "Chụp ảnh hàng loạt", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Xóa phông", "Smart HDR 4", "Quay video Full HD", "Live Photos", "Góc siêu rộng", "Flash màn hình", "Chụp ảnh hàng loạt"]}}, {"Kết nối": {"Thực hiện cuộc gọi": "Nghe gọi qua FaceTime", "Wifi": "Wi-Fi 6E", "GPS": ["iBeacon", "GPS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Trung tâm màn hình", "Nam châm & sạc cho Apple Pencil Pro", "Mở khóa bằng khuôn mặt (Face ID)", "Kết nối bàn phím rời", "Kết nối Apple Pencil Pro", "HDR10", "Dolby Vision", "DCI-P3", "Công nghệ True Tone", "4 micro", "4 loa stereo"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "31.29 Wh", "Loại pin": "Li-Po", "Công nghệ pin": "Sạc pin nhanh", "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 249.7 mm - Ngang 177.5 mm - Dày 5.3 mm - Nặng 444 g", "Thời điểm ra mắt": "05/2024"}}]'::jsonb,
        ARRAY['ipad-pro-11-inch-m4-wifi-sliver-1.jpg', 'ipad-pro-11-inch-m4-wifi-sliver-2.jpg', 'ipad-pro-11-inch-m4-wifi-sliver-3.jpg', 'ipad-pro-m4-11-inch-wifi-1tb-tem-99-1.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-pro-m4-11-inch-wifi-1tb/ipad-pro-11-inch-m4-wifi-sliver-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-pro-m4-11-inch-wifi-1tb/ipad-pro-11-inch-m4-wifi-sliver-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-pro-m4-11-inch-wifi-1tb/ipad-pro-m4-11-inch-wifi-1tb-tem-99-1.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/ipad-pro-m4-11-inch-wifi-1tb/ipad-pro-11-inch-m4-wifi-sliver-1.jpg'
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

-- Product: Máy tính bảng Lenovo Idea Tab 5G 8GB/128GB
-- Slug: lenovo-idea-tab-5g-8gb-128gb
-- Variants: 4

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Lenovo';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Máy tính bảng';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Máy tính bảng Lenovo Idea Tab 5G 8GB/128GB',
        'lenovo-idea-tab-5g-8gb-128gb',
        v_brand_id,
        v_category_id,
        'Lenovo Idea Tab 5G mang đến trải nghiệm học tập và giải trí trọn vẹn với màn hình 2.5K sắc nét, âm thanh Dolby Atmos sống động, chip MediaTek Dimensity 6300 mượt mà. Bên cạnh đó, máy còn hỗ trợ AI Note, Circle to Search cùng bàn phím và bút cảm ứng tùy chọn, đáp ứng linh hoạt mọi nhu cầu học tập, làm việc và sáng tạo của sinh viên.',
        '{"meta_title": "Lenovo Idea Tab 5G giá tốt, mua trả chậm 0% lãi suất", "meta_description": "Lenovo Idea Tab 5G 8GB/128GB giá tốt, giảm ngay 200k hoặc tặng phiếu mua hàng trị giá 250k, tặng bao da kèm bút trị giá 990k, trả chậm 0% lãi suất. Mua ngay!", "meta_keywords": "Lenovo Idea Tab 5G 8GB/128GB, Lenovo Idea Tab 5g, Lenovo Idea Tab, Lenovo IdeaTab, idaetap, lenovo idea tab"}'::jsonb,
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
        'LENOVO_IDEA_TAB_5G_8GB_128GB_5G_XANH_DUONG',
        'lenovo-idea-tab-5g-8gb-128gb-5g-xanh-duong',
        '{"color": "Xanh Dương", "connection": "5G"}'::jsonb,
        7390000.0,
        NULL,
        777,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "1600 x 2560 Pixels", "Màn hình rộng": "11 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "MediaTek Dimensity 6300 8 nhân", "Tốc độ CPU": "2 nhân 2.4 GHz & 6 nhân 2 GHz", "Chip đồ hoạ (GPU)": "Mali-G57 MC2"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "104 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 2 TB"}}, {"Camera sau": {"Độ phân giải": "8 MP", "Quay phim": "FullHD 1080p@30fps", "Tính năng": ["Nhãn dán (AR Stickers)", "Làm đẹp", "HDR"]}}, {"Camera trước": {"Độ phân giải": "5 MP", "Tính năng": ["Nhãn dán (AR Stickers)", "Làm đẹp", "HDR"]}}, {"Kết nối": {"Mạng di động": "5G", "SIM": "1 Nano SIM", "Thực hiện cuộc gọi": "Có nghe gọi", "Wifi": "Wi-Fi 5", "GPS": ["GPS", "GLONASS", "GALILEO"], "Bluetooth": "v5.2", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "3.5 mm", "Kết nối khác": "OTG"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Lenovo AI Note", "Âm thanh Dolby Atmos", "Mở khóa bằng khuôn mặt", "4 loa"], "Kháng nước, bụi": "IP52", "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "7040 mAh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Kim loại nguyên khối", "Kích thước, khối lượng": "Dài 254.59 mm - Ngang 166.15 mm - Dày 6.99 mm - Nặng 480 g", "Thời điểm ra mắt": "08/2025"}}]'::jsonb,
        ARRAY['lenovo-idea-tab-5g-xanh-1-638971777242904720.jpg', 'lenovo-idea-tab-5g-xanh-2-638971777237335426.jpg', 'lenovo-idea-tab-5g-xanh-3-638971777227029174.jpg', 'lenovo-idea-tab-5g-tem-99-638971784088249607.jpg', 'lenovo-idea-tab-wifi-bbh-638971784455899312.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-5g-xanh-2-638971777237335426.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-5g-xanh-3-638971777227029174.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-5g-tem-99-638971784088249607.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-wifi-bbh-638971784455899312.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-5g-xanh-1-638971777242904720.jpg'
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
        'LENOVO_IDEA_TAB_5G_8GB_128GB_5G_XAM',
        'lenovo-idea-tab-5g-8gb-128gb-5g-xam',
        '{"color": "Xám", "connection": "5G"}'::jsonb,
        7390000.0,
        NULL,
        855,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "1600 x 2560 Pixels", "Màn hình rộng": "11 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "MediaTek Dimensity 6300 8 nhân", "Tốc độ CPU": "2 nhân 2.4 GHz & 6 nhân 2 GHz", "Chip đồ hoạ (GPU)": "Mali-G57 MC2"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "104 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 2 TB"}}, {"Camera sau": {"Độ phân giải": "8 MP", "Quay phim": "FullHD 1080p@30fps", "Tính năng": ["Nhãn dán (AR Stickers)", "Làm đẹp", "HDR"]}}, {"Camera trước": {"Độ phân giải": "5 MP", "Tính năng": ["Nhãn dán (AR Stickers)", "Làm đẹp", "HDR"]}}, {"Kết nối": {"Mạng di động": "5G", "SIM": "1 Nano SIM", "Thực hiện cuộc gọi": "Có nghe gọi", "Wifi": "Wi-Fi 5", "GPS": ["GPS", "GLONASS", "GALILEO"], "Bluetooth": "v5.2", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "3.5 mm", "Kết nối khác": "OTG"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Lenovo AI Note", "Âm thanh Dolby Atmos", "Mở khóa bằng khuôn mặt", "4 loa"], "Kháng nước, bụi": "IP52", "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "7040 mAh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Kim loại nguyên khối", "Kích thước, khối lượng": "Dài 254.59 mm - Ngang 166.15 mm - Dày 6.99 mm - Nặng 480 g", "Thời điểm ra mắt": "08/2025"}}]'::jsonb,
        ARRAY['lenovo-idea-tab-5g-xam-1-638971780741368250.jpg', 'lenovo-idea-tab-5g-xam-2-638971780734266983.jpg', 'lenovo-idea-tab-5g-xam-3-638971780726871271.jpg', 'lenovo-idea-tab-5g-tem-99-638971784017086899.jpg', 'lenovo-idea-tab-wifi-bbh-638971784455899312.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-5g-xam-2-638971780734266983.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-5g-xam-3-638971780726871271.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-5g-tem-99-638971784017086899.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-wifi-bbh-638971784455899312.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-5g-xam-1-638971780741368250.jpg'
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
        'LENOVO_IDEA_TAB_5G_8GB_128GB_WIFI_XANH_DUONG',
        'lenovo-idea-tab-5g-8gb-128gb-wifi-xanh-duong',
        '{"color": "Xanh Dương", "connection": "WiFi"}'::jsonb,
        6590000.0,
        NULL,
        115,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "1600 x 2560 Pixels", "Màn hình rộng": "11 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "MediaTek Dimensity 6300 8 nhân", "Tốc độ CPU": "2 nhân 2.4 GHz & 6 nhân 2 GHz", "Chip đồ hoạ (GPU)": "Mali-G57 MC2"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "104 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 2 TB"}}, {"Camera sau": {"Độ phân giải": "8 MP", "Quay phim": "FullHD 1080p@30fps", "Tính năng": ["Nhãn dán (AR Stickers)", "Làm đẹp", "HDR"]}}, {"Camera trước": {"Độ phân giải": "5 MP", "Tính năng": ["Nhãn dán (AR Stickers)", "Làm đẹp", "HDR"]}}, {"Kết nối": {"Wifi": "Wi-Fi 5", "GPS": ["GPS", "GLONASS", "GALILEO"], "Bluetooth": "v5.2", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "3.5 mm", "Kết nối khác": "OTG"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Lenovo AI Note", "Âm thanh Dolby Atmos", "Mở khóa bằng khuôn mặt", "4 loa"], "Kháng nước, bụi": "IP52", "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "7040 mAh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Kim loại nguyên khối", "Kích thước, khối lượng": "Dài 254.59 mm - Ngang 166.15 mm - Dày 6.99 mm - Nặng 480 g", "Thời điểm ra mắt": "08/2025"}}]'::jsonb,
        ARRAY['lenovo-idea-tab-1-638971756363636473.jpg', 'lenovo-idea-tab-2-638971756313265277.jpg', 'lenovo-idea-tab-3-638971756306383469.jpg', 'lenovo-idea-tab-4-638971756298833705.jpg', 'lenovo-idea-tab-5-638971756291727057.jpg', 'lenovo-idea-tab-6-638971756284811979.jpg', 'lenovo-idea-tab-7-638971756277643665.jpg', 'lenovo-idea-tab-8-638971756270743727.jpg', 'lenovo-idea-tab-9-638971756259401799.jpg', 'lenovo-idea-tab-10-638971756357367641.jpg', 'lenovo-idea-tab-11-638971756350469038.jpg', 'lenovo-idea-tab-12-638971756343441755.jpg', 'lenovo-idea-tab-13-638971756334276997.jpg', 'lenovo-idea-tab-14-638971756326449584.jpg', 'lenovo-idea-tab-15-638971756319959878.jpg', 'lenovo-idea-tab-wifi-bbh-638971766157866799.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-2-638971756313265277.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-3-638971756306383469.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-4-638971756298833705.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-5-638971756291727057.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-6-638971756284811979.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-7-638971756277643665.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-8-638971756270743727.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-9-638971756259401799.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-10-638971756357367641.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-11-638971756350469038.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-12-638971756343441755.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-13-638971756334276997.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-14-638971756326449584.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-15-638971756319959878.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-wifi-bbh-638971766157866799.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-1-638971756363636473.jpg'
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
        'LENOVO_IDEA_TAB_5G_8GB_128GB_WIFI_XAM',
        'lenovo-idea-tab-5g-8gb-128gb-wifi-xam',
        '{"color": "Xám", "connection": "WiFi"}'::jsonb,
        6590000.0,
        NULL,
        610,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "1600 x 2560 Pixels", "Màn hình rộng": "11 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "MediaTek Dimensity 6300 8 nhân", "Tốc độ CPU": "2 nhân 2.4 GHz & 6 nhân 2 GHz", "Chip đồ hoạ (GPU)": "Mali-G57 MC2"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "104 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 2 TB"}}, {"Camera sau": {"Độ phân giải": "8 MP", "Quay phim": "FullHD 1080p@30fps", "Tính năng": ["Nhãn dán (AR Stickers)", "Làm đẹp", "HDR"]}}, {"Camera trước": {"Độ phân giải": "5 MP", "Tính năng": ["Nhãn dán (AR Stickers)", "Làm đẹp", "HDR"]}}, {"Kết nối": {"Wifi": "Wi-Fi 5", "GPS": ["GPS", "GLONASS", "GALILEO"], "Bluetooth": "v5.2", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "3.5 mm", "Kết nối khác": "OTG"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Lenovo AI Note", "Âm thanh Dolby Atmos", "Mở khóa bằng khuôn mặt", "4 loa"], "Kháng nước, bụi": "IP52", "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "7040 mAh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "20 W", "Sạc kèm theo máy": "20 W"}}, {"Thông tin chung": {"Chất liệu": "Kim loại nguyên khối", "Kích thước, khối lượng": "Dài 254.59 mm - Ngang 166.15 mm - Dày 6.99 mm - Nặng 480 g", "Thời điểm ra mắt": "08/2025"}}]'::jsonb,
        ARRAY['lenovo-idea-tab-1-638971756363636473.jpg', 'lenovo-idea-tab-2-638971756313265277.jpg', 'lenovo-idea-tab-3-638971756306383469.jpg', 'lenovo-idea-tab-4-638971756298833705.jpg', 'lenovo-idea-tab-5-638971756291727057.jpg', 'lenovo-idea-tab-6-638971756284811979.jpg', 'lenovo-idea-tab-7-638971756277643665.jpg', 'lenovo-idea-tab-8-638971756270743727.jpg', 'lenovo-idea-tab-9-638971756259401799.jpg', 'lenovo-idea-tab-10-638971756357367641.jpg', 'lenovo-idea-tab-11-638971756350469038.jpg', 'lenovo-idea-tab-12-638971756343441755.jpg', 'lenovo-idea-tab-13-638971756334276997.jpg', 'lenovo-idea-tab-14-638971756326449584.jpg', 'lenovo-idea-tab-15-638971756319959878.jpg', 'lenovo-idea-tab-wifi-bbh-638971766157866799.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-2-638971756313265277.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-3-638971756306383469.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-4-638971756298833705.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-5-638971756291727057.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-6-638971756284811979.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-7-638971756277643665.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-8-638971756270743727.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-9-638971756259401799.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-10-638971756357367641.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-11-638971756350469038.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-12-638971756343441755.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-13-638971756334276997.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-14-638971756326449584.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-15-638971756319959878.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-wifi-bbh-638971766157866799.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-idea-tab-5g-8gb-128gb/lenovo-idea-tab-1-638971756363636473.jpg'
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

-- Product: Máy tính bảng Lenovo Tab Plus WiFi 8GB/256GB
-- Slug: lenovo-tab-plus-wifi-8gb-256gb
-- Variants: 1

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Lenovo';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Máy tính bảng';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Máy tính bảng Lenovo Tab Plus WiFi 8GB/256GB',
        'lenovo-tab-plus-wifi-8gb-256gb',
        v_brand_id,
        v_category_id,
        'Lenovo Tab Plus kết hợp thiết kế tinh tế, hiệu năng mạnh mẽ và trải nghiệm giải trí đỉnh cao. Với màn hình lớn, chân đế tiện lợi, âm thanh sống động và pin bền bỉ, sản phẩm này đáp ứng tốt mọi nhu cầu từ công việc đến giải trí. Lenovo Tab Plus là lựa chọn lý tưởng trong phân khúc tablet tầm trung đến cao cấp.',
        '{"meta_title": "Lenovo Tab Plus WiFi 8GB/256GB - Chính hãng, giá rẻ, có mua trả chậm", "meta_description": "Lenovo Tab Plus WiFi 8GB/256GB giá rẻ, có mua trả chậm, nhiều khuyến mãi và quà tặng hấp dẫn. Giao hàng nhanh chóng, 1 đổi 1 trong 1 tháng tận nhà nếu lỗi.", "meta_keywords": "Mua Lenovo Tab Plus WiFi 8GB/256GB, mua online Lenovo Tab Plus WiFi 8GB/256GB, Lenovo Tab Plus WiFi 8GB/256GB"}'::jsonb,
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
        'LENOVO_TAB_PLUS_WIFI_8GB_256GB_DEFAULT',
        'lenovo-tab-plus-wifi-8gb-256gb-default',
        NULL,
        7850000.0,
        NULL,
        178,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "1200 x 2000 Pixels", "Màn hình rộng": "11.5 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 14", "Chip xử lý (CPU)": "MediaTek Helio G99", "Tốc độ CPU": "2 nhân 2.2 GHz & 6 nhân 2 GHz", "Chip đồ hoạ (GPU)": "Mali-G57 MC2"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "235 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 1 TB"}}, {"Camera sau": {"Độ phân giải": "8 MP", "Quay phim": "FullHD 1080p@30fps", "Tính năng": ["HDR", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "8 MP", "Tính năng": ["Tự động lấy nét (AF)", "Quay video Full HD"]}}, {"Kết nối": {"Wifi": "Wi-Fi Direct", "GPS": ["GPS", "GLONASS", "GALILEO"], "Bluetooth": "v5.2", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "3.5 mm"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Chạm 2 lần mở màn hình", "Google Kids Space"], "Kháng nước, bụi": "IP52"}}, {"Pin & Sạc": {"Dung lượng pin": "8600 mAh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "45 W", "Sạc kèm theo máy": "45 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 268.3 mm - Ngang 174.25 mm - Dày 7.77-13.58 mm - Nặng 650 g", "Thời điểm ra mắt": "07/2024"}}]'::jsonb,
        ARRAY['lenovo-tab-plus-1.jpg', 'lenovo-tab-plus-2.jpg', 'lenovo-tab-plus-3.jpg', 'lenovo-tab-plus-4.jpg', 'lenovo-tab-plus-5.jpg', 'lenovo-tab-plus-6.jpg', 'lenovo-tab-plus-7.jpg', 'lenovo-tab-plus-8.jpg', 'lenovo-tab-plus-9.jpg', 'lenovo-tab-plus-10.jpg', 'lenovo-tab-plus-11.jpg', 'lenovo-tab-plus-12.jpg', 'lenovo-tab-plus-13.jpg', 'lenovo-tab-plus-14.jpg', 'lenovo-tab-plus-mohop-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-tab-plus-wifi-8gb-256gb/lenovo-tab-plus-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-tab-plus-wifi-8gb-256gb/lenovo-tab-plus-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-tab-plus-wifi-8gb-256gb/lenovo-tab-plus-4.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-tab-plus-wifi-8gb-256gb/lenovo-tab-plus-5.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-tab-plus-wifi-8gb-256gb/lenovo-tab-plus-6.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-tab-plus-wifi-8gb-256gb/lenovo-tab-plus-7.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-tab-plus-wifi-8gb-256gb/lenovo-tab-plus-8.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-tab-plus-wifi-8gb-256gb/lenovo-tab-plus-9.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-tab-plus-wifi-8gb-256gb/lenovo-tab-plus-10.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-tab-plus-wifi-8gb-256gb/lenovo-tab-plus-11.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-tab-plus-wifi-8gb-256gb/lenovo-tab-plus-12.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-tab-plus-wifi-8gb-256gb/lenovo-tab-plus-13.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-tab-plus-wifi-8gb-256gb/lenovo-tab-plus-14.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-tab-plus-wifi-8gb-256gb/lenovo-tab-plus-mohop-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/lenovo-tab-plus-wifi-8gb-256gb/lenovo-tab-plus-1.jpg'
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

-- Product: Vòng đeo tay thông minh Mi Band 10 viền gốm
-- Slug: mi-band-10-vien-gom
-- Variants: 1

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Xiaomi';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Đồng hồ thông minh';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Vòng đeo tay thông minh Mi Band 10 viền gốm',
        'mi-band-10-vien-gom',
        v_brand_id,
        v_category_id,
        'Xiaomi tiếp tục khẳng định vị thế vững chắc trong phân khúc thiết bị đeo thông minh với phiên bản đặc biệt Mi Band 10 Ceramic - một sự kết hợp hài hòa giữa thiết kế sang trọng và công nghệ hiện đại. Bên cạnh loạt cải tiến về phần cứng và phần mềm, thiết bị còn vận hành mượt mà trên nền tảng HyperOS, hứa hẹn mang lại trải nghiệm cao cấp và tối ưu hóa toàn diện cho người dùng yêu thích theo dõi sức khỏe lẫn thời trang công nghệ.',
        '{"meta_title": "Xiaomi Mi Band 10 Ceramic viền gốm chỉ 1.660K, trả góp 0%", "meta_description": "Mua vòng đeo tay Xiaomi Smart Band 10 Ceramic Edition gốm trắng nhận cơ hội trúng 10 suất mua 1010đ cùng 150 suất quà trị giá 1Tr dành cho khách mua hàng sớm.", "meta_keywords": "Mua vòng đeo tay Xiaomi Smart Band 10 Ceramic Edition gốm trắng nhận cơ hội trúng 10 suất mua 1010đ cùng 150 suất quà trị giá 1Tr dành cho khách mua hàng sớm."}'::jsonb,
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
        'MI_BAND_10_VIEN_GOM_DEFAULT',
        'mi-band-10-vien-gom-default',
        NULL,
        1760000.0,
        NULL,
        197,
        '[{"Màn hình": {"Công nghệ màn hình": "AMOLED", "Kích thước màn hình": "1.72 inch", "Độ phân giải": "212 x 520 pixels", "Kích thước mặt": "43.7 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Kính cường lực 2.5D", "Chất liệu khung viền": "Gốm", "Chất liệu dây": "Cao su", "Độ rộng dây": "1.4 cm", "Chu vi cổ tay phù hợp": "13.5 - 21 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 47.74 mm - Ngang 23.94 mm - Dày 10.95 mm - Nặng 23.05 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Chạy bộ", "Đạp xe"], "Tiện ích đặc biệt": "Màn hình luôn hiển thị", "Chống nước / Kháng nước": "Kháng nước 5 ATM (Tắm, đi mưa thoải mái)", "Theo dõi sức khoẻ": ["Đo nồng độ oxy (SpO2)", "Hệ thống đánh giá sức khỏe PAI", "Theo dõi Nồng độ oxy trong máu 24h", "Tính quãng đường chạy", "Theo dõi nhịp tim 24h", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi mức độ stress", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Nhắc nhở ít vận động", "Đo nhịp tim", "Đếm số bước chân", "Bài tập thở"], "Tiện ích khác": ["Tìm đồng hồ", "Nâng cổ tay sáng màn hình", "Màn hình cảm ứng", "Chế độ DND (Không làm phiền)", "Đồng hồ đếm ngược", "Đồng hồ bấm giờ", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Thay mặt đồng hồ", "Rung thông báo", "Dự báo thời tiết", "Báo thức", "Đèn pin", "Hẹn giờ", "Tự động điều chỉnh độ sáng màn hình", "Lời nhắc sự kiện", "Lịch", "Chạm để đánh thức màn hình", "Che để tắt màn hình"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Viber", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 9 ngày (khi bật Always On Display)", "Khoảng 21 ngày (ở chế độ cơ bản)"], "Thời gian sạc": "Khoảng 1 giờ", "Dung lượng pin": "233 mAh", "Cổng sạc": "Dây sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Hãng không công bố", "Bộ nhớ trong": "Hãng không công bố", "Hệ điều hành": "HyperOS", "Kết nối được với hệ điều hành": ["Android 8.0 trở lên", "iOS 12 trở lên"], "Ứng dụng quản lý": "Mi Fitness", "Kết nối": "Bluetooth v5.4", "Cảm biến": ["Cảm biến ánh sáng môi trường", "Cảm biến nhịp tim quang học (PPG)", "Cảm biến từ", "Con quay hồi chuyển", "Gia tốc kế", "La bàn điện tử"]}}, {"Thông tin khác": {"Sản xuất tại": "Trung Quốc", "Thời gian ra mắt": "07/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh"]}}]'::jsonb,
        ARRAY['mi-band-10-vien-gom-hc-1-638868962974334045.jpg', 'mi-band-10-vien-gom-hc-2-638868962979395863.jpg', 'mi-band-10-vien-gom-hc-3-638868962986506208.jpg', 'mi-band-10-vien-gom-hc-4-638868962991949199.jpg', 'mi-band-10-vien-gom-hc-7-638868963013094734.jpg', 'mi-band-10-vien-gom-hc-8-638868963019505411.jpg', 'mi-band-10-vien-gom-hc-9-638868962968278957.jpg', 'mi-band-10-vien-gom-hc-10-638868963001602594.jpg', 'mi-band-10-vien-gom-hc-11-638868963007288088.jpg', 'mi-band-10-vien-gom-tem-40-638869628750592426.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/mi-band-10-vien-gom/mi-band-10-vien-gom-hc-2-638868962979395863.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/mi-band-10-vien-gom/mi-band-10-vien-gom-hc-3-638868962986506208.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/mi-band-10-vien-gom/mi-band-10-vien-gom-hc-4-638868962991949199.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/mi-band-10-vien-gom/mi-band-10-vien-gom-hc-7-638868963013094734.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/mi-band-10-vien-gom/mi-band-10-vien-gom-hc-8-638868963019505411.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/mi-band-10-vien-gom/mi-band-10-vien-gom-hc-9-638868962968278957.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/mi-band-10-vien-gom/mi-band-10-vien-gom-hc-10-638868963001602594.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/mi-band-10-vien-gom/mi-band-10-vien-gom-hc-11-638868963007288088.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/mi-band-10-vien-gom/mi-band-10-vien-gom-tem-40-638869628750592426.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/mi-band-10-vien-gom/mi-band-10-vien-gom-hc-1-638868962974334045.jpg'
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

-- Product: Máy tính bảng Xiaomi Redmi Pad SE 8.7 4G 4GB/128GB
-- Slug: redmi-pad-se-8-7-4g-4gb-128gb
-- Variants: 6

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Xiaomi';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Máy tính bảng';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Máy tính bảng Xiaomi Redmi Pad SE 8.7 4G 4GB/128GB',
        'redmi-pad-se-8-7-4g-4gb-128gb',
        v_brand_id,
        v_category_id,
        'Xiaomi Redmi Pad SE 8.7 4G có thiết kế gọn nhẹ với nhiều màu sắc lựa chọn. Pin dung lượng lớn cho thời gian sử dụng lâu dài, vi xử lý ổn định giúp xử lý mượt mà các tác vụ hàng ngày, và màn hình 8.7 inch mang lại hình ảnh sắc nét, dễ nhìn.',
        '{"meta_title": "Xiaomi Redmi Pad SE 8.7 4G 4GB/128GB - Chính hãng, giá rẻ, có mua trả chậm", "meta_description": "Xiaomi Redmi Pad SE 8.7 4G 4GB/128GB giá rẻ, có mua trả chậm, nhiều khuyến mãi và quà tặng hấp dẫn. Giao hàng nhanh chóng, 1 đổi 1 trong 1 tháng tận nhà nếu lỗi.", "meta_keywords": "Mua Xiaomi Redmi Pad SE 8.7 4G 4GB/128GB, mua online Xiaomi Redmi Pad SE 8.7 4G 4GB/128GB, Xiaomi Redmi Pad SE 8.7 4G 4GB/128GB"}'::jsonb,
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
        'REDMI_PAD_SE_8_7_4G_4GB_128GB_6GB_XANH_LA',
        'redmi-pad-se-8-7-4g-4gb-128gb-6gb-xanh-la',
        '{"color": "Xanh lá", "memory": "6GB"}'::jsonb,
        575000.0,
        NULL,
        127,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "800 x 1340 Pixels", "Màn hình rộng": "8.7 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 14", "Chip xử lý (CPU)": "MediaTek Helio G85 8 nhân", "Tốc độ CPU": "2 nhân 2.0 GHz & 6 nhân 1.8 GHz", "Chip đồ hoạ (GPU)": "Mali-G52 MC2"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "6 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "109 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 2 TB"}}, {"Camera sau": {"Độ phân giải": "8 MP", "Quay phim": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Tính năng": "Đèn Flash"}}, {"Camera trước": {"Độ phân giải": "5 MP", "Tính năng": ["Quay video HD", "Quay video Full HD"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 4G", "SIM": "2 Nano SIM", "Thực hiện cuộc gọi": "Có nghe gọi", "Wifi": "Wi-Fi 802.11 a/b/g/n/ac", "GPS": ["GPS", "GLONASS", "GALILEO", "BDS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "3.5 mm"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Mở khóa bằng khuôn mặt", "Loa kép"], "Ghi âm": "Có", "Radio": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "6650 mAh", "Loại pin": "Li-Po", "Công nghệ pin": "Tiết kiệm pin", "Hỗ trợ sạc tối đa": "18 W", "Sạc kèm theo máy": "10 W"}}, {"Thông tin chung": {"Chất liệu": "Nhựa nguyên khối", "Kích thước, khối lượng": "Dài 211.58 mm - Ngang 125.48 mm - Dày 8.8 mm - Nặng 375 g", "Thời điểm ra mắt": "08/2024"}}]'::jsonb,
        ARRAY['redmi-pad-se-8-7-4g-blue-1.jpg', 'redmi-pad-se-8-7-4g-blue-2.jpg', 'redmi-pad-se-8-7-4g-blue-3.jpg', 'redmi-pad-se-8-7-4g-blue-4.jpg', 'redmi-pad-se-8-7-4g-blue-5.jpg', 'redmi-pad-se-8-7-4g-blue-6.jpg', 'redmi-pad-se-8-7-4g-blue-7.jpg', 'redmi-pad-se-8-7-4g-blue-8.jpg', 'redmi-pad-se-8-7-4g-blue-9.jpg', 'redmi-pad-se-8-7-4g-blue-10.jpg', 'redmi-pad-se-8-7-4g-blue-11.jpg', 'redmi-pad-se-8-7-4g-blue-12.jpg', 'redmi-pad-se-8-7-tem-99-1.jpg', 'redmi-pad-se-8-7-4g-mohop-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-4.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-5.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-6.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-7.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-8.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-9.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-10.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-11.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-12.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-tem-99-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-mohop-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-1.jpg'
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
        'REDMI_PAD_SE_8_7_4G_4GB_128GB_6GB_XANH_DUONG',
        'redmi-pad-se-8-7-4g-4gb-128gb-6gb-xanh-duong',
        '{"color": "Xanh Dương", "memory": "6GB"}'::jsonb,
        575000.0,
        NULL,
        784,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "800 x 1340 Pixels", "Màn hình rộng": "8.7 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 14", "Chip xử lý (CPU)": "MediaTek Helio G85 8 nhân", "Tốc độ CPU": "2 nhân 2.0 GHz & 6 nhân 1.8 GHz", "Chip đồ hoạ (GPU)": "Mali-G52 MC2"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "6 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "109 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 2 TB"}}, {"Camera sau": {"Độ phân giải": "8 MP", "Quay phim": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Tính năng": "Đèn Flash"}}, {"Camera trước": {"Độ phân giải": "5 MP", "Tính năng": ["Quay video HD", "Quay video Full HD"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 4G", "SIM": "2 Nano SIM", "Thực hiện cuộc gọi": "Có nghe gọi", "Wifi": "Wi-Fi 802.11 a/b/g/n/ac", "GPS": ["GPS", "GLONASS", "GALILEO", "BDS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "3.5 mm"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Mở khóa bằng khuôn mặt", "Loa kép"], "Ghi âm": "Có", "Radio": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "6650 mAh", "Loại pin": "Li-Po", "Công nghệ pin": "Tiết kiệm pin", "Hỗ trợ sạc tối đa": "18 W", "Sạc kèm theo máy": "10 W"}}, {"Thông tin chung": {"Chất liệu": "Nhựa nguyên khối", "Kích thước, khối lượng": "Dài 211.58 mm - Ngang 125.48 mm - Dày 8.8 mm - Nặng 375 g", "Thời điểm ra mắt": "08/2024"}}]'::jsonb,
        ARRAY['redmi-pad-se-8-7-4g-blue-1.jpg', 'redmi-pad-se-8-7-4g-blue-2.jpg', 'redmi-pad-se-8-7-4g-blue-3.jpg', 'redmi-pad-se-8-7-4g-blue-4.jpg', 'redmi-pad-se-8-7-4g-blue-5.jpg', 'redmi-pad-se-8-7-4g-blue-6.jpg', 'redmi-pad-se-8-7-4g-blue-7.jpg', 'redmi-pad-se-8-7-4g-blue-8.jpg', 'redmi-pad-se-8-7-4g-blue-9.jpg', 'redmi-pad-se-8-7-4g-blue-10.jpg', 'redmi-pad-se-8-7-4g-blue-11.jpg', 'redmi-pad-se-8-7-4g-blue-12.jpg', 'redmi-pad-se-8-7-tem-99-1.jpg', 'redmi-pad-se-8-7-4g-mohop-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-4.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-5.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-6.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-7.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-8.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-9.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-10.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-11.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-12.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-tem-99-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-mohop-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-1.jpg'
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
        'REDMI_PAD_SE_8_7_4G_4GB_128GB_6GB_XAM',
        'redmi-pad-se-8-7-4g-4gb-128gb-6gb-xam',
        '{"color": "Xám", "memory": "6GB"}'::jsonb,
        575000.0,
        NULL,
        706,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "800 x 1340 Pixels", "Màn hình rộng": "8.7 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 14", "Chip xử lý (CPU)": "MediaTek Helio G85 8 nhân", "Tốc độ CPU": "2 nhân 2.0 GHz & 6 nhân 1.8 GHz", "Chip đồ hoạ (GPU)": "Mali-G52 MC2"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "6 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "109 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 2 TB"}}, {"Camera sau": {"Độ phân giải": "8 MP", "Quay phim": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Tính năng": "Đèn Flash"}}, {"Camera trước": {"Độ phân giải": "5 MP", "Tính năng": ["Quay video HD", "Quay video Full HD"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 4G", "SIM": "2 Nano SIM", "Thực hiện cuộc gọi": "Có nghe gọi", "Wifi": "Wi-Fi 802.11 a/b/g/n/ac", "GPS": ["GPS", "GLONASS", "GALILEO", "BDS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "3.5 mm"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Mở khóa bằng khuôn mặt", "Loa kép"], "Ghi âm": "Có", "Radio": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "6650 mAh", "Loại pin": "Li-Po", "Công nghệ pin": "Tiết kiệm pin", "Hỗ trợ sạc tối đa": "18 W", "Sạc kèm theo máy": "10 W"}}, {"Thông tin chung": {"Chất liệu": "Nhựa nguyên khối", "Kích thước, khối lượng": "Dài 211.58 mm - Ngang 125.48 mm - Dày 8.8 mm - Nặng 375 g", "Thời điểm ra mắt": "08/2024"}}]'::jsonb,
        ARRAY['redmi-pad-se-8-7-4g-blue-1.jpg', 'redmi-pad-se-8-7-4g-blue-2.jpg', 'redmi-pad-se-8-7-4g-blue-3.jpg', 'redmi-pad-se-8-7-4g-blue-4.jpg', 'redmi-pad-se-8-7-4g-blue-5.jpg', 'redmi-pad-se-8-7-4g-blue-6.jpg', 'redmi-pad-se-8-7-4g-blue-7.jpg', 'redmi-pad-se-8-7-4g-blue-8.jpg', 'redmi-pad-se-8-7-4g-blue-9.jpg', 'redmi-pad-se-8-7-4g-blue-10.jpg', 'redmi-pad-se-8-7-4g-blue-11.jpg', 'redmi-pad-se-8-7-4g-blue-12.jpg', 'redmi-pad-se-8-7-tem-99-1.jpg', 'redmi-pad-se-8-7-4g-mohop-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-4.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-5.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-6.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-7.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-8.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-9.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-10.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-11.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-12.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-tem-99-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-mohop-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-1.jpg'
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
        'REDMI_PAD_SE_8_7_4G_4GB_128GB_4GB_XANH_LA',
        'redmi-pad-se-8-7-4g-4gb-128gb-4gb-xanh-la',
        '{"color": "Xanh lá", "memory": "4GB"}'::jsonb,
        4900000.0,
        NULL,
        898,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "800 x 1340 Pixels", "Màn hình rộng": "8.7 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 14", "Chip xử lý (CPU)": "MediaTek Helio G85 8 nhân", "Tốc độ CPU": "2 nhân 2.0 GHz & 6 nhân 1.8 GHz", "Chip đồ hoạ (GPU)": "Mali-G52 MC2"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "4 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "109 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 2 TB"}}, {"Camera sau": {"Độ phân giải": "8 MP", "Quay phim": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Tính năng": "Đèn Flash"}}, {"Camera trước": {"Độ phân giải": "5 MP", "Tính năng": ["Quay video HD", "Quay video Full HD"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 4G", "SIM": "2 Nano SIM", "Thực hiện cuộc gọi": "Có nghe gọi", "Wifi": "Wi-Fi 802.11 a/b/g/n/ac", "GPS": ["GPS", "GLONASS", "GALILEO", "BDS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "3.5 mm"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Mở khóa bằng khuôn mặt", "Loa kép"], "Ghi âm": "Có", "Radio": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "6650 mAh", "Loại pin": "Li-Po", "Công nghệ pin": "Tiết kiệm pin", "Hỗ trợ sạc tối đa": "18 W", "Sạc kèm theo máy": "10 W"}}, {"Thông tin chung": {"Chất liệu": "Nhựa nguyên khối", "Kích thước, khối lượng": "Dài 211.58 mm - Ngang 125.48 mm - Dày 8.8 mm - Nặng 375 g", "Thời điểm ra mắt": "08/2024"}}]'::jsonb,
        ARRAY['redmi-pad-se-8-7-4g-green-1.jpg', 'redmi-pad-se-8-7-4g-green-2.jpg', 'redmi-pad-se-8-7-4g-green-3.jpg', 'redmi-pad-se-8-7-4g-green-4.jpg', 'redmi-pad-se-8-7-4g-green-5.jpg', 'redmi-pad-se-8-7-4g-green-6.jpg', 'redmi-pad-se-8-7-4g-green-7.jpg', 'redmi-pad-se-8-7-4g-green-8.jpg', 'redmi-pad-se-8-7-4g-green-9.jpg', 'redmi-pad-se-8-7-4g-green-10.jpg', 'redmi-pad-se-8-7-4g-green-11.jpg', 'redmi-pad-se-8-7-4g-green-12.jpg', 'redmi-pad-se-8-7-tem-99.jpg', 'redmi-pad-se-8-7-4g-mohop-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-green-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-green-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-green-4.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-green-5.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-green-6.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-green-7.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-green-8.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-green-9.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-green-10.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-green-11.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-green-12.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-tem-99.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-mohop-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-green-1.jpg'
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
        'REDMI_PAD_SE_8_7_4G_4GB_128GB_4GB_XANH_DUONG',
        'redmi-pad-se-8-7-4g-4gb-128gb-4gb-xanh-duong',
        '{"color": "Xanh Dương", "memory": "4GB"}'::jsonb,
        4900000.0,
        NULL,
        223,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "800 x 1340 Pixels", "Màn hình rộng": "8.7 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 14", "Chip xử lý (CPU)": "MediaTek Helio G85 8 nhân", "Tốc độ CPU": "2 nhân 2.0 GHz & 6 nhân 1.8 GHz", "Chip đồ hoạ (GPU)": "Mali-G52 MC2"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "4 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "109 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 2 TB"}}, {"Camera sau": {"Độ phân giải": "8 MP", "Quay phim": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Tính năng": "Đèn Flash"}}, {"Camera trước": {"Độ phân giải": "5 MP", "Tính năng": ["Quay video HD", "Quay video Full HD"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 4G", "SIM": "2 Nano SIM", "Thực hiện cuộc gọi": "Có nghe gọi", "Wifi": "Wi-Fi 802.11 a/b/g/n/ac", "GPS": ["GPS", "GLONASS", "GALILEO", "BDS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "3.5 mm"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Mở khóa bằng khuôn mặt", "Loa kép"], "Ghi âm": "Có", "Radio": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "6650 mAh", "Loại pin": "Li-Po", "Công nghệ pin": "Tiết kiệm pin", "Hỗ trợ sạc tối đa": "18 W", "Sạc kèm theo máy": "10 W"}}, {"Thông tin chung": {"Chất liệu": "Nhựa nguyên khối", "Kích thước, khối lượng": "Dài 211.58 mm - Ngang 125.48 mm - Dày 8.8 mm - Nặng 375 g", "Thời điểm ra mắt": "08/2024"}}]'::jsonb,
        ARRAY['redmi-pad-se-8-7-4g-blue-1.jpg', 'redmi-pad-se-8-7-4g-blue-2.jpg', 'redmi-pad-se-8-7-4g-blue-3.jpg', 'redmi-pad-se-8-7-4g-blue-4.jpg', 'redmi-pad-se-8-7-4g-blue-5.jpg', 'redmi-pad-se-8-7-4g-blue-6.jpg', 'redmi-pad-se-8-7-4g-blue-7.jpg', 'redmi-pad-se-8-7-4g-blue-8.jpg', 'redmi-pad-se-8-7-4g-blue-9.jpg', 'redmi-pad-se-8-7-4g-blue-10.jpg', 'redmi-pad-se-8-7-4g-blue-11.jpg', 'redmi-pad-se-8-7-4g-blue-12.jpg', 'redmi-pad-se-8-7-tem-99-1.jpg', 'redmi-pad-se-8-7-4g-mohop-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-4.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-5.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-6.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-7.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-8.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-9.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-10.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-11.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-12.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-tem-99-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-mohop-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-blue-1.jpg'
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
        'REDMI_PAD_SE_8_7_4G_4GB_128GB_4GB_XAM',
        'redmi-pad-se-8-7-4g-4gb-128gb-4gb-xam',
        '{"color": "Xám", "memory": "4GB"}'::jsonb,
        4900000.0,
        NULL,
        526,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "800 x 1340 Pixels", "Màn hình rộng": "8.7 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 14", "Chip xử lý (CPU)": "MediaTek Helio G85 8 nhân", "Tốc độ CPU": "2 nhân 2.0 GHz & 6 nhân 1.8 GHz", "Chip đồ hoạ (GPU)": "Mali-G52 MC2"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "4 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "109 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 2 TB"}}, {"Camera sau": {"Độ phân giải": "8 MP", "Quay phim": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Tính năng": "Đèn Flash"}}, {"Camera trước": {"Độ phân giải": "5 MP", "Tính năng": ["Quay video HD", "Quay video Full HD"]}}, {"Kết nối": {"Mạng di động": "Hỗ trợ 4G", "SIM": "2 Nano SIM", "Thực hiện cuộc gọi": "Có nghe gọi", "Wifi": "Wi-Fi 802.11 a/b/g/n/ac", "GPS": ["GPS", "GLONASS", "GALILEO", "BDS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "3.5 mm"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Âm thanh Dolby Atmos", "Mở khóa bằng khuôn mặt", "Loa kép"], "Ghi âm": "Có", "Radio": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "6650 mAh", "Loại pin": "Li-Po", "Công nghệ pin": "Tiết kiệm pin", "Hỗ trợ sạc tối đa": "18 W", "Sạc kèm theo máy": "10 W"}}, {"Thông tin chung": {"Chất liệu": "Nhựa nguyên khối", "Kích thước, khối lượng": "Dài 211.58 mm - Ngang 125.48 mm - Dày 8.8 mm - Nặng 375 g", "Thời điểm ra mắt": "08/2024"}}]'::jsonb,
        ARRAY['redmi-pad-se-8-7-4g-grey-1.jpg', 'redmi-pad-se-8-7-4g-grey-2.jpg', 'redmi-pad-se-8-7-4g-grey-3.jpg', 'redmi-pad-se-8-7-4g-grey-4.jpg', 'redmi-pad-se-8-7-4g-grey-5.jpg', 'redmi-pad-se-8-7-4g-grey-6.jpg', 'redmi-pad-se-8-7-4g-grey-7.jpg', 'redmi-pad-se-8-7-4g-grey-8.jpg', 'redmi-pad-se-8-7-4g-grey-9.jpg', 'redmi-pad-se-8-7-4g-grey-10.jpg', 'redmi-pad-se-8-7-4g-grey-11.jpg', 'redmi-pad-se-8-7-4g-grey-12.jpg', 'redmi-pad-se-8-7-tem-99-2.jpg', 'redmi-pad-se-8-7-4g-mohop-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-grey-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-grey-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-grey-4.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-grey-5.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-grey-6.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-grey-7.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-grey-8.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-grey-9.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-grey-10.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-grey-11.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-grey-12.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-tem-99-2.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-mohop-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/redmi-pad-se-8-7-4g-4gb-128gb/redmi-pad-se-8-7-4g-grey-1.jpg'
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

-- Product: Máy tính bảng Samsung Galaxy Tab A9+ 5G 4GB/64GB
-- Slug: samsung-galaxy-tab-a9-plus-5g
-- Variants: 3

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Samsung';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Máy tính bảng';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Máy tính bảng Samsung Galaxy Tab A9+ 5G 4GB/64GB',
        'samsung-galaxy-tab-a9-plus-5g',
        v_brand_id,
        v_category_id,
        'Với giá cả phải chăng, Samsung Galaxy Tab A9+ 5G là một sản phẩm máy tính bảng của Samsung dành cho người dùng muốn sở hữu một thiết bị giải trí cơ bản với màn hình rộng và khả năng kết nối mạng toàn diện để truy cập internet bất kỳ lúc nào và ở bất kỳ đâu.',
        '{"meta_title": "Samsung Galaxy Tab A9+ 5G giá tốt, bảo hành 1 năm chính hãng", "meta_description": "Mua máy tính bảng Samsung Galaxy Tab A9+ (Plus) 5G 4GB/64GB chính hãng, giá rẻ, bảo hành 1 năm, hư gì đổi nấy 12 tháng, trả chậm 0% lãi suất. Mua ngay!", "meta_keywords": "Mua máy tính bảng Samsung Galaxy Tab A9+ (Plus) 5G 4GB/64GB chính hãng, giá rẻ, bảo hành 1 năm, hư gì đổi nấy 12 tháng, trả chậm 0% lãi suất. Mua ngay!"}'::jsonb,
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
        'SAMSUNG_GALAXY_TAB_A9_PLUS_5G_BAC',
        'samsung-galaxy-tab-a9-plus-5g-bac',
        '{"color": "Bạc"}'::jsonb,
        7360000.0,
        NULL,
        96,
        '[{"Màn hình": {"Công nghệ màn hình": "TFT LCD", "Độ phân giải": "1200 x 1920 Pixels", "Màn hình rộng": "11 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 13", "Chip xử lý (CPU)": "Snapdragon 695", "Tốc độ CPU": "2.2 GHz", "Chip đồ hoạ (GPU)": "Adreno 619"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "4 GB", "Dung lượng lưu trữ": "64 GB", "Dung lượng còn lại (khả dụng) khoảng": "45 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 1 TB"}}, {"Camera sau": {"Độ phân giải": "8 MP", "Quay phim": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Tính năng": ["Bộ lọc màu", "Ánh sáng yếu (Chụp đêm)", "Zoom kỹ thuật số", "Xóa phông", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Quét tài liệu", "Quét mã QR", "Làm đẹp", "HDR", "Chụp hẹn giờ", "Chuyên nghiệp (Pro)", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "5 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Xóa phông", "Quay video HD", "Quay video Full HD", "Làm đẹp", "Hẹn giờ chụp", "HDR", "Góc rộng", "Flash màn hình", "Bộ lọc màu", "Chụp ban đêm"]}}, {"Kết nối": {"Mạng di động": "5G", "SIM": "1 Nano SIM", "Thực hiện cuộc gọi": "Có nghe gọi", "Wifi": "Wi-Fi Direct", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BDS"], "Bluetooth": "v5.1", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "3.5 mm"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Ứng dụng kép (Dual Messenger)", "Đa cửa sổ", "Âm thanh Dolby Atmos", "Samsung DeX (Giao diện tương tự PC)", "Mở khóa bằng khuôn mặt", "Kết nối bàn phím rời", "Không gian thứ hai (Thư mục bảo mật)", "Chế độ trẻ em (Samsung Kids)", "Chạm 2 lần tắt/mở màn hình", "4 loa"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "7040 mAh", "Loại pin": "Li-Ion", "Công nghệ pin": "Tiết kiệm pin", "Hỗ trợ sạc tối đa": "15 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 257.1 mm - Ngang 168.7 mm - Dày 6.9 mm - Nặng 491 g", "Thời điểm ra mắt": "10/2023"}}]'::jsonb,
        ARRAY['samsung-galaxy-tab-a9-plus-bac-1-1.jpg', 'samsung-galaxy-tab-a9-plus-bac-2-1.jpg', 'samsung-galaxy-a9-plus-bac-3-1.jpg', 'sansung-galaxy-tab-a9-plus-bac-13.jpg', 'samsung-galaxy-tab-a9-plus-bbh-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-bac-2-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-a9-plus-bac-3-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/sansung-galaxy-tab-a9-plus-bac-13.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-bbh-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-bac-1-1.jpg'
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
        'SAMSUNG_GALAXY_TAB_A9_PLUS_5G_XAM',
        'samsung-galaxy-tab-a9-plus-5g-xam',
        '{"color": "Xám"}'::jsonb,
        7360000.0,
        NULL,
        977,
        '[{"Màn hình": {"Công nghệ màn hình": "TFT LCD", "Độ phân giải": "1200 x 1920 Pixels", "Màn hình rộng": "11 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 13", "Chip xử lý (CPU)": "Snapdragon 695", "Tốc độ CPU": "2.2 GHz", "Chip đồ hoạ (GPU)": "Adreno 619"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "4 GB", "Dung lượng lưu trữ": "64 GB", "Dung lượng còn lại (khả dụng) khoảng": "45 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 1 TB"}}, {"Camera sau": {"Độ phân giải": "8 MP", "Quay phim": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Tính năng": ["Bộ lọc màu", "Ánh sáng yếu (Chụp đêm)", "Zoom kỹ thuật số", "Xóa phông", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Quét tài liệu", "Quét mã QR", "Làm đẹp", "HDR", "Chụp hẹn giờ", "Chuyên nghiệp (Pro)", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "5 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Xóa phông", "Quay video HD", "Quay video Full HD", "Làm đẹp", "Hẹn giờ chụp", "HDR", "Góc rộng", "Flash màn hình", "Bộ lọc màu", "Chụp ban đêm"]}}, {"Kết nối": {"Mạng di động": "5G", "SIM": "1 Nano SIM", "Thực hiện cuộc gọi": "Có nghe gọi", "Wifi": "Wi-Fi Direct", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BDS"], "Bluetooth": "v5.1", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "3.5 mm"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Ứng dụng kép (Dual Messenger)", "Đa cửa sổ", "Âm thanh Dolby Atmos", "Samsung DeX (Giao diện tương tự PC)", "Mở khóa bằng khuôn mặt", "Kết nối bàn phím rời", "Không gian thứ hai (Thư mục bảo mật)", "Chế độ trẻ em (Samsung Kids)", "Chạm 2 lần tắt/mở màn hình", "4 loa"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "7040 mAh", "Loại pin": "Li-Ion", "Công nghệ pin": "Tiết kiệm pin", "Hỗ trợ sạc tối đa": "15 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 257.1 mm - Ngang 168.7 mm - Dày 6.9 mm - Nặng 491 g", "Thời điểm ra mắt": "10/2023"}}]'::jsonb,
        ARRAY['samsung-galaxy-tab-a9-plus-xam-1-2.jpg', 'sansung-galaxy-tab-a9-plus-xam-1-1.jpg', 'sansung-galaxy-tab-a9-plus-xam-2-1.jpg', 'sansung-galaxy-tab-a9-plus-xam-3-1.jpg', 'sansung-galaxy-tab-a9-plus-xam-4-1.jpg', 'sansung-galaxy-tab-a9-plus-xam-5-1.jpg', 'sansung-galaxy-tab-a9-plus-xam-6-1.jpg', 'sansung-galaxy-tab-a9-plus-xam-7-1.jpg', 'sansung-galaxy-tab-a9-plus-xam-8-1.jpg', 'sansung-galaxy-tab-a9-plus-xam-9-1.jpg', 'sansung-galaxy-tab-a9-plus-xam-10-1.jpg', 'sansung-galaxy-tab-a9-plus-xam-11-1.jpg', 'sansung-galaxy-tab-a9-plus-xam-12-1.jpg', 'sansung-galaxy-tab-a9-plus-xam-13-1.jpg', 'samsung-galaxy-tab-a9-plus-bbh-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/sansung-galaxy-tab-a9-plus-xam-1-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/sansung-galaxy-tab-a9-plus-xam-2-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/sansung-galaxy-tab-a9-plus-xam-3-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/sansung-galaxy-tab-a9-plus-xam-4-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/sansung-galaxy-tab-a9-plus-xam-5-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/sansung-galaxy-tab-a9-plus-xam-6-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/sansung-galaxy-tab-a9-plus-xam-7-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/sansung-galaxy-tab-a9-plus-xam-8-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/sansung-galaxy-tab-a9-plus-xam-9-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/sansung-galaxy-tab-a9-plus-xam-10-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/sansung-galaxy-tab-a9-plus-xam-11-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/sansung-galaxy-tab-a9-plus-xam-12-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/sansung-galaxy-tab-a9-plus-xam-13-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-bbh-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-xam-1-2.jpg'
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
        'SAMSUNG_GALAXY_TAB_A9_PLUS_5G_XANH_DUONG_DAM',
        'samsung-galaxy-tab-a9-plus-5g-xanh-duong-dam',
        '{"color": "Xanh dương đậm"}'::jsonb,
        7360000.0,
        NULL,
        848,
        '[{"Màn hình": {"Công nghệ màn hình": "TFT LCD", "Độ phân giải": "1200 x 1920 Pixels", "Màn hình rộng": "11 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 13", "Chip xử lý (CPU)": "Snapdragon 695", "Tốc độ CPU": "2.2 GHz", "Chip đồ hoạ (GPU)": "Adreno 619"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "4 GB", "Dung lượng lưu trữ": "64 GB", "Dung lượng còn lại (khả dụng) khoảng": "45 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 1 TB"}}, {"Camera sau": {"Độ phân giải": "8 MP", "Quay phim": ["HD 720p@30fps", "FullHD 1080p@30fps"], "Tính năng": ["Bộ lọc màu", "Ánh sáng yếu (Chụp đêm)", "Zoom kỹ thuật số", "Xóa phông", "Tua nhanh thời gian (Time‑lapse)", "Toàn cảnh (Panorama)", "Quét tài liệu", "Quét mã QR", "Làm đẹp", "HDR", "Chụp hẹn giờ", "Chuyên nghiệp (Pro)", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "5 MP", "Tính năng": ["Trôi nhanh thời gian (Time Lapse)", "Xóa phông", "Quay video HD", "Quay video Full HD", "Làm đẹp", "Hẹn giờ chụp", "HDR", "Góc rộng", "Flash màn hình", "Bộ lọc màu", "Chụp ban đêm"]}}, {"Kết nối": {"Mạng di động": "5G", "SIM": "1 Nano SIM", "Thực hiện cuộc gọi": "Có nghe gọi", "Wifi": "Wi-Fi Direct", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BDS"], "Bluetooth": "v5.1", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "3.5 mm"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Ứng dụng kép (Dual Messenger)", "Đa cửa sổ", "Âm thanh Dolby Atmos", "Samsung DeX (Giao diện tương tự PC)", "Mở khóa bằng khuôn mặt", "Kết nối bàn phím rời", "Không gian thứ hai (Thư mục bảo mật)", "Chế độ trẻ em (Samsung Kids)", "Chạm 2 lần tắt/mở màn hình", "4 loa"], "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "7040 mAh", "Loại pin": "Li-Ion", "Công nghệ pin": "Tiết kiệm pin", "Hỗ trợ sạc tối đa": "15 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 257.1 mm - Ngang 168.7 mm - Dày 6.9 mm - Nặng 491 g", "Thời điểm ra mắt": "10/2023"}}]'::jsonb,
        ARRAY['samsung-galaxy-tab-a9-plus-xanh-1-1.jpg', 'samsung-galaxy-tab-a9-plus-xanh-2-1.jpg', 'samsung-galaxy-tab-a9-plus-xanh-3.jpg', 'samsung-galaxy-tab-a9-plus-xanh-4.jpg', 'samsung-galaxy-tab-a9-plus-xanh-5.jpg', 'samsung-galaxy-tab-a9-plus-xanh-6.jpg', 'samsung-galaxy-tab-a9-plus-xanh-7.jpg', 'samsung-galaxy-tab-a9-plus-xanh-8.jpg', 'samsung-galaxy-tab-a9-plus-xanh-9.jpg', 'samsung-galaxy-tab-a9-plus-xanh-11.jpg', 'samsung-galaxy-tab-a9-plus-xanh-12.jpg', 'sansung-galaxy-tab-a9-plus-xanh-13.jpg', 'samsung-galaxy-tab-a9-plus-bbh-org.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-xanh-2-1.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-xanh-3.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-xanh-4.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-xanh-5.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-xanh-6.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-xanh-7.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-xanh-8.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-xanh-9.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-xanh-11.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-xanh-12.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/sansung-galaxy-tab-a9-plus-xanh-13.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-bbh-org.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-a9-plus-5g/samsung-galaxy-tab-a9-plus-xanh-1-1.jpg'
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

-- Product: Máy tính bảng Samsung Galaxy Tab S10 FE+ WiFi 8GB/128GB
-- Slug: samsung-galaxy-tab-s10-fe-plus
-- Variants: 6

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Samsung';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Máy tính bảng';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Máy tính bảng Samsung Galaxy Tab S10 FE+ WiFi 8GB/128GB',
        'samsung-galaxy-tab-s10-fe-plus',
        v_brand_id,
        v_category_id,
        'Mở rộng giới hạn trải nghiệm công nghệ cùng Samsung Galaxy Tab S10 FE Plus , chiếc tablet tầm trung cao cấp mang đến sức mạnh vượt mong đợi. Được thiết kế để hỗ trợ từ công việc đến giải trí, sản phẩm là lựa chọn hoàn hảo cho học sinh, sinh viên, dân văn phòng hay người yêu công nghệ hiện đại.',
        '{"meta_title": "Samsung Galaxy Tab S10 FE Plus chính hãng, bảo hành 1 năm", "meta_description": "Samsung Galaxy Tab S10 FE Plus 8GB/128GB chính hãng, giá tốt, tặng bảo hành mở rộng 12 tháng, giảm ngay 1 triệu, hư gì đổi nấy 12 tháng, bảo hành 1 năm. Mua ngay!", "meta_keywords": "Samsung Galaxy Tab S10 FE+, Galaxy Tab S10 FE+, Samsung Tab S10 FE+, Tab S10 FE+, Samsung Galaxy Tab S10, Galaxy Tab S10, Tab S10, S10, Galaxy Tab S 10, S 10, tabs10, tab s10fe+, Tablet S10, Máy tính bảng Android, Samsung Galaxy Tab S10 FE+ WiFi 8GB/128GB, s10 fe+ 5G, s10fe+ 5g, galaxy tab s10 fe+, tab s10 fe+"}'::jsonb,
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
        'SAMSUNG_GALAXY_TAB_S10_FE_PLUS_128GB_XAM',
        'samsung-galaxy-tab-s10-fe-plus-128gb-xam',
        '{"color": "Xám", "storage": "128GB"}'::jsonb,
        15700000.0,
        NULL,
        49,
        '[{"Màn hình": {"Công nghệ màn hình": "TFT LCD", "Độ phân giải": "1800 x 2880 Pixels", "Màn hình rộng": "13.1 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Exynos 1580 8 nhân", "Tốc độ CPU": "2.9 GHz", "Chip đồ hoạ (GPU)": "Xclipse 540"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "106.2 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 2 TB"}}, {"Camera sau": {"Độ phân giải": "13 MP", "Quay phim": "4K 2160p@30fps", "Tính năng": ["Bộ lọc màu", "Zoom kỹ thuật số", "Xóa phông", "Quét tài liệu", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Xóa phông", "Làm đẹp", "Bộ lọc màu"]}}, {"Kết nối": {"Wifi": "Wi-Fi Direct", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BDS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Xoá vật thể AI", "Trợ lý Google Gemini", "Trợ giúp viết tay AI", "Khuôn mặt đẹp nhất AI", "Khoanh tròn để tìm kiếm với Google", "Giải toán AI", "Biên tập video thông minh", "AI Key", "Đa cửa sổ", "Âm thanh AKG", "Vision Booster", "Samsung DeX (Giao diện tương tự PC)", "Mở khóa bằng vân tay", "Kết nối bút S Pen", "Kết nối bàn phím rời"], "Kháng nước, bụi": "IP68", "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "10090 mAh", "Loại pin": "Li-Ion", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "45 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 300.6 mm - Ngang 194.7 mm - Dày 6 mm - Nặng 664 g", "Thời điểm ra mắt": "04/2025"}}]'::jsonb,
        ARRAY['samsung-galaxy-tab-s10-fe-plus-gray-1-638844716187937058.jpg', 'samsung-galaxy-tab-s10-fe-plus-gray-2-638844716194280493.jpg', 'samsung-galaxy-tab-s10-fe-plus-gray-3-638844716200249285.jpg', 'samsung-galaxy-tab-s10-fe-plus-gray-4-638844716206493505.jpg', 'samsung-galaxy-tab-s10-fe-plus-tem-99-638863580023005270.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-gray-2-638844716194280493.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-gray-3-638844716200249285.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-gray-4-638844716206493505.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-tem-99-638863580023005270.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-gray-1-638844716187937058.jpg'
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
        'SAMSUNG_GALAXY_TAB_S10_FE_PLUS_128GB_XANH_DUONG',
        'samsung-galaxy-tab-s10-fe-plus-128gb-xanh-duong',
        '{"color": "Xanh Dương", "storage": "128GB"}'::jsonb,
        15700000.0,
        NULL,
        436,
        '[{"Màn hình": {"Công nghệ màn hình": "TFT LCD", "Độ phân giải": "1800 x 2880 Pixels", "Màn hình rộng": "13.1 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Exynos 1580 8 nhân", "Tốc độ CPU": "2.9 GHz", "Chip đồ hoạ (GPU)": "Xclipse 540"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "106.2 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 2 TB"}}, {"Camera sau": {"Độ phân giải": "13 MP", "Quay phim": "4K 2160p@30fps", "Tính năng": ["Bộ lọc màu", "Zoom kỹ thuật số", "Xóa phông", "Quét tài liệu", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Xóa phông", "Làm đẹp", "Bộ lọc màu"]}}, {"Kết nối": {"Wifi": "Wi-Fi Direct", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BDS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Xoá vật thể AI", "Trợ lý Google Gemini", "Trợ giúp viết tay AI", "Khuôn mặt đẹp nhất AI", "Khoanh tròn để tìm kiếm với Google", "Giải toán AI", "Biên tập video thông minh", "AI Key", "Đa cửa sổ", "Âm thanh AKG", "Vision Booster", "Samsung DeX (Giao diện tương tự PC)", "Mở khóa bằng vân tay", "Kết nối bút S Pen", "Kết nối bàn phím rời"], "Kháng nước, bụi": "IP68", "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "10090 mAh", "Loại pin": "Li-Ion", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "45 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 300.6 mm - Ngang 194.7 mm - Dày 6 mm - Nặng 664 g", "Thời điểm ra mắt": "04/2025"}}]'::jsonb,
        ARRAY['samsung-galaxy-tab-s10-fe-plus-blue-1-638844713760079274.jpg', 'samsung-galaxy-tab-s10-fe-plus-blue-2-638844713769880061.jpg', 'samsung-galaxy-tab-s10-fe-plus-blue-3-638844713775305662.jpg', 'samsung-galaxy-tab-s10-fe-plus-blue-4-638844713780968362.jpg', 'samsung-galaxy-tab-s10-fe-plus-tem-99-638863580112481922.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-blue-2-638844713769880061.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-blue-3-638844713775305662.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-blue-4-638844713780968362.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-tem-99-638863580112481922.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-blue-1-638844713760079274.jpg'
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
        'SAMSUNG_GALAXY_TAB_S10_FE_PLUS_128GB_BAC',
        'samsung-galaxy-tab-s10-fe-plus-128gb-bac',
        '{"color": "Bạc", "storage": "128GB"}'::jsonb,
        15700000.0,
        NULL,
        879,
        '[{"Màn hình": {"Công nghệ màn hình": "TFT LCD", "Độ phân giải": "1800 x 2880 Pixels", "Màn hình rộng": "13.1 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Exynos 1580 8 nhân", "Tốc độ CPU": "2.9 GHz", "Chip đồ hoạ (GPU)": "Xclipse 540"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "106.2 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 2 TB"}}, {"Camera sau": {"Độ phân giải": "13 MP", "Quay phim": "4K 2160p@30fps", "Tính năng": ["Bộ lọc màu", "Zoom kỹ thuật số", "Xóa phông", "Quét tài liệu", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Xóa phông", "Làm đẹp", "Bộ lọc màu"]}}, {"Kết nối": {"Wifi": "Wi-Fi Direct", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BDS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Xoá vật thể AI", "Trợ lý Google Gemini", "Trợ giúp viết tay AI", "Khuôn mặt đẹp nhất AI", "Khoanh tròn để tìm kiếm với Google", "Giải toán AI", "Biên tập video thông minh", "AI Key", "Đa cửa sổ", "Âm thanh AKG", "Vision Booster", "Samsung DeX (Giao diện tương tự PC)", "Mở khóa bằng vân tay", "Kết nối bút S Pen", "Kết nối bàn phím rời"], "Kháng nước, bụi": "IP68", "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "10090 mAh", "Loại pin": "Li-Ion", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "45 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 300.6 mm - Ngang 194.7 mm - Dày 6 mm - Nặng 664 g", "Thời điểm ra mắt": "04/2025"}}]'::jsonb,
        ARRAY['samsung-galaxy-tab-s10-fe-plus-silver-1-638844713880449008.jpg', 'samsung-galaxy-tab-s10-fe-plus-silver-2-638844713886893048.jpg', 'samsung-galaxy-tab-s10-fe-plus-silver-3-638844713895436114.jpg', 'samsung-galaxy-tab-s10-fe-plus-silver-4-638844713902834909.jpg', 'samsung-galaxy-tab-s10-fe-plus-tem-99-638863580207661628.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-silver-2-638844713886893048.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-silver-3-638844713895436114.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-silver-4-638844713902834909.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-tem-99-638863580207661628.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-silver-1-638844713880449008.jpg'
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
        'SAMSUNG_GALAXY_TAB_S10_FE_PLUS_256GB_XAM',
        'samsung-galaxy-tab-s10-fe-plus-256gb-xam',
        '{"color": "Xám", "storage": "256GB"}'::jsonb,
        17590000.0,
        17670000.0,
        801,
        '[{"Màn hình": {"Công nghệ màn hình": "TFT LCD", "Độ phân giải": "1800 x 2880 Pixels", "Màn hình rộng": "13.1 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Exynos 1580 8 nhân", "Tốc độ CPU": "2.9 GHz", "Chip đồ hoạ (GPU)": "Xclipse 540"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "12 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "234 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 2 TB"}}, {"Camera sau": {"Độ phân giải": "13 MP", "Quay phim": "4K 2160p@30fps", "Tính năng": ["Bộ lọc màu", "Zoom kỹ thuật số", "Xóa phông", "Quét tài liệu", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Xóa phông", "Làm đẹp", "Bộ lọc màu"]}}, {"Kết nối": {"Wifi": "Wi-Fi Direct", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BDS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Xoá vật thể AI", "Trợ lý Google Gemini", "Trợ giúp viết tay AI", "Khuôn mặt đẹp nhất AI", "Khoanh tròn để tìm kiếm với Google", "Giải toán AI", "Biên tập video thông minh", "AI Key", "Đa cửa sổ", "Âm thanh AKG", "Vision Booster", "Samsung DeX (Giao diện tương tự PC)", "Mở khóa bằng vân tay", "Kết nối bút S Pen", "Kết nối bàn phím rời"], "Kháng nước, bụi": "IP68", "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "10090 mAh", "Loại pin": "Li-Ion", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "45 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 300.6 mm - Ngang 194.7 mm - Dày 6 mm - Nặng 664 g", "Thời điểm ra mắt": "04/2025"}}]'::jsonb,
        ARRAY['samsung-galaxy-tab-s10-fe-xam-1-638856713052930477.jpg', 'samsung-galaxy-tab-s10-fe-xam-2-638856713059293244.jpg', 'samsung-galaxy-tab-s10-fe-xam-3-638856713066894442.jpg', 'samsung-galaxy-tab-s10-fe-xam-4-638856713074402580.jpg', 'samsung-galaxy-tab-s10-fe-xam-5-638856713081550643.jpg', 'samsung-galaxy-tab-s10-fe-xam-6-638856713092124651.jpg', 'samsung-galaxy-tab-s10-fe-xam-7-638856713098865057.jpg', 'samsung-galaxy-tab-s10-fe-xam-8-638856713108705872.jpg', 'samsung-galaxy-tab-s10-fe-xam-9-638856713117948057.jpg', 'samsung-galaxy-tab-s10-fe-xam-10-638856713128316007.jpg', 'samsung-galaxy-tab-s10-fe-xam-11-638856713138080430.jpg', 'samsung-galaxy-tab-s10-fe-xam-12-638856713148141944.jpg', 'samsung-galaxy-tab-s10-fe-xam-13-638856713155356319.jpg', 'samsung-galaxy-tab-s10-fe-xam-14-638856713163341717.jpg', 'samsung-galaxy-tab-s10-fe-plus-tem-99-638863581573924480.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-2-638856713059293244.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-3-638856713066894442.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-4-638856713074402580.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-5-638856713081550643.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-6-638856713092124651.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-7-638856713098865057.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-8-638856713108705872.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-9-638856713117948057.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-10-638856713128316007.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-11-638856713138080430.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-12-638856713148141944.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-13-638856713155356319.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-14-638856713163341717.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-tem-99-638863581573924480.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-1-638856713052930477.jpg'
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
        'SAMSUNG_GALAXY_TAB_S10_FE_PLUS_256GB_XANH_DUONG',
        'samsung-galaxy-tab-s10-fe-plus-256gb-xanh-duong',
        '{"color": "Xanh Dương", "storage": "256GB"}'::jsonb,
        17590000.0,
        17670000.0,
        412,
        '[{"Màn hình": {"Công nghệ màn hình": "TFT LCD", "Độ phân giải": "1800 x 2880 Pixels", "Màn hình rộng": "13.1 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Exynos 1580 8 nhân", "Tốc độ CPU": "2.9 GHz", "Chip đồ hoạ (GPU)": "Xclipse 540"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "12 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "234 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 2 TB"}}, {"Camera sau": {"Độ phân giải": "13 MP", "Quay phim": "4K 2160p@30fps", "Tính năng": ["Bộ lọc màu", "Zoom kỹ thuật số", "Xóa phông", "Quét tài liệu", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Xóa phông", "Làm đẹp", "Bộ lọc màu"]}}, {"Kết nối": {"Wifi": "Wi-Fi Direct", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BDS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Xoá vật thể AI", "Trợ lý Google Gemini", "Trợ giúp viết tay AI", "Khuôn mặt đẹp nhất AI", "Khoanh tròn để tìm kiếm với Google", "Giải toán AI", "Biên tập video thông minh", "AI Key", "Đa cửa sổ", "Âm thanh AKG", "Vision Booster", "Samsung DeX (Giao diện tương tự PC)", "Mở khóa bằng vân tay", "Kết nối bút S Pen", "Kết nối bàn phím rời"], "Kháng nước, bụi": "IP68", "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "10090 mAh", "Loại pin": "Li-Ion", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "45 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 300.6 mm - Ngang 194.7 mm - Dày 6 mm - Nặng 664 g", "Thời điểm ra mắt": "04/2025"}}]'::jsonb,
        ARRAY['samsung-galaxy-tab-s10-fe-xam-1-638856713052930477.jpg', 'samsung-galaxy-tab-s10-fe-xam-2-638856713059293244.jpg', 'samsung-galaxy-tab-s10-fe-xam-3-638856713066894442.jpg', 'samsung-galaxy-tab-s10-fe-xam-4-638856713074402580.jpg', 'samsung-galaxy-tab-s10-fe-xam-5-638856713081550643.jpg', 'samsung-galaxy-tab-s10-fe-xam-6-638856713092124651.jpg', 'samsung-galaxy-tab-s10-fe-xam-7-638856713098865057.jpg', 'samsung-galaxy-tab-s10-fe-xam-8-638856713108705872.jpg', 'samsung-galaxy-tab-s10-fe-xam-9-638856713117948057.jpg', 'samsung-galaxy-tab-s10-fe-xam-10-638856713128316007.jpg', 'samsung-galaxy-tab-s10-fe-xam-11-638856713138080430.jpg', 'samsung-galaxy-tab-s10-fe-xam-12-638856713148141944.jpg', 'samsung-galaxy-tab-s10-fe-xam-13-638856713155356319.jpg', 'samsung-galaxy-tab-s10-fe-xam-14-638856713163341717.jpg', 'samsung-galaxy-tab-s10-fe-plus-tem-99-638863581573924480.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-2-638856713059293244.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-3-638856713066894442.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-4-638856713074402580.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-5-638856713081550643.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-6-638856713092124651.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-7-638856713098865057.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-8-638856713108705872.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-9-638856713117948057.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-10-638856713128316007.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-11-638856713138080430.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-12-638856713148141944.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-13-638856713155356319.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-14-638856713163341717.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-tem-99-638863581573924480.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-1-638856713052930477.jpg'
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
        'SAMSUNG_GALAXY_TAB_S10_FE_PLUS_256GB_BAC',
        'samsung-galaxy-tab-s10-fe-plus-256gb-bac',
        '{"color": "Bạc", "storage": "256GB"}'::jsonb,
        17590000.0,
        17670000.0,
        358,
        '[{"Màn hình": {"Công nghệ màn hình": "TFT LCD", "Độ phân giải": "1800 x 2880 Pixels", "Màn hình rộng": "13.1 inch - Tần số quét 90 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Android 15", "Chip xử lý (CPU)": "Exynos 1580 8 nhân", "Tốc độ CPU": "2.9 GHz", "Chip đồ hoạ (GPU)": "Xclipse 540"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "12 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "234 GB", "Thẻ nhớ ngoài": "Micro SD, hỗ trợ tối đa 2 TB"}}, {"Camera sau": {"Độ phân giải": "13 MP", "Quay phim": "4K 2160p@30fps", "Tính năng": ["Bộ lọc màu", "Zoom kỹ thuật số", "Xóa phông", "Quét tài liệu", "Tự động lấy nét"]}}, {"Camera trước": {"Độ phân giải": "12 MP", "Tính năng": ["Xóa phông", "Làm đẹp", "Bộ lọc màu"]}}, {"Kết nối": {"Wifi": "Wi-Fi Direct", "GPS": ["QZSS", "GPS", "GLONASS", "GALILEO", "BDS"], "Bluetooth": "v5.3", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Tính năng đặc biệt": ["Xoá vật thể AI", "Trợ lý Google Gemini", "Trợ giúp viết tay AI", "Khuôn mặt đẹp nhất AI", "Khoanh tròn để tìm kiếm với Google", "Giải toán AI", "Biên tập video thông minh", "AI Key", "Đa cửa sổ", "Âm thanh AKG", "Vision Booster", "Samsung DeX (Giao diện tương tự PC)", "Mở khóa bằng vân tay", "Kết nối bút S Pen", "Kết nối bàn phím rời"], "Kháng nước, bụi": "IP68", "Ghi âm": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "10090 mAh", "Loại pin": "Li-Ion", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "45 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 300.6 mm - Ngang 194.7 mm - Dày 6 mm - Nặng 664 g", "Thời điểm ra mắt": "04/2025"}}]'::jsonb,
        ARRAY['samsung-galaxy-tab-s10-fe-xam-1-638856713052930477.jpg', 'samsung-galaxy-tab-s10-fe-xam-2-638856713059293244.jpg', 'samsung-galaxy-tab-s10-fe-xam-3-638856713066894442.jpg', 'samsung-galaxy-tab-s10-fe-xam-4-638856713074402580.jpg', 'samsung-galaxy-tab-s10-fe-xam-5-638856713081550643.jpg', 'samsung-galaxy-tab-s10-fe-xam-6-638856713092124651.jpg', 'samsung-galaxy-tab-s10-fe-xam-7-638856713098865057.jpg', 'samsung-galaxy-tab-s10-fe-xam-8-638856713108705872.jpg', 'samsung-galaxy-tab-s10-fe-xam-9-638856713117948057.jpg', 'samsung-galaxy-tab-s10-fe-xam-10-638856713128316007.jpg', 'samsung-galaxy-tab-s10-fe-xam-11-638856713138080430.jpg', 'samsung-galaxy-tab-s10-fe-xam-12-638856713148141944.jpg', 'samsung-galaxy-tab-s10-fe-xam-13-638856713155356319.jpg', 'samsung-galaxy-tab-s10-fe-xam-14-638856713163341717.jpg', 'samsung-galaxy-tab-s10-fe-plus-tem-99-638863581573924480.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-2-638856713059293244.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-3-638856713066894442.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-4-638856713074402580.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-5-638856713081550643.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-6-638856713092124651.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-7-638856713098865057.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-8-638856713108705872.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-9-638856713117948057.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-10-638856713128316007.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-11-638856713138080430.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-12-638856713148141944.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-13-638856713155356319.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-14-638856713163341717.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-plus-tem-99-638863581573924480.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-tab-s10-fe-plus/samsung-galaxy-tab-s10-fe-xam-1-638856713052930477.jpg'
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

-- Product: Samsung Galaxy Watch Ultra LTE 47mm (2025) dây silicone
-- Slug: samsung-galaxy-watch-ultra-2025
-- Variants: 4

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Samsung';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Đồng hồ thông minh';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Samsung Galaxy Watch Ultra LTE 47mm (2025) dây silicone',
        'samsung-galaxy-watch-ultra-2025',
        v_brand_id,
        v_category_id,
        'Dù không phải một phiên bản hoàn toàn mới, Samsung Galaxy Watch Ultra 2025 vẫn tạo dấu ấn mạnh mẽ nhờ những tinh chỉnh đáng giá về tính năng, khả năng xử lý và trải nghiệm người dùng. Đây là chiếc đồng hồ lý tưởng dành cho các tín đồ đam mê vận động, yêu thích công nghệ và mong muốn sở hữu thiết bị đeo tay toàn diện cả về thẩm mỹ lẫn hiệu năng.',
        '{"meta_title": "Samsung Galaxy Watch Ultra 2025 ưu đãi 3Tr, mua 1 đổi 1", "meta_description": "Đồng hồ Galaxy Watch Ultra 2025 phong cách thể thao hạng nặng, tặng phiếu mua sim 250K, thu cũ đổi mới thêm 850K, hoàn tiền 200K khi mở thẻ tín dụng, góp 0%.", "meta_keywords": "Đồng hồ Galaxy Watch Ultra 2025 phong cách thể thao hạng nặng, tặng phiếu mua sim 250K, thu cũ đổi mới thêm 850K, hoàn tiền 200K khi mở thẻ tín dụng, góp 0%."}'::jsonb,
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
        'SAMSUNG_GALAXY_WATCH_ULTRA_2025_XANH_DUONG_DAM',
        'samsung-galaxy-watch-ultra-2025-xanh-duong-dam',
        '{"color": "Xanh dương đậm"}'::jsonb,
        11790000.0,
        NULL,
        997,
        '[{"Màn hình": {"Công nghệ màn hình": "Super AMOLED", "Kích thước màn hình": "1.47 inch", "Độ phân giải": "480 x 480 pixels", "Kích thước mặt": "47 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Kính Sapphire", "Chất liệu khung viền": "Titanium", "Chất liệu dây": "Silicone", "Độ rộng dây": "2.4 cm", "Chu vi cổ tay phù hợp": "Hãng không công bố", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 47.4 mm - Ngang 47.4 mm - Dày 12.1 mm - Nặng 60.5 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Nhảy dây", "Chạy bộ", "Bơi lội", "Đạp xe"], "Sim": "eSIM", "Hỗ trợ nghe gọi": "Nghe gọi độc lập", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe", "4G/LTE"], "Chống nước / Kháng nước": "Chống nước 10 ATM (Bơi, lặn vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ (chỉ hỗ trợ khi kết nối với điện thoại Samsung)", "Đo nồng độ oxy (SpO2)", "Đo huyết áp (chỉ hỗ trợ khi kết nối với điện thoại Samsung)", "Đo Sức ép lên mạch máu", "Đo Chỉ số chống oxy hóa", "Theo dõi chỉ số AGEs", "Phân tích thành phần cơ thể", "Phân tích môi trường ngủ (Environment Monitor)", "Phát hiện chứng ngưng thở khi ngủ", "Hướng dẫn trước khi đi ngủ (Bedtime Guidance)", "Chấm điểm giấc ngủ", "Huấn luyện viên giấc ngủ (Sleep Coaching)", "Cá nhân hoá vùng nhịp tim (Personalized HR Zone)", "Tính quãng đường chạy", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi mức độ stress", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tìm đồng hồ", "Màn hình cảm ứng", "Chứng nhận độ bền MIL-STD-810H", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Trả lời nhanh tin nhắn có sẵn", "Thay mặt đồng hồ", "Dự báo thời tiết", "Báo thức", "Điểm số năng lượng", "Tính năng Cấp độ chạy (Running Level Analysis)", "Trợ lý sống khỏe (Wellness Tips)", "Thiết lập tuyến đường trở về (Track Back)", "Thiết lập mục tiêu lộ trình (Route Target)", "Thao tác liên ứng dụng bằng lời nói", "Quản lý tiến độ tập luyện (Race)", "Nhắc nhở uống thuốc", "Khóa dưới nước", "Gợi ý trả lời tin nhắn bằng AI", "Gợi ý trả lời tin nhắn", "Double Pinch (Chụm 2 lần)", "Chỉ số phân tích chạy bộ nâng cao (Advanced Running Metrics)", "Ví điện tử Samsung Wallet", "Loa và mic tích hợp", "Tiêu chuẩn IP68"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 80 giờ (Khi tắt Always-On-Display)", "Khoảng 100 giờ (ở chế độ tiết kiệm pin)"], "Thời gian sạc": "Khoảng 1.6 giờ", "Dung lượng pin": "590 mAh", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Exynos W1000", "Bộ nhớ trong": "64 GB", "Hệ điều hành": "Wear OS được tùy biến bởi Samsung", "Kết nối được với hệ điều hành": "Android 12 trở lên dùng Google Mobile Service", "Ứng dụng quản lý": ["Galaxy Wearable", "Samsung Health"], "Kết nối": ["Bluetooth v5.3", "NFC", "Wifi"], "Cảm biến": ["Cảm biến ánh sáng môi trường", "Samsung BioActive thế hệ 2 (Cảm biến 3 trong 1)", "Khí áp kế", "Cảm biến nhiệt độ hồng ngoại", "Cảm biến địa từ", "Con quay hồi chuyển", "Gia tốc kế"], "Định vị": ["Beidou", "GLONASS", "GPS", "Băng tần kép (L1 và L5)", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Việt Nam", "Thời gian ra mắt": "07/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh", "Tiếng Trung"]}}]'::jsonb,
        ARRAY['galaxy-watch-ultra-2025-xanh-1-638878289244792947.jpg', 'galaxy-watch-ultra-2025-xanh-2-638878289251333179.jpg', 'galaxy-watch-ultra-2025-xanh-3-638878289257737363.jpg', 'galaxy-watch-ultra-2025-xanh-4-638878289263389942.jpg', 'galaxy-watch-ultra-2025-xanh-5-638878289269556298.jpg', 'galaxy-watch-ultra-2025-tem-638878289274754917.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-xanh-2-638878289251333179.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-xanh-3-638878289257737363.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-xanh-4-638878289263389942.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-xanh-5-638878289269556298.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-tem-638878289274754917.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-xanh-1-638878289244792947.jpg'
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
        'SAMSUNG_GALAXY_WATCH_ULTRA_2025_DEN',
        'samsung-galaxy-watch-ultra-2025-den',
        '{"color": "Đen"}'::jsonb,
        11790000.0,
        NULL,
        699,
        '[{"Màn hình": {"Công nghệ màn hình": "Super AMOLED", "Kích thước màn hình": "1.47 inch", "Độ phân giải": "480 x 480 pixels", "Kích thước mặt": "47 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Kính Sapphire", "Chất liệu khung viền": "Titanium", "Chất liệu dây": "Silicone", "Độ rộng dây": "2.4 cm", "Chu vi cổ tay phù hợp": "Hãng không công bố", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 47.4 mm - Ngang 47.4 mm - Dày 12.1 mm - Nặng 60.5 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Nhảy dây", "Chạy bộ", "Bơi lội", "Đạp xe"], "Sim": "eSIM", "Hỗ trợ nghe gọi": "Nghe gọi độc lập", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe", "4G/LTE"], "Chống nước / Kháng nước": "Chống nước 10 ATM (Bơi, lặn vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ (chỉ hỗ trợ khi kết nối với điện thoại Samsung)", "Đo nồng độ oxy (SpO2)", "Đo huyết áp (chỉ hỗ trợ khi kết nối với điện thoại Samsung)", "Đo Sức ép lên mạch máu", "Đo Chỉ số chống oxy hóa", "Theo dõi chỉ số AGEs", "Phân tích thành phần cơ thể", "Phân tích môi trường ngủ (Environment Monitor)", "Phát hiện chứng ngưng thở khi ngủ", "Hướng dẫn trước khi đi ngủ (Bedtime Guidance)", "Chấm điểm giấc ngủ", "Huấn luyện viên giấc ngủ (Sleep Coaching)", "Cá nhân hoá vùng nhịp tim (Personalized HR Zone)", "Tính quãng đường chạy", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi mức độ stress", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tìm đồng hồ", "Màn hình cảm ứng", "Chứng nhận độ bền MIL-STD-810H", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Trả lời nhanh tin nhắn có sẵn", "Thay mặt đồng hồ", "Dự báo thời tiết", "Báo thức", "Điểm số năng lượng", "Tính năng Cấp độ chạy (Running Level Analysis)", "Trợ lý sống khỏe (Wellness Tips)", "Thiết lập tuyến đường trở về (Track Back)", "Thiết lập mục tiêu lộ trình (Route Target)", "Thao tác liên ứng dụng bằng lời nói", "Quản lý tiến độ tập luyện (Race)", "Nhắc nhở uống thuốc", "Khóa dưới nước", "Gợi ý trả lời tin nhắn bằng AI", "Gợi ý trả lời tin nhắn", "Double Pinch (Chụm 2 lần)", "Chỉ số phân tích chạy bộ nâng cao (Advanced Running Metrics)", "Ví điện tử Samsung Wallet", "Loa và mic tích hợp", "Tiêu chuẩn IP68"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 80 giờ (Khi tắt Always-On-Display)", "Khoảng 100 giờ (ở chế độ tiết kiệm pin)"], "Thời gian sạc": "Khoảng 1.6 giờ", "Dung lượng pin": "590 mAh", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Exynos W1000", "Bộ nhớ trong": "64 GB", "Hệ điều hành": "Wear OS được tùy biến bởi Samsung", "Kết nối được với hệ điều hành": "Android 12 trở lên dùng Google Mobile Service", "Ứng dụng quản lý": ["Galaxy Wearable", "Samsung Health"], "Kết nối": ["Bluetooth v5.3", "NFC", "Wifi"], "Cảm biến": ["Cảm biến ánh sáng môi trường", "Samsung BioActive thế hệ 2 (Cảm biến 3 trong 1)", "Khí áp kế", "Cảm biến nhiệt độ hồng ngoại", "Cảm biến địa từ", "Con quay hồi chuyển", "Gia tốc kế"], "Định vị": ["Beidou", "GLONASS", "GPS", "Băng tần kép (L1 và L5)", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Việt Nam", "Thời gian ra mắt": "07/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh", "Tiếng Trung"]}}]'::jsonb,
        ARRAY['galaxy-watch-ultra-2025-den-1-638878288869765273.jpg', 'galaxy-watch-ultra-2025-den-2-638878288875860309.jpg', 'galaxy-watch-ultra-2025-den-3-638878288883785527.jpg', 'galaxy-watch-ultra-2025-den-4-638878288889594094.jpg', 'galaxy-watch-ultra-2025-den-5-638878288895321240.jpg', 'galaxy-watch-ultra-2025-den-6-638878288902196819.jpg', 'galaxy-watch-ultra-2025-tem-638878288863150625.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-den-2-638878288875860309.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-den-3-638878288883785527.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-den-4-638878288889594094.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-den-5-638878288895321240.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-den-6-638878288902196819.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-tem-638878288863150625.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-den-1-638878288869765273.jpg'
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
        'SAMSUNG_GALAXY_WATCH_ULTRA_2025_TRANG',
        'samsung-galaxy-watch-ultra-2025-trang',
        '{"color": "Trắng"}'::jsonb,
        11790000.0,
        NULL,
        810,
        '[{"Màn hình": {"Công nghệ màn hình": "Super AMOLED", "Kích thước màn hình": "1.47 inch", "Độ phân giải": "480 x 480 pixels", "Kích thước mặt": "47 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Kính Sapphire", "Chất liệu khung viền": "Titanium", "Chất liệu dây": "Silicone", "Độ rộng dây": "2.4 cm", "Chu vi cổ tay phù hợp": "Hãng không công bố", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 47.4 mm - Ngang 47.4 mm - Dày 12.1 mm - Nặng 60.5 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Nhảy dây", "Chạy bộ", "Bơi lội", "Đạp xe"], "Sim": "eSIM", "Hỗ trợ nghe gọi": "Nghe gọi độc lập", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe", "4G/LTE"], "Chống nước / Kháng nước": "Chống nước 10 ATM (Bơi, lặn vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ (chỉ hỗ trợ khi kết nối với điện thoại Samsung)", "Đo nồng độ oxy (SpO2)", "Đo huyết áp (chỉ hỗ trợ khi kết nối với điện thoại Samsung)", "Đo Sức ép lên mạch máu", "Đo Chỉ số chống oxy hóa", "Theo dõi chỉ số AGEs", "Phân tích thành phần cơ thể", "Phân tích môi trường ngủ (Environment Monitor)", "Phát hiện chứng ngưng thở khi ngủ", "Hướng dẫn trước khi đi ngủ (Bedtime Guidance)", "Chấm điểm giấc ngủ", "Huấn luyện viên giấc ngủ (Sleep Coaching)", "Cá nhân hoá vùng nhịp tim (Personalized HR Zone)", "Tính quãng đường chạy", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi mức độ stress", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tìm đồng hồ", "Màn hình cảm ứng", "Chứng nhận độ bền MIL-STD-810H", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Trả lời nhanh tin nhắn có sẵn", "Thay mặt đồng hồ", "Dự báo thời tiết", "Báo thức", "Điểm số năng lượng", "Tính năng Cấp độ chạy (Running Level Analysis)", "Trợ lý sống khỏe (Wellness Tips)", "Thiết lập tuyến đường trở về (Track Back)", "Thiết lập mục tiêu lộ trình (Route Target)", "Thao tác liên ứng dụng bằng lời nói", "Quản lý tiến độ tập luyện (Race)", "Nhắc nhở uống thuốc", "Khóa dưới nước", "Gợi ý trả lời tin nhắn bằng AI", "Gợi ý trả lời tin nhắn", "Double Pinch (Chụm 2 lần)", "Chỉ số phân tích chạy bộ nâng cao (Advanced Running Metrics)", "Ví điện tử Samsung Wallet", "Loa và mic tích hợp", "Tiêu chuẩn IP68"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 80 giờ (Khi tắt Always-On-Display)", "Khoảng 100 giờ (ở chế độ tiết kiệm pin)"], "Thời gian sạc": "Khoảng 1.6 giờ", "Dung lượng pin": "590 mAh", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Exynos W1000", "Bộ nhớ trong": "64 GB", "Hệ điều hành": "Wear OS được tùy biến bởi Samsung", "Kết nối được với hệ điều hành": "Android 12 trở lên dùng Google Mobile Service", "Ứng dụng quản lý": ["Galaxy Wearable", "Samsung Health"], "Kết nối": ["Bluetooth v5.3", "NFC", "Wifi"], "Cảm biến": ["Cảm biến ánh sáng môi trường", "Samsung BioActive thế hệ 2 (Cảm biến 3 trong 1)", "Khí áp kế", "Cảm biến nhiệt độ hồng ngoại", "Cảm biến địa từ", "Con quay hồi chuyển", "Gia tốc kế"], "Định vị": ["Beidou", "GLONASS", "GPS", "Băng tần kép (L1 và L5)", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Việt Nam", "Thời gian ra mắt": "07/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh", "Tiếng Trung"]}}]'::jsonb,
        ARRAY['galaxy-watch-ultra-2025-trang-1-638878289053076587.jpg', 'galaxy-watch-ultra-2025-trang-2-638878289060012043.jpg', 'galaxy-watch-ultra-2025-trang-3-638878289066846765.jpg', 'galaxy-watch-ultra-2025-trang-4-638878289073448507.jpg', 'galaxy-watch-ultra-2025-trang-5-638878289078944785.jpg', 'galaxy-watch-ultra-2025-trang-6-638878289085319379.jpg', 'galaxy-watch-ultra-2025-tem-638878289045429691.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-trang-2-638878289060012043.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-trang-3-638878289066846765.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-trang-4-638878289073448507.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-trang-5-638878289078944785.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-trang-6-638878289085319379.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-tem-638878289045429691.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-trang-1-638878289053076587.jpg'
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
        'SAMSUNG_GALAXY_WATCH_ULTRA_2025_CAM',
        'samsung-galaxy-watch-ultra-2025-cam',
        '{"color": "Cam"}'::jsonb,
        11790000.0,
        NULL,
        954,
        '[{"Màn hình": {"Công nghệ màn hình": "Super AMOLED", "Kích thước màn hình": "1.47 inch", "Độ phân giải": "480 x 480 pixels", "Kích thước mặt": "47 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Kính Sapphire", "Chất liệu khung viền": "Titanium", "Chất liệu dây": "Silicone", "Độ rộng dây": "2.4 cm", "Chu vi cổ tay phù hợp": "Hãng không công bố", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 47.4 mm - Ngang 47.4 mm - Dày 12.1 mm - Nặng 60.5 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Nhảy dây", "Chạy bộ", "Bơi lội", "Đạp xe"], "Sim": "eSIM", "Hỗ trợ nghe gọi": "Nghe gọi độc lập", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe", "4G/LTE"], "Chống nước / Kháng nước": "Chống nước 10 ATM (Bơi, lặn vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ (chỉ hỗ trợ khi kết nối với điện thoại Samsung)", "Đo nồng độ oxy (SpO2)", "Đo huyết áp (chỉ hỗ trợ khi kết nối với điện thoại Samsung)", "Đo Sức ép lên mạch máu", "Đo Chỉ số chống oxy hóa", "Theo dõi chỉ số AGEs", "Phân tích thành phần cơ thể", "Phân tích môi trường ngủ (Environment Monitor)", "Phát hiện chứng ngưng thở khi ngủ", "Hướng dẫn trước khi đi ngủ (Bedtime Guidance)", "Chấm điểm giấc ngủ", "Huấn luyện viên giấc ngủ (Sleep Coaching)", "Cá nhân hoá vùng nhịp tim (Personalized HR Zone)", "Tính quãng đường chạy", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi mức độ stress", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tìm đồng hồ", "Màn hình cảm ứng", "Chứng nhận độ bền MIL-STD-810H", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Trả lời nhanh tin nhắn có sẵn", "Thay mặt đồng hồ", "Dự báo thời tiết", "Báo thức", "Điểm số năng lượng", "Tính năng Cấp độ chạy (Running Level Analysis)", "Trợ lý sống khỏe (Wellness Tips)", "Thiết lập tuyến đường trở về (Track Back)", "Thiết lập mục tiêu lộ trình (Route Target)", "Thao tác liên ứng dụng bằng lời nói", "Quản lý tiến độ tập luyện (Race)", "Nhắc nhở uống thuốc", "Khóa dưới nước", "Gợi ý trả lời tin nhắn bằng AI", "Gợi ý trả lời tin nhắn", "Double Pinch (Chụm 2 lần)", "Chỉ số phân tích chạy bộ nâng cao (Advanced Running Metrics)", "Ví điện tử Samsung Wallet", "Loa và mic tích hợp", "Tiêu chuẩn IP68"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 80 giờ (Khi tắt Always-On-Display)", "Khoảng 100 giờ (ở chế độ tiết kiệm pin)"], "Thời gian sạc": "Khoảng 1.6 giờ", "Dung lượng pin": "590 mAh", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Exynos W1000", "Bộ nhớ trong": "64 GB", "Hệ điều hành": "Wear OS được tùy biến bởi Samsung", "Kết nối được với hệ điều hành": "Android 12 trở lên dùng Google Mobile Service", "Ứng dụng quản lý": ["Galaxy Wearable", "Samsung Health"], "Kết nối": ["Bluetooth v5.3", "NFC", "Wifi"], "Cảm biến": ["Cảm biến ánh sáng môi trường", "Samsung BioActive thế hệ 2 (Cảm biến 3 trong 1)", "Khí áp kế", "Cảm biến nhiệt độ hồng ngoại", "Cảm biến địa từ", "Con quay hồi chuyển", "Gia tốc kế"], "Định vị": ["Beidou", "GLONASS", "GPS", "Băng tần kép (L1 và L5)", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Việt Nam", "Thời gian ra mắt": "07/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh", "Tiếng Trung"]}}]'::jsonb,
        ARRAY['galaxy-watch-ultra-2025-cam-1-638878288728773287.jpg', 'galaxy-watch-ultra-2025-cam-5-638878288755564429.jpg', 'galaxy-watch-ultra-2025-cam-6-638878288761399972.jpg', 'galaxy-watch-ultra-2025-cam-3-638878288742580215.jpg', 'galaxy-watch-ultra-2025-cam-2-638878288736231180.jpg', 'galaxy-watch-ultra-2025-cam-4-638878288749148611.jpg', 'galaxy-watch-ultra-2025-tem-638878288768086386.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-cam-5-638878288755564429.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-cam-6-638878288761399972.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-cam-3-638878288742580215.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-cam-2-638878288736231180.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-cam-4-638878288749148611.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-tem-638878288768086386.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch-ultra-2025/galaxy-watch-ultra-2025-cam-1-638878288728773287.jpg'
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

-- Product: Samsung Galaxy Watch8 Classic 46mm dây da
-- Slug: samsung-galaxy-watch8-classic
-- Variants: 2

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Samsung';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Đồng hồ thông minh';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Samsung Galaxy Watch8 Classic 46mm dây da',
        'samsung-galaxy-watch8-classic',
        v_brand_id,
        v_category_id,
        'Tại sự kiện Galaxy Unpacked 2025, Samsung chính thức đánh dấu sự trở lại đầy ấn tượng của dòng đồng hồ cao cấp mang phong cách cổ điển với Samsung Galaxy Watch8 Classic . Phiên bản này không chỉ kế thừa thiết kế sang trọng từ những thế hệ trước mà còn được nâng cấp mạnh mẽ về công nghệ, cảm biến sức khỏe và hiệu suất sử dụng. Sở hữu kích thước lớn, mặt xoay bezel vật lý linh hoạt cùng dây da Eco Hybrid cao cấp, đây là biểu tượng hoàn hảo cho người dùng theo đuổi sự đẳng cấp, lịch lãm nhưng vẫn yêu cầu cao về chức năng và hiệu năng sử dụng.',
        '{"meta_title": "Samsung Galaxy Watch 8 Classic thu cũ 650K, trả trước 0đ", "meta_description": "Galaxy Watch 8 Classic trở lại với vòng xoay bezel cùng vi xử lý 3nm siêu mạnh, tặng ngay 2.5Tr khi mua kèm điện thoại, 1 đổi 1 lỗi NSX cả năm, trả góp 0%.", "meta_keywords": "Galaxy Watch 8 Classic trở lại với vòng xoay bezel cùng vi xử lý 3nm siêu mạnh, tặng ngay 2.5Tr khi mua kèm điện thoại, 1 đổi 1 lỗi NSX cả năm, trả góp 0%."}'::jsonb,
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
        'SAMSUNG_GALAXY_WATCH8_CLASSIC_TRANG',
        'samsung-galaxy-watch8-classic-trang',
        '{"color": "Trắng"}'::jsonb,
        8790000.0,
        NULL,
        158,
        '[{"Màn hình": {"Công nghệ màn hình": "Super AMOLED", "Kích thước màn hình": "1.34 inch", "Độ phân giải": "438 x 438 pixels", "Kích thước mặt": "46 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Kính Sapphire", "Chất liệu khung viền": "Thép không gỉ", "Chất liệu dây": "Da hỗn hợp", "Độ rộng dây": "2.45 cm", "Chu vi cổ tay phù hợp": "Hãng không công bố", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 46.5 mm - Ngang 46 mm - Dày 10.6 mm - Nặng 63.5 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Nhảy dây", "Leo núi", "Chạy bộ", "Bơi lội", "Đạp xe"], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe"], "Chống nước / Kháng nước": "Chống nước 5 ATM - ISO 22810:2010 (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ (chỉ hỗ trợ khi kết nối với điện thoại Samsung)", "Đo nồng độ oxy (SpO2)", "Đo huyết áp (chỉ hỗ trợ khi kết nối với điện thoại Samsung)", "Đo Sức ép lên mạch máu", "Đo Chỉ số chống oxy hóa", "Theo dõi chỉ số AGEs", "Phân tích thành phần cơ thể", "Phân tích môi trường ngủ (Environment Monitor)", "Phát hiện chứng ngưng thở khi ngủ", "Hướng dẫn trước khi đi ngủ (Bedtime Guidance)", "Chấm điểm giấc ngủ", "Huấn luyện viên giấc ngủ (Sleep Coaching)", "Cá nhân hoá vùng nhịp tim (Personalized HR Zone)", "Tính quãng đường chạy", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi mức độ stress", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tìm đồng hồ", "Màn hình cảm ứng", "Chứng nhận độ bền MIL-STD-810H", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Trả lời nhanh tin nhắn có sẵn", "Thay mặt đồng hồ", "Dự báo thời tiết", "Báo thức", "Điểm số năng lượng", "Tính năng Cấp độ chạy (Running Level Analysis)", "Trợ lý sống khỏe (Wellness Tips)", "Thao tác liên ứng dụng bằng lời nói", "Quản lý tiến độ tập luyện (Race)", "Nhắc nhở uống thuốc", "Khóa dưới nước", "Gợi ý trả lời tin nhắn bằng AI", "Double Pinch (Chụm 2 lần)", "Chỉ số phân tích chạy bộ nâng cao (Advanced Running Metrics)", "Ví điện tử Samsung Wallet", "Loa và mic tích hợp", "Tiêu chuẩn IP68"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": "Khoảng 40 giờ (Khi tắt Always-On-Display)", "Thời gian sạc": "Khoảng 1.2 giờ", "Dung lượng pin": "445 mAh", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Exynos W1000", "Bộ nhớ trong": "64 GB", "Hệ điều hành": "Wear OS được tùy biến bởi Samsung", "Kết nối được với hệ điều hành": "Android 12 trở lên dùng Google Mobile Service", "Ứng dụng quản lý": ["Samsung Health Monitor", "Galaxy Wearable", "Samsung Health"], "Kết nối": ["Bluetooth v5.3", "NFC", "Wifi"], "Cảm biến": ["Cảm biến ánh sáng môi trường", "Samsung BioActive thế hệ 2 (Cảm biến 3 trong 1)", "Khí áp kế", "Cảm biến nhiệt độ hồng ngoại", "Cảm biến địa từ", "Con quay hồi chuyển", "Gia tốc kế"], "Định vị": ["Beidou", "GLONASS", "GPS", "Băng tần kép (L1 và L5)", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Việt Nam", "Thời gian ra mắt": "07/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh", "Tiếng Trung"]}}]'::jsonb,
        ARRAY['samsung-galaxy-watch8-classic-hc-1-638888811617288837.jpg', 'samsung-galaxy-watch8-classic-hc-2-638888811628233098.jpg', 'samsung-galaxy-watch8-classic-hc-3-638888811635769308.jpg', 'samsung-galaxy-watch8-classic-hc-4-638888811643437834.jpg', 'samsung-galaxy-watch8-classic-hc-5-638888811649374451.jpg', 'samsung-galaxy-watch8-classic-hc-6-638888811657955316.jpg', 'samsung-galaxy-watch8-classic-hc-7-638888811668067405.jpg', 'samsung-galaxy-watch8-classic-hc-8-638888811675069668.jpg', 'samsung-galaxy-watch8-classic-hc-9-638888811681975461.jpg', 'samsung-galaxy-watch8-classic-hc-10-638888811688368651.jpg', 'samsung-galaxy-watch8-classic-hc-11-638888811603426025.jpg', 'samsung-galaxy-watch8-classic-hc-12-638888811610826186.jpg', 'samsung-galaxy-watch8-classic-trang-40-638878304106162920.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-hc-2-638888811628233098.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-hc-3-638888811635769308.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-hc-4-638888811643437834.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-hc-5-638888811649374451.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-hc-6-638888811657955316.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-hc-7-638888811668067405.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-hc-8-638888811675069668.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-hc-9-638888811681975461.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-hc-10-638888811688368651.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-hc-11-638888811603426025.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-hc-12-638888811610826186.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-trang-40-638878304106162920.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-hc-1-638888811617288837.jpg'
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
        'SAMSUNG_GALAXY_WATCH8_CLASSIC_DEN',
        'samsung-galaxy-watch8-classic-den',
        '{"color": "Đen"}'::jsonb,
        8790000.0,
        NULL,
        344,
        '[{"Màn hình": {"Công nghệ màn hình": "Super AMOLED", "Kích thước màn hình": "1.34 inch", "Độ phân giải": "438 x 438 pixels", "Kích thước mặt": "46 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Kính Sapphire", "Chất liệu khung viền": "Thép không gỉ", "Chất liệu dây": "Da hỗn hợp", "Độ rộng dây": "2.45 cm", "Chu vi cổ tay phù hợp": "Hãng không công bố", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 46.5 mm - Ngang 46 mm - Dày 10.6 mm - Nặng 63.5 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Nhảy dây", "Leo núi", "Chạy bộ", "Bơi lội", "Đạp xe"], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe"], "Chống nước / Kháng nước": "Chống nước 5 ATM - ISO 22810:2010 (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ (chỉ hỗ trợ khi kết nối với điện thoại Samsung)", "Đo nồng độ oxy (SpO2)", "Đo huyết áp (chỉ hỗ trợ khi kết nối với điện thoại Samsung)", "Đo Sức ép lên mạch máu", "Đo Chỉ số chống oxy hóa", "Theo dõi chỉ số AGEs", "Phân tích thành phần cơ thể", "Phân tích môi trường ngủ (Environment Monitor)", "Phát hiện chứng ngưng thở khi ngủ", "Hướng dẫn trước khi đi ngủ (Bedtime Guidance)", "Chấm điểm giấc ngủ", "Huấn luyện viên giấc ngủ (Sleep Coaching)", "Cá nhân hoá vùng nhịp tim (Personalized HR Zone)", "Tính quãng đường chạy", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi mức độ stress", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tìm đồng hồ", "Màn hình cảm ứng", "Chứng nhận độ bền MIL-STD-810H", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Trả lời nhanh tin nhắn có sẵn", "Thay mặt đồng hồ", "Dự báo thời tiết", "Báo thức", "Điểm số năng lượng", "Tính năng Cấp độ chạy (Running Level Analysis)", "Trợ lý sống khỏe (Wellness Tips)", "Thao tác liên ứng dụng bằng lời nói", "Quản lý tiến độ tập luyện (Race)", "Nhắc nhở uống thuốc", "Khóa dưới nước", "Gợi ý trả lời tin nhắn bằng AI", "Double Pinch (Chụm 2 lần)", "Chỉ số phân tích chạy bộ nâng cao (Advanced Running Metrics)", "Ví điện tử Samsung Wallet", "Loa và mic tích hợp", "Tiêu chuẩn IP68"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": "Khoảng 40 giờ (Khi tắt Always-On-Display)", "Thời gian sạc": "Khoảng 1.2 giờ", "Dung lượng pin": "445 mAh", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Exynos W1000", "Bộ nhớ trong": "64 GB", "Hệ điều hành": "Wear OS được tùy biến bởi Samsung", "Kết nối được với hệ điều hành": "Android 12 trở lên dùng Google Mobile Service", "Ứng dụng quản lý": ["Samsung Health Monitor", "Galaxy Wearable", "Samsung Health"], "Kết nối": ["Bluetooth v5.3", "NFC", "Wifi"], "Cảm biến": ["Cảm biến ánh sáng môi trường", "Samsung BioActive thế hệ 2 (Cảm biến 3 trong 1)", "Khí áp kế", "Cảm biến nhiệt độ hồng ngoại", "Cảm biến địa từ", "Con quay hồi chuyển", "Gia tốc kế"], "Định vị": ["Beidou", "GLONASS", "GPS", "Băng tần kép (L1 và L5)", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Việt Nam", "Thời gian ra mắt": "07/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh", "Tiếng Trung"]}}]'::jsonb,
        ARRAY['samsung-galaxy-watch8-classic-den-1-638878303089744795.jpg', 'samsung-galaxy-watch8-classic-den-2-638878303120420165.jpg', 'samsung-galaxy-watch8-classic-den-3-638878303115185270.jpg', 'samsung-galaxy-watch8-classic-den-4-638878303108879295.jpg', 'samsung-galaxy-watch8-classic-den-5-638878303102241704.jpg', 'samsung-galaxy-watch8-classic-den-6-638878303096047668.jpg', 'samsung-galaxy-watch8-classic-den-40-638878303271034453.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-den-2-638878303120420165.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-den-3-638878303115185270.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-den-4-638878303108879295.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-den-5-638878303102241704.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-den-6-638878303096047668.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-den-40-638878303271034453.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8-classic/samsung-galaxy-watch8-classic-den-1-638878303089744795.jpg'
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

-- Product: Samsung Galaxy Watch8 40mm dây silicone
-- Slug: samsung-galaxy-watch8
-- Variants: 2

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Samsung';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Đồng hồ thông minh';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Samsung Galaxy Watch8 40mm dây silicone',
        'samsung-galaxy-watch8',
        v_brand_id,
        v_category_id,
        'Tại sự kiện Galaxy Unpacked 2025, Samsung một lần nữa tạo nên cột mốc mới trong ngành thiết bị đeo thông minh với sự ra mắt của Samsung Galaxy Watch 8 . Đây là phiên bản đồng hồ Galaxy mỏng nhất từ trước đến nay, sở hữu thiết kế tinh tế, hiệu năng vượt trội, khả năng theo dõi sức khỏe nâng cấp toàn diện cùng loạt tính năng AI mới mẻ, mang đến trải nghiệm cá nhân hóa và thông minh hơn bao giờ hết. Không đơn thuần là một chiếc đồng hồ, Galaxy Watch 8 chính là người bạn đồng hành lý tưởng cho những ai theo đuổi phong cách sống năng động, khoa học và đẳng cấp.',
        '{"meta_title": "Samsung Galaxy Watch 8 | Mua kèm giảm 2.5Tr, thu cũ 500K", "meta_description": "Mua đồng hồ Galaxy Watch 8 siêu mỏng, màn hình sắc nét, đa năng với Galaxy AI, hoàn tiền 200K khi mở thẻ tín dụng, bảo hiểm 1 đổi 1, lãi 0%, trả trước 0đ.", "meta_keywords": "Mua đồng hồ Galaxy Watch 8 siêu mỏng, màn hình sắc nét, đa năng với Galaxy AI, hoàn tiền 200K khi mở thẻ tín dụng, bảo hiểm 1 đổi 1, lãi 0%, trả trước 0đ."}'::jsonb,
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
        'SAMSUNG_GALAXY_WATCH8_TRANG',
        'samsung-galaxy-watch8-trang',
        '{"color": "Trắng"}'::jsonb,
        6690000.0,
        8990000.0,
        647,
        '[{"Màn hình": {"Công nghệ màn hình": "Super AMOLED", "Kích thước màn hình": "1.34 inch", "Độ phân giải": "438 x 438 pixels", "Kích thước mặt": "40 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Kính Sapphire", "Chất liệu khung viền": "Nhôm nguyên khối", "Chất liệu dây": "Silicone", "Độ rộng dây": "2.69 cm", "Chu vi cổ tay phù hợp": "Hãng không công bố", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 42.7 mm - Ngang 40.4 mm - Dày 8.6 mm - Nặng 30.1 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Nhảy dây", "Leo núi", "Chạy bộ", "Bơi lội", "Đạp xe"], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe"], "Chống nước / Kháng nước": "Chống nước 5 ATM - ISO 22810:2010 (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ (chỉ hỗ trợ khi kết nối với điện thoại Samsung)", "Đo nồng độ oxy (SpO2)", "Đo huyết áp (chỉ hỗ trợ khi kết nối với điện thoại Samsung)", "Đo Sức ép lên mạch máu", "Đo Chỉ số chống oxy hóa", "Theo dõi chỉ số AGEs", "Phân tích thành phần cơ thể", "Phân tích môi trường ngủ (Environment Monitor)", "Phát hiện chứng ngưng thở khi ngủ", "Hướng dẫn trước khi đi ngủ (Bedtime Guidance)", "Chấm điểm giấc ngủ", "Huấn luyện viên giấc ngủ (Sleep Coaching)", "Cá nhân hoá vùng nhịp tim (Personalized HR Zone)", "Tính quãng đường chạy", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi mức độ stress", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tìm đồng hồ", "Màn hình cảm ứng", "Chứng nhận độ bền MIL-STD-810H", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Trả lời nhanh tin nhắn có sẵn", "Thay mặt đồng hồ", "Dự báo thời tiết", "Báo thức", "Điểm số năng lượng", "Tính năng Cấp độ chạy (Running Level Analysis)", "Trợ lý sống khỏe (Wellness Tips)", "Thao tác liên ứng dụng bằng lời nói", "Quản lý tiến độ tập luyện (Race)", "Nhắc nhở uống thuốc", "Khóa dưới nước", "Gợi ý trả lời tin nhắn bằng AI", "Double Pinch (Chụm 2 lần)", "Chỉ số phân tích chạy bộ nâng cao (Advanced Running Metrics)", "Ví điện tử Samsung Wallet", "Loa và mic tích hợp", "Tiêu chuẩn IP68"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": "Khoảng 40 giờ (Khi tắt Always-On-Display)", "Thời gian sạc": "Khoảng 1.1 giờ", "Dung lượng pin": "325 mAh", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Exynos W1000", "Bộ nhớ trong": "32 GB", "Hệ điều hành": "Wear OS được tùy biến bởi Samsung", "Kết nối được với hệ điều hành": "Android 12 trở lên dùng Google Mobile Service", "Ứng dụng quản lý": ["Samsung Health Monitor", "Galaxy Wearable", "Samsung Health"], "Kết nối": ["Bluetooth v5.3", "NFC", "Wifi"], "Cảm biến": ["Cảm biến ánh sáng môi trường", "Samsung BioActive thế hệ 2 (Cảm biến 3 trong 1)", "Khí áp kế", "Cảm biến nhiệt độ hồng ngoại", "Cảm biến địa từ", "Con quay hồi chuyển", "Gia tốc kế"], "Định vị": ["Beidou", "GLONASS", "GPS", "Băng tần kép (L1 và L5)", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Việt Nam", "Thời gian ra mắt": "07/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh", "Tiếng Trung"]}}]'::jsonb,
        ARRAY['samsung-galaxy-watch8-40mm-trang-1-638942238088083930.jpg', 'samsung-galaxy-watch8-40mm-trang-2-638942238094599591.jpg', 'samsung-galaxy-watch8-40mm-trang-3-638942238102435571.jpg', 'samsung-galaxy-watch8-40mm-trang-4-638942238111860657.jpg', 'samsung-galaxy-watch8-40mm-trang-5-638942238119912366.jpg', 'samsung-galaxy-watch8-40mm-trang-6-638942238126378622.jpg', 'samsung-galaxy-watch8-40mm-trang-7-638942238136860353.jpg', 'samsung-galaxy-watch8-40mm-trang-8-638942238143850263.jpg', 'samsung-galaxy-watch8-40mm-trang-9-638942238150504274.jpg', 'samsung-galaxy-watch8-40mm-trang-10-638942238062655990.jpg', 'samsung-galaxy-watch8-40mm-trang-11-638942238072688413.jpg', 'samsung-galaxy-watch8-40mm-trang-12-638942238080311462.jpg', 'samsung-galaxy-watch8-40mm-bac-40-638878309469713076.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-trang-2-638942238094599591.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-trang-3-638942238102435571.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-trang-4-638942238111860657.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-trang-5-638942238119912366.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-trang-6-638942238126378622.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-trang-7-638942238136860353.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-trang-8-638942238143850263.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-trang-9-638942238150504274.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-trang-10-638942238062655990.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-trang-11-638942238072688413.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-trang-12-638942238080311462.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-bac-40-638878309469713076.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-trang-1-638942238088083930.jpg'
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
        'SAMSUNG_GALAXY_WATCH8_DEN',
        'samsung-galaxy-watch8-den',
        '{"color": "Đen"}'::jsonb,
        6690000.0,
        8990000.0,
        644,
        '[{"Màn hình": {"Công nghệ màn hình": "Super AMOLED", "Kích thước màn hình": "1.34 inch", "Độ phân giải": "438 x 438 pixels", "Kích thước mặt": "40 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Kính Sapphire", "Chất liệu khung viền": "Nhôm nguyên khối", "Chất liệu dây": "Silicone", "Độ rộng dây": "2.69 cm", "Chu vi cổ tay phù hợp": "Hãng không công bố", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 42.7 mm - Ngang 40.4 mm - Dày 8.6 mm - Nặng 30.1 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Yoga", "Nhảy dây", "Leo núi", "Chạy bộ", "Bơi lội", "Đạp xe"], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Nghe nhạc", "Kết nối bluetooth với tai nghe"], "Chống nước / Kháng nước": "Chống nước 5 ATM - ISO 22810:2010 (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Điện tâm đồ (chỉ hỗ trợ khi kết nối với điện thoại Samsung)", "Đo nồng độ oxy (SpO2)", "Đo huyết áp (chỉ hỗ trợ khi kết nối với điện thoại Samsung)", "Đo Sức ép lên mạch máu", "Đo Chỉ số chống oxy hóa", "Theo dõi chỉ số AGEs", "Phân tích thành phần cơ thể", "Phân tích môi trường ngủ (Environment Monitor)", "Phát hiện chứng ngưng thở khi ngủ", "Hướng dẫn trước khi đi ngủ (Bedtime Guidance)", "Chấm điểm giấc ngủ", "Huấn luyện viên giấc ngủ (Sleep Coaching)", "Cá nhân hoá vùng nhịp tim (Personalized HR Zone)", "Tính quãng đường chạy", "Tính lượng calories tiêu thụ", "Theo dõi giấc ngủ", "Theo dõi mức độ stress", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở nhịp tim cao, thấp", "Đo nhịp tim", "Đếm số bước chân"], "Tiện ích khác": ["Tìm đồng hồ", "Màn hình cảm ứng", "Chứng nhận độ bền MIL-STD-810H", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Từ chối cuộc gọi", "Tìm điện thoại", "Trả lời nhanh tin nhắn có sẵn", "Thay mặt đồng hồ", "Dự báo thời tiết", "Báo thức", "Điểm số năng lượng", "Tính năng Cấp độ chạy (Running Level Analysis)", "Trợ lý sống khỏe (Wellness Tips)", "Thao tác liên ứng dụng bằng lời nói", "Quản lý tiến độ tập luyện (Race)", "Nhắc nhở uống thuốc", "Khóa dưới nước", "Gợi ý trả lời tin nhắn bằng AI", "Double Pinch (Chụm 2 lần)", "Chỉ số phân tích chạy bộ nâng cao (Advanced Running Metrics)", "Ví điện tử Samsung Wallet", "Loa và mic tích hợp", "Tiêu chuẩn IP68"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": "Khoảng 40 giờ (Khi tắt Always-On-Display)", "Thời gian sạc": "Khoảng 1.1 giờ", "Dung lượng pin": "325 mAh", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Exynos W1000", "Bộ nhớ trong": "32 GB", "Hệ điều hành": "Wear OS được tùy biến bởi Samsung", "Kết nối được với hệ điều hành": "Android 12 trở lên dùng Google Mobile Service", "Ứng dụng quản lý": ["Samsung Health Monitor", "Galaxy Wearable", "Samsung Health"], "Kết nối": ["Bluetooth v5.3", "NFC", "Wifi"], "Cảm biến": ["Cảm biến ánh sáng môi trường", "Samsung BioActive thế hệ 2 (Cảm biến 3 trong 1)", "Khí áp kế", "Cảm biến nhiệt độ hồng ngoại", "Cảm biến địa từ", "Con quay hồi chuyển", "Gia tốc kế"], "Định vị": ["Beidou", "GLONASS", "GPS", "Băng tần kép (L1 và L5)", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Việt Nam", "Thời gian ra mắt": "07/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh", "Tiếng Trung"]}}]'::jsonb,
        ARRAY['samsung-galaxy-watch8-40mm-xam-1-638878309234246240.jpg', 'samsung-galaxy-watch8-40mm-xam-2-638878309228969240.jpg', 'samsung-galaxy-watch8-40mm-xam-3-638878309223253196.jpg', 'samsung-galaxy-watch8-40mm-xam-4-638878309216001688.jpg', 'samsung-galaxy-watch8-40mm-xam-5-638878309251783219.jpg', 'samsung-galaxy-watch8-40mm-xam-6-638878309246263506.jpg', 'samsung-galaxy-watch8-40mm-xam-40-638878309240080891.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-xam-2-638878309228969240.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-xam-3-638878309223253196.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-xam-4-638878309216001688.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-xam-5-638878309251783219.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-xam-6-638878309246263506.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-xam-40-638878309240080891.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/samsung-galaxy-watch8/samsung-galaxy-watch8-40mm-xam-1-638878309234246240.jpg'
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

-- Product: Máy tính bảng Xiaomi Pad 7 WiFi 8GB/256GB
-- Slug: xiaomi-pad-7-8gb-256gb
-- Variants: 6

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Xiaomi';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Máy tính bảng';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Máy tính bảng Xiaomi Pad 7 WiFi 8GB/256GB',
        'xiaomi-pad-7-8gb-256gb',
        v_brand_id,
        v_category_id,
        'Ra mắt vào tháng 3/2025, Xiaomi Pad 7 256GB nhanh chóng trở thành một trong những thiết bị đáng chú ý trên thị trường máy tính bảng. Với thiết kế tối giản, hiệu năng mạnh mẽ nhờ vi xử lý Snapdragon 7+ Gen 3, cùng hàng loạt công nghệ hỗ trợ làm việc và giải trí, sản phẩm này là lựa chọn phù hợp cho nhiều đối tượng.',
        '{"meta_title": "Xiaomi Pad 7 256GB giá rẻ, trả chậm 0% lãi suất, BH 18 tháng", "meta_description": "Máy tính bảng Xiaomi Pad 7 8GB/256GB chính hãng, giá rẻ, giảm ngay 800K, tặng phiếu mua hàng máy lọc nước trị giá 300K, trả chậm 0% lãi suất. Mua ngay!", "meta_keywords": "Máy tính bảng Xiaomi Pad 7 8GB/256GB chính hãng, giá rẻ, giảm ngay 800K, tặng phiếu mua hàng máy lọc nước trị giá 300K, trả chậm 0% lãi suất. Mua ngay!"}'::jsonb,
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
        'XIAOMI_PAD_7_8GB_256GB_256GB_XANH_DUONG',
        'xiaomi-pad-7-8gb-256gb-256gb-xanh-duong',
        '{"color": "Xanh Dương", "storage": "256GB"}'::jsonb,
        11290000.0,
        NULL,
        82,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "2136 x 3200 Pixels", "Màn hình rộng": "11.2 inch - Tần số quét 144 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Xiaomi HyperOS 2", "Chip xử lý (CPU)": "Snapdragon 7+ Gen 3 8 nhân", "Tốc độ CPU": "2.8 GHz", "Chip đồ hoạ (GPU)": "Andreno 732"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB"}}, {"Camera sau": {"Độ phân giải": "13 MP", "Tính năng": "Quét tài liệu"}}, {"Camera trước": {"Độ phân giải": "8 MP", "Tính năng": "Làm đẹp"}}, {"Kết nối": {"Wifi": "Wi-Fi Direct", "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Ghi âm": "Có", "Radio": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "8850 mAh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "45 W", "Sạc kèm theo máy": "45 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 251.22 mm - Ngang 173.42 mm - Dày 6.18 mm - Nặng 500 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['xiaomi-pad-7-xanh-duong-1-638775431461406403.jpg', 'xiaomi-pad-7-xanh-duong-2-638775431468327041.jpg', 'xiaomi-pad-7-xanh-duong-3-638775431473922818.jpg', 'xiaomi-pad-7-xanh-duong-4-638775431479714056.jpg', 'xiaomi-pad-7-xanh-duong-5-638775431485871357.jpg', 'xiaomi-pad-7-xanh-duong-6-638775431495229832.jpg', 'xiaomi-pad-7-xanh-duong-7-638775431503140146.jpg', 'xiaomi-pad-7-xanh-duong-8-638775431512267055.jpg', 'xiaomi-pad-7-xanh-duong-9-638775431518932080.jpg', 'xiaomi-pad-7-xanh-duong-10-638775431524918372.jpg', 'xiaomi-pad-7-xanh-duong-11-638775431530978262.jpg', 'xiaomi-pad-7-xanh-duong-12-638775431536820000.jpg', 'xiaomi-pad-7-tem-99-638775440402213727.jpg', 'xiaomi-pad-7-mohop-638775438745877546.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-duong-2-638775431468327041.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-duong-3-638775431473922818.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-duong-4-638775431479714056.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-duong-5-638775431485871357.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-duong-6-638775431495229832.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-duong-7-638775431503140146.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-duong-8-638775431512267055.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-duong-9-638775431518932080.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-duong-10-638775431524918372.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-duong-11-638775431530978262.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-duong-12-638775431536820000.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-tem-99-638775440402213727.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-mohop-638775438745877546.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-duong-1-638775431461406403.jpg'
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
        'XIAOMI_PAD_7_8GB_256GB_256GB_XANH_LA',
        'xiaomi-pad-7-8gb-256gb-256gb-xanh-la',
        '{"color": "Xanh lá", "storage": "256GB"}'::jsonb,
        11290000.0,
        NULL,
        24,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "2136 x 3200 Pixels", "Màn hình rộng": "11.2 inch - Tần số quét 144 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Xiaomi HyperOS 2", "Chip xử lý (CPU)": "Snapdragon 7+ Gen 3 8 nhân", "Tốc độ CPU": "2.8 GHz", "Chip đồ hoạ (GPU)": "Andreno 732"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB"}}, {"Camera sau": {"Độ phân giải": "13 MP", "Tính năng": "Quét tài liệu"}}, {"Camera trước": {"Độ phân giải": "8 MP", "Tính năng": "Làm đẹp"}}, {"Kết nối": {"Wifi": "Wi-Fi Direct", "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Ghi âm": "Có", "Radio": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "8850 mAh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "45 W", "Sạc kèm theo máy": "45 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 251.22 mm - Ngang 173.42 mm - Dày 6.18 mm - Nặng 500 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['xiaomi-pad-7-xanh-la-1-638775431787010243.jpg', 'xiaomi-pad-7-xanh-la-2-638775431792691959.jpg', 'xiaomi-pad-7-xanh-la-3-638775431798904466.jpg', 'xiaomi-pad-7-xanh-la-4-638775431805212911.jpg', 'xiaomi-pad-7-xanh-la-5-638775431814767207.jpg', 'xiaomi-pad-7-xanh-la-6-638775431823686197.jpg', 'xiaomi-pad-7-xanh-la-7-638775431830166558.jpg', 'xiaomi-pad-7-xanh-la-8-638775431836373891.jpg', 'xiaomi-pad-7-xanh-la-9-638775431842856408.jpg', 'xiaomi-pad-7-xanh-la-10-638775431849394671.jpg', 'xiaomi-pad-7-xanh-la-11-638775431855832177.jpg', 'xiaomi-pad-7-xanh-la-12-638775431862023175.jpg', 'xiaomi-pad-7-tem-99-638775440110828845.jpg', 'xiaomi-pad-7-mohop-638775438745877546.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-2-638775431792691959.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-3-638775431798904466.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-4-638775431805212911.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-5-638775431814767207.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-6-638775431823686197.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-7-638775431830166558.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-8-638775431836373891.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-9-638775431842856408.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-10-638775431849394671.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-11-638775431855832177.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-12-638775431862023175.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-tem-99-638775440110828845.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-mohop-638775438745877546.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-1-638775431787010243.jpg'
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
        'XIAOMI_PAD_7_8GB_256GB_256GB_XAM',
        'xiaomi-pad-7-8gb-256gb-256gb-xam',
        '{"color": "Xám", "storage": "256GB"}'::jsonb,
        11290000.0,
        NULL,
        608,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "2136 x 3200 Pixels", "Màn hình rộng": "11.2 inch - Tần số quét 144 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Xiaomi HyperOS 2", "Chip xử lý (CPU)": "Snapdragon 7+ Gen 3 8 nhân", "Tốc độ CPU": "2.8 GHz", "Chip đồ hoạ (GPU)": "Andreno 732"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "256 GB", "Dung lượng còn lại (khả dụng) khoảng": "241 GB"}}, {"Camera sau": {"Độ phân giải": "13 MP", "Tính năng": "Quét tài liệu"}}, {"Camera trước": {"Độ phân giải": "8 MP", "Tính năng": "Làm đẹp"}}, {"Kết nối": {"Wifi": "Wi-Fi Direct", "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Ghi âm": "Có", "Radio": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "8850 mAh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "45 W", "Sạc kèm theo máy": "45 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 251.22 mm - Ngang 173.42 mm - Dày 6.18 mm - Nặng 500 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['xiaomi-pad-7-xam-1-638775430772452367.jpg', 'xiaomi-pad-7-xam-2-638775430778679966.jpg', 'xiaomi-pad-7-xam-3-638775430784196506.jpg', 'xiaomi-pad-7-xam-4-638775430789867617.jpg', 'xiaomi-pad-7-xam-5-638775430795928525.jpg', 'xiaomi-pad-7-xam-6-638775430802165114.jpg', 'xiaomi-pad-7-xam-7-638775430807639427.jpg', 'xiaomi-pad-7-xam-8-638775430814261725.jpg', 'xiaomi-pad-7-xam-9-638775430820149727.jpg', 'xiaomi-pad-7-xam-10-638775430826485975.jpg', 'xiaomi-pad-7-xam-11-638775430833102398.jpg', 'xiaomi-pad-7-xam-12-638775430840940477.jpg', 'xiaomi-pad-7-tem-99-638775440929150764.jpg', 'xiaomi-pad-7-mohop-638775438745877546.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xam-2-638775430778679966.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xam-3-638775430784196506.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xam-4-638775430789867617.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xam-5-638775430795928525.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xam-6-638775430802165114.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xam-7-638775430807639427.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xam-8-638775430814261725.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xam-9-638775430820149727.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xam-10-638775430826485975.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xam-11-638775430833102398.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xam-12-638775430840940477.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-tem-99-638775440929150764.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-mohop-638775438745877546.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xam-1-638775430772452367.jpg'
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
        'XIAOMI_PAD_7_8GB_256GB_128GB_XANH_DUONG',
        'xiaomi-pad-7-8gb-256gb-128gb-xanh-duong',
        '{"color": "Xanh Dương", "storage": "128GB"}'::jsonb,
        10300000.0,
        NULL,
        924,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "2136 x 3200 Pixels", "Màn hình rộng": "11.2 inch - Tần số quét 144 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Xiaomi HyperOS 2", "Chip xử lý (CPU)": "Snapdragon 7+ Gen 3 8 nhân", "Tốc độ CPU": "2.8 GHz", "Chip đồ hoạ (GPU)": "Andreno 732"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "113 GB"}}, {"Camera sau": {"Độ phân giải": "13 MP", "Tính năng": "Quét tài liệu"}}, {"Camera trước": {"Độ phân giải": "8 MP", "Tính năng": "Làm đẹp"}}, {"Kết nối": {"Wifi": "Wi-Fi Direct", "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Ghi âm": "Có", "Radio": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "8850 mAh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "45 W", "Sạc kèm theo máy": "45 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 251.22 mm - Ngang 173.42 mm - Dày 6.18 mm - Nặng 500 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['xiaomi-pad-7-xanh-la-1-638775431977738492.jpg', 'xiaomi-pad-7-xanh-la-2-638775431984574368.jpg', 'xiaomi-pad-7-xanh-la-3-638775431991735530.jpg', 'xiaomi-pad-7-xanh-la-4-638775431999404486.jpg', 'xiaomi-pad-7-xanh-la-5-638775432006635570.jpg', 'xiaomi-pad-7-xanh-la-6-638775432012715634.jpg', 'xiaomi-pad-7-xanh-la-7-638775432018835027.jpg', 'xiaomi-pad-7-xanh-la-8-638775432026584283.jpg', 'xiaomi-pad-7-xanh-la-9-638775432032428129.jpg', 'xiaomi-pad-7-xanh-la-10-638775432038610745.jpg', 'xiaomi-pad-7-xanh-la-11-638775432044971091.jpg', 'xiaomi-pad-7-xanh-la-12-638775432053079275.jpg', 'xiaomi-pad-7-tem-99-638775441075208568.jpg', 'xiaomi-pad-7-mohop-638775438904814512.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-2-638775431984574368.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-3-638775431991735530.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-4-638775431999404486.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-5-638775432006635570.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-6-638775432012715634.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-7-638775432018835027.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-8-638775432026584283.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-9-638775432032428129.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-10-638775432038610745.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-11-638775432044971091.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-12-638775432053079275.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-tem-99-638775441075208568.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-mohop-638775438904814512.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-1-638775431977738492.jpg'
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
        'XIAOMI_PAD_7_8GB_256GB_128GB_XANH_LA',
        'xiaomi-pad-7-8gb-256gb-128gb-xanh-la',
        '{"color": "Xanh lá", "storage": "128GB"}'::jsonb,
        10300000.0,
        NULL,
        457,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "2136 x 3200 Pixels", "Màn hình rộng": "11.2 inch - Tần số quét 144 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Xiaomi HyperOS 2", "Chip xử lý (CPU)": "Snapdragon 7+ Gen 3 8 nhân", "Tốc độ CPU": "2.8 GHz", "Chip đồ hoạ (GPU)": "Andreno 732"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "113 GB"}}, {"Camera sau": {"Độ phân giải": "13 MP", "Tính năng": "Quét tài liệu"}}, {"Camera trước": {"Độ phân giải": "8 MP", "Tính năng": "Làm đẹp"}}, {"Kết nối": {"Wifi": "Wi-Fi Direct", "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Ghi âm": "Có", "Radio": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "8850 mAh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "45 W", "Sạc kèm theo máy": "45 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 251.22 mm - Ngang 173.42 mm - Dày 6.18 mm - Nặng 500 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['xiaomi-pad-7-xanh-la-1-638775431977738492.jpg', 'xiaomi-pad-7-xanh-la-2-638775431984574368.jpg', 'xiaomi-pad-7-xanh-la-3-638775431991735530.jpg', 'xiaomi-pad-7-xanh-la-4-638775431999404486.jpg', 'xiaomi-pad-7-xanh-la-5-638775432006635570.jpg', 'xiaomi-pad-7-xanh-la-6-638775432012715634.jpg', 'xiaomi-pad-7-xanh-la-7-638775432018835027.jpg', 'xiaomi-pad-7-xanh-la-8-638775432026584283.jpg', 'xiaomi-pad-7-xanh-la-9-638775432032428129.jpg', 'xiaomi-pad-7-xanh-la-10-638775432038610745.jpg', 'xiaomi-pad-7-xanh-la-11-638775432044971091.jpg', 'xiaomi-pad-7-xanh-la-12-638775432053079275.jpg', 'xiaomi-pad-7-tem-99-638775441075208568.jpg', 'xiaomi-pad-7-mohop-638775438904814512.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-2-638775431984574368.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-3-638775431991735530.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-4-638775431999404486.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-5-638775432006635570.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-6-638775432012715634.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-7-638775432018835027.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-8-638775432026584283.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-9-638775432032428129.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-10-638775432038610745.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-11-638775432044971091.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-12-638775432053079275.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-tem-99-638775441075208568.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-mohop-638775438904814512.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-1-638775431977738492.jpg'
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
        'XIAOMI_PAD_7_8GB_256GB_128GB_XAM',
        'xiaomi-pad-7-8gb-256gb-128gb-xam',
        '{"color": "Xám", "storage": "128GB"}'::jsonb,
        10300000.0,
        NULL,
        61,
        '[{"Màn hình": {"Công nghệ màn hình": "IPS LCD", "Độ phân giải": "2136 x 3200 Pixels", "Màn hình rộng": "11.2 inch - Tần số quét 144 Hz"}}, {"Hệ điều hành & CPU": {"Hệ điều hành": "Xiaomi HyperOS 2", "Chip xử lý (CPU)": "Snapdragon 7+ Gen 3 8 nhân", "Tốc độ CPU": "2.8 GHz", "Chip đồ hoạ (GPU)": "Andreno 732"}}, {"Bộ nhớ &  Lưu trữ": {"RAM": "8 GB", "Dung lượng lưu trữ": "128 GB", "Dung lượng còn lại (khả dụng) khoảng": "113 GB"}}, {"Camera sau": {"Độ phân giải": "13 MP", "Tính năng": "Quét tài liệu"}}, {"Camera trước": {"Độ phân giải": "8 MP", "Tính năng": "Làm đẹp"}}, {"Kết nối": {"Wifi": "Wi-Fi Direct", "Bluetooth": "v5.4", "Cổng kết nối/sạc": "Type-C", "Jack tai nghe": "Type-C"}}, {"Tiện ích": {"Ghi âm": "Có", "Radio": "Có"}}, {"Pin & Sạc": {"Dung lượng pin": "8850 mAh", "Loại pin": "Li-Po", "Công nghệ pin": ["Sạc pin nhanh", "Tiết kiệm pin"], "Hỗ trợ sạc tối đa": "45 W", "Sạc kèm theo máy": "45 W"}}, {"Thông tin chung": {"Chất liệu": "Nhôm nguyên khối", "Kích thước, khối lượng": "Dài 251.22 mm - Ngang 173.42 mm - Dày 6.18 mm - Nặng 500 g", "Thời điểm ra mắt": "03/2025"}}]'::jsonb,
        ARRAY['xiaomi-pad-7-xanh-la-1-638775431977738492.jpg', 'xiaomi-pad-7-xanh-la-2-638775431984574368.jpg', 'xiaomi-pad-7-xanh-la-3-638775431991735530.jpg', 'xiaomi-pad-7-xanh-la-4-638775431999404486.jpg', 'xiaomi-pad-7-xanh-la-5-638775432006635570.jpg', 'xiaomi-pad-7-xanh-la-6-638775432012715634.jpg', 'xiaomi-pad-7-xanh-la-7-638775432018835027.jpg', 'xiaomi-pad-7-xanh-la-8-638775432026584283.jpg', 'xiaomi-pad-7-xanh-la-9-638775432032428129.jpg', 'xiaomi-pad-7-xanh-la-10-638775432038610745.jpg', 'xiaomi-pad-7-xanh-la-11-638775432044971091.jpg', 'xiaomi-pad-7-xanh-la-12-638775432053079275.jpg', 'xiaomi-pad-7-tem-99-638775441075208568.jpg', 'xiaomi-pad-7-mohop-638775438904814512.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-2-638775431984574368.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-3-638775431991735530.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-4-638775431999404486.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-5-638775432006635570.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-6-638775432012715634.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-7-638775432018835027.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-8-638775432026584283.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-9-638775432032428129.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-10-638775432038610745.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-11-638775432044971091.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-12-638775432053079275.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-tem-99-638775441075208568.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-mohop-638775438904814512.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-pad-7-8gb-256gb/xiaomi-pad-7-xanh-la-1-638775431977738492.jpg'
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

-- Product: Xiaomi Watch S4 41mm dây Milanese
-- Slug: xiaomi-watch-s4-41mm-day-milanese
-- Variants: 1

BEGIN;

DO $$
DECLARE
    v_product_id uuid;
    v_variant_id uuid;
    v_brand_id integer;
    v_category_id integer;
BEGIN
    -- Get brand_id from name
    SELECT id INTO v_brand_id FROM brands WHERE name = 'Xiaomi';
    
    -- Get category_id from name
    SELECT id INTO v_category_id FROM categories WHERE name = 'Đồng hồ thông minh';
    
    -- Insert or update product (without default_variant_id yet)
    INSERT INTO products (name, slug, brand_id, category_id, description, meta, default_variant_id)
    VALUES (
        'Xiaomi Watch S4 41mm dây Milanese',
        'xiaomi-watch-s4-41mm-day-milanese',
        v_brand_id,
        v_category_id,
        'Với chiếc Xiaomi Watch S4 41mm dây Milanese , bạn không chỉ có một trợ lý sức khỏe mà còn là một huấn luyện viên thể thao đa năng ngay trên cổ tay. Chiếc đồng hồ này sẽ giúp bạn theo dõi mọi chỉ số, tối ưu hóa quá trình luyện tập và tận hưởng vô vàn tiện ích, để mỗi ngày của bạn trở nên hiệu quả và trọn vẹn hơn.',
        '{"meta_title": "Xiaomi Watch S4 41mm dây Milanese giá rẻ", "meta_description": "Xiaomi Watch S4 41mm dây Milanese chính hãng, giá rẻ. Mua online giao nhanh toàn quốc 1 giờ, xem hàng không mua không sao. Click ngay!", "meta_keywords": "Xiaomi Watch S4 41mm dây Milanese,Đồng hồ thông minh Xiaomi Watch S4 41mm,0232391002772,Đồng hồ thông minh,Đồng hồ thông minh Xiaomi,Xiaomi Watch,Xiaomi Watch S4,Xiaomi Watch S4 41,Xiaomi Watch S4 41mm,Watch S4 41mm dây Milanese,Watch S4,Watch S4 41mm,Đồng hồ thông minh S4"}'::jsonb,
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
        'XIAOMI_WATCH_S4_41MM_DAY_MILANESE_DEFAULT',
        'xiaomi-watch-s4-41mm-day-milanese-default',
        NULL,
        5690000.0,
        5990000.0,
        558,
        '[{"Màn hình": {"Công nghệ màn hình": "AMOLED", "Kích thước màn hình": "1.32 inch", "Độ phân giải": "466 x 466 pixels", "Kích thước mặt": "41 mm"}}, {"Thiết kế": {"Chất liệu mặt": "Kính cường lực", "Chất liệu khung viền": "Thép không gỉ", "Chất liệu dây": "Dây thép Milanese", "Độ rộng dây": "1.8 cm", "Chu vi cổ tay phù hợp": "12 - 19 cm", "Khả năng thay dây": "Có", "Kích thước, khối lượng": "Dài 41 mm - Ngang 41 mm - Dày 9.5 mm - Nặng 32 g"}}, {"Tiện ích": {"Môn thể thao": ["Đi bộ", "Quần vợt", "Yoga", "Nhảy dây", "Cầu lông", "Chạy bộ", "Bơi lội", "Đạp xe", "Bóng đá"], "Hỗ trợ nghe gọi": "Nghe gọi ngay trên đồng hồ", "Tiện ích đặc biệt": ["Màn hình luôn hiển thị", "Phát hiện té ngã", "Kết nối bluetooth với tai nghe"], "Chống nước / Kháng nước": "Chống nước 5 ATM - ISO 22810:2010 (Tắm, bơi vùng nước nông)", "Theo dõi sức khoẻ": ["Đo nồng độ oxy (SpO2)", "Theo dõi nhịp tim 24h", "Theo dõi giấc ngủ", "Theo dõi mức độ stress", "Theo dõi chu kỳ kinh nguyệt", "Nhắc nhở ít vận động", "Đo nhịp tim", "Đếm số bước chân", "Bài tập thở"], "Tiện ích khác": ["Tìm đồng hồ", "Đồng hồ đếm ngược", "Đồng hồ bấm giờ", "Điều khiển chụp ảnh", "Điều khiển chơi nhạc", "Tìm điện thoại", "Dự báo thời tiết", "Báo thức", "Điều khiển không chạm", "Chia sẻ vị trí theo thời gian thực"], "Hiển thị thông báo": ["Line", "Messenger (Facebook)", "Viber", "Zalo", "Tin nhắn", "Cuộc gọi"]}}, {"Pin": {"Thời gian sử dụng pin": ["Khoảng 3 ngày sử dụng thường xuyên (chế độ tiêu chuẩn)", "Khoảng 8 ngày (ở chế độ cơ bản)"], "Thời gian sạc": "Khoảng 2 giờ", "Dung lượng pin": "320 mAh", "Cổng sạc": "Đế sạc nam châm"}}, {"Cấu hình & Kết nối": {"CPU": "Hãng không công bố", "Bộ nhớ trong": "4 GB", "Hệ điều hành": "HyperOS", "Kết nối được với hệ điều hành": ["Android 8.0 trở lên", "iOS 14 trở lên"], "Ứng dụng quản lý": "Mi Fitness", "Kết nối": ["Bluetooth v5.4", "NFC"], "Cảm biến": ["Cảm biến ánh sáng môi trường", "Khí áp kế", "Cảm biến nhiệt độ", "Cảm biến nhịp tim quang học (PPG)", "Con quay hồi chuyển", "Gia tốc kế", "La bàn điện tử"], "Định vị": ["Beidou", "GLONASS", "GPS", "QZSS", "Băng tần kép (L1 và L5)", "Galileo"]}}, {"Thông tin khác": {"Sản xuất tại": "Trung Quốc", "Thời gian ra mắt": "09/2025", "Ngôn ngữ": ["Tiếng Việt", "Tiếng Anh", "Tiếng Trung"]}}]'::jsonb,
        ARRAY['xiaomi-watch-s4-41mm-day-milanese-hc-1-638943915424164997.jpg', 'xiaomi-watch-s4-41mm-day-milanese-hc-2-638943915490346055.jpg', 'xiaomi-watch-s4-41mm-day-milanese-hc-3-638943915518355339.jpg', 'xiaomi-watch-s4-41mm-day-milanese-hc-4-638943915624009104.jpg', 'xiaomi-watch-s4-41mm-day-milanese-hc-5-638943915753011128.jpg', 'xiaomi-watch-s4-41mm-day-milanese-hc-6-638943915894012106.jpg', 'xiaomi-watch-s4-41mm-day-milanese-hc-7-638943916062850030.jpg', 'xiaomi-watch-s4-41mm-day-milanese-hc-8-638943920705305071.jpg', 'xiaomi-watch-s4-41mm-day-milanese-hc-9-638947540521198702.jpg', 'xiaomi-watch-s4-41mm-day-milanese-hc-10-638943918278965465.jpg', 'xiaomi-watch-s4-41mm-day-milanese-hc-11-638943915383248676.jpg', 'xiaomi-watch-s4-41mm-day-milanese-99-638950013738288425.jpg'],
        '["https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-watch-s4-41mm-day-milanese/xiaomi-watch-s4-41mm-day-milanese-hc-2-638943915490346055.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-watch-s4-41mm-day-milanese/xiaomi-watch-s4-41mm-day-milanese-hc-3-638943915518355339.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-watch-s4-41mm-day-milanese/xiaomi-watch-s4-41mm-day-milanese-hc-4-638943915624009104.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-watch-s4-41mm-day-milanese/xiaomi-watch-s4-41mm-day-milanese-hc-5-638943915753011128.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-watch-s4-41mm-day-milanese/xiaomi-watch-s4-41mm-day-milanese-hc-6-638943915894012106.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-watch-s4-41mm-day-milanese/xiaomi-watch-s4-41mm-day-milanese-hc-7-638943916062850030.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-watch-s4-41mm-day-milanese/xiaomi-watch-s4-41mm-day-milanese-hc-8-638943920705305071.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-watch-s4-41mm-day-milanese/xiaomi-watch-s4-41mm-day-milanese-hc-9-638947540521198702.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-watch-s4-41mm-day-milanese/xiaomi-watch-s4-41mm-day-milanese-hc-10-638943918278965465.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-watch-s4-41mm-day-milanese/xiaomi-watch-s4-41mm-day-milanese-hc-11-638943915383248676.jpg", "https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-watch-s4-41mm-day-milanese/xiaomi-watch-s4-41mm-day-milanese-99-638950013738288425.jpg"]'::jsonb,
        'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/product_images/xiaomi-watch-s4-41mm-day-milanese/xiaomi-watch-s4-41mm-day-milanese-hc-1-638943915424164997.jpg'
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
