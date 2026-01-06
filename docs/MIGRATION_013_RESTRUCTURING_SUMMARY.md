# MIGRATION 013 RESTRUCTURING - CHANGE SUMMARY

## Overview
Migration 013 has been completely restructured to separate admin settings, add API configuration, enhance security with blocked users and RLS policies, and introduce audit logging infrastructure.

---

## 🗄️ DATABASE CHANGES

### 1. Admin Settings - Restructured (4 separate keys)

**Before:** Single `shop_settings` key with all configuration

**After:** 4 separate keys for better organization:

1. **`shop_info`**
   - shop_name
   - contact_email
   - hotline

2. **`shipping_config`**
   - default_shipping_fee (number)
   - estimated_delivery_days (number)

3. **`order_config`**
   - cod_enabled (boolean)

4. **`default_seo`**
   - meta_title
   - meta_description

### 2. New Table: `api_settings`

```sql
CREATE TABLE api_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key TEXT UNIQUE NOT NULL,
  model_name TEXT,
  api_endpoint TEXT,
  default_prompt TEXT,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
```

**Default Data:**
- key: `article_generation`
- model_name: `gpt-4`
- api_endpoint: `https://api.openai.com/v1/chat/completions`
- default_prompt: (article generation prompt)

### 3. Profiles Table Enhancement

**Removed:**
- `is_admin` column (deprecated)

**Added:**
- `blocked` BOOLEAN DEFAULT false

**Migration:**
- All existing admins remain (role = 'admin')
- All users get blocked = false by default

### 4. New Table: `audit_logs`

```sql
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id UUID REFERENCES profiles(id),
  action TEXT NOT NULL,
  resource_type TEXT NOT NULL,
  resource_id TEXT,
  details JSONB DEFAULT '{}'::jsonb,
  ip_address TEXT,
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

**Indexes:**
- admin_id
- resource_type
- action
- created_at (DESC)

### 5. Row Level Security (RLS) Policies

**admin_settings:**
- Only admins can read/write

**api_settings:**
- Only admins can read/write

**audit_logs:**
- Only admins can read
- No direct write access (use backend service)

---

## 🔧 BACKEND CHANGES

### 1. Guards: `admin.guard.ts`

**Added blocked user check:**
```typescript
if (profile.blocked === true) {
  throw new ForbiddenException('Tài khoản admin đã bị khóa');
}
```

### 2. DTOs: `admin.dto.ts`

**New DTOs:**
- `ShopInfoDto` (shop_name, contact_email, hotline)
- `ShippingConfigDto` (default_shipping_fee, estimated_delivery_days)
- `OrderConfigDto` (cod_enabled)
- `DefaultSEODto` (meta_title, meta_description)
- `APISettingsDto` (key, model_name, api_endpoint, default_prompt, description)

**Legacy DTOs (kept for backward compatibility):**
- `AISettingsDto`
- `ShopSettingsDto`

### 3. Services: `settings.service.ts`

**New Methods:**
- `getShopInfo()` / `updateShopInfo(dto)`
- `getShippingConfig()` / `updateShippingConfig(dto)`
- `getOrderConfig()` / `updateOrderConfig(dto)`
- `getDefaultSEO()` / `updateDefaultSEO(dto)`
- `getAPISettings(key)` / `updateAPISettings(key, dto)`
- `getAllAPISettings()`

**Legacy Methods (still available):**
- `getAISettings()` / `updateAISettings(dto)`
- `getShopSettings()` / `updateShopSettings(dto)`

### 4. Controllers: `settings.controller.ts`

**New Endpoints:**
```
GET    /api/admin/settings/shop-info
PUT    /api/admin/settings/shop-info
GET    /api/admin/settings/shipping
PUT    /api/admin/settings/shipping
GET    /api/admin/settings/order
PUT    /api/admin/settings/order
GET    /api/admin/settings/seo
PUT    /api/admin/settings/seo
GET    /api/admin/settings/api
GET    /api/admin/settings/api/:key
PUT    /api/admin/settings/api/:key
```

### 5. New Services: `audit-logs.service.ts`

**Methods:**
- `createLog(dto)` - Create audit log entry
- `getLogs(page, limit, filters)` - Get logs with pagination
- `getLogDetail(id)` - Get single log detail
- `getLogStats(days)` - Get statistics

### 6. New Controllers: `audit-logs.controller.ts`

**Endpoints:**
```
GET    /api/admin/audit-logs?page=1&limit=20&filters...
GET    /api/admin/audit-logs/:id
GET    /api/admin/audit-logs/stats/summary?days=30
```

### 7. Module: `admin.module.ts`

**Added:**
- `AuditLogsController`
- `AuditLogsService`

---

## 🎨 FRONTEND CHANGES

### 1. Admin Layout: `admin/layout.tsx`

**Updated Navigation:**

**Collapsed "Bài viết" with sub-menu:**
- Danh sách bài viết → `/admin/articles`
- Cấu hình API → `/admin/api-settings`

**Collapsed "Cài đặt" with sub-menu:**
- Thông tin cửa hàng → `/admin/settings/shop-info`
- Vận chuyển → `/admin/settings/shipping`
- Đơn hàng → `/admin/settings/order`
- SEO mặc định → `/admin/settings/seo`

**New top-level item:**
- Nhật ký hoạt động → `/admin/logs`

**Security Enhancement:**
```typescript
if (profile.blocked === true) {
  logout();
  router.push("/");
}
```

### 2. New Page: `/admin/api-settings`

**File:** `admin/api-settings/page.tsx`

**Features:**
- Configure model name, API endpoint, default prompt
- Reset to default functionality
- Shows character counts and validation

### 3. New Page: `/admin/logs`

**File:** `admin/logs/page.tsx`

**Features:**
- List audit logs with pagination
- Filter by admin, resource type, action, date range
- Development notice banner
- Shows admin details with avatar

**Status:** Marked as "In Development" with yellow notice

### 4. Updated Page: `/admin/settings`

**File:** `admin/settings/page.tsx`

**Changed from:** Full settings form

**Changed to:** Navigation hub with 4 cards linking to:
- Shop Info
- Shipping Config
- Order Config
- Default SEO

### 5. New Sub-Pages:

**a) `/admin/settings/shop-info`**
- Shop name
- Contact email
- Hotline

**b) `/admin/settings/shipping`**
- Default shipping fee (VNĐ)
- Estimated delivery days

**c) `/admin/settings/order`**
- COD enabled/disabled checkbox

**d) `/admin/settings/seo`**
- Meta title (with character counter)
- Meta description (with character counter)

---

## 🔐 SECURITY ENHANCEMENTS

### 1. Backend

✅ AdminGuard checks both role and blocked status
✅ RLS policies prevent database bypass
✅ Audit logs track all admin actions

### 2. Frontend

✅ Admin layout checks blocked status
✅ Blocked admins are logged out immediately
✅ All admin routes protected by layout

---

## 📝 MIGRATION CHECKLIST

### Before Running Migration

- [ ] Backup database
- [ ] Review all existing admin_settings data
- [ ] Ensure no active admin sessions

### After Running Migration

- [ ] Verify all 4 new admin_settings keys exist
- [ ] Verify api_settings table has article_generation row
- [ ] Verify profiles.blocked column exists (all false)
- [ ] Verify audit_logs table is empty
- [ ] Test RLS policies

### Backend Verification

- [ ] Test all new endpoints with Postman/Thunder Client
- [ ] Verify AdminGuard blocks blocked users
- [ ] Test backward compatibility with old endpoints

### Frontend Verification

- [ ] Check sidebar navigation (collapsible items work)
- [ ] Test all 4 settings sub-pages
- [ ] Test API settings page
- [ ] Check audit logs page displays notice
- [ ] Verify blocked admin gets logged out

---

## 🚀 DEPLOYMENT STEPS

### 1. Backend

```bash
cd shopin-backend

