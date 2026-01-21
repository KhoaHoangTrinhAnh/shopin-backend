# Article Structure Update - Excerpt → Tags

## 📝 Change Summary

**Date:** January 20, 2026  
**Change:** Replaced "Mô tả ngắn" (excerpt) field with "Tags" field in article structure

## 🔄 What Changed

### Before
```typescript
interface Article {
  title: string;
  excerpt: string;  // Mô tả ngắn
  // ...
}
```

### After
```typescript
interface Article {
  title: string;
  tags: string[];   // Tags (array of keywords)
  // ...
}
```

## 📋 Files Modified

### Frontend
1. **[new/page.tsx](d:\shopin-frontend\src\app\admin\articles\new\page.tsx)**
   - Changed state: `excerpt` → `tags`
   - Updated AI generation: sets tags array from AI response
   - Updated validation: `tags` required for published articles
   - Updated save: converts comma-separated string to array
   - Updated UI: replaced textarea with input field

2. **[adminApi.ts](d:\shopin-frontend\src\lib\adminApi.ts)**
   - Updated `Article` interface: `excerpt?` → `tags?`
   - Updated AI generation response mapping

### Backend
3. **[admin.dto.ts](d:\shopin-backend\src\admin\dto\admin.dto.ts)**
   - `CreateArticleDto`: `excerpt?: string` → `tags?: string[]`
   - `UpdateArticleDto`: `excerpt?: string` → `tags?: string[]`

4. **[articles.service.ts](d:\shopin-backend\src\admin\articles.service.ts)**
   - Updated search query: `excerpt.ilike` → `body.ilike`

## 🎯 Validation Changes

### Draft Articles
- Required: `title` only

### Published Articles
- Required: 
  - ✅ `title`
  - ✅ `slug`
  - ✅ `content`
  - ✅ `tags` (NEW - replaces excerpt)
  - ✅ `featured_image`
  - ✅ `meta_title`
  - ✅ `meta_description`

## 🖼️ UI Changes

**Old "Mô tả ngắn" field:**
```tsx
<textarea
  value={excerpt}
  placeholder="Mô tả ngắn về bài viết..."
  rows={3}
/>
```

**New "Tags" field:**
```tsx
<input
  type="text"
  value={tags}
  placeholder="công nghệ, điện thoại, smartphone..."
/>
<p className="text-xs text-gray-500 mt-1">
  Các từ khóa cách nhau bằng dấu phẩy (,)
</p>
```

## 🔧 Implementation Details

### Tag Input Format
- **User Input:** Comma-separated string
  ```
  "công nghệ, điện thoại, smartphone, iphone"
  ```

- **Saved to Database:** Array of strings
  ```json
  ["công nghệ", "điện thoại", "smartphone", "iphone"]
  ```

- **Conversion Logic:**
  ```typescript
  tags: tags.split(',').map(tag => tag.trim()).filter(tag => tag)
  ```

### AI Generation
- AI returns tags in the response
- Tags are joined with comma for display:
  ```typescript
  if (result.tags && Array.isArray(result.tags)) {
    setTags(result.tags.join(', '));
  }
  ```

## 📊 Database Schema

The `articles` table already has `tags` field:
```sql
CREATE TABLE articles (
  -- ...
  tags text[],  -- Already exists ✅
  -- ...
);
```

No database migration needed - the field already exists!

## ✅ Benefits

1. **Better SEO:** Tags are more useful than excerpt for categorization
2. **AI Integration:** AI naturally generates tags/keywords
3. **User Experience:** Simpler input (one-line vs textarea)
4. **Flexibility:** Can have multiple tags vs single excerpt
5. **Search:** Tags are indexed and searchable

## 🧪 Testing

### Manual Testing
1. Create new article
2. Enter tags: "điện thoại, công nghệ, đánh giá"
3. Save as published
4. Verify tags saved as array in database
5. Verify tags displayed correctly in admin list

### AI Generation Testing
1. Generate article with keyword
2. Verify AI returns tags
3. Verify tags populated in input field
4. Verify tags saved correctly

## 📝 Migration Notes

### For Existing Articles
If you have existing articles with `excerpt` field:
1. Optionally convert excerpt to tags:
   ```sql
   -- Example migration (if needed)
   UPDATE articles 
   SET tags = ARRAY[topic] 
   WHERE excerpt IS NOT NULL AND tags IS NULL;
   ```
2. Or leave as is - `excerpt` column can remain in DB for historical data

### No Breaking Changes
- Old articles without tags will still work
- Tags field is optional for drafts
- Only required for new published articles

## 🎉 Conclusion

Article structure successfully updated:
- ✅ Frontend updated
- ✅ Backend updated
- ✅ Validation updated
- ✅ UI updated
- ✅ No TypeScript errors
- ✅ Ready to use

Tags provide better categorization and SEO benefits compared to excerpt!
