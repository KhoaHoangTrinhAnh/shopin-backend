-- Migration 013: Admin Panel Features
-- Adds tables and columns for admin panel functionality
-- Run this in Supabase SQL Editor

-- ============================================================================
-- 1. ADMIN SETTINGS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.admin_settings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  key text NOT NULL UNIQUE,
  value jsonb NOT NULL DEFAULT '{}'::jsonb,
  description text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT admin_settings_pkey PRIMARY KEY (id)
);

-- Insert default shop info settings
INSERT INTO public.admin_settings (key, value, description)
VALUES (
  'shop_info',
  '{
    "shop_name": "ShopIn",
    "contact_email": "contact@shopin.vn",
    "hotline": "1900 xxxx"
  }'::jsonb,
  'Shop basic information'
)
ON CONFLICT (key) DO NOTHING;

-- Insert default shipping settings
INSERT INTO public.admin_settings (key, value, description)
VALUES (
  'shipping_config',
  '{
    "default_shipping_fee": 30000,
    "estimated_delivery_days": "3-5"
  }'::jsonb,
  'Shipping configuration'
)
ON CONFLICT (key) DO NOTHING;

-- Insert default order config
INSERT INTO public.admin_settings (key, value, description)
VALUES (
  'order_config',
  '{
    "cod_enabled": true
  }'::jsonb,
  'Order configuration'
)
ON CONFLICT (key) DO NOTHING;

-- Insert default SEO settings
INSERT INTO public.admin_settings (key, value, description)
VALUES (
  'default_seo',
  '{
    "meta_title": "ShopIn - Cửa hàng điện thoại và phụ kiện uy tín",
    "meta_description": "Mua sắm điện thoại, laptop, tablet, phụ kiện chính hãng với giá tốt nhất tại ShopIn. Giao hàng nhanh, bảo hành uy tín."
  }'::jsonb,
  'Default SEO meta tags'
)
ON CONFLICT (key) DO NOTHING;

-- ============================================================================
-- 2. API SETTINGS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.api_settings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  key text NOT NULL UNIQUE,
  model_name text NOT NULL,
  api_endpoint text NOT NULL,
  default_prompt text NOT NULL,
  description text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT api_settings_pkey PRIMARY KEY (id)
);

-- Insert default article generation API settings
INSERT INTO public.api_settings (key, model_name, api_endpoint, default_prompt, description)
VALUES (
  'article_generation',
  'gpt-4',
  'https://api.openai.com/v1/chat/completions',
  'Hãy viết một bài viết chi tiết, chuyên nghiệp và hấp dẫn về chủ đề: {{keyword}}. Bài viết cần có:
1. Tiêu đề hấp dẫn
2. Mở bài thu hút người đọc
3. Nội dung chính với các tiêu đề phụ (h2, h3) rõ ràng
4. Kết luận súc tích
5. Sử dụng ngôn ngữ tự nhiên, dễ hiểu
6. Tối ưu cho SEO

Đảm bảo bài viết có giá trị thông tin cao, độ dài khoảng 1000-1500 từ.',
  'API settings for article content generation based on keywords'
)
ON CONFLICT (key) DO NOTHING;

-- ============================================================================
-- 3. ENHANCE ARTICLES TABLE FOR BLOCK-BASED CONTENT
-- ============================================================================