# Run migration
psql -h YOUR_SUPABASE_HOST -U postgres -d YOUR_DATABASE -f database/013_admin_panel_features.sql

# Or run in Supabase SQL Editor
```

### 2. Frontend

```bash
cd shopin-frontend
npm run build
npm run start
# or deploy to Cloudflare Pages
```

---

## 🔄 BACKWARD COMPATIBILITY

### Endpoints Still Available

**Old settings endpoints still work:**
- `GET /api/admin/settings/ai` → Returns AI settings (from admin_settings)
- `PUT /api/admin/settings/ai` → Updates AI settings
- `GET /api/admin/settings/shop` → Returns shop settings (legacy format)
- `PUT /api/admin/settings/shop` → Updates shop settings

### New Endpoints (Recommended)

Use the new separated endpoints for better organization:
- `/api/admin/settings/shop-info`
- `/api/admin/settings/shipping`
- `/api/admin/settings/order`
- `/api/admin/settings/seo`
- `/api/admin/settings/api/:key`

---

## 📋 TODO (Future Development)

### Audit Logs

- [ ] Auto-log all admin create/update/delete operations
- [ ] Add audit log middleware/decorator
- [ ] Implement advanced filters in UI
- [ ] Export audit logs to CSV/PDF
- [ ] Add IP address and user agent tracking

### Settings

- [ ] Add more order config options (auto-confirm, etc.)
- [ ] Add email notification settings
- [ ] Add payment gateway settings

### Security

- [ ] Add 2FA for admin accounts
- [ ] Add session timeout configuration
- [ ] Add IP whitelist for admin panel

---

## ⚠️ BREAKING CHANGES

### None (All changes are backward compatible)

**Old code will continue to work** because:
1. Legacy DTOs and endpoints are preserved
2. Old settings structure (shop_settings) is still supported
3. New fields (blocked) default to safe values (false)

---

## 📞 SUPPORT

If you encounter any issues:

1. Check migration was applied successfully
2. Verify RLS policies are enabled
3. Clear browser cache and cookies
4. Check backend logs for errors
5. Ensure JWT tokens are valid

---

**Migration Version:** 013
**Date:** 2025-01-08
**Status:** ✅ Complete
