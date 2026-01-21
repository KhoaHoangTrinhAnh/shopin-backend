# AI Article Generation Feature - Technical Specification

**Version:** 1.1.0  
**Last Updated:** 2026-01-13  
**Status:** Partially Implemented (UI prompt editor is still legacy textarea)

---

## Overview

Tính năng tự động tạo bài viết tin tức sử dụng AI (OpenRouter) với khả năng tùy chỉnh prompt chi tiết. Hệ thống cho phép người dùng nhập từ khóa và tùy chỉnh cách AI tạo nội dung thông qua các template prompt có cấu trúc.

### Key Features
- ✅ Auto-generate article content từ keyword
- ✅ Prompt template lưu dạng JSONB (structured fields) trong `api_settings.default_prompt`
- ⚠️ UI prompt editor bắt buộc phải chia thành input field riêng (Title / Description / Tags / SEO / Meta...), hiện codebase vẫn đang dùng textarea (legacy)
- ✅ Real-time preview trước khi lưu
- ✅ SEO-optimized output (meta tags, slug, keywords)
- ✅ Cost control với rate limiting
- ✅ Validation & error handling

---

## Codebase Review (2026-01-13)

### Thực trạng hiện tại (đúng theo code)

- Frontend trang tạo bài: `shopin-frontend/src/app/admin/articles/new/page.tsx`
  - Prompt editor đang là **1 textarea** (`customPrompt: string`).
  - Khi load `api_settings.default_prompt` (JSONB), frontend **convert JSONB -> text** (helper `convertPromptJsonbToText`) để đổ vào textarea.

- Frontend trang sửa bài: `shopin-frontend/src/app/admin/articles/[id]/edit/page.tsx`
  - Prompt editor cũng đang là **1 textarea** (`customPrompt: string`).
  - Khi load `default_prompt`, đang **JSON.stringify** (không convert sang format text chuẩn).

- Frontend API client: `shopin-frontend/src/lib/adminApi.ts`
  - `generateArticleContent(keyword, topic, customPrompt?: string)` hiện chỉ nhận **string**.

- Backend generation: `shopin-backend/src/admin/articles.service.ts`
  - Backend đã hỗ trợ **`customPrompt` là string hoặc JSON object**.
  - Nếu nhận JSON object, backend convert JSONB -> text bằng `convertPromptJsonbToText()` rồi ghép với `HARD_PROMPT_PREFIX`.

### Kết luận

- DB/Backend đã theo hướng **structured prompt JSONB**, nhưng UI hiện tại vẫn là **textarea dạng text**.
- Tài liệu phiên bản 1.0.0 mô tả UI đã chia input field là **không khớp codebase**, cần sửa lại để:
  - Nêu rõ “textarea là legacy”,
  - Định nghĩa “UI bắt buộc phải chia field”,
  - Chỉ rõ cần refactor ở những file nào.

---

## Scope

### In Scope
- Generate article từ keyword với AI
- Customizable prompt template (title, content, tags, meta fields)
- Parse AI response theo structured format
- Populate article form fields với AI-generated data
- Validate & save article to database
- Cost monitoring & rate limiting
- Multiple AI providers (OpenRouter)

### Out of Scope
- Batch generation
- Auto-publish (cần user review trước)
- Image generation
- Translation

---

## User Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    USER FLOW DIAGRAM                            │
└─────────────────────────────────────────────────────────────────┘

1. USER ACCESS PAGE
   │
  ├─► Load default prompt template từ DB (api_settings.default_prompt - JSONB)
  │   ├─► (Hiện tại) convert JSONB → text → hiển thị textarea (legacy)
  │   └─► (Mục tiêu bắt buộc) hiển thị prompt dưới dạng input field riêng: TITLE / DESCRIPTION / TAGS / SEO / META...
   │
2. USER INPUT
   │
   ├─► Nhập keyword: "ổi là loại trái cây có nhiều vitamin C nhất"
   ├─► (Optional) Customize prompt template:
   │   ├─► Title format
   │   ├─► Content structure
   │   ├─► Tags format
   │   ├─► Meta fields format
   │   └─► SEO requirements
   │
3. USER CLICK "TẠO NỘI DUNG"
   │
  ├─► Frontend sends: { keyword, topic?, customPrompt }
  │   ├─► (Legacy) customPrompt: string (text prompt)
  │   └─► (Chuẩn) customPrompt: JSON object (structured prompt template)
   │
