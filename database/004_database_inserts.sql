-- Migration 004: Add logo_url to brands, avatar_url to profiles, create banners table
-- Created: 2025-01-XX

-- Add logo_url to brands table
ALTER TABLE brands 
ADD COLUMN IF NOT EXISTS logo_url TEXT;

-- Add avatar_url to profiles table  
ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS avatar_url TEXT;

-- Create banners table for promotional banners
CREATE TABLE IF NOT EXISTS banners (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    images_url TEXT[] NOT NULL, -- Array of image URLs
    link_url VARCHAR(500),
    position INTEGER DEFAULT 0, -- Order/position for display
    is_active BOOLEAN DEFAULT true,
    starts_at TIMESTAMP WITH TIME ZONE,
    ends_at TIMESTAMP WITH TIME ZONE,
    metadata JSONB DEFAULT '{}', -- Flexible JSON field for additional data
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for active banners query
CREATE INDEX IF NOT EXISTS idx_banners_active ON banners(is_active, position) WHERE is_active = true;

-- Create index for date range queries
CREATE INDEX IF NOT EXISTS idx_banners_dates ON banners(starts_at, ends_at);

-- Insert sample brand logos (update existing brands)
UPDATE brands SET logo_url = 'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/brand_images/apple/apple-logo.svg' WHERE slug = 'apple';
UPDATE brands SET logo_url = 'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/brand_images/iphone/iphone-logo.svg' WHERE slug = 'iphone';
UPDATE brands SET logo_url = 'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/brand_images/macbook/macbook-logo.svg' WHERE slug = 'macbook';
UPDATE brands SET logo_url = 'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/brand_images/samsung/samsung-logo.svg' WHERE slug = 'samsung';
UPDATE brands SET logo_url = 'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/brand_images/asus/asus-logo.svg' WHERE slug = 'asus';
UPDATE brands SET logo_url = 'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/brand_images/dell/dell-logo.svg' WHERE slug = 'dell';
UPDATE brands SET logo_url = 'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/brand_images/hp/hp-logo.svg' WHERE slug = 'hp';
UPDATE brands SET logo_url = 'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/brand_images/lenovo/lenovo-logo.svg' WHERE slug = 'lenovo';
UPDATE brands SET logo_url = 'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/brand_images/huawei/huawei-logo.svg' WHERE slug = 'huawei';
UPDATE brands SET logo_url = 'https://ijgcycxbnduntvguabis.supabase.co/storage/v1/object/public/shopin_storage/brand_images/garmin/garmin-logo.svg' WHERE slug = 'garmin';