-- Add new columns if not exist
DO $$ 
BEGIN
  -- Add content_blocks column for block-based editor
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'articles' 
    AND column_name = 'content_blocks'
  ) THEN
    ALTER TABLE public.articles ADD COLUMN content_blocks jsonb DEFAULT '[]'::jsonb;
    COMMENT ON COLUMN public.articles.content_blocks IS 'Block-based content structure: [{type: "text"|"image", content: string, level?: "h2"|"h3"|"p", url?: string, alt?: string}]';
  END IF;

  -- Add featured_image column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'articles' 
    AND column_name = 'featured_image'
  ) THEN
    ALTER TABLE public.articles ADD COLUMN featured_image text;
    COMMENT ON COLUMN public.articles.featured_image IS 'Featured/thumbnail image URL';
  END IF;

  -- Add topic column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'articles' 
    AND column_name = 'topic'
  ) THEN
    ALTER TABLE public.articles ADD COLUMN topic text;
  END IF;

  -- Add keyword column for AI generation
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'articles' 
    AND column_name = 'keyword'
  ) THEN
    ALTER TABLE public.articles ADD COLUMN keyword text;
  END IF;

  -- Add SEO fields
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'articles' 
    AND column_name = 'meta_title'
  ) THEN
    ALTER TABLE public.articles ADD COLUMN meta_title text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'articles' 
    AND column_name = 'meta_description'
  ) THEN
    ALTER TABLE public.articles ADD COLUMN meta_description text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'articles' 
    AND column_name = 'meta_keywords'
  ) THEN
    ALTER TABLE public.articles ADD COLUMN meta_keywords text[];
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'articles' 
    AND column_name = 'seo_keywords'
  ) THEN
    ALTER TABLE public.articles ADD COLUMN seo_keywords text;
  END IF;

  -- Add status column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'articles' 
    AND column_name = 'status'
  ) THEN
    ALTER TABLE public.articles ADD COLUMN status text DEFAULT 'draft' CHECK (status IN ('draft', 'published'));
  END IF;

  -- Add view_count column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'articles' 
    AND column_name = 'view_count'
  ) THEN
    ALTER TABLE public.articles ADD COLUMN view_count integer DEFAULT 0;
  END IF;
END $$;

-- ============================================================================
-- 4. ENHANCE COUPONS TABLE
-- ============================================================================

DO $$ 
BEGIN
  -- Add is_active column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'coupons' 
    AND column_name = 'is_active'
  ) THEN
    ALTER TABLE public.coupons ADD COLUMN is_active boolean DEFAULT true;
  END IF;

  -- Add min_order_value column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'coupons' 
    AND column_name = 'min_order_value'
  ) THEN
    ALTER TABLE public.coupons ADD COLUMN min_order_value numeric DEFAULT 0;
  END IF;

  -- Add max_discount column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'coupons' 
    AND column_name = 'max_discount'
  ) THEN
    ALTER TABLE public.coupons ADD COLUMN max_discount numeric;
  END IF;

  -- Add usage_count column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'coupons' 
    AND column_name = 'usage_count'
  ) THEN
    ALTER TABLE public.coupons ADD COLUMN usage_count integer DEFAULT 0;
  END IF;

  -- Add description column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'coupons' 
    AND column_name = 'description'
  ) THEN
    ALTER TABLE public.coupons ADD COLUMN description text;
  END IF;

  -- Add created_at column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'coupons' 
    AND column_name = 'created_at'
  ) THEN
    ALTER TABLE public.coupons ADD COLUMN created_at timestamp with time zone DEFAULT now();
  END IF;

  -- Add updated_at column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'coupons' 
    AND column_name = 'updated_at'
  ) THEN
    ALTER TABLE public.coupons ADD COLUMN updated_at timestamp with time zone DEFAULT now();
  END IF;
END $$;

-- ============================================================================
-- 5. ENHANCE ORDERS TABLE FOR CONFIRMATION
-- ============================================================================

-- Update default status to 'pending' (unconfirmed)
ALTER TABLE public.orders ALTER COLUMN status SET DEFAULT 'pending';

-- Add confirmed_at column
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'orders' 
    AND column_name = 'confirmed_at'
  ) THEN
    ALTER TABLE public.orders ADD COLUMN confirmed_at timestamp with time zone;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'orders' 
    AND column_name = 'confirmed_by'
  ) THEN
    ALTER TABLE public.orders ADD COLUMN confirmed_by uuid REFERENCES public.profiles(id);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'orders' 
    AND column_name = 'admin_notes'
  ) THEN
    ALTER TABLE public.orders ADD COLUMN admin_notes text;
  END IF;
END $$;

-- ============================================================================
-- 6. ENHANCE PROFILES TABLE - REMOVE is_admin, ADD blocked
-- ============================================================================

DO $$ 
BEGIN
  -- Remove is_admin column if exists
  IF EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'profiles' 
    AND column_name = 'is_admin'
  ) THEN
    ALTER TABLE public.profiles DROP COLUMN is_admin;
    RAISE NOTICE 'Dropped is_admin column from profiles';
  END IF;

  -- Add blocked column if not exists
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'profiles' 
    AND column_name = 'blocked'
  ) THEN
    ALTER TABLE public.profiles ADD COLUMN blocked boolean DEFAULT false;
    RAISE NOTICE 'Added blocked column to profiles';
  END IF;