4. BACKEND PROCESSING
   │
  ├─► Build prompt:
  │   ├─► `HARD_PROMPT_PREFIX` + keyword
  │   ├─► + (customPrompt text) OR (convert customPrompt JSONB → text)
  │   ├─► else: convert `api_settings.default_prompt` (JSONB) → text
  │   └─► + topic context (nếu có)
   │
   ├─► Call API:
   │   ├─► Model: 'model_name' col from api_settings table
   │   ├─► Prompt: structured_prompt
  │   ├─► API Key: `admin_settings[key='api_keys'].value.openrouter_key` hoặc env `OPENROUTER_API_KEY`
   │   └─► Endpoint: 'api_endpoint' col from api_settings table
   │
   ├─► Parse AI Response:
   │   ├─► Extract TITLE
   │   ├─► Extract DESCRIPTION (HTML format)
   │   ├─► Extract TAGS (comma-separated)
   │   ├─► Extract SEO_KEYWORD (slug)
   │   ├─► Extract META_TITLE
   │   ├─► Extract META_DESCRIPTION
   │   └─► Extract META_KEYWORDS
   │
5. FRONTEND DISPLAY
   │
   ├─► Populate form fields:
   │   ├─► Title input ← AI title
   │   ├─► Content editor ← AI content (HTML)
   │   ├─► Tags input ← AI tags
   │   ├─► Slug input ← AI slug
   │   ├─► Meta title ← AI meta title
   │   ├─► Meta description ← AI meta description
   │   └─► SEO keywords ← AI keywords
   │
6. USER REVIEW & VALIDATE
   │
   ├─► Check nội dung
   ├─► Edit if needed
   └─► Click "Xuất bản" hoặc "Lưu nháp"
   │
7. SAVE TO DATABASE
   │
   └─► Insert into articles table
       └─► Success notification
