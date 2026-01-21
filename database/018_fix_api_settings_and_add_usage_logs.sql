-- Migration: Fix API settings key storage and add AI usage logs
-- Date: 2026-01-13
-- Description: 
--   1. Fix security issue where API key was stored in api_settings.key column
--   2. Add ai_usage_logs table for cost monitoring
--   3. Add name column if not exists and ensure proper defaults

-- ============================================================================
-- PART 1: Fix API settings key storage (security fix)
-- ============================================================================

-- Replace any API key-like values in the key column with safe identifiers
UPDATE public.api_settings 
SET key = 'openrouter_article_generation'
WHERE key LIKE 'sk-%' OR key LIKE 'sk-or-%';

-- Ensure the article generation record has correct identifiers
UPDATE public.api_settings 
SET 
  key = 'openrouter_article_generation',
  api_endpoint = 'https://openrouter.ai/api/v1/chat/completions',
  model_name = COALESCE(NULLIF(model_name, ''), 'meta-llama/llama-3.3-70b-instruct:free')
WHERE name = 'article';

-- ============================================================================
-- PART 2: Create AI usage logs table for cost monitoring
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.ai_usage_logs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
  feature text NOT NULL DEFAULT 'article_generation',
  keyword text,
  model_name text,
  tokens_used integer DEFAULT 0,
  prompt_tokens integer DEFAULT 0,
  completion_tokens integer DEFAULT 0,
  estimated_cost numeric(10, 6) DEFAULT 0,
  success boolean DEFAULT true,
  error_message text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT ai_usage_logs_pkey PRIMARY KEY (id)
);

-- Create index for querying by user and date
CREATE INDEX IF NOT EXISTS ai_usage_logs_user_id_idx ON public.ai_usage_logs(user_id);
CREATE INDEX IF NOT EXISTS ai_usage_logs_created_at_idx ON public.ai_usage_logs(created_at);
CREATE INDEX IF NOT EXISTS ai_usage_logs_feature_idx ON public.ai_usage_logs(feature);

-- Add comment
COMMENT ON TABLE public.ai_usage_logs IS 'Logs AI API usage for monitoring and cost control';

-- ============================================================================
-- PART 3: Convert default_prompt to JSONB with structured template
-- ============================================================================

-- Step 1: Add new JSONB column temporarily
ALTER TABLE public.api_settings 
ADD COLUMN IF NOT EXISTS default_prompt_new jsonb;

-- Step 2: Convert existing text prompt to structured JSONB
UPDATE public.api_settings
SET default_prompt_new = jsonb_build_object(
  'title', jsonb_build_object(
    'instruction', 'Tiêu đề bài viết hấp dẫn và SEO-friendly',
    'max_length', 200,
    'format', 'Không dùng ký tự đặc biệt'
  ),
  'description', jsonb_build_object(
    'instruction', 'Nội dung bài viết chi tiết',
    'min_words', 500,
    'structure', jsonb_build_array(
      'Chia thành 3-7 phần với tiêu đề rõ ràng',
      'Mỗi phần có 1 tiêu đề phụ (dùng thẻ <h3>) và 1-3 đoạn văn (dùng thẻ <p>)',
      'Ví dụ format: <h3>Giới thiệu về [chủ đề]</h3><p>Nội dung giới thiệu...</p>',
      'KHÔNG dùng markdown **, ### hoặc ký tự đặc biệt',
      'Nội dung phải logic, dễ đọc, mạch lạc, tự nhiên, đúng chính tả, có giá trị thông tin thực tế, không trùng lặp'
    ),
    'no_markdown', true
  ),
  'tags', jsonb_build_object(
    'instruction', 'Từ khóa liên quan',
    'quantity', '5-8',
    'separator', ',',
    'no_quotes', true
  ),
  'seo_keyword', jsonb_build_object(
    'instruction', 'URL slug thân thiện SEO',
    'format', 'lowercase, a-z, 0-9, hyphens only',
    'max_length', 100,
    'no_diacritics', true,
    'example', 'oi-la-trai-cay-giau-vitamin-c-nhat'
  ),
  'meta_title', jsonb_build_object(
    'instruction', 'Tiêu đề SEO tối ưu',
    'length', '50-60 ký tự',
    'no_duplicate_with_title', true,
    'natural', true
  ),
  'meta_description', jsonb_build_object(
    'instruction', 'Mô tả SEO hấp dẫn',
    'length', '120-150 ký tự',
    'natural', true
  ),
  'meta_keywords', jsonb_build_object(
    'instruction', 'Từ khóa SEO',
    'separator', ',',
    'correct_spelling', true,
    'complete_words', true
  )
)
WHERE name = 'article' AND default_prompt_new IS NULL;

