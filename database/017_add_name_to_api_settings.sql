-- Migration: Add name column to api_settings and update article generation settings
-- Date: 2026-01-07

-- Add name column to api_settings
ALTER TABLE public.api_settings ADD COLUMN IF NOT EXISTS name text;

-- Update existing records to have name values
UPDATE public.api_settings SET name = 'article' WHERE key = 'openai_article_generation';

-- Create unique index on name column
CREATE UNIQUE INDEX IF NOT EXISTS api_settings_name_idx ON public.api_settings(name) WHERE name IS NOT NULL;

-- Insert default article generation settings if not exists
INSERT INTO public.api_settings (key, name, model_name, api_endpoint, default_prompt, description)
VALUES (
  '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',
  'article',
  'meta-llama/llama-3.3-70b-instruct:free',
  'https://openrouter.ai/api/v1/chat/completions',
  'QUAN TRỌNG: Trả lời CHÍNH XÁC theo format sau, không thêm ký tự đặc biệt, KHÔNG sử dụng ** hoặc markdown formatting:

TITLE: Tiêu đề bài viết hấp dẫn và SEO-friendly (tối đa 200 ký tự)
DESCRIPTION: Nội dung bài viết chi tiết, ít nhất 500 từ. CẤU TRÚC BÀI VIẾT:
- Chia thành 3-7 phần với tiêu đề rõ ràng
- Mỗi phần có 1 tiêu đề phụ (dùng thẻ <h3>) và 1-3 đoạn văn (dùng thẻ <p>)
- Ví dụ format: <h3>Giới thiệu về [chủ đề]</h3><p>Nội dung giới thiệu...</p><h3>Lợi ích của [chủ đề]</h3><p>Nội dung về lợi ích...</p>
- KHÔNG dùng markdown **, ### hoặc ký tự đặc biệt
- Nội dung phải logic, dễ đọc, mạch lạc, tự nhiên, đúng chính tả, có giá trị thông tin thực tế, không trùng lặp.
TAGS: 5-8 từ khóa liên quan, cách nhau bằng dấu phẩy, không có dấu ngoặc
SEO_KEYWORD: URL slug thân thiện SEO (ví dụ: tin-tuc-cong-nghe-moi-nhat), chỉ dùng a-z, 0-9, dấu gạch ngang, không dấu, tối đa 100 ký tự
META_TITLE: Tiêu đề SEO tối ưu, dài 50-60 ký tự, tự nhiên, không trùng 100% với TITLE
META_DESCRIPTION: Mô tả SEO 120-150 ký tự, hấp dẫn, tự nhiên
META_KEYWORDS: Từ khóa SEO, cách nhau bằng dấu phẩy, ĐÚNG chính tả, đầy đủ chữ

Yêu cầu:
- Nội dung đầy đủ, không bị cắt giữa chừng
- DESCRIPTION phải có cấu trúc <h3>Tiêu đề</h3><p>Nội dung</p> rõ ràng
- Tất cả field phải có nội dung hoàn chỉnh
- Viết văn phong báo chí tự nhiên, đúng chính tả
- Tập trung cung cấp thông tin hữu ích, phù hợp với từ khóa',
  'Cài đặt API cho tính năng tạo bài viết tự động'
)
ON CONFLICT (key) DO UPDATE SET
  name = EXCLUDED.name,
  model_name = EXCLUDED.model_name,
  api_endpoint = EXCLUDED.api_endpoint,
  default_prompt = EXCLUDED.default_prompt,
  description = EXCLUDED.description;
