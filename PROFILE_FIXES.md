# Profile Feature Fixes - Migration Guide

## Issues Fixed

### 1. ❌ Avatar Upload Error: "bucket not found"
**Error**: `POST http://localhost:3000/api/profiles/avatar 400 (Bad Request)`

**Root Cause**: 
- Backend was using bucket name `'public'` which doesn't exist
- Correct bucket name should be `'avatars'`
- Storage bucket wasn't configured in Supabase

**Fix**: 
- ✅ Changed bucket from `'public'` to `'avatars'` in profiles.service.ts
- ✅ Changed upload path from `avatars/` to `profile_images/` 
- ✅ Fixed public URL construction
- ✅ Created migration 012 to setup storage bucket with proper RLS policies

---

### 2. ❌ Gender Column Missing
**Error**: Could not find the 'gender' column of 'profiles' in the schema cache

**Root Cause**: profiles table doesn't have gender column

**Fix**:
- ✅ Created migration 011 to add gender column with CHECK constraint
- ✅ Updated schema.public.sql to reflect new column

---

### 3. ❌ Date of Birth Column Missing
**Error**: Could not find the 'date_of_birth' column of 'profiles' in the schema cache

**Root Cause**: profiles table doesn't have date_of_birth column

**Fix**:
- ✅ Created migration 011 to add date_of_birth column (date type)
- ✅ Updated schema.public.sql to reflect new column

---

### 4. ❌ Phone Number Validation Error
**Error**: Phone number must be a valid Vietnamese phone number (e.g., 0987654321 or +84987654321)

**Root Cause**: 
- Regex only accepted Vietnamese format: `/^(\+84|0)[3|5|7|8|9][0-9]{8}$/`
- User requested E.164 international format

**Fix**:
- ✅ Updated regex to E.164 standard: `/^\+?[1-9]\d{1,14}$/`
- ✅ Accepts international phone numbers in format: +1234567890
- ✅ Validation message updated

---

## Migration Steps

### Step 1: Run Migration 011 (Add Profile Columns)

**File**: `database/011_add_profile_columns.sql`

**What it does**:
- Adds `gender` column with CHECK constraint (male, female, other)
- Adds `date_of_birth` column (date type)
- Creates index on gender for demographic queries
- Includes verification checks

**How to run**:
1. Open Supabase Dashboard → SQL Editor
2. Copy contents of `011_add_profile_columns.sql`
3. Click "Run"
4. Check for success message: "Migration 011 completed successfully"

---

### Step 2: Run Migration 012 (Setup Storage Bucket)

**File**: `database/012_setup_storage_bucket.sql`

**What it does**:
- Creates `avatars` bucket with public access
- Sets 5MB file size limit
- Restricts to image MIME types (jpeg, jpg, png, gif, webp)
- Sets up RLS policies:
  - Public read access for all avatars
  - Authenticated users can upload/update/delete their own avatars

**How to run**:
1. Open Supabase Dashboard → SQL Editor
2. Copy contents of `012_setup_storage_bucket.sql`
3. Click "Run"
4. Check for success message: "Migration 012 completed successfully"

**Manual Verification**:
1. Go to Supabase Dashboard → Storage
2. Check that `avatars` bucket exists
3. Verify it's marked as "Public"
4. Check bucket policies are active

---

## Code Changes Summary

### Backend Changes

#### 1. `src/profiles/dto/profiles.dto.ts`
- ✅ Added `@Transform` decorator to all optional fields (converts empty strings to undefined)
- ✅ Updated phone validation regex to E.164 format
- ✅ Updated validation message

#### 2. `src/profiles/profiles.service.ts`
- ✅ Changed bucket name from `'public'` to `'avatars'`
- ✅ Changed upload path from `avatars/` to `profile_images/`
- ✅ Fixed public URL: `${supabaseUrl}/storage/v1/object/public/avatars/${filePath}`
- ✅ Injected ConfigService for Supabase URL

### Frontend Changes

#### 1. `src/app/profile/sections/ProfileSection.tsx`
- ✅ Already using correct column names (gender, date_of_birth)
- ✅ Has `getAvatarSrc()` helper for URL validation
- ✅ Separated avatar upload from profile save
- ✅ Added pending avatar state with warning message