```

---

## Input Specification

### User Inputs

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| **keyword** | `string` | ✅ Yes | Từ khóa chính để generate | "ổi là loại trái cây có nhiều vitamin C nhất" |
| **topic** | `string` | ❌ Optional | Chủ đề bài viết | "Trái cây, Sức khỏe" |
| **customPrompt** | `string \| object` | ❌ Optional | Prompt template (legacy text hoặc JSONB structured) | See Prompt Template Structure |

### Prompt Template Structure (JSONB - đúng theo codebase)

```json
{
  "title": {
    "instruction": "Tiêu đề bài viết hấp dẫn và SEO-friendly",
    "max_length": 200,
    "format": "Không dùng ký tự đặc biệt"
  },
  "description": {
    "instruction": "Nội dung bài viết chi tiết",
    "min_words": 500,
    "structure": [
      "Chia thành 3-7 phần với tiêu đề rõ ràng",
      "Mỗi phần có 1 tiêu đề phụ (dùng thẻ <h3>) và 1-3 đoạn văn (dùng thẻ <p>)",
      "Ví dụ format: <h3>Giới thiệu về [chủ đề]</h3><p>Nội dung giới thiệu...</p>",
      "KHÔNG dùng markdown **, ### hoặc ký tự đặc biệt",
      "Nội dung phải logic, dễ đọc, mạch lạc, tự nhiên, đúng chính tả, có giá trị thông tin thực tế, không trùng lặp"
    ],
    "no_markdown": true
  },
  "tags": {
    "instruction": "Từ khóa liên quan",
    "quantity": "5-8",
    "separator": ",",
    "no_quotes": true
  },
  "seo_keyword": {
    "instruction": "URL slug thân thiện SEO",
    "format": "a-z, 0-9, dấu gạch ngang",
    "max_length": 100,
    "no_diacritics": true,
    "example": "oi-la-trai-cay-giau-vitamin-c-nhat"
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
}
```

---

## Prompt Design

### Hard-coded Prompt Prefix

```typescript
const HARD_PROMPT_PREFIX = `Dựa trên từ khóa: '{keyword}', hãy viết một bài viết tin tức hoàn chỉnh bằng tiếng Việt.

QUAN TRỌNG: Trả lời CHÍNH XÁC theo format sau, không thêm ký tự đặc biệt, sử dụng định dạng thẻ <h3> cho tiêu đề phụ và thẻ <p> cho nội dung, KHÔNG sử dụng ** hoặc markdown formatting:

`;
```

### Default Prompt Template (Text Format)

```
TITLE: Tiêu đề bài viết hấp dẫn và SEO-friendly (tối đa 200 ký tự)

DESCRIPTION: Nội dung bài viết chi tiết, ít nhất 500 từ.

CẤU TRÚC BÀI VIẾT:
- Chia thành 3-7 phần với tiêu đề rõ ràng
- Mỗi phần có 1 tiêu đề phụ (dùng thẻ <h3>) và 1-3 đoạn văn (dùng thẻ <p>)
- Ví dụ format:
  <h3>Giới thiệu về [chủ đề]</h3>
  <p>Nội dung giới thiệu...</p>
  <h3>Lợi ích của [chủ đề]</h3>
  <p>Nội dung về lợi ích...</p>
- KHÔNG dùng markdown **, ### hoặc ký tự đặc biệt
- Nội dung phải logic, dễ đọc, mạch lạc, tự nhiên, đúng chính tả, có giá trị thông tin thực tế, không trùng lặp.

TAGS: 5-8 từ khóa liên quan, cách nhau bằng dấu phẩy, không có dấu ngoặc

SEO_KEYWORD: URL slug thân thiện SEO (ví dụ: oi-la-trai-cay-giau-vitamin-c-nhat), chỉ dùng a-z, 0-9, dấu gạch ngang, không dấu, tối đa 100 ký tự

META_TITLE: Tiêu đề SEO tối ưu, dài 50-60 ký tự, tự nhiên, không trùng 100% với TITLE

META_DESCRIPTION: Mô tả SEO 120-150 ký tự, hấp dẫn, tự nhiên

META_KEYWORDS: Từ khóa SEO, cách nhau bằng dấu phẩy, ĐÚNG chính tả, đầy đủ chữ

Yêu cầu:
- Nội dung đầy đủ, không bị cắt giữa chừng
- DESCRIPTION phải có cấu trúc <h3>Tiêu đề</h3><p>Nội dung</p> rõ ràng
- Mọi nội dung HTML phải hợp lệ
- Tất cả field phải có nội dung hoàn chỉnh
- Viết văn phong báo chí tự nhiên, đúng chính tả
- Tập trung cung cấp thông tin hữu ích, có thể đăng ngay lên website tin tức
```

### Final Structured Prompt

```typescript
// Backend builds this (simplified):
// - If customPrompt is JSONB object: convert JSONB -> text
// - Else: use customPrompt text
// - Else: convert default JSONB from DB
const structuredPrompt = HARD_PROMPT_PREFIX.replace('{keyword}', keyword) + promptTemplateText;

// Example result:
const fullPrompt = `Dựa trên từ khóa: 'ổi là loại trái cây có nhiều vitamin C nhất', hãy viết một bài viết tin tức hoàn chỉnh bằng tiếng Việt.

QUAN TRỌNG: Trả lời CHÍNH XÁC theo format sau, không thêm ký tự đặc biệt, sử dụng định dạng thẻ <h3> cho tiêu đề phụ và thẻ <p> cho nội dung, KHÔNG sử dụng ** hoặc markdown formatting:

TITLE: Tiêu đề bài viết hấp dẫn và SEO-friendly (tối đa 200 ký tự)
DESCRIPTION: Nội dung bài viết chi tiết, ít nhất 500 từ...
[... rest of template ...]`;
```

---

## Backend Responsibilities

### 1. Prompt Building

```typescript
// File: src/admin/articles.service.ts (actual behavior)

async generateContent(dto: GenerateArticleDto, userId?: string) {
  // 1) Validate & sanitize keyword
  // 2) Load api_settings[name='article'] (contains model_name, api_endpoint, default_prompt JSONB)
  // 3) Load OpenRouter API key (admin_settings or env)
  // 4) Build promptTemplateText:
  //    - dto.customPrompt is object => convert JSONB -> text
  //    - dto.customPrompt is string => use it
  //    - else => convert apiSettings.default_prompt JSONB -> text
  // 5) finalPrompt = HARD_PROMPT_PREFIX + promptTemplateText + topicContext
  // 6) Call OpenRouter
  // 7) Parse and validate response
}
```

### 2. Response Parsing

```typescript
private parseAIResponse(content: string) {
  // Extract fields using regex
  const titleMatch = content.match(/TITLE:\s*(.+?)(?=\n(?:DESCRIPTION:|$))/s);
  const descriptionMatch = content.match(/DESCRIPTION:\s*(.+?)(?=\n(?:TAGS:|$))/s);
  const tagsMatch = content.match(/TAGS:\s*(.+?)(?=\n(?:SEO_KEYWORD:|$))/s);
  const seoKeywordMatch = content.match(/SEO_KEYWORD:\s*(.+?)(?=\n(?:META_TITLE:|$))/s);
  const metaTitleMatch = content.match(/META_TITLE:\s*(.+?)(?=\n(?:META_DESCRIPTION:|$))/s);
  const metaDescriptionMatch = content.match(/META_DESCRIPTION:\s*(.+?)(?=\n(?:META_KEYWORDS:|$))/s);
  const metaKeywordsMatch = content.match(/META_KEYWORDS:\s*(.+?)$/s);

  // Clean & format
  const title = this.cleanText(titleMatch?.[1] || '');
  const body = this.cleanText(descriptionMatch?.[1] || '');
  const tags = tagsMatch?.[1]?.split(',').map(t => t.trim()) || [];
  const slug = this.generateSeoUrl(seoKeywordMatch?.[1]?.trim() || title);

  return {
    success: true,
    data: {
      title,
      body,
      slug,
      tags,
      meta: {
        meta_title: this.cleanText(metaTitleMatch?.[1] || ''),
        meta_description: this.cleanText(metaDescriptionMatch?.[1] || ''),
        seo_keywords: metaKeywordsMatch?.[1]?.trim() || ''
      }
    }
  };
}

private cleanText(text: string): string {
  return text
    .replace(/\*\*/g, '')      // Remove **bold**
    .replace(/###/g, '')       // Remove ### headings
    .replace(/\*/g, '')        // Remove *italic*
    .trim();
}

private generateSeoUrl(text: string): string {
  return text
    .toLowerCase()
    .replace(/đ/g, 'd')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '');
}
```

### 3. API Endpoint

```typescript
// File: src/admin/articles.controller.ts

@Post('generate')
async generateContent(@Body() dto: GenerateArticleDto) {
  return this.articlesService.generateContent(dto);
}
```

### 4. DTO Validation

```typescript
// File: src/admin/dto/admin.dto.ts

export class GenerateArticleDto {
  @IsString()
  keyword: string;

  @IsOptional()
  @IsString()
  topic?: string;

  // Backward-compatible:
  // - string: legacy text prompt
  // - object: structured JSONB prompt template
  @IsOptional()
  customPrompt?: string | Record<string, any>;
}
```

---

## Frontend Responsibilities

### 1. Page Load - Fetch Default Prompt (hiện tại)

```typescript
// File: src/app/admin/articles/new/page.tsx
// Hiện tại: load default_prompt (JSONB) rồi convert sang text để hiển thị textarea

useEffect(() => {
  const loadDefaultPrompt = async () => {
    const apiSettings = await getAllAPISettings();
    const articleSettings = apiSettings.find((s) => s.name === 'article');
    if (!articleSettings?.default_prompt) return;

    const promptText = typeof articleSettings.default_prompt === 'object'
      ? convertPromptJsonbToText(articleSettings.default_prompt)
      : (articleSettings.default_prompt as string);

    setDefaultPrompt(promptText);
    setCustomPrompt(promptText);
  };

  loadDefaultPrompt();
}, []);
```

### 2. Prompt Editor UI

#### 2.1 Hiện tại (legacy - textarea)

Lưu ý: Đây là lý do bạn vẫn thấy prompt là textarea.

```tsx
// File: src/app/admin/articles/new/page.tsx
// Prompt Editor Toggle -> textarea

{showPromptEditor && (
  <textarea
    value={customPrompt}
    onChange={(e) => setCustomPrompt(e.target.value)}
    rows={12}
  />
)}
```

#### 2.2 Mục tiêu bắt buộc (PHẢI chia field)

Prompt **phải** được quản lý dưới dạng object và UI hiển thị input field riêng cho từng nhóm:

- TITLE
- DESCRIPTION (instruction + min_words + structure[])
- TAGS
- SEO_KEYWORD
- META_TITLE
- META_DESCRIPTION
- META_KEYWORDS

Gợi ý hướng implement (frontend):

- State nên là `promptTemplate: PromptTemplateJsonb` thay vì `customPrompt: string`.
- Khi user bấm “Tạo nội dung”, gửi `customPrompt` là object lên backend (backend đã hỗ trợ).
- Không cần convert JSONB → text ở frontend nữa (frontend chỉ edit JSONB).

```tsx
{/* Prompt Customization Section */}
<div className="bg-white rounded-xl shadow-sm border p-4">
  <button onClick={() => setShowPrompt(!showPrompt)}>
    <span>Tùy chỉnh Prompt</span>
    {showPrompt ? <ChevronUp /> : <ChevronDown />}
  </button>

  {showPrompt && (
    <div className="space-y-4 mt-4">
      {/* Title Prompt */}
      <div>
        <label>Tiêu đề (TITLE)</label>
        <input
          value={promptTitle.instruction}
          onChange={(e) => setPromptTitle({
            ...promptTitle,
            instruction: e.target.value
          })}
          placeholder="Tiêu đề bài viết hấp dẫn và SEO-friendly"
        />
        <div className="flex gap-2">
          <input
            type="number"
            value={promptTitle.max_length}
            onChange={(e) => setPromptTitle({
              ...promptTitle,
              max_length: parseInt(e.target.value)
            })}
            placeholder="Max length"
          />
        </div>
      </div>

      {/* Description Prompt */}
      <div>
        <label>Nội dung (DESCRIPTION)</label>
        <textarea
          value={promptDescription.instruction}
          onChange={(e) => setPromptDescription({
            ...promptDescription,
            instruction: e.target.value
          })}
          rows={4}
        />
        <input
          type="number"
          value={promptDescription.min_words}
          onChange={(e) => setPromptDescription({
            ...promptDescription,
            min_words: parseInt(e.target.value)
          })}
          placeholder="Min words"
        />
      </div>

      {/* Tags Prompt */}
      <div>
        <label>Tags</label>
        <input
          value={promptTags.instruction}
          onChange={(e) => setPromptTags({
            ...promptTags,
            instruction: e.target.value
          })}
        />
      </div>

      {/* SEO Keyword Prompt */}
      <div>
        <label>SEO Keyword (Slug)</label>
        <input
          value={promptSeoKeyword.instruction}
          onChange={(e) => setPromptSeoKeyword({
            ...promptSeoKeyword,
            instruction: e.target.value
          })}
        />
      </div>

      {/* Meta Title */}
      <div>
        <label>Meta Title</label>
        <input
          value={promptMetaTitle.instruction}
          onChange={(e) => setPromptMetaTitle({
            ...promptMetaTitle,
            instruction: e.target.value
          })}
        />
      </div>

      {/* Meta Description */}
      <div>
        <label>Meta Description</label>
        <textarea
          value={promptMetaDescription.instruction}
          onChange={(e) => setPromptMetaDescription({
            ...promptMetaDescription,
            instruction: e.target.value
          })}
          rows={2}
        />
      </div>

      {/* Meta Keywords */}
      <div>
        <label>Meta Keywords</label>
        <input
          value={promptMetaKeywords.instruction}
          onChange={(e) => setPromptMetaKeywords({
            ...promptMetaKeywords,
            instruction: e.target.value
          })}
        />
      </div>

      <button onClick={resetToDefault}>
        Khôi phục mặc định
      </button>
    </div>
  )}
</div>
```

### 3. Generate API Call

```typescript
const handleGenerate = async () => {
  if (!keyword) {
    alert('Vui lòng nhập từ khóa');
    return;
  }

  try {
    setGenerating(true);

    // Legacy (current code): send string prompt
    const result = await generateArticleContent(keyword, topic, customPrompt);

    // Target (required): send JSONB object (structured prompt)
    // const result = await generateArticleContent(keyword, topic, promptTemplateJsonb);

    // Populate form fields
    if (result.title) setTitle(result.title);
    if (result.body) setContent(result.body);
    if (result.tags) setTags(result.tags);
    if (result.slug) setSlug(result.slug);
    if (result.meta) {
      setMetaTitle(result.meta.meta_title);
      setMetaDescription(result.meta.meta_description);
      setSeoKeywords(result.meta.seo_keywords);
    }

    alert('Tạo nội dung thành công! Vui lòng kiểm tra và chỉnh sửa nếu cần.');
  } catch (error) {
    alert(error.message || 'Lỗi khi tạo nội dung');
  } finally {
    setGenerating(false);
  }
};
```

### 4. Form Validation & Save

```typescript
const handleSave = async (publishStatus: 'draft' | 'published') => {
  // Validate
  if (!title) {
    alert('Vui lòng nhập tiêu đề');
    return;
  }

  if (!content) {
    alert('Vui lòng nhập nội dung');
    return;
  }

  if (content.length < 500) {
    alert('Nội dung quá ngắn (tối thiểu 500 ký tự)');
    return;
  }

  try {
    setLoading(true);

    await createArticle({
      title,
      slug,
      excerpt,
      featured_image: featuredImage,
      content_blocks: [{
        type: 'text',
        content: content,
        level: 'p'
      }],
      topic,
      keyword,
      meta_title: metaTitle,
      meta_description: metaDescription,
      seo_keywords: seoKeywords,
      status: publishStatus
    });

    router.push('/admin/articles');
  } catch (error) {
    alert(error.message || 'Lỗi khi lưu bài viết');
  } finally {
    setLoading(false);
  }
};
```

---

## Data Storage

### Database Schema Changes

#### Migration: Convert `default_prompt` to JSONB

```sql
-- File: database/018_fix_api_settings_and_add_usage_logs.sql

-- Step 1: Add new JSONB column temporarily
ALTER TABLE public.api_settings
ADD COLUMN IF NOT EXISTS default_prompt_new jsonb;

-- Step 2: Convert to JSONB structured template (example)
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
  )
)
WHERE name = 'article' AND default_prompt_new IS NULL;