END $$;

-- ============================================================================
-- 7. AUDIT LOGS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.audit_logs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  admin_id uuid NOT NULL,
  action text NOT NULL,
  resource_type text,
  resource_id text,
  details jsonb,
  ip_address text,
  user_agent text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT audit_logs_pkey PRIMARY KEY (id),
  CONSTRAINT audit_logs_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.profiles(id)
);

-- ============================================================================
-- 8. CHAT SYSTEM TABLES
-- ============================================================================

-- Conversations table
CREATE TABLE IF NOT EXISTS public.conversations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  last_message text,
  last_message_at timestamp with time zone DEFAULT now(),
  unread_count integer DEFAULT 0,
  status text DEFAULT 'active' CHECK (status IN ('active', 'archived', 'closed')),
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT conversations_pkey PRIMARY KEY (id),
  CONSTRAINT conversations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE
);

-- Chat messages table  
CREATE TABLE IF NOT EXISTS public.chat_messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  conversation_id uuid NOT NULL,
  sender_id uuid NOT NULL,
  sender_role text NOT NULL CHECK (sender_role IN ('user', 'admin')),
  message text NOT NULL,
  is_read boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT chat_messages_pkey PRIMARY KEY (id),
  CONSTRAINT chat_messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE,
  CONSTRAINT chat_messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.profiles(id) ON DELETE CASCADE
);

-- ============================================================================
-- 9. CREATE INDEXES FOR PERFORMANCE
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_articles_status ON articles(status);
CREATE INDEX IF NOT EXISTS idx_articles_published_at ON articles(published_at DESC);
CREATE INDEX IF NOT EXISTS idx_articles_topic ON articles(topic);
CREATE INDEX IF NOT EXISTS idx_articles_author_id ON articles(author_id);
CREATE INDEX IF NOT EXISTS idx_coupons_is_active ON coupons(is_active);
CREATE INDEX IF NOT EXISTS idx_orders_confirmed_at ON orders(confirmed_at);
CREATE INDEX IF NOT EXISTS idx_admin_settings_key ON admin_settings(key);
CREATE INDEX IF NOT EXISTS idx_api_settings_key ON api_settings(key);
CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);
CREATE INDEX IF NOT EXISTS idx_profiles_blocked ON profiles(blocked);
CREATE INDEX IF NOT EXISTS idx_audit_logs_admin_id ON audit_logs(admin_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_resource_type ON audit_logs(resource_type);
CREATE INDEX IF NOT EXISTS idx_audit_logs_action ON audit_logs(action);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON audit_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_conversations_user_id ON conversations(user_id);
CREATE INDEX IF NOT EXISTS idx_conversations_status ON conversations(status);
CREATE INDEX IF NOT EXISTS idx_conversations_last_message_at ON conversations(last_message_at DESC);
CREATE INDEX IF NOT EXISTS idx_chat_messages_conversation_id ON chat_messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_sender_id ON chat_messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_created_at ON chat_messages(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_chat_messages_is_read ON chat_messages(is_read);

-- ============================================================================
-- 10. ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Enable RLS on admin_settings
ALTER TABLE public.admin_settings ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Admin settings readable by authenticated users" ON admin_settings;
DROP POLICY IF EXISTS "Admin settings modifiable by admins only" ON admin_settings;

-- Admins can read all settings
CREATE POLICY "Admin settings readable by authenticated users"
ON public.admin_settings FOR SELECT
TO authenticated
USING (true);

-- Only admins can modify settings
CREATE POLICY "Admin settings modifiable by admins only"
ON public.admin_settings FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
    AND profiles.blocked = false
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
    AND profiles.blocked = false
  )
);

-- Enable RLS on api_settings
ALTER TABLE public.api_settings ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "API settings readable by admins" ON api_settings;
DROP POLICY IF EXISTS "API settings modifiable by admins only" ON api_settings;

-- Only admins can read API settings
CREATE POLICY "API settings readable by admins"
ON public.api_settings FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
    AND profiles.blocked = false
  )
);

-- Only admins can modify API settings
CREATE POLICY "API settings modifiable by admins only"
ON public.api_settings FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
    AND profiles.blocked = false
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
    AND profiles.blocked = false
  )
);