### Schema Changes

#### 1. `schema.public.sql`
- ✅ Added gender column with CHECK constraint
- ✅ Added date_of_birth column

#### 2. `database/README.md`
- ✅ Documented migrations 011 and 012
- ✅ Added troubleshooting steps

---

## Testing Checklist

After running migrations, test these features:

### Avatar Upload
- [ ] Upload a JPG image (< 5MB)
- [ ] Upload a PNG image (< 5MB)
- [ ] Try uploading a file > 5MB (should fail)
- [ ] Try uploading a non-image file (should fail)
- [ ] Verify preview shows immediately
- [ ] Verify warning message appears
- [ ] Click "Lưu thay đổi" and verify avatar saves
- [ ] Refresh page and verify avatar persists

### Gender Selection
- [ ] Select "Nam" (male)
- [ ] Select "Nữ" (female)
- [ ] Select "Khác" (other)
- [ ] Leave empty
- [ ] Click "Lưu thay đổi" and verify saves correctly

### Date of Birth
- [ ] Select a date from date picker
- [ ] Clear the date
- [ ] Click "Lưu thay đổi" and verify saves correctly

### Phone Number (E.164)
- [ ] Enter Vietnamese number: +84987654321
- [ ] Enter US number: +11234567890
- [ ] Enter without +: 84987654321
- [ ] Enter invalid number: 123 (should fail)
- [ ] Leave empty (should succeed)
- [ ] Click "Lưu thay đổi" and verify saves correctly

### Complete Profile Update
- [ ] Change name, phone, gender, birth date, and upload avatar
- [ ] Click "Lưu thay đổi" once
- [ ] Verify all fields save correctly
- [ ] Refresh page and verify all changes persist

---

## Troubleshooting

### Issue: Migration 011 fails
**Check**: Run this query to see if columns already exist:
```sql
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'profiles' 
AND column_name IN ('gender', 'date_of_birth');
```
If columns exist, migration is already applied (safe to ignore).

### Issue: Migration 012 fails with "bucket already exists"
**Check**: Run this query:
```sql
SELECT id, name, public FROM storage.buckets WHERE id = 'avatars';
```
If bucket exists, migration is already applied (safe to ignore).

### Issue: Avatar upload still fails
**Check**:
1. Verify bucket exists in Supabase Storage UI
2. Check backend logs for detailed error message
3. Verify Supabase URL in .env matches project URL
4. Test bucket manually by uploading file in Supabase UI

### Issue: Phone validation still rejects valid numbers
**Check**:
1. Verify backend was restarted after code changes
2. Test with E.164 format: +[country code][number]
3. Check network tab for exact error message from backend

---

## Environment Variables

Ensure these are set in your backend `.env`:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

No changes needed - existing configuration works with new bucket.

---

## Rollback Plan

If you need to rollback:

### Rollback Migration 011:
```sql
-- Remove added columns
ALTER TABLE profiles DROP COLUMN IF EXISTS gender;
ALTER TABLE profiles DROP COLUMN IF EXISTS date_of_birth;
DROP INDEX IF EXISTS idx_profiles_gender;
```

### Rollback Migration 012:
```sql
-- Remove bucket and policies
DROP POLICY IF EXISTS "Avatar images are publicly accessible" ON storage.objects;
DROP POLICY IF EXISTS "Users can upload their own avatar" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own avatar" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own avatar" ON storage.objects;
DELETE FROM storage.buckets WHERE id = 'avatars';
```

---

## Summary

| Fix | Status | Migration | Code Changes |
|-----|--------|-----------|--------------|
| Avatar bucket config | ✅ Done | 012 | profiles.service.ts |
| Gender column | ✅ Done | 011 | schema.public.sql |
| Date of birth column | ✅ Done | 011 | schema.public.sql |
| Phone E.164 format | ✅ Done | N/A | profiles.dto.ts |
| Empty field validation | ✅ Done | N/A | profiles.dto.ts |
| Avatar preview/save UX | ✅ Done | N/A | ProfileSection.tsx |

**Next Steps**:
1. Run migrations 011 and 012 in Supabase
2. Restart backend server
3. Test all profile features
4. Deploy to production
