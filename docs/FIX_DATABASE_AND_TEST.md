# Hướng dẫn Fix Database và Test

## 📋 BƯỚC 1: Fix Database Schema (Chạy trong Supabase SQL Editor)

### 1.1. Migration 019 - Fix default_prompt JSONB

```sql
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
```

### 1.2. Migration 020 - Fix API Key Configuration

```sql
-- Migration: Fix API key configuration
-- Move API key from api_settings.key to admin_settings table

-- Step 1: Extract the API key from api_settings (it's currently in the wrong column)
DO $$
DECLARE
  openrouter_key TEXT;
BEGIN
  -- Get the misplaced API key from api_settings.key column
  SELECT key INTO openrouter_key
  FROM public.api_settings
  WHERE name = 'article'
  AND key LIKE 'sk-or-v1-%';

  IF openrouter_key IS NOT NULL THEN
    -- Insert or update admin_settings with the correct API key
    INSERT INTO public.admin_settings (key, value, description)
    VALUES (
      'api_keys',
      jsonb_build_object('openrouter_key', openrouter_key),
      'API keys for external services (OpenRouter, etc.)'
    )
    ON CONFLICT (key) DO UPDATE SET
      value = jsonb_set(
        COALESCE(admin_settings.value, '{}'::jsonb),
        '{openrouter_key}',
        to_jsonb(openrouter_key)
      ),
      updated_at = now();

    RAISE NOTICE 'Moved API key to admin_settings successfully';
  ELSE
    RAISE NOTICE 'No API key found in api_settings.key column';
  END IF;
END $$;

-- Step 2: Clear the api_settings.key column (it should be a unique identifier, not the API key!)
UPDATE public.api_settings
SET key = 'openai_article_generation'
WHERE name = 'article';

COMMENT ON COLUMN public.api_settings.key IS 'Unique identifier for this API setting (NOT the API key!)';
```

### 1.3. Verify Database After Migration

```sql
-- Check api_settings
SELECT id, key, name, model_name, api_endpoint, 
       jsonb_pretty(default_prompt) as default_prompt_formatted
FROM public.api_settings 
WHERE name = 'article';

-- Check admin_settings for API key
SELECT key, value, description
FROM public.admin_settings
WHERE key = 'api_keys';

-- Verify no default_prompt_jsonb column exists
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'api_settings' AND table_schema = 'public';
```

---

## 📋 BƯỚC 2: Run Unit Tests

```powershell
cd D:\shopin-backend
npm test -- articles.service.spec
```

Expected output: **All 22 tests should pass** ✅

---

## 📋 BƯỚC 3: Test E2E trong Web

### 3.1. Start Backend
```powershell
cd D:\shopin-backend
npm run start:dev
```

### 3.2. Start Frontend
```powershell
cd D:\shopin-frontend
npm run dev
```

### 3.3. Test Flow
1. Login as admin
2. Go to "Quản lý bài viết" → "Tạo bài viết mới"
3. Expand "Tùy chỉnh Prompt AI"
4. Fill in structured fields (Title, Description, Tags, etc.)
5. Enter keyword: "iPhone 15 Pro Max"
6. Click "Tạo nội dung"
7. Verify generated content appears in form fields

---

## 🔧 TROUBLESHOOTING

### Issue: "OpenRouter API key chưa được cấu hình"

**Cause**: API key ở sai bảng hoặc sai column

**Solution**: Run migration 020 above to move API key to `admin_settings`

### Issue: Migration 019 fails with "invalid input syntax for type json"

**Cause**: Empty string `''` cannot be cast to JSONB

**Solution**: Updated migration 019 now handles empty/null values correctly

### Issue: Column `default_prompt_jsonb` still exists

**Cause**: Migration 018 should have dropped it but might have failed

**Solution**: Migration 019 now explicitly drops this column

---

## ✅ EXPECTED FINAL STATE

### `api_settings` table:
```sql
id: 1de23527-7560-456d-acbf-0391b187b83c
key: 'openai_article_generation'  -- Fixed: not the API key!
name: 'article'
model_name: 'meta-llama/llama-3.3-70b-instruct:free'
api_endpoint: 'https://openrouter.ai/api/v1/chat/completions'
default_prompt: {/* JSONB object with title, description, tags, etc. */}
description: 'Cài đặt API cho tính năng tạo bài viết tự động'
```

### `admin_settings` table:
```sql
key: 'api_keys'
value: {
  "openrouter_key": "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"
}
description: 'API keys for external services (OpenRouter, etc.)'
```

### No `default_prompt_jsonb` column exists

---

## 📝 NOTES

1. **API Key Security**: The API key is now properly stored in `admin_settings.value` (JSONB), not in `api_settings.key`
2. **Default Prompt**: Now stored as JSONB structure, not text
3. **Frontend**: Uses structured editor (NOT textarea)
4. **Backend**: Converts JSONB → text for AI prompt
5. **Rate Limiting**: Per-user based on JWT userId
