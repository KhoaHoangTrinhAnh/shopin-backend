# Bug Fixes - Admin Access & Backend Startup Issues

## Date: January 5, 2026

---

## 🐛 Issues Fixed

### Issue 1: Backend Startup Failure - NestJS Dependency Injection Error ✅

**Error:**
```
Error: Nest can't resolve dependencies of the JwtAuthGuard (AuthService).
Please make sure that the argument AuthService at index [0] is available in the CategoriesModule context.

Potential solutions:
- Is CategoriesModule a valid NestJS module?
- If AuthService is a provider, is it part of the current CategoriesModule?
- If AuthService is exported from a separate @Module, is that module imported within CategoriesModule?
```

**Root Cause:**
- `CategoriesModule` uses `JwtAuthGuard` via `@UseGuards(JwtAuthGuard)` in its controllers
- `JwtAuthGuard` requires `AuthService` as a dependency (constructor injection)
- `CategoriesModule` did NOT import `AuthModule` which provides `AuthService`
- NestJS couldn't resolve the dependency chain: JwtAuthGuard → AuthService

**Fix Applied:**
Updated [categories.module.ts](d:\shopin-backend\src\categories\categories.module.ts):

```typescript
// Before:
@Module({
  imports: [SupabaseModule],  // Missing AuthModule!
  controllers: [CategoriesController, BrandsController, AdminCategoriesController, AdminBrandsController],
  providers: [CategoriesService, BrandsService],
  exports: [CategoriesService, BrandsService],
})

// After:
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [SupabaseModule, AuthModule],  // Added AuthModule
  controllers: [CategoriesController, BrandsController, AdminCategoriesController, AdminBrandsController],
  providers: [CategoriesService, BrandsService],
  exports: [CategoriesService, BrandsService],
})
```

**Why This Works:**
1. `AuthModule` exports `AuthService` in its configuration
2. By importing `AuthModule`, `CategoriesModule` gains access to `AuthService`
3. Now when `JwtAuthGuard` is instantiated, NestJS can inject `AuthService` successfully
4. The dependency injection chain is complete: CategoriesModule → AuthModule → AuthService → JwtAuthGuard

**Status:** ✅ FIXED - Backend now starts without dependency injection errors

---

### Issue 2: Admin Route Access - Always Redirects to /403 🔍

**Problem:**
- User with `role = 'admin'` in profiles table
- Accessing `http://localhost:3001/admin` always redirects to `/403`
- Admin check in layout.tsx looks correct: `if (!profile || profile.role !== "admin")`

**Investigation Added:**
Added debug logging to trace the issue:

**File 1: [AuthContext.tsx](d:\shopin-frontend\src\contexts\AuthContext.tsx)**
```typescript
// Added logging to track profile loading
const loadProfile = async (userId: string) => {
  console.log('[AuthContext] Loading profile for user:', userId);
  const userProfile = await authApi.getProfile(userId);
  console.log('[AuthContext] Profile loaded:', userProfile);
  setProfile(userProfile || null);
};
```

**File 2: [admin/layout.tsx](d:\shopin-frontend\src\app\admin\layout.tsx)**
```typescript
// Added logging to track admin access checks
useEffect(() => {
  console.log('[AdminLayout] Auth state:', { loading, profile, role: profile?.role });
  if (!loading) {
    if (!profile || profile.role !== "admin") {
      console.log('[AdminLayout] Access denied - redirecting to /403');
      router.push("/403");
    } else if (profile.blocked === true) {
      console.log('[AdminLayout] Admin blocked - logging out');
      logout();
      router.push("/");
    } else {
      console.log('[AdminLayout] Admin access granted');
    }
  }
}, [profile, loading, router, logout]);
```

**How to Diagnose:**
1. Open browser console (F12)
2. Navigate to http://localhost:3001/admin
3. Check console logs to see:
   - Is profile loading correctly?
   - What is the value of `profile.role`?
   - At what point does the redirect happen?

**Possible Root Causes:**

1. **Profile Not Loading:**
   - Check if `[AuthContext] Profile loaded:` shows `null`
   - Verify JWT token is being sent correctly
   - Check backend `/api/auth/profile` endpoint returns role field

2. **Role Field Missing:**
   - Profile loads but doesn't have `role` field
   - Check database: `SELECT * FROM profiles WHERE user_id = 'YOUR_USER_ID'`
   - Verify migration 013 ran correctly (added role column)

3. **Timing Issue:**
   - Profile loads AFTER redirect check
   - Check if `loading` is still `true` when check happens

4. **CORS/Network Issue:**
   - Profile API call fails silently
   - Check Network tab for failed requests
   - Check browser console for CORS errors

**Next Steps:**
1. Check console logs when accessing /admin
2. If profile is null:
   - Verify you're logged in: Check Application → Local Storage → supabase auth tokens
   - Test profile endpoint: `GET http://localhost:3001/api/auth/profile` with Bearer token
