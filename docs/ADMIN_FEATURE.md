# Admin Panel – Feature Specification (E-commerce Side Project)
## 1. Dashboard
### Required
- Show total orders (today / month)
- Show total revenue
- Show total users
- Show total products
- Show number of unconfirmed orders
- Show orders by status (pending / confirmed / shipping / completed / cancelled)
- Revenue chart by day/week
- Top selling products
- Payment method breakdown (COD / Online)

---

## 2. Order Management
### Required (MVP)
- List orders in a table (pagination, sorting)
- View order details
- Order status workflow:
  - pending
  - confirmed
  - processing
  - shipping
  - delivered
  - cancelled
  - refunded
- Manually confirm orders
- Manually canceled orders request
- View customer information
- View ordered products
- View payment method and payment status
- Export orders (CSV)
- Refund flag

---

## 3. Product Management
### Required (MVP)
- CRUD products
- CRUD product variants
- Upload product images (Supabase Storage, bucket:shopin_storage:product_images:[slug product])
- Assign category and brand
- Manage price and stock quantity
- Enable / disable product visibility
- SEO fields (meta title, description)

---

## 4. Article / Blog Management (CMS)
### Required (MVP)
- List articles
- Create / edit / delete articles
- Article status: draft / published
- Block-based editor (1 text blocks + 1 image blocks)
- Store article content as JSON (JSONB)
- SEO meta fields (title, description, keywords)
- Upload article images to Supabase Storage (bucket: shopin_storage: article_images)
- AI article generation from keywords and fill the form after generate done
    - modifiable prompt to generate
    - Reset prompt to default
    - Hard-code prompt in code: Dựa trên từ khóa: '{$keyword}', hãy viết một bài viết tin tức hoàn chỉnh bằng tiếng Việt.
    - Prompt to generate = Hard-code prompt /n + prompt input on interface 


---

## 5. User Management
### Required (MVP)
- List users
- View user details
- View user order history
- User roles: user / admin
- Enable / disable users
- Assign / revoke admin role (can't revoke myself)
- Trigger password reset email
- Login history
- Soft delete users
- Block user from chat

---

## 6. API Key & AI Configuration
### Required (MVP)
- Manage API keys (masked display)
- Select AI provider and model
- Configure API URL
- Configure AI prompt_default
- Test API connection

---

## 7. Coupon / Discount Management
### Required (MVP)
- CRUD discount coupons
- Discount type: percentage / fixed amount
- Usage limit
- Expiration date
- Enable / disable coupons

---

## 8. Category & Brand Management
### Required (MVP)
- CRUD categories
- CRUD brands
- Assign products to categories and brands

---

## 9. Customer Support (Realtime Chat)
### Required (MVP)
- List customer conversations
- Real-time 1–1 chat with customers
- UI messages as read/unread
- Online / offline customers

---

## 10. Settings (Admin Settings – Beta)
### Required (MVP)
- Shop information settings
- Shipping configuration
- Payment configuration
- Default SEO configuration

---

## 11. Activity Log (Beta)
### Required (MVP)
- Log admin actions (who, action, target, time)
- Examples:
  - Admin A updated product X
  - Admin B confirmed order Y

### Nice to Have
- Filter logs by admin
- Filter logs by module
- Export activity logs

---

## Notes
- All admin routes must be protected by role-based access control (admin only).
- Avoid read-only or demo-only implementations.
- All modules should support basic CRUD and real admin workflows.
- Code should be clean, production-ready, and minimal.
