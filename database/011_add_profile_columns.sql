-- Migration 011: Add missing columns to profiles table
-- Adds gender and date_of_birth columns for complete user profile support
-- Run this in Supabase SQL Editor

-- ============================================================================
-- 1. ADD GENDER COLUMN
-- ============================================================================

-- Add gender column if not exists
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'profiles' 
    AND column_name = 'gender'
  ) THEN
    ALTER TABLE public.profiles ADD COLUMN gender text CHECK (gender IN ('male', 'female', 'other'));
    COMMENT ON COLUMN public.profiles.gender IS 'User gender: male, female, or other';
  END IF;
END $$;

-- ============================================================================
-- 2. ADD DATE_OF_BIRTH COLUMN
-- ============================================================================

-- Add date_of_birth column if not exists
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'profiles' 
    AND column_name = 'date_of_birth'
  ) THEN
    ALTER TABLE public.profiles ADD COLUMN date_of_birth date;
    COMMENT ON COLUMN public.profiles.date_of_birth IS 'User date of birth';
  END IF;
END $$;

-- ============================================================================
-- 3. CREATE INDEXES FOR QUERY PERFORMANCE
-- ============================================================================

-- Index on gender for demographic queries (optional)
CREATE INDEX IF NOT EXISTS idx_profiles_gender ON public.profiles(gender) WHERE gender IS NOT NULL;

-- ============================================================================
-- 4. VERIFY COLUMNS
-- ============================================================================

-- Verify the columns were added
DO $$ 
DECLARE
  has_gender boolean;
  has_dob boolean;
BEGIN
  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'profiles' 
    AND column_name = 'gender'
  ) INTO has_gender;
  
  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'profiles' 
    AND column_name = 'date_of_birth'
  ) INTO has_dob;
  
  IF has_gender AND has_dob THEN
    RAISE NOTICE 'Migration 011 completed successfully: gender and date_of_birth columns added';
  ELSE
    RAISE WARNING 'Migration 011 incomplete: gender=%, date_of_birth=%', has_gender, has_dob;
  END IF;
END $$;