-- Step 3: Drop old TEXT column
ALTER TABLE public.api_settings 
DROP COLUMN IF EXISTS default_prompt;

-- Step 4: Rename new column to default_prompt
ALTER TABLE public.api_settings 
RENAME COLUMN default_prompt_new TO default_prompt;

-- Step 5: Remove default_prompt_jsonb if it exists (cleanup)
ALTER TABLE public.api_settings 
DROP COLUMN IF EXISTS default_prompt_jsonb;

-- Add comment
COMMENT ON COLUMN public.api_settings.default_prompt IS 'JSONB structure for customizable AI prompt template';

-- Step 6: Ensure article settings have the JSONB prompt
INSERT INTO public.api_settings (key, name, api_endpoint, model_name, default_prompt, description)
VALUES (
  'openrouter_article_generation',
  'article',
  'https://openrouter.ai/api/v1/chat/completions',
  'meta-llama/llama-3.3-70b-instruct:free',
  jsonb_build_object(
    'title', jsonb_build_object(
      'instruction', 'Tiêu đề bài viết hấp dẫn và SEO-friendly',
      'max_length', 200,
      'format', 'Không dùng ký tự đặc biệt'
    ),
    'description', jsonb_build_object(
      'instruction', 'Nội dung bài viết chi tiết',
      'min_words', 500,
      'structure', jsonb_build_array(
        'Chia thành 3-7 phần với tiêu đề rõ ràng',
        'Mỗi phần có 1 tiêu đề phụ (dùng thẻ <h3>) và 1-3 đoạn văn (dùng thẻ <p>)',
        'Ví dụ format: <h3>Giới thiệu về [chủ đề]</h3><p>Nội dung giới thiệu...</p>',
        'KHÔNG dùng markdown **, ### hoặc ký tự đặc biệt',
        'Nội dung phải logic, dễ đọc, mạch lạc, tự nhiên, đúng chính tả, có giá trị thông tin thực tế, không trùng lặp'
      ),
      'no_markdown', true
    ),
    'tags', jsonb_build_object(
      'instruction', 'Từ khóa liên quan',
      'quantity', '5-8',
      'separator', ',',
      'no_quotes', true
    ),
    'seo_keyword', jsonb_build_object(
      'instruction', 'URL slug thân thiện SEO',
      'format', 'lowercase, a-z, 0-9, hyphens only',
      'max_length', 100,
      'no_diacritics', true,
      'example', 'oi-la-trai-cay-giau-vitamin-c-nhat'
    ),
    'meta_title', jsonb_build_object(
      'instruction', 'Tiêu đề SEO tối ưu',
      'length', '50-60 ký tự',
      'no_duplicate_with_title', true,
      'natural', true
    ),
    'meta_description', jsonb_build_object(
      'instruction', 'Mô tả SEO hấp dẫn',
      'length', '120-150 ký tự',
      'natural', true
    ),
    'meta_keywords', jsonb_build_object(
      'instruction', 'Từ khóa SEO',
      'separator', ',',
      'correct_spelling', true,
      'complete_words', true
    )
  ),
  'OpenRouter AI settings for article generation with structured JSONB prompt template'
)
ON CONFLICT (key) DO UPDATE SET
  api_endpoint = EXCLUDED.api_endpoint,
  model_name = EXCLUDED.model_name,
  default_prompt = EXCLUDED.default_prompt,
  description = EXCLUDED.description,
  updated_at = now();

-- ============================================================================
-- PART 4: Ensure default api_keys setting exists in admin_settings
-- ============================================================================

-- Insert placeholder for api_keys if not exists (actual key should be set via admin UI)
INSERT INTO public.admin_settings (key, value, description)
VALUES (
  'api_keys',
  '{"openrouter_key": ""}',
  'API keys for external services (OpenRouter, etc.)'
)
ON CONFLICT (key) DO UPDATE SET
  value = CASE 
    WHEN public.admin_settings.value ? 'openrouter_key' THEN public.admin_settings.value
    ELSE public.admin_settings.value || '{"openrouter_key": ""}'::jsonb
  END,
  updated_at = now();
