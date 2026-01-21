# API Testing Guide - ShopIn Admin APIs

This guide provides curl and Postman commands to test all admin APIs.

## Authentication

All admin APIs require authentication. First, you need to get an access token:

### Login
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@example.com",
    "password": "your_password"
  }'
```

**Response:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid",
    "email": "admin@example.com",
    "role": "admin"
  }
}
```

Save the `access_token` for use in subsequent requests.

## Article APIs

### 1. Generate Article Content (AI)

```bash
curl -X POST http://localhost:3000/admin/articles/generate \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "keyword": "iPhone 15 Pro Max",
    "topic": "Đánh giá sản phẩm",
    "customPrompt": "Viết bài đánh giá chi tiết về sản phẩm này..."
  }'
```

**Parameters:**
- `keyword` (required): Từ khóa chính để tạo nội dung
- `topic` (optional): Chủ đề bài viết
- `customPrompt` (optional): Prompt tùy chỉnh (nếu không có sẽ dùng default_prompt từ api_settings)

**Response:**
```json
{
  "success": true,
  "data": {
    "title": "iPhone 15 Pro Max: Đánh giá chi tiết sản phẩm",
    "body": "Nội dung bài viết...",
    "slug": "iphone-15-pro-max-danh-gia-chi-tiet-san-pham",
    "tags": ["iPhone", "Apple", "Smartphone"],
    "meta": {
      "meta_title": "iPhone 15 Pro Max - Review chi tiết",
      "meta_description": "Đánh giá toàn diện về iPhone 15 Pro Max...",
      "seo_keywords": "iphone 15 pro max, đánh giá iphone, apple smartphone"
    }
  }
}
```

### 2. Create Article

```bash
curl -X POST http://localhost:3000/admin/articles \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "title": "iPhone 15 Pro Max: Đánh giá chi tiết",
    "slug": "iphone-15-pro-max-danh-gia",
    "excerpt": "Đánh giá toàn diện về iPhone 15 Pro Max",
    "featured_image": "https://example.com/image.jpg",
    "topic": "Đánh giá sản phẩm",
    "keyword": "iPhone 15 Pro Max",
    "meta_title": "iPhone 15 Pro Max Review",
    "meta_description": "Đánh giá chi tiết iPhone 15 Pro Max",
    "seo_keywords": "iphone, apple, smartphone",
    "status": "published",
    "content_blocks": [
      {
        "type": "text",
        "content": "Nội dung đầu tiên...",
        "level": "p"
      },
      {
        "type": "heading",
        "content": "Thiết kế",
        "level": "h2"
      },
      {
        "type": "image",
        "url": "https://example.com/design.jpg",
        "alt": "Thiết kế iPhone 15 Pro Max"
      }
    ]
  }'
```

**Response:**
```json
{
  "id": "uuid",
  "title": "iPhone 15 Pro Max: Đánh giá chi tiết",
  "slug": "iphone-15-pro-max-danh-gia",
  "status": "published",
  "created_at": "2025-06-08T10:00:00Z",
  "updated_at": "2025-06-08T10:00:00Z"
}
```

### 3. Get All Articles

```bash
curl -X GET "http://localhost:3000/admin/articles?page=1&limit=10&status=published&search=iphone" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Query Parameters:**
- `page`: Trang hiện tại (default: 1)
- `limit`: Số lượng mỗi trang (default: 10)
- `status`: Lọc theo trạng thái (draft/published)
- `search`: Tìm kiếm theo title/keyword

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "title": "iPhone 15 Pro Max",
      "slug": "iphone-15-pro-max",
      "excerpt": "...",
      "status": "published",
      "created_at": "2025-06-08T10:00:00Z"
    }
  ],
  "total": 50,
  "page": 1,
  "limit": 10,
  "totalPages": 5
}
```

### 4. Get Article by ID

```bash
curl -X GET http://localhost:3000/admin/articles/ARTICLE_ID \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Response:**
```json
{
  "id": "uuid",
  "title": "iPhone 15 Pro Max",
  "slug": "iphone-15-pro-max",
  "excerpt": "...",
  "featured_image": "https://...",
  "topic": "Đánh giá sản phẩm",
  "keyword": "iPhone 15 Pro Max",
  "meta_title": "...",
  "meta_description": "...",
  "seo_keywords": "...",
  "status": "published",
  "content_blocks": [...],
  "created_at": "2025-06-08T10:00:00Z",
  "updated_at": "2025-06-08T10:00:00Z"
}
```

### 5. Update Article

```bash
curl -X PUT http://localhost:3000/admin/articles/ARTICLE_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "title": "iPhone 15 Pro Max - Updated",
    "status": "published",
    "content_blocks": [...]
  }'
```

### 6. Delete Article

```bash
curl -X DELETE http://localhost:3000/admin/articles/ARTICLE_ID \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Response:**
```json
{
  "message": "Article deleted successfully"
}
```

### 7. Upload Article Image

```bash
curl -X POST http://localhost:3000/admin/articles/upload-image \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -F "file=@/path/to/image.jpg"
```

**Response:**
```json
{
  "url": "https://storage.example.com/articles/image.jpg"
}
```

## Product APIs

### 1. Get All Products

```bash
curl -X GET "http://localhost:3000/admin/products?page=1&limit=20&category=laptop&search=macbook" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 2. Get Product by ID

```bash
curl -X GET http://localhost:3000/admin/products/PRODUCT_ID \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 3. Create Product

