# 🛍️ ShopIn Backend

<p align="center">
  <img src="https://nestjs.com/img/logo-small.svg" width="80" alt="NestJS Logo" />
</p>

<p align="center">
  Backend API cho hệ thống thương mại điện tử ShopIn - Xây dựng với NestJS, TypeScript và Supabase
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#tech-stack">Tech Stack</a> •
  <a href="#getting-started">Getting Started</a> •
  <a href="#api-endpoints">API Endpoints</a> •
  <a href="#deployment">Deployment</a>
</p>

---

## 📋 Mục lục

- [Tổng quan](#-tổng-quan)
- [Features](#-features)
- [Tech Stack](#️-tech-stack)
- [Cấu trúc dự án](#-cấu-trúc-dự-án)
- [Getting Started](#-getting-started)
- [Environment Variables](#-environment-variables)
- [Database Schema](#️-database-schema)
- [API Endpoints](#-api-endpoints)
- [Authentication](#-authentication)
- [Testing](#-testing)
- [Deployment](#-deployment)
- [Documentation](#-documentation)

---

## 🎯 Tổng quan

**ShopIn Backend** là RESTful API server cho nền tảng thương mại điện tử toàn diện. Hệ thống được xây dựng với NestJS framework, sử dụng Supabase làm database và authentication backend, cung cấp các tính năng:

- 🛒 Quản lý sản phẩm, danh mục, thương hiệu
- 👤 Xác thực người dùng và quản lý hồ sơ
- 🛍️ Giỏ hàng và đơn hàng
- 💳 Tích hợp thanh toán (Stripe)
- 📝 Hệ thống blog/tin tức với AI generation
- 🎫 Mã giảm giá và khuyến mãi
- 💬 Chat hỗ trợ khách hàng real-time
- 👨‍💼 Admin panel với đầy đủ CRUD operations
- 📊 Audit logs và monitoring
- 🤖 AI-powered article generation (OpenRouter)

### 📌 Về Dự Án

> **Lưu ý quan trọng:** ShopIn là **side project cá nhân** được tạo ra với mục đích:
> - 🎓 **Học tập và rèn luyện kỹ năng** phát triển fullstack website
> - 💻 **Thực hành các công nghệ hiện đại**: NestJS, Next.js, TypeScript, Supabase
> - 🔧 **Nghiên cứu kiến trúc** hệ thống e-commerce quy mô lớn
>
> ⚠️ **Dự án KHÔNG có mục đích thương mại** và không được sử dụng cho môi trường production thực tế.

### 📊 Dữ Liệu Sản Phẩm

Dữ liệu sản phẩm trong hệ thống là **dữ liệu thực tế** được thu thập từ TheGioiDiDong.com thông qua web crawler:

**Data Source:** [TheGioiDiDong Product Crawler](https://github.com/KhoaHoangTrinhAnh/thegioididong-product-crawler)

- 📱 **490+ sản phẩm** thực tế (điện thoại, laptop, smartwatch, tablet)
- 🏷️ **1750+ biến thể** sản phẩm (màu sắc, dung lượng, size)
- 🖼️ **3750+ hình ảnh** sản phẩm chất lượng cao
- 📝 **Thông số kỹ thuật đầy đủ** (CPU, RAM, Storage, Display...)
- 💰 **Giá cả thực tế** từ thị trường Việt Nam

> Dataset được tự động crawl và convert thành SQL scripts ready-to-import vào Supabase/PostgreSQL.

---

## ✨ Features

### 🛒 E-commerce Core
- **Product Management:** CRUD sản phẩm với variants, images, specifications
- **Category & Brand:** Phân loại sản phẩm theo danh mục và thương hiệu
- **Inventory:** Quản lý tồn kho, stock tracking
- **Search & Filter:** Tìm kiếm và lọc sản phẩm theo nhiều tiêu chí
- **Pricing:** Giá gốc, giá khuyến mãi, giảm giá theo %

### 👤 User Management
- **Authentication:** JWT-based auth với Supabase
- **User Profiles:** Quản lý thông tin cá nhân, avatar
- **Addresses:** Lưu nhiều địa chỉ giao hàng
- **Favorites:** Danh sách yêu thích
- **Order History:** Lịch sử đơn hàng

### 🛍️ Shopping Experience
- **Shopping Cart:** Giỏ hàng với variants selection
- **Checkout:** Quy trình thanh toán hoàn chỉnh
- **Payment:** Tích hợp SePay payment gateway
- **Order Tracking:** Theo dõi trạng thái đơn hàng
- **Coupons:** Áp dụng mã giảm giá

### 📝 Content Management
- **Blog/News Articles:** Quản lý bài viết tin tức
- **AI Article Generation:** Tạo nội dung tự động với OpenRouter AI
- **SEO Optimization:** Meta tags, slugs, keywords
- **Rich Text Editor:** Hỗ trợ HTML content

### 💬 Communication
- **Real-time Chat:** Hỗ trợ khách hàng qua chat
- **Conversations:** Quản lý cuộc hội thoại
- **Admin Dashboard:** Quản lý chat từ admin panel

### 👨‍💼 Admin Panel
- **Dashboard:** Thống kê tổng quan
- **Product Management:** CRUD sản phẩm, categories, brands
- **Order Management:** Quản lý đơn hàng, cập nhật trạng thái
- **User Management:** Quản lý người dùng, profiles
- **Coupon Management:** Tạo và quản lý mã giảm giá
- **Article Management:** CRUD articles với AI generation
- **Settings:** Cấu hình hệ thống, API settings
- **Audit Logs:** Theo dõi hoạt động admin

### 🤖 AI Features
- **Article Generation:** Tạo bài viết tự động từ keyword
- **Customizable Prompts:** Template prompt có cấu trúc (JSONB)
- **Multi-provider Support:** OpenRouter, OpenAI
- **Rate Limiting:** 10 requests/hour per user
- **Usage Tracking:** Log tất cả AI requests

---

## 🛠️ Tech Stack

### Core Framework
- **NestJS** 11.x - Progressive Node.js framework
- **TypeScript** 5.x - Type-safe development
- **Node.js** 20+ - Runtime environment

### Database & Auth
- **Supabase** - PostgreSQL database + Auth
- **Prisma Client** 6.x - Type-safe ORM
- **PostgreSQL** - Relational database

### Authentication & Security
- **Passport JWT** - JWT authentication strategy
- **bcrypt** - Password hashing
- **class-validator** - DTO validation
- **class-transformer** - Data transformation

### Payment & External Services
- **SePay** - Payment processing
- **OpenRouter** - AI article generation
- **Supabase Storage** - File storage

### Development Tools
- **Jest** - Unit & E2E testing
- **ESLint** - Code linting
- **Prettier** - Code formatting
- **SWC** - Fast TypeScript compiler

---

## 📁 Cấu trúc dự án

```
shopin-backend/
├── src/
│   ├── addresses/          # Địa chỉ giao hàng
│   ├── admin/              # Admin panel controllers & services
│   │   ├── admin.controller.ts
│   │   ├── articles.controller.ts
│   │   ├── articles.service.ts
│   │   ├── audit-logs.controller.ts
│   │   ├── chat.controller.ts
│   │   ├── coupons.controller.ts
│   │   ├── products.controller.ts
│   │   ├── settings.controller.ts
│   │   └── dto/
│   ├── auth/               # Authentication
│   ├── cart/               # Giỏ hàng
│   ├── categories/         # Danh mục & thương hiệu
│   ├── conversations/      # Chat system
│   ├── favorites/          # Sản phẩm yêu thích
│   ├── orders/             # Đơn hàng
│   ├── products/           # Sản phẩm
│   ├── profiles/           # User profiles
│   ├── common/             # Shared utilities
│   ├── config/             # Configuration
│   ├── decorators/         # Custom decorators
│   ├── guards/             # Auth guards
│   ├── supabase/           # Supabase client
│   ├── app.module.ts       # Root module
│   └── main.ts             # Entry point
├── database/               # SQL migrations
│   ├── 001_schema.sql
│   ├── 002-017_*.sql
│   └── 018_fix_api_settings_and_add_usage_logs.sql
├── docs/                   # Documentation
│   ├── features/
│   │   ├── AI_ARTICLE_GENERATION.md
│   │   └── ADMIN_FEATURE.md
│   └── *.md
├── test/                   # E2E tests
├── .env.example            # Environment template
├── nest-cli.json           # NestJS CLI config
├── package.json
└── tsconfig.json
```

---

## 🚀 Getting Started

### Prerequisites

- **Node.js** >= 20.x
- **npm** >= 10.x
- **PostgreSQL** (hoặc Supabase account)
- **Supabase Account** (cho auth & storage)

### Installation

1. **Clone repository:**
```bash
git clone https://github.com/your-username/shopin-backend.git
cd shopin-backend
```

2. **Install dependencies:**
```bash
npm install
```

3. **Setup environment variables:**
```bash
cp .env.example .env
```

Chỉnh sửa `.env` với thông tin của bạn:
```env
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
DATABASE_URL=postgresql://postgres:password@host:port/database
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# App Configuration
PORT=3000
APP_BASE_URL=http://localhost:3000
FRONTEND_URL=http://localhost:3001

# Optional: AI Features
OPENROUTER_API_KEY=sk-or-v1-xxxxx
```

4. **Run database migrations:**
```bash
# Kết nối đến PostgreSQL/Supabase và chạy các file trong database/
# Hoặc sử dụng Supabase SQL Editor để run migrations
```

5. **Import product data (Optional):**

Để có dữ liệu sản phẩm thực tế, import từ [TheGioiDiDong Crawler](https://github.com/KhoaHoangTrinhAnh/thegioididong-product-crawler):

```bash
# Clone crawler repository
git clone https://github.com/KhoaHoangTrinhAnh/thegioididong-product-crawler.git
cd thegioididong-product-crawler

# Sử dụng file SQL đã có sẵn hoặc crawl mới
# Import database_inserts.sql vào Supabase SQL Editor
```

6. **Start development server:**
```bash
npm run start:dev
```

Server sẽ chạy tại: `http://localhost:3000`

### Development Commands

```bash
# Development mode (watch mode)
npm run start:dev

# Production build
npm run build
npm run start:prod

# Run tests
npm run test              # Unit tests
npm run test:watch        # Watch mode
npm run test:cov          # Coverage
npm run test:e2e          # E2E tests

# Code quality
npm run lint              # ESLint
npm run format            # Prettier
```

---

## 🔐 Environment Variables

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `SUPABASE_URL` | Supabase project URL | `https://xxx.supabase.co` |
| `SUPABASE_ANON_KEY` | Supabase anonymous key | `eyJhbGci...` |
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://...` |
| `SUPABASE_SERVICE_ROLE_KEY` | Service role key (admin) | `eyJhbGci...` |
| `PORT` | Server port | `3000` |
| `APP_BASE_URL` | Backend base URL | `http://localhost:3000` |
| `FRONTEND_URL` | Frontend URL (CORS) | `http://localhost:3001` |

### Optional Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `OPENROUTER_API_KEY` | OpenRouter API key for AI | - |
| `OPENROUTER_ENDPOINT` | OpenRouter endpoint | `https://openrouter.ai/api/v1/chat/completions` |
| `OPENROUTER_MODEL` | AI model name | `meta-llama/llama-3.3-70b-instruct:free` |

---

## 🗄️ Database Schema

### Core Tables

- **profiles** - User profiles
- **products** - Sản phẩm
- **product_variants** - Biến thể sản phẩm
- **product_images** - Hình ảnh sản phẩm
- **categories** - Danh mục
- **brands** - Thương hiệu
- **cart_items** - Giỏ hàng
- **orders** - Đơn hàng
- **order_items** - Chi tiết đơn hàng
- **addresses** - Địa chỉ giao hàng
- **favorites** - Sản phẩm yêu thích
- **coupons** - Mã giảm giá

### Content & Admin

- **articles** - Bài viết blog/tin tức
- **conversations** - Cuộc hội thoại chat
- **messages** - Tin nhắn
- **admin_settings** - Cấu hình admin
- **api_settings** - Cấu hình API (AI)
- **ai_usage_logs** - Log AI usage
- **audit_logs** - Audit trail

### Migrations

Tất cả migrations nằm trong thư mục `database/`:
- `001_schema.sql` - Initial schema
- `002-017_*.sql` - Feature migrations
- `018_fix_api_settings_and_add_usage_logs.sql` - AI features (latest)

---

## 📡 API Endpoints

### Authentication (`/auth`)

```http
POST   /auth/register          # Đăng ký
POST   /auth/login             # Đăng nhập
POST   /auth/logout            # Đăng xuất
GET    /auth/profile           # Lấy profile (auth required)
```

### Products (`/products`)

```http
GET    /products               # Danh sách sản phẩm (filter, search, pagination)
GET    /products/:id           # Chi tiết sản phẩm
GET    /products/slug/:slug    # Lấy sản phẩm theo slug
```

### Categories & Brands

```http
GET    /categories             # Danh sách danh mục
GET    /categories/:id         # Chi tiết danh mục
GET    /brands                 # Danh sách thương hiệu
```

### Cart (`/cart`)

```http
GET    /cart                   # Lấy giỏ hàng (auth)
POST   /cart                   # Thêm vào giỏ (auth)
PATCH  /cart/:id               # Cập nhật số lượng (auth)
DELETE /cart/:id               # Xóa khỏi giỏ (auth)
DELETE /cart                   # Xóa toàn bộ giỏ (auth)
```

### Orders (`/orders`)

```http
GET    /orders                 # Danh sách đơn hàng (auth)
GET    /orders/:id             # Chi tiết đơn hàng (auth)
POST   /orders                 # Tạo đơn hàng (auth)
POST   /orders/:id/cancel      # Hủy đơn hàng (auth)
```

### Addresses (`/addresses`)

```http
GET    /addresses              # Danh sách địa chỉ (auth)
POST   /addresses              # Thêm địa chỉ (auth)
PATCH  /addresses/:id          # Cập nhật địa chỉ (auth)
DELETE /addresses/:id          # Xóa địa chỉ (auth)
```

### Favorites (`/favorites`)

```http
GET    /favorites              # Danh sách yêu thích (auth)
POST   /favorites              # Thêm yêu thích (auth)
DELETE /favorites/:productId   # Xóa yêu thích (auth)
```

### Articles (`/articles`)

```http
GET    /articles               # Danh sách bài viết (public)
GET    /articles/:id           # Chi tiết bài viết
GET    /articles/slug/:slug    # Lấy theo slug
```

### Chat (`/chat`)

```http
GET    /chat/conversations     # Danh sách cuộc hội thoại (auth)
POST   /chat/conversations     # Tạo cuộc hội thoại (auth)
GET    /chat/:conversationId/messages  # Lấy tin nhắn
POST   /chat/:conversationId/messages  # Gửi tin nhắn (auth)
```

### Admin Endpoints (`/admin/*`)

> Tất cả admin endpoints yêu cầu JWT authentication và admin role

#### Products Management
```http
GET    /admin/products                    # Danh sách sản phẩm
POST   /admin/products                    # Tạo sản phẩm
PATCH  /admin/products/:id                # Cập nhật sản phẩm
DELETE /admin/products/:id                # Xóa sản phẩm
POST   /admin/products/:id/images         # Upload hình ảnh
```

#### Orders Management
```http
GET    /admin/orders                      # Danh sách đơn hàng
GET    /admin/orders/:id                  # Chi tiết đơn hàng
PATCH  /admin/orders/:id/status           # Cập nhật trạng thái
```

#### Articles Management
```http
GET    /admin/articles                    # Danh sách bài viết
POST   /admin/articles                    # Tạo bài viết
POST   /admin/articles/generate           # Generate bài viết bằng AI
PATCH  /admin/articles/:id                # Cập nhật bài viết
DELETE /admin/articles/:id                # Xóa bài viết
```

#### Coupons Management
```http
GET    /admin/coupons                     # Danh sách mã giảm giá
POST   /admin/coupons                     # Tạo coupon
PATCH  /admin/coupons/:id                 # Cập nhật coupon
DELETE /admin/coupons/:id                 # Xóa coupon
```

#### Settings & Logs
```http
GET    /admin/settings                    # Lấy settings
PATCH  /admin/settings                    # Cập nhật settings
GET    /admin/audit-logs                  # Audit logs
```

---

## 🔒 Authentication

### JWT Strategy

Backend sử dụng **JWT (JSON Web Tokens)** cho authentication:

1. User login → Server trả về JWT token
2. Client lưu token (localStorage/cookie)
3. Mỗi request gửi token trong header: `Authorization: Bearer <token>`
4. Server verify token và extract user info

### Protected Routes

Sử dụng `@UseGuards(JwtAuthGuard)` decorator:

```typescript
@Get('profile')
@UseGuards(JwtAuthGuard)
getProfile(@Request() req) {
  return req.user;
}
```

### Admin Routes

Sử dụng `@UseGuards(JwtAuthGuard, AdminGuard)`:

```typescript
@Post('products')
@UseGuards(JwtAuthGuard, AdminGuard)
createProduct(@Body() dto: CreateProductDto) {
  // Only admins can access
}
```

---

## 🧪 Testing

### Unit Tests

```bash
npm run test

# Test specific file
npm run test -- articles.service.spec

# Watch mode
npm run test:watch

# Coverage
npm run test:cov
```

### E2E Tests

```bash
npm run test:e2e
```

### Test Files

- `src/**/*.spec.ts` - Unit tests
- `test/*.e2e-spec.ts` - E2E tests

**Current Test Coverage:**
- Articles Service: ✅ 18/18 tests pass
- More tests coming soon...

---

## 🚀 Deployment

### Production Build

```bash
# Build application
npm run build

# Start production server
npm run start:prod
```

### Environment Setup

1. Setup production database (Supabase recommended)
2. Run all migrations from `database/` folder
3. Set production environment variables
4. Configure CORS for frontend domain
5. Setup SSL/HTTPS
6. Configure rate limiting

### Deployment Platforms

**Recommended:**
- **Railway** - Easy deployment with PostgreSQL
- **Render** - Free tier available
- **Heroku** - Classic PaaS
- **AWS/GCP/Azure** - Enterprise solutions
- **Vercel** - With serverless functions

### Docker (Optional)

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["npm", "run", "start:prod"]
```

---

## � Related Repositories

ShopIn là hệ thống fullstack bao gồm 3 repositories:

### 📦 Main Repositories

| Repository | Description | Link |
|------------|-------------|------|
| **Frontend** | Next.js 16 web application | [shopin-frontend](https://github.com/KhoaHoangTrinhAnh/shopin-frontend) |
| **Backend** | NestJS API server (repo này) | [shopin-backend](https://github.com/KhoaHoangTrinhAnh/shopin-backend) |
| **Crawler** | Python web crawler cho data | [thegioididong-product-crawler](https://github.com/KhoaHoangTrinhAnh/thegioididong-product-crawler) |

### 🔄 System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   SHOPIN ECOSYSTEM                      │
└─────────────────────────────────────────────────────────┘

   Crawler (Python)          Backend (NestJS)        Frontend (Next.js)
  ┌──────────────┐          ┌──────────────┐        ┌──────────────┐
  │              │          │              │        │              │
  │  Selenium    │  crawl   │  PostgreSQL  │  API   │   React 19   │
  │  BeautifulSoup│ ──────> │  Supabase    │ <────> │  TailwindCSS │
  │              │  data    │  NestJS      │  HTTP  │  TypeScript  │
  │              │          │              │        │              │
  └──────────────┘          └──────────────┘        └──────────────┘
       ↓                          ↓                        ↓
   JSON files              Database Schema            User Interface
   SQL scripts             REST API                   Admin Panel
   Product images          Authentication             E-commerce UI
```

---

## �📚 Documentation

### Feature Documentation

- [AI Article Generation](./docs/features/AI_ARTICLE_GENERATION.md) - AI-powered content generation
- [Admin Features](./docs/features/ADMIN_FEATURE.md) - Admin panel features
- [Chat System](./docs/CHAT_SYSTEM_IMPLEMENTATION_SUMMARY.md) - Real-time chat

### Implementation Guides

- [API Testing Guide](./docs/API_TESTING_GUIDE.md)
- [Migration Guide](./docs/MIGRATION_013_RESTRUCTURING_SUMMARY.md)
- [Deployment Guide](./AI_ARTICLE_GENERATION_DEPLOYMENT.md)

### API Documentation

API documentation có thể được generate bằng:
- Swagger/OpenAPI (coming soon)
- Postman Collection (coming soon)

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

### Code Style

- Follow TypeScript best practices
- Use ESLint and Prettier
- Write unit tests for new features
- Update documentation

---

## 📝 License

This project is licensed under the **UNLICENSED** license - see the package.json file for details.

---

## 👥 Authors

- **Development Team** - Initial work and maintenance

---

## 🙏 Acknowledgments

- **NestJS** - Amazing framework
- **Supabase** - Awesome backend platform
- **OpenRouter** - AI API provider
- **SePay** - Payment processing

---

## 📞 Support

For issues and questions:
- Create an issue on GitHub
- Contact: khoahoangtrinhanh@gmail.com

---

**Built with ❤️ using NestJS and TypeScript**