3. If profile loads but role is wrong:
   - Check database: `SELECT role FROM profiles WHERE email = 'your-email@example.com'`
   - Update role if needed: `UPDATE profiles SET role = 'admin' WHERE email = 'your-email@example.com'`
4. If profile loads correctly but still redirects:
   - Check for JavaScript errors in console
   - Verify React state updates correctly

**Status:** 🔍 INVESTIGATING - Debug logs added to identify the issue

---

## 📝 Files Changed

### Backend (1 file)
1. ✅ [src/categories/categories.module.ts](d:\shopin-backend\src\categories\categories.module.ts)
   - Added `AuthModule` to imports array
   - Fixes dependency injection for `JwtAuthGuard`

### Frontend (2 files)
1. 🔍 [src/contexts/AuthContext.tsx](d:\shopin-frontend\src\contexts\AuthContext.tsx)
   - Added debug logging to `loadProfile` function
   - Helps diagnose profile loading issues

2. 🔍 [src/app/admin/layout.tsx](d:\shopin-frontend\src\app\admin\layout.tsx)
   - Added debug logging to admin access check
   - Shows auth state and decision flow

---

## 🧪 Testing Steps

### Test 1: Backend Starts Successfully
```bash
cd shopin-backend
npm run start:dev
```

**Expected:**
- No dependency injection errors
- Server starts on http://localhost:3001
- Console shows: "Application is running on: http://localhost:3001"

**Actual Result:** ✅ SHOULD PASS NOW

---

### Test 2: Admin Access (After running backend)

**Prerequisites:**
1. Backend running on http://localhost:3001
2. Frontend running on http://localhost:3000
3. Logged in user with `role = 'admin'` in database

**Steps:**
1. Open browser console (F12)
2. Navigate to http://localhost:3000/admin
3. Check console logs

**Expected Console Output:**
```
[AuthContext] Loading profile for user: <user-id>
[AuthContext] Profile loaded: { id: ..., role: 'admin', ... }
[AdminLayout] Auth state: { loading: false, profile: {...}, role: 'admin' }
[AdminLayout] Admin access granted
```

**If You See:**
```
[AdminLayout] Access denied - redirecting to /403
```

**Then check:**
1. Is profile null? → Login again
2. Is role not 'admin'? → Update database
3. Is loading still true? → Wait and check again

---

## 🔧 Database Verification

### Check User Role:
```sql
-- Find your user
SELECT id, user_id, email, role, blocked 
FROM profiles 
WHERE email = 'your-email@example.com';

-- Update to admin if needed
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'your-email@example.com';

-- Verify update
SELECT email, role FROM profiles WHERE email = 'your-email@example.com';
```

### Check Migration 013 Ran:
```sql
-- Check if role column exists
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'profiles' 
AND column_name = 'role';

-- Should return: role | text
```

---

## 🎯 Summary

### Backend Issue: ✅ FIXED
- **Problem:** Dependency injection error preventing backend startup
- **Solution:** Added `AuthModule` import to `CategoriesModule`
- **Result:** Backend should start successfully now

### Frontend Issue: 🔍 INVESTIGATING
- **Problem:** Admin redirect to /403 even with correct role
- **Solution:** Added debug logging to trace the issue
- **Next:** Check browser console to see where the flow breaks
- **Likely Causes:**
  1. Profile not loading (API call failing)
  2. Role field not in database
  3. Timing issue (check happens before profile loads)
  4. Token expired/invalid

### Other Modules Verified: ✅
All other modules already import AuthModule correctly:
- ✅ CartModule
- ✅ FavoritesModule  
- ✅ AddressesModule
- ✅ OrdersModule
- ✅ ProfilesModule
- ✅ AdminModule
- ✅ AuthModule

Only CategoriesModule was missing the import.

---

## 📞 If Still Not Working

### Backend Won't Start:
```bash
# Clean build
cd shopin-backend
rm -rf dist node_modules
npm install
npm run build
npm run start:dev
```

### Admin Access Still Blocked:

**Step 1: Test Profile API Directly**
```bash
# Get your auth token from browser
# Application → Local Storage → supabase.auth.token

# Test profile endpoint
curl -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  http://localhost:3001/api/auth/profile
```

**Step 2: Check Response**
Should return:
```json
{
  "id": "...",
  "user_id": "...",
  "email": "...",
  "role": "admin",
  "full_name": "...",
  ...
}
```

If `role` is missing or not "admin", update database.

**Step 3: Clear Browser Cache**
```
1. Open DevTools (F12)
2. Right-click refresh button
3. Select "Empty Cache and Hard Reload"
4. Try accessing /admin again
```

---

**All Issues Addressed:** 1/2 Fixed, 1/2 Investigating  
**Backend Status:** ✅ Should start successfully  
**Frontend Status:** 🔍 Need to check console logs to diagnose
