-- ============================================================================
-- Migration: 020_fix_chat_fk_to_auth_users.sql
-- Purpose: Fix chat tables foreign keys to reference auth.users instead of profiles
-- Date: 2026-02-01
-- Author: System
-- 
-- This migration fixes the FK constraints in conversations and chat_messages
-- to reference auth.users(id) instead of profiles(id), consistent with
-- migration 017 changes.
-- ============================================================================

BEGIN;

-- ============================================================================
-- STEP 1: Fix conversations table FK
-- ============================================================================

-- Drop old FK constraint
ALTER TABLE public.conversations 
DROP CONSTRAINT IF EXISTS conversations_user_id_fkey;

-- Add new FK constraint referencing auth.users
ALTER TABLE public.conversations 
ADD CONSTRAINT conversations_user_id_fkey 
FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- ============================================================================
-- STEP 2: Fix chat_messages table FKs
-- ============================================================================

-- Drop old FK constraint for sender_id
ALTER TABLE public.chat_messages 
DROP CONSTRAINT IF EXISTS chat_messages_sender_id_fkey;

-- Add new FK constraint referencing auth.users
ALTER TABLE public.chat_messages 
ADD CONSTRAINT chat_messages_sender_id_fkey 
FOREIGN KEY (sender_id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- ============================================================================
-- STEP 3: Verify data consistency
-- ============================================================================

-- Check if there are any orphaned records
DO $$
DECLARE
  orphaned_conversations INTEGER;
  orphaned_messages INTEGER;
BEGIN
  -- Check conversations
  SELECT COUNT(*) INTO orphaned_conversations
  FROM public.conversations c
  WHERE NOT EXISTS (SELECT 1 FROM auth.users u WHERE u.id = c.user_id);
  
  IF orphaned_conversations > 0 THEN
    RAISE WARNING 'Found % orphaned conversations (will be deleted on next cleanup)', orphaned_conversations;
  END IF;
  
  -- Check chat_messages
  SELECT COUNT(*) INTO orphaned_messages
  FROM public.chat_messages m
  WHERE NOT EXISTS (SELECT 1 FROM auth.users u WHERE u.id = m.sender_id);
  
  IF orphaned_messages > 0 THEN
    RAISE WARNING 'Found % orphaned chat messages (will be deleted on next cleanup)', orphaned_messages;
  END IF;
  
  RAISE NOTICE 'Migration completed successfully. Fixed FK constraints to reference auth.users.';
END $$;

COMMIT;
