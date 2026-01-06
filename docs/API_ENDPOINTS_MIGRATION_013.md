# API ENDPOINTS DOCUMENTATION - Migration 013

## Admin Settings API

### Shop Info

**Get Shop Info**
```http
GET /api/admin/settings/shop-info
Authorization: Bearer {token}
```

Response:
```json
{
  "shop_name": "ShopIn",
  "contact_email": "contact@shopin.vn",
  "hotline": "+84 123 456 789"
}
```

**Update Shop Info**
```http
PUT /api/admin/settings/shop-info
Authorization: Bearer {token}
Content-Type: application/json

{
  "shop_name": "ShopIn",
  "contact_email": "contact@shopin.vn",
  "hotline": "+84 123 456 789"
}
```

---

### Shipping Config

**Get Shipping Config**
```http
GET /api/admin/settings/shipping
Authorization: Bearer {token}
```

Response:
```json
{
  "default_shipping_fee": 30000,
  "estimated_delivery_days": 3
}
```

**Update Shipping Config**
```http
PUT /api/admin/settings/shipping
Authorization: Bearer {token}
Content-Type: application/json

{
  "default_shipping_fee": 30000,
  "estimated_delivery_days": 3
}
```

---

### Order Config

**Get Order Config**
```http
GET /api/admin/settings/order
Authorization: Bearer {token}
```

Response:
```json
{
  "cod_enabled": true
}
```

**Update Order Config**
```http
PUT /api/admin/settings/order
Authorization: Bearer {token}
Content-Type: application/json

{
  "cod_enabled": true
}
```

---

### Default SEO

**Get Default SEO**
```http
GET /api/admin/settings/seo
Authorization: Bearer {token}
```

Response:
```json
{
  "meta_title": "ShopIn - Mua sắm trực tuyến",
  "meta_description": "Cửa hàng điện tử trực tuyến uy tín, giá tốt"
}
```

**Update Default SEO**
```http
PUT /api/admin/settings/seo
Authorization: Bearer {token}
Content-Type: application/json

{
  "meta_title": "ShopIn - Mua sắm trực tuyến",
  "meta_description": "Cửa hàng điện tử trực tuyến uy tín, giá tốt"
}
```

---

### API Settings

**Get All API Settings**
```http
GET /api/admin/settings/api
Authorization: Bearer {token}
```

Response:
```json
[
  {
    "id": "uuid",
    "key": "article_generation",
    "model_name": "gpt-4",
    "api_endpoint": "https://api.openai.com/v1/chat/completions",
    "default_prompt": "...",
    "description": "Tạo nội dung bài viết tự động từ từ khóa",
    "created_at": "2025-01-08T...",
    "updated_at": "2025-01-08T..."
  }
]
```

**Get Specific API Setting**
```http
GET /api/admin/settings/api/{key}
Authorization: Bearer {token}
```

Example: `GET /api/admin/settings/api/article_generation`

Response:
```json
{
  "id": "uuid",
  "key": "article_generation",
  "model_name": "gpt-4",
  "api_endpoint": "https://api.openai.com/v1/chat/completions",
  "default_prompt": "...",
  "description": "Tạo nội dung bài viết tự động từ từ khóa"
}
```

**Update API Setting**
```http
PUT /api/admin/settings/api/{key}
Authorization: Bearer {token}
Content-Type: application/json

{
  "model_name": "gpt-4",
  "api_endpoint": "https://api.openai.com/v1/chat/completions",
  "default_prompt": "Your custom prompt here...",
  "description": "Tạo nội dung bài viết tự động từ từ khóa"
}
```

---

## Audit Logs API

### Get Audit Logs

**List Audit Logs**
```http
GET /api/admin/audit-logs?page=1&limit=20&admin_id=&resource_type=&action=&start_date=&end_date=
Authorization: Bearer {token}
```

Query Parameters:
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20)
- `admin_id` (optional): Filter by admin ID
- `resource_type` (optional): Filter by resource type (articles, coupons, settings, etc.)
- `action` (optional): Filter by action (create, update, delete, etc.)
- `start_date` (optional): Filter from date (ISO 8601)
- `end_date` (optional): Filter to date (ISO 8601)

Response:
```json
{
  "data": [
    {
      "id": "uuid",
      "admin_id": "uuid",
      "action": "update",
      "resource_type": "settings",
      "resource_id": "shop_info",
      "details": {
        "old_value": {...},
        "new_value": {...}
      },
      "ip_address": "192.168.1.1",
      "user_agent": "Mozilla/5.0...",
      "created_at": "2025-01-08T...",
      "admin": {
        "id": "uuid",
        "full_name": "Admin Name",
        "email": "admin@example.com",
        "avatar_url": "https://..."
      }
    }
  ],
  "meta": {
    "total": 100,
    "page": 1,
    "limit": 20,
    "totalPages": 5
  }
}
```

**Get Audit Log Detail**
```http
GET /api/admin/audit-logs/{id}
Authorization: Bearer {token}
```