-- Step 3: Drop old TEXT column (if exists)
ALTER TABLE public.api_settings
DROP COLUMN IF EXISTS default_prompt;

-- Step 4: Rename new column to default_prompt
ALTER TABLE public.api_settings
RENAME COLUMN default_prompt_new TO default_prompt;

-- Step 5: Cleanup old temporary column (if exists)
ALTER TABLE public.api_settings
DROP COLUMN IF EXISTS default_prompt_jsonb;

COMMENT ON COLUMN public.api_settings.default_prompt
IS 'JSONB structure for customizable AI prompt template';
```

#### Updated Schema

```sql
CREATE TABLE api_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key TEXT NOT NULL,
  name TEXT UNIQUE NOT NULL,
  model_name TEXT NOT NULL,
  api_endpoint TEXT NOT NULL,
  default_prompt JSONB NOT NULL,  -- Changed from TEXT to JSONB
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Example data
INSERT INTO api_settings (key, name, model_name, api_endpoint, default_prompt, description)
VALUES (
  'openrouter_article_generation',
  'article',
  'meta-llama/llama-3.3-70b-instruct:free',
  'https://openrouter.ai/api/v1/chat/completions',
  '{
    "title": {
      "instruction": "Tiêu đề bài viết hấp dẫn và SEO-friendly",
      "max_length": 200,
      "format": "Không dùng ký tự đặc biệt"
    },
    "description": {
      "instruction": "Nội dung bài viết chi tiết",
      "min_words": 500,
      "structure": [
        "Chia thành 3-7 phần với tiêu đề rõ ràng",
        "Mỗi phần có 1 tiêu đề phụ (dùng thẻ <h3>) và 1-3 đoạn văn (dùng thẻ <p>)",
        "Ví dụ format: <h3>Giới thiệu về [chủ đề]</h3><p>Nội dung giới thiệu...</p>",
        "KHÔNG dùng markdown **, ### hoặc ký tự đặc biệt",
        "Nội dung phải logic, dễ đọc, mạch lạc, tự nhiên, đúng chính tả, có giá trị thông tin thực tế, không trùng lặp"
      ],
      "no_markdown": true
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
      "no_diacritics": true,
      "example": "oi-la-trai-cay-giau-vitamin-c-nhat"
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
  }',
  'OpenRouter AI settings for article generation with structured JSONB prompt template'
);
```

---

## Security & Cost Control

### 1. Rate Limiting

```typescript
// File: src/admin/articles.service.ts