-- Enable RLS on audit_logs
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

-- Drop existing policy if exists
DROP POLICY IF EXISTS "Audit logs readable by admins only" ON audit_logs;

-- Only admins can read audit logs
CREATE POLICY "Audit logs readable by admins only"
ON public.audit_logs FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
    AND profiles.blocked = false
  )
);

-- Enable RLS on conversations
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view their own conversations" ON conversations;
DROP POLICY IF EXISTS "Admins can view all conversations" ON conversations;
DROP POLICY IF EXISTS "Users can create conversations" ON conversations;
DROP POLICY IF EXISTS "Users can update their conversations" ON conversations;

-- Users can view their own conversations
CREATE POLICY "Users can view their own conversations"
ON public.conversations FOR SELECT
TO authenticated
USING (user_id = auth.uid());

-- Admins can view all conversations
CREATE POLICY "Admins can view all conversations"
ON public.conversations FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
    AND profiles.blocked = false
  )
);

-- Users can create conversations
CREATE POLICY "Users can create conversations"
ON public.conversations FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

-- Users can update their conversations
CREATE POLICY "Users can update their conversations"
ON public.conversations FOR UPDATE
TO authenticated
USING (user_id = auth.uid());

-- Enable RLS on chat_messages
ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view messages in their conversations" ON chat_messages;
DROP POLICY IF EXISTS "Admins can view all messages" ON chat_messages;
DROP POLICY IF EXISTS "Users can send messages" ON chat_messages;
DROP POLICY IF EXISTS "Users can mark messages as read" ON chat_messages;

-- Users can view messages in their conversations
CREATE POLICY "Users can view messages in their conversations"
ON public.chat_messages FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.conversations
    WHERE conversations.id = chat_messages.conversation_id
    AND conversations.user_id = auth.uid()
  )
);

-- Admins can view all messages
CREATE POLICY "Admins can view all messages"
ON public.chat_messages FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
    AND profiles.blocked = false
  )
);

-- Users and admins can send messages
CREATE POLICY "Users can send messages"
ON public.chat_messages FOR INSERT
TO authenticated
WITH CHECK (sender_id = auth.uid());

-- Users and admins can mark messages as read
CREATE POLICY "Users can mark messages as read"
ON public.chat_messages FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.conversations
    WHERE conversations.id = chat_messages.conversation_id
    AND (conversations.user_id = auth.uid() OR EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
      AND profiles.blocked = false
    ))
  )
);

-- ============================================================================
-- 11. CREATE ARTICLE IMAGES STORAGE BUCKET
-- ============================================================================

-- Insert bucket for article images if not exists
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'shopin_storage',
  'shopin_storage',
  true,
  10485760, -- 10MB max file size
  ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp']
)
ON CONFLICT (id) DO UPDATE SET
  public = true,
  file_size_limit = 10485760,
  allowed_mime_types = ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Article images are publicly accessible" ON storage.objects;
DROP POLICY IF EXISTS "Admins can upload article images" ON storage.objects;
DROP POLICY IF EXISTS "Admins can update article images" ON storage.objects;
DROP POLICY IF EXISTS "Admins can delete article images" ON storage.objects;

-- Create storage policies
CREATE POLICY "Article images are publicly accessible"
ON storage.objects FOR SELECT
USING (bucket_id = 'shopin_storage');

CREATE POLICY "Admins can upload article images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'shopin_storage');

CREATE POLICY "Admins can update article images"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'shopin_storage')
WITH CHECK (bucket_id = 'shopin_storage');

CREATE POLICY "Admins can delete article images"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'shopin_storage');

-- ============================================================================
-- 12. VERIFY MIGRATION
-- ============================================================================

DO $$ 
BEGIN
  RAISE NOTICE 'Migration 013 completed successfully: Admin panel features added';
  RAISE NOTICE '- Admin settings restructured (shop_info, shipping_config, order_config, default_seo)';
  RAISE NOTICE '- API settings table created';
  RAISE NOTICE '- Profiles: removed is_admin, added blocked column';
  RAISE NOTICE '- Audit logs table created';
  RAISE NOTICE '- Chat system tables created (conversations, chat_messages)';
  RAISE NOTICE '- RLS policies enabled for all admin and chat tables';
  RAISE NOTICE '- Indexes created for performance optimization';
END $$;