```bash
curl -X POST http://localhost:3000/admin/products \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "name": "MacBook Pro M3",
    "slug": "macbook-pro-m3",
    "description": "Laptop cao cấp",
    "price": 45000000,
    "compare_price": 50000000,
    "category": "laptop",
    "brand": "Apple",
    "sku": "MBP-M3-16-512",
    "stock": 10,
    "images": ["https://example.com/image1.jpg"],
    "specifications": {
      "CPU": "Apple M3",
      "RAM": "16GB",
      "Storage": "512GB SSD"
    },
    "is_featured": true,
    "is_active": true
  }'
```

### 4. Update Product

```bash
curl -X PUT http://localhost:3000/admin/products/PRODUCT_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "price": 43000000,
    "stock": 5
  }'
```

### 5. Delete Product

```bash
curl -X DELETE http://localhost:3000/admin/products/PRODUCT_ID \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## Order APIs

### 1. Get All Orders

```bash
curl -X GET "http://localhost:3000/admin/orders?page=1&limit=20&status=pending" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 2. Get Order by ID

```bash
curl -X GET http://localhost:3000/admin/orders/ORDER_ID \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 3. Update Order Status

```bash
curl -X PATCH http://localhost:3000/admin/orders/ORDER_ID/status \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "status": "processing"
  }'
```

**Status values:** `pending`, `processing`, `shipped`, `delivered`, `cancelled`

## User APIs

### 1. Get All Users

```bash
curl -X GET "http://localhost:3000/admin/users?page=1&limit=20&role=customer" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 2. Get User by ID

```bash
curl -X GET http://localhost:3000/admin/users/USER_ID \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 3. Update User

```bash
curl -X PUT http://localhost:3000/admin/users/USER_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "role": "admin",
    "is_active": true
  }'
```

### 4. Delete User

```bash
curl -X DELETE http://localhost:3000/admin/users/USER_ID \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## Settings APIs

### 1. Get API Settings

```bash
curl -X GET http://localhost:3000/admin/settings/api-settings \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Response:**
```json
[
  {
    "id": "uuid",
    "key": "openai",
    "name": "article",
    "model_name": "gpt-4",
    "api_endpoint": "https://api.openai.com/v1/chat/completions",
    "default_prompt": "Dựa trên từ khóa...",
    "description": "AI settings for article generation",
    "created_at": "2025-06-08T10:00:00Z",
    "updated_at": "2025-06-08T10:00:00Z"
  }
]
```

### 2. Update API Settings

```bash
curl -X PUT http://localhost:3000/admin/settings/api-settings/SETTING_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "model_name": "gpt-4-turbo",
    "default_prompt": "Updated prompt..."
  }'
```

### 3. Get Admin Settings

```bash
curl -X GET http://localhost:3000/admin/settings/admin-settings \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 4. Update Admin Settings

```bash
curl -X PUT http://localhost:3000/admin/settings/admin-settings/SETTING_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "key": "api_keys",
    "value": {
      "openai_key": "sk-..."
    }
  }'
```

## Postman Collection

Import this JSON into Postman for easier testing:

```json
{
  "info": {
    "name": "ShopIn Admin API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "auth": {
    "type": "bearer",
    "bearer": [
      {
        "key": "token",
        "value": "{{access_token}}",
        "type": "string"
      }
    ]
  },
  "item": [
    {
      "name": "Articles",
      "item": [
        {
          "name": "Generate Article Content",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"keyword\": \"iPhone 15 Pro Max\",\n  \"topic\": \"Đánh giá sản phẩm\",\n  \"customPrompt\": \"Viết bài đánh giá chi tiết...\"\n}"
            },
            "url": {
              "raw": "{{base_url}}/admin/articles/generate",
              "host": ["{{base_url}}"],
              "path": ["admin", "articles", "generate"]
            }
          }
        },
        {
          "name": "Create Article",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"title\": \"Test Article\",\n  \"slug\": \"test-article\",\n  \"status\": \"draft\"\n}"
            },
            "url": {
              "raw": "{{base_url}}/admin/articles",
              "host": ["{{base_url}}"],
              "path": ["admin", "articles"]
            }
          }
        },
        {
          "name": "Get All Articles",
          "request": {
            "method": "GET",
            "url": {
              "raw": "{{base_url}}/admin/articles?page=1&limit=10",
              "host": ["{{base_url}}"],
              "path": ["admin", "articles"],
              "query": [
                {"key": "page", "value": "1"},
                {"key": "limit", "value": "10"}
              ]
            }
          }
        }
      ]
    }
  ],
  "variable": [
    {
      "key": "base_url",
      "value": "http://localhost:3000"
    },
    {
      "key": "access_token",
      "value": ""
    }
  ]
}
```

## Testing Workflow

1. **Login** to get access token
2. **Set environment variable** `access_token` with the token from login
3. **Test article generation**:
   - Call `/admin/articles/generate` with keyword
   - Verify AI-generated content is returned
4. **Create article**:
   - Use generated content or custom data
   - Call `/admin/articles` POST
5. **Verify creation**:
   - Call `/admin/articles/ARTICLE_ID` GET
   - Verify all fields are saved correctly
6. **Update article**:
   - Call `/admin/articles/ARTICLE_ID` PUT
7. **Delete article**:
   - Call `/admin/articles/ARTICLE_ID` DELETE

## Common Error Responses

### 401 Unauthorized
```json
{
  "statusCode": 401,
  "message": "Unauthorized"
}
```
**Solution:** Check if access token is valid and included in Authorization header

### 400 Bad Request
```json
{
  "statusCode": 400,
  "message": ["field is required"],
  "error": "Bad Request"
}
```
**Solution:** Check request body matches required schema

### 404 Not Found
```json
{
  "statusCode": 404,
  "message": "Article not found"
}
```
**Solution:** Verify the ID exists in database

### 500 Internal Server Error
```json
{
  "statusCode": 500,
  "message": "Internal server error"
}
```
**Solution:** Check server logs for detailed error message