// In-memory rate limit tracking
private readonly rateLimitMap = new Map<string, { count: number; resetAt: number }>();

async generateContent(dto: GenerateArticleDto, userId: string) {
  // Check rate limit
  this.checkRateLimit(userId);

  // ... rest of generation logic
}

private checkRateLimit(userId: string) {
  const now = Date.now();
  const limit = this.rateLimitMap.get(userId);

  // Reset if time window expired
  if (limit && now > limit.resetAt) {
    this.rateLimitMap.delete(userId);
  }

  // Check if limit reached
  const current = this.rateLimitMap.get(userId) || { count: 0, resetAt: now + 3600000 }; // 1 hour

  if (current.count >= 10) { // 10 requests per hour
    throw new ForbiddenException('Đã vượt quá giới hạn tạo bài viết. Vui lòng thử lại sau 1 giờ.');
  }

  // Increment counter
  current.count++;
  this.rateLimitMap.set(userId, current);
}
```

### 2. Cost Monitoring

```typescript
// Log usage for monitoring
private async logAIUsage(userId: string, keyword: string, tokenUsed: number) {
  await this.supabase.from('ai_usage_logs').insert({
    user_id: userId,
    feature: 'article_generation',
    keyword: keyword,
    tokens_used: tokenUsed,
    estimated_cost: tokenUsed * 0.00002, // $0.02 per 1K tokens (GPT-4)
    created_at: new Date()
  });
}
```

### 3. Input Validation

```typescript
// Validate keyword length to avoid abuse
if (dto.keyword.length > 200) {
  throw new BadRequestException('Từ khóa quá dài (tối đa 200 ký tự)');
}

