-- Migration: Ensure default_prompt in api_settings is JSONB and properly configured

-- Step 1: Remove redundant column if exists
ALTER TABLE public.api_settings
DROP COLUMN IF EXISTS default_prompt_jsonb;

-- Step 2: Update empty/null default_prompt to proper JSONB default
UPDATE public.api_settings
SET default_prompt = '{
  "title": {
    "instruction": "Tiêu đề bài viết hấp dẫn và SEO-friendly",
    "max_length": 200,
    "format": "Không dùng ký tự đặc biệt"
  },
  "description": {
    "instruction": "Nội dung bài viết chi tiết",
    "min_words": 500,
    "structure": [
      "Giới thiệu về chủ đề",
      "Các điểm chính",
      "Lợi ích và ứng dụng",
      "Kết luận"
    ],
    "no_markdown": false
  },
  "tags": {
    "instruction": "Từ khóa liên quan",
    "quantity": "5-8",
    "separator": ",",
    "no_quotes": true
  },
  "seo_keyword": {
    "instruction": "URL slug thân thiện SEO",
    "format": "lowercase, a-z, 0-9, hyphens only",
    "max_length": 100,
    "example": "tin-tuc-cong-nghe-moi-nhat",
    "no_diacritics": true
  },
  "meta_title": {
    "instruction": "Tiêu đề SEO tối ưu",
    "length": "50-60 ký tự",
    "no_duplicate_with_title": true,
    "natural": true
  },
  "meta_description": {
    "instruction": "Mô tả SEO hấp dẫn",
    "length": "120-150 ký tự",
    "natural": true
  },
  "meta_keywords": {
    "instruction": "Từ khóa SEO",
    "separator": ",",
    "correct_spelling": true,
    "complete_words": true
  }
}'::jsonb
WHERE name = 'article' AND (default_prompt IS NULL OR default_prompt::text = '' OR default_prompt::text = '""');

-- Step 3: Ensure column type is JSONB
ALTER TABLE public.api_settings
ALTER COLUMN default_prompt TYPE jsonb USING 
  CASE 
    WHEN default_prompt IS NULL OR default_prompt::text = '' OR default_prompt::text = '""'
    THEN '{}'::jsonb
    ELSE default_prompt::jsonb
  END;

-- Step 4: Add NOT NULL constraint with default
ALTER TABLE public.api_settings
ALTER COLUMN default_prompt SET DEFAULT '{}'::jsonb;

COMMENT ON COLUMN public.api_settings.default_prompt IS 'JSONB structure for customizable AI prompt template';