Response:
```json
{
  "id": "uuid",
  "admin_id": "uuid",
  "action": "update",
  "resource_type": "settings",
  "resource_id": "shop_info",
  "details": {
    "changed_fields": ["shop_name", "contact_email"],
    "old_values": {...},
    "new_values": {...}
  },
  "ip_address": "192.168.1.1",
  "user_agent": "Mozilla/5.0...",
  "created_at": "2025-01-08T...",
  "admin": {
    "id": "uuid",
    "full_name": "Admin Name",
    "email": "admin@example.com",
    "avatar_url": "https://..."
  }
}
```

**Get Audit Log Statistics**
```http
GET /api/admin/audit-logs/stats/summary?days=30
Authorization: Bearer {token}
```

Query Parameters:
- `days` (optional): Number of days to calculate stats (default: 30)

Response:
```json
{
  "total_logs": 150,
  "by_action": {
    "create": 50,
    "update": 80,
    "delete": 20
  },
  "by_resource": {
    "articles": 60,
    "settings": 40,
    "coupons": 30,
    "users": 20
  },
  "by_day": {
    "2025-01-08": 15,
    "2025-01-07": 20,
    "2025-01-06": 18,
    ...
  }
}
```

---

## Legacy Endpoints (Still Supported)

### AI Settings (Legacy)

**Get AI Settings**
```http
GET /api/admin/settings/ai
Authorization: Bearer {token}
```

**Update AI Settings**
```http
PUT /api/admin/settings/ai
Authorization: Bearer {token}
Content-Type: application/json

{
  "api_key": "sk-...",
  "model": "gpt-4",
  "api_url": "https://api.openai.com/v1/chat/completions",
  "prompt": "..."
}
```

**Reset AI Prompt**
```http
POST /api/admin/settings/ai/reset-prompt
Authorization: Bearer {token}
```

---

### Shop Settings (Legacy)

**Get Shop Settings**
```http
GET /api/admin/settings/shop
Authorization: Bearer {token}
```

**Update Shop Settings**
```http
PUT /api/admin/settings/shop
Authorization: Bearer {token}
Content-Type: application/json

{
  "shop_name": "ShopIn",
  "shop_description": "...",
  "contact_email": "...",
  "contact_phone": "...",
  "address": "...",
  "social_links": {
    "facebook": "...",
    "instagram": "...",
    "youtube": "..."
  },
  "shipping_fee": 30000,
  "free_shipping_threshold": 5000000
}
```

---

### Get All Settings

**Get All Settings**
```http
GET /api/admin/settings
Authorization: Bearer {token}
```

Response:
```json
{
  "ai": {
    "api_key": "***...",
    "has_api_key": true,
    "model": "gpt-4",
    "api_url": "...",
    "prompt": "..."
  },
  "shop": {
    "shop_name": "ShopIn",
    "shop_description": "...",
    "contact_email": "...",
    ...
  }
}
```

---

## Error Responses

### 401 Unauthorized
```json
{
  "statusCode": 401,
  "message": "Unauthorized",
  "error": "Unauthorized"
}
```

### 403 Forbidden (Not Admin)
```json
{
  "statusCode": 403,
  "message": "Chỉ admin mới có quyền truy cập",
  "error": "Forbidden"
}
```

### 403 Forbidden (Blocked Admin)
```json
{
  "statusCode": 403,
  "message": "Tài khoản admin đã bị khóa",
  "error": "Forbidden"
}
```

### 400 Bad Request
```json
{
  "statusCode": 400,
  "message": "Lỗi khi cập nhật...",
  "error": "Bad Request"
}
```

### 404 Not Found
```json
{
  "statusCode": 404,
  "message": "Không tìm thấy...",
  "error": "Not Found"
}
```

---

## Testing with cURL

### Get Shop Info
```bash
curl -X GET \
  https://your-backend.com/api/admin/settings/shop-info \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN'
```

### Update Shipping Config
```bash
curl -X PUT \
  https://your-backend.com/api/admin/settings/shipping \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "default_shipping_fee": 35000,
    "estimated_delivery_days": 2
  }'
```

### Get Audit Logs
```bash
curl -X GET \
  'https://your-backend.com/api/admin/audit-logs?page=1&limit=10' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN'
```

---

## TypeScript Types

```typescript
// Shop Info
interface ShopInfo {
  shop_name: string;
  contact_email: string;
  hotline: string;
}

// Shipping Config
interface ShippingConfig {
  default_shipping_fee: number;
  estimated_delivery_days: number;
}

// Order Config
interface OrderConfig {
  cod_enabled: boolean;
}

// Default SEO
interface DefaultSEO {
  meta_title: string;
  meta_description: string;
}

// API Settings
interface APISettings {
  id?: string;
  key: string;
  model_name: string;
  api_endpoint: string;
  default_prompt: string;
  description: string;
  created_at?: string;
  updated_at?: string;
}

// Audit Log
interface AuditLog {
  id: string;
  admin_id: string;
  action: string;
  resource_type: string;
  resource_id?: string;
  details?: Record<string, any>;
  ip_address?: string;
  user_agent?: string;
  created_at: string;
  admin?: {
    id: string;
    full_name: string;
    email: string;
    avatar_url?: string;
  };
}
```