// Sanitize input
const sanitizedKeyword = dto.keyword
  .replace(/<script[^>]*>.*?<\/script>/gi, '')
  .replace(/<[^>]+>/g, '')
  .trim();
```

### 4. API Key Security

```typescript
// NEVER expose API key to frontend
// Always fetch from backend environment/database

// Environment variable (preferred)
const apiKey = process.env.OPENROUTER_API_KEY;

// Or from database (encrypted)
const { data } = await this.supabase
  .from('admin_settings')
  .select('value')
  .eq('key', 'api_keys')
  .single();

const apiKey = data.value.openrouter_key;
```

### 5. Free API Tier Optimization

```typescript
// For free API tier, implement stricter limits
const FREE_TIER_LIMITS = {
  MAX_REQUESTS_PER_DAY: 5,
  MAX_TOKENS_PER_REQUEST: 1500, // Reduce max_tokens to save quota
  COOLDOWN_MINUTES: 30 // Minimum time between requests
};

// Check daily limit
const todayUsage = await this.getTodayUsageCount(userId);
if (todayUsage >= FREE_TIER_LIMITS.MAX_REQUESTS_PER_DAY) {
  throw new ForbiddenException('Đã hết quota hôm nay. Vui lòng thử lại vào ngày mai.');
}

// Check cooldown
const lastRequest = await this.getLastRequestTime(userId);
const cooldownMs = FREE_TIER_LIMITS.COOLDOWN_MINUTES * 60 * 1000;
if (lastRequest && (Date.now() - lastRequest.getTime()) < cooldownMs) {
  throw new ForbiddenException(`Vui lòng đợi ${FREE_TIER_LIMITS.COOLDOWN_MINUTES} phút giữa các lần tạo bài viết.`);
}

// Reduce max_tokens for free tier
const response = await fetch(apiSettings.api_endpoint, {
  method: 'POST',
  body: JSON.stringify({
    model: 'gpt-3o-mini', // Use cheaper OpenRouter model for free tier
    max_tokens: FREE_TIER_LIMITS.MAX_TOKENS_PER_REQUEST,
    // ... rest of config
  })
});
```

---

## Final Constraints

### Mandatory Requirements

| Constraint | Requirement | Rationale |
|------------|-------------|-----------|
| **Prompt Format** | MUST return structured text with TITLE, DESCRIPTION, TAGS, etc. | Parsing consistency |
| **HTML Tags** | MUST use `<h3>` and `<p>` only | Prevent XSS, consistent formatting |
| **No Markdown** | MUST NOT use `**`, `##`, `*` | Avoid parsing conflicts |
| **Minimum Words** | MUST have at least 500 words in DESCRIPTION | Content quality |
| **SEO Slug** | MUST be lowercase, no diacritics, hyphen-separated | URL compatibility |
| **Meta Length** | Meta title: 50-60 chars, Meta description: 120-150 chars | SEO best practices |
| **Rate Limiting** | Maximum 10 requests/hour (or 5/day for free tier) | Cost control |
| **Validation** | MUST validate all fields before saving to DB | Data integrity |

### Data Quality Checks

```typescript
// Backend validation before returning response
private validateAIResponse(data: any): boolean {
  const checks = [
    data.title && data.title.length > 0 && data.title.length <= 200,
    data.body && data.body.length >= 500,
    data.tags && data.tags.length >= 5 && data.tags.length <= 8,
    data.slug && /^[a-z0-9-]+$/.test(data.slug) && data.slug.length <= 100,
    data.meta.meta_title && data.meta.meta_title.length >= 50 && data.meta.meta_title.length <= 60,
    data.meta.meta_description && data.meta.meta_description.length >= 120 && data.meta.meta_description.length <= 150,
    data.body.includes('<h3>') && data.body.includes('<p>'), // Must have proper HTML structure
    !data.body.includes('**') && !data.body.includes('##'), // No markdown
  ];

  return checks.every(check => check === true);
}

// If validation fails, throw error
if (!this.validateAIResponse(parsedData)) {
  throw new BadRequestException('AI response không đạt yêu cầu. Vui lòng thử lại.');
}
```

### Error Handling

```typescript
// Comprehensive error handling
try {
  const result = await this.generateContent(dto, userId);
  return result;
} catch (error) {
  if (error instanceof ForbiddenException) {
    // Rate limit or quota exceeded
    throw error;
  } else if (error.response?.status === 401) {
    // Invalid API key
    throw new UnauthorizedException('API key không hợp lệ. Vui lòng kiểm tra cấu hình.');
  } else if (error.response?.status === 429) {
    // OpenRouter rate limit
    throw new TooManyRequestsException('OpenRouter API đã vượt quota. Vui lòng thử lại sau.');
  } else if (error.response?.status >= 500) {
    // OpenRouter server error
    throw new InternalServerErrorException('Lỗi từ OpenRouter API. Vui lòng thử lại sau.');
  } else {
    // Unknown error
    throw new InternalServerErrorException('Lỗi không xác định khi tạo nội dung.');
  }
}
```

---

## Implementation Checklist

### Backend

- [x] Add migration `database/018_fix_api_settings_and_add_usage_logs.sql` (includes default_prompt JSONB)
- [x] Update backend generate endpoint to accept `customPrompt` as string or JSONB
- [x] Convert JSONB prompt template → text prompt (`convertPromptJsonbToText`)
- [x] Parse AI response + validation (`parseAIResponse`, `validateParsedContent`)
- [x] Rate limiting (in-memory)
- [x] Usage logging (`ai_usage_logs`)
- [x] Error handling for OpenRouter response codes
- [x] Unit tests for parsing (`src/admin/articles.service.spec.ts`)

### Frontend

- [x] Load `default_prompt` JSONB from API settings
- [ ] Replace legacy textarea prompt editor with structured input fields (REQUIRED)
- [ ] Store prompt as JSONB state (not string), and send JSONB in `customPrompt`
- [ ] Add "Khôi phục mặc định" for prompt template JSONB
- [ ] Update `generateArticleContent()` signature to accept JSONB (currently string-only)
- [ ] Improve form validation before save
- [ ] Add loading states and progress indicators
- [ ] Add error messages for user feedback
- [ ] Test end-to-end workflow

### Database

- [x] Add migration converting `default_prompt` TEXT → JSONB in repo
- [ ] Apply migration to each environment DB
- [ ] Verify data migration correctness (spot-check `api_settings.default_prompt` JSON)
- [ ] Backup + rollback procedure (ops)
- [ ] Add indexes if needed for performance

### Testing

- [ ] Unit tests for prompt building (JSONB → text)
- [x] Unit tests for response parsing
- [ ] Integration tests for full workflow
- [ ] E2E tests for UI interaction
- [ ] Load testing for rate limiting
- [ ] Error scenario testing

---

## Appendix

### A. Example API Request/Response

**Request:**
```json
{
  "keyword": "ổi là loại trái cây có nhiều vitamin C nhất",
  "topic": "Trái cây, Sức khỏe",
  "customPrompt": {
    "title": {
      "instruction": "Tiêu đề bài viết hấp dẫn và SEO-friendly",
      "max_length": 200
    },
    "description": {
      "instruction": "Nội dung bài viết chi tiết",
      "min_words": 500,
      "structure": [
        "Chia thành 3-7 phần với tiêu đề rõ ràng",
        "Mỗi phần có 1 tiêu đề phụ (dùng thẻ <h3>) và 1-3 đoạn văn (dùng thẻ <p>)"
      ],
      "no_markdown": true
    }
    // ... other fields
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "title": "Ổi - Vua Vitamin C: Lợi Ích Tuyệt Vời Cho Sức Khỏe",
    "body": "<h3>Giới thiệu về ổi</h3><p>Ổi là loại trái cây nhiệt đới...</p><h3>Hàm lượng vitamin C trong ổi</h3><p>Theo nghiên cứu...</p>",
    "slug": "oi-vua-vitamin-c-loi-ich-tuyet-voi-cho-suc-khoe",
    "tags": ["ổi", "vitamin C", "trái cây", "sức khỏe", "dinh dưỡng", "miễn dịch"],
    "meta": {
      "meta_title": "Ổi - Trái Cây Giàu Vitamin C Nhất | Lợi Ích Sức Khỏe",
      "meta_description": "Khám phá lợi ích tuyệt vời của ổi - loại trái cây có hàm lượng vitamin C cao nhất. Tìm hiểu cách ổi giúp tăng cường miễn dịch...",
      "seo_keywords": "ổi, vitamin c, trái cây nhiệt đới, sức khỏe, dinh dưỡng"
    }
  }
}
```

### B. Default Prompt Template (Full JSONB)

See [Prompt Template Structure](#prompt-template-structure-jsonb) section above.

---

**Document Version:** 1.1.0  
**Author:** ShopIn Development Team  
**Last Updated:** 2026-01-13  
**Status:** Partially Implemented (UI prompt editor needs refactor)
