-- ============================================================================
-- Migration: 019_chat_realtime_setup.sql
-- Purpose: Setup realtime chat feature with constraints, RLS, indexes, and RPC functions
-- Date: 2026-02-01
-- Author: System
-- 
-- This migration:
-- 1. Adds UNIQUE constraint on conversations(user_id) - one conversation per customer
-- 2. Updates status CHECK constraint to use 'active', 'resolved', 'archived'
-- 3. Adds message length CHECK constraint
-- 4. Creates indexes for performance
-- 5. Creates RLS policies for security
-- 6. Creates RPC functions for business logic
-- 7. Enables realtime for tables
-- ============================================================================

BEGIN;

-- ============================================================================
-- STEP 1: Update existing data to match new status values
-- ============================================================================

-- Change 'closed' to 'resolved' for consistency with documentation
UPDATE conversations SET status = 'resolved' WHERE status = 'closed';

-- ============================================================================
-- STEP 2: Add/Update constraints
-- ============================================================================

-- 2.1: Add UNIQUE constraint on user_id (one conversation per customer)
-- First check if constraint exists
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'uq_conversations_user_id'
  ) THEN
    ALTER TABLE conversations 
    ADD CONSTRAINT uq_conversations_user_id UNIQUE (user_id);
  END IF;
END $$;

-- 2.2: Drop old status CHECK and add new one with 'resolved' instead of 'closed'
ALTER TABLE conversations DROP CONSTRAINT IF EXISTS conversations_status_check;
ALTER TABLE conversations 
ADD CONSTRAINT conversations_status_check 
CHECK (status IN ('active', 'resolved', 'archived'));

-- 2.3: Add message length CHECK constraint (1-5000 characters)
ALTER TABLE chat_messages DROP CONSTRAINT IF EXISTS chk_messages_length;
ALTER TABLE chat_messages 
ADD CONSTRAINT chk_messages_length 
CHECK (LENGTH(message) BETWEEN 1 AND 5000);

-- ============================================================================
-- STEP 3: Create indexes for performance
-- ============================================================================

-- Index on conversations for admin list query (status + last_message_at)
CREATE INDEX IF NOT EXISTS idx_conversations_status_last_message 
ON conversations(status, last_message_at DESC);

-- Composite index on chat_messages for pagination
CREATE INDEX IF NOT EXISTS idx_chat_messages_conversation_created 
ON chat_messages(conversation_id, created_at DESC);

-- Index on chat_messages for unread count queries
CREATE INDEX IF NOT EXISTS idx_chat_messages_unread 
ON chat_messages(conversation_id, is_read) 
WHERE is_read = false;

-- ============================================================================
-- STEP 4: Enable Row Level Security (RLS)
-- ============================================================================

-- Enable RLS on tables
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if any (to avoid conflicts)
DROP POLICY IF EXISTS "conversations_select_own" ON conversations;
DROP POLICY IF EXISTS "conversations_select_admin" ON conversations;
DROP POLICY IF EXISTS "conversations_insert_own" ON conversations;
DROP POLICY IF EXISTS "conversations_update_own" ON conversations;
DROP POLICY IF EXISTS "conversations_update_admin" ON conversations;

DROP POLICY IF EXISTS "chat_messages_select_own" ON chat_messages;
DROP POLICY IF EXISTS "chat_messages_select_admin" ON chat_messages;
DROP POLICY IF EXISTS "chat_messages_insert_own" ON chat_messages;
DROP POLICY IF EXISTS "chat_messages_insert_admin" ON chat_messages;
DROP POLICY IF EXISTS "chat_messages_update_own" ON chat_messages;
DROP POLICY IF EXISTS "chat_messages_update_admin" ON chat_messages;

-- 4.1: Conversations policies

-- Customers can view their own conversation
CREATE POLICY "conversations_select_own" ON conversations
FOR SELECT USING (user_id = auth.uid());

-- Admins can view all conversations
CREATE POLICY "conversations_select_admin" ON conversations
FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM profiles 
    WHERE profiles.user_id = auth.uid() 
    AND profiles.role = 'admin'
  )
);

-- Customers can create their own conversation
CREATE POLICY "conversations_insert_own" ON conversations
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Customers can update their own conversation (limited fields via RPC)
CREATE POLICY "conversations_update_own" ON conversations
FOR UPDATE USING (user_id = auth.uid());

-- Admins can update any conversation
CREATE POLICY "conversations_update_admin" ON conversations
FOR UPDATE USING (
  EXISTS (
    SELECT 1 FROM profiles 
    WHERE profiles.user_id = auth.uid() 
    AND profiles.role = 'admin'
  )
);

-- 4.2: Chat messages policies

-- Customers can view messages in their conversation
CREATE POLICY "chat_messages_select_own" ON chat_messages
FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM conversations 
    WHERE conversations.id = chat_messages.conversation_id 
    AND conversations.user_id = auth.uid()
  )
);

-- Admins can view all messages
CREATE POLICY "chat_messages_select_admin" ON chat_messages
FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM profiles 
    WHERE profiles.user_id = auth.uid() 
    AND profiles.role = 'admin'
  )
);

-- Customers can insert messages in their conversation
CREATE POLICY "chat_messages_insert_own" ON chat_messages
FOR INSERT WITH CHECK (
  sender_id = auth.uid() AND
  EXISTS (
    SELECT 1 FROM conversations 
    WHERE conversations.id = chat_messages.conversation_id 
    AND conversations.user_id = auth.uid()
  )
);

-- Admins can insert messages in any conversation
CREATE POLICY "chat_messages_insert_admin" ON chat_messages
FOR INSERT WITH CHECK (
  sender_id = auth.uid() AND
  EXISTS (
    SELECT 1 FROM profiles 
    WHERE profiles.user_id = auth.uid() 
    AND profiles.role = 'admin'
  )
);

-- Customers can update read status of messages in their conversation
CREATE POLICY "chat_messages_update_own" ON chat_messages
FOR UPDATE USING (
  EXISTS (
    SELECT 1 FROM conversations 
    WHERE conversations.id = chat_messages.conversation_id 
    AND conversations.user_id = auth.uid()
  )
);

-- Admins can update any message
CREATE POLICY "chat_messages_update_admin" ON chat_messages
FOR UPDATE USING (
  EXISTS (
    SELECT 1 FROM profiles 
    WHERE profiles.user_id = auth.uid() 
    AND profiles.role = 'admin'
  )
);

-- ============================================================================
-- STEP 5: Create RPC Functions
-- ============================================================================

-- 5.1: Create or get conversation for current user
-- Returns existing conversation or creates new one
CREATE OR REPLACE FUNCTION create_or_get_conversation()
RETURNS conversations
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_conversation conversations;
  v_user_id uuid;
BEGIN
  -- Get current user ID
  v_user_id := auth.uid();
  
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  -- Try to get existing conversation
  SELECT * INTO v_conversation
  FROM conversations
  WHERE user_id = v_user_id;
  
  -- If found, return it
  IF FOUND THEN
    RETURN v_conversation;
  END IF;
  
  -- Create new conversation (INSERT with ON CONFLICT for race condition safety)
  INSERT INTO conversations (user_id, status, last_message_at)
  VALUES (v_user_id, 'active', NOW())
  ON CONFLICT (user_id) DO UPDATE SET updated_at = NOW()
  RETURNING * INTO v_conversation;
  
  RETURN v_conversation;
END;
$$;

-- Grant execute to authenticated users
GRANT EXECUTE ON FUNCTION create_or_get_conversation() TO authenticated;


-- 5.2: Send chat message
-- Auto-creates conversation if p_conversation_id is null
-- Auto-reopens resolved conversations
CREATE OR REPLACE FUNCTION send_chat_message(
  p_conversation_id uuid,
  p_message text
)
RETURNS chat_messages
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_message chat_messages;
  v_conversation_id uuid;
  v_sender_id uuid;
  v_sender_role text;
  v_trimmed_message text;
BEGIN
  -- Get current user
  v_sender_id := auth.uid();
  
  IF v_sender_id IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;
  
  -- Trim and validate message
  v_trimmed_message := TRIM(p_message);
  
  IF LENGTH(v_trimmed_message) < 1 THEN
    RAISE EXCEPTION 'Message cannot be empty';
  END IF;
  
  IF LENGTH(v_trimmed_message) > 5000 THEN
    RAISE EXCEPTION 'Message too long (max 5000 characters)';
  END IF;
  
  -- Get sender role from profiles
  SELECT role INTO v_sender_role
  FROM profiles
  WHERE user_id = v_sender_id;
  
  -- Default to 'user' if no profile found
  IF v_sender_role IS NULL THEN
    v_sender_role := 'user';
  END IF;
  
  -- Handle conversation ID
  IF p_conversation_id IS NULL THEN
    -- Auto-create conversation for user
    IF v_sender_role = 'user' THEN
      SELECT id INTO v_conversation_id
      FROM create_or_get_conversation();
    ELSE
      RAISE EXCEPTION 'Admin must specify conversation_id';
    END IF;
  ELSE
    v_conversation_id := p_conversation_id;
    
    -- Verify access: user can only send to their own conversation
    IF v_sender_role = 'user' THEN
      IF NOT EXISTS (
        SELECT 1 FROM conversations 
        WHERE id = v_conversation_id AND user_id = v_sender_id
      ) THEN
        RAISE EXCEPTION 'Conversation not found or access denied';
      END IF;
    END IF;
    -- Admins can send to any conversation (no check needed)
  END IF;
  
  -- Insert message
  INSERT INTO chat_messages (
    conversation_id,
    sender_id,
    sender_role,
    message,
    is_read
  ) VALUES (
    v_conversation_id,
    v_sender_id,
    v_sender_role,
    v_trimmed_message,
    false
  )
  RETURNING * INTO v_message;
  
  -- Update conversation metadata
  UPDATE conversations
  SET 
    last_message = v_trimmed_message,
    last_message_at = NOW(),
    updated_at = NOW(),
    -- Reopen if resolved (customer sends new message)
    status = CASE 
      WHEN status = 'resolved' AND v_sender_role = 'user' THEN 'active'
      ELSE status
    END,
    -- Increment unread count for opposite party
    unread_count = CASE
      WHEN v_sender_role = 'user' THEN unread_count + 1  -- Admin has unread
      ELSE unread_count  -- Keep for customer
    END
  WHERE id = v_conversation_id;
  
  RETURN v_message;
END;
$$;

-- Grant execute to authenticated users
GRANT EXECUTE ON FUNCTION send_chat_message(uuid, text) TO authenticated;


-- 5.3: Mark messages as read
-- Marks all unread messages from opposite party as read
CREATE OR REPLACE FUNCTION mark_messages_read(p_conversation_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id uuid;
  v_user_role text;
  v_opposite_role text;
BEGIN
  v_user_id := auth.uid();
  
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;
  
  -- Get user role
  SELECT role INTO v_user_role
  FROM profiles
  WHERE user_id = v_user_id;
  
  v_user_role := COALESCE(v_user_role, 'user');
  v_opposite_role := CASE WHEN v_user_role = 'admin' THEN 'user' ELSE 'admin' END;
  
  -- Verify access for non-admin users
  IF v_user_role = 'user' THEN
    IF NOT EXISTS (
      SELECT 1 FROM conversations 
      WHERE id = p_conversation_id AND user_id = v_user_id
    ) THEN
      RAISE EXCEPTION 'Conversation not found or access denied';
    END IF;
  END IF;
  
  -- Mark messages from opposite party as read
  UPDATE chat_messages
  SET is_read = true
  WHERE conversation_id = p_conversation_id
    AND sender_role = v_opposite_role
    AND is_read = false;
  
  -- Reset unread count if admin is reading
  IF v_user_role = 'admin' THEN
    UPDATE conversations
    SET unread_count = 0, updated_at = NOW()
    WHERE id = p_conversation_id;
  END IF;
END;
$$;

-- Grant execute to authenticated users
GRANT EXECUTE ON FUNCTION mark_messages_read(uuid) TO authenticated;


-- 5.4: Get unread count for customer
-- Returns number of unread messages from admin in customer's conversation
CREATE OR REPLACE FUNCTION get_customer_unread_count()
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_count integer;
  v_user_id uuid;
BEGIN
  v_user_id := auth.uid();
  
  IF v_user_id IS NULL THEN
    RETURN 0;
  END IF;
  
  SELECT COUNT(*)::integer INTO v_count
  FROM chat_messages cm
  JOIN conversations c ON c.id = cm.conversation_id
  WHERE c.user_id = v_user_id
    AND cm.sender_role = 'admin'
    AND cm.is_read = false;
  
  RETURN COALESCE(v_count, 0);
END;
$$;

-- Grant execute to authenticated users
GRANT EXECUTE ON FUNCTION get_customer_unread_count() TO authenticated;


-- 5.5: Get total unread count for admin
-- Returns total unread messages across all conversations
CREATE OR REPLACE FUNCTION get_admin_unread_count()
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_count integer;
  v_user_id uuid;
BEGIN
  v_user_id := auth.uid();
  
  IF v_user_id IS NULL THEN
    RETURN 0;
  END IF;
  
  -- Verify user is admin
  IF NOT EXISTS (
    SELECT 1 FROM profiles 
    WHERE user_id = v_user_id AND role = 'admin'
  ) THEN
    RETURN 0;
  END IF;
  
  SELECT COALESCE(SUM(unread_count), 0)::integer INTO v_count
  FROM conversations
  WHERE status != 'archived';
  
  RETURN v_count;
END;
$$;

-- Grant execute to authenticated users
GRANT EXECUTE ON FUNCTION get_admin_unread_count() TO authenticated;


-- 5.6: Update conversation status (admin only)
CREATE OR REPLACE FUNCTION update_conversation_status(
  p_conversation_id uuid,
  p_status text
)
RETURNS conversations
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_conversation conversations;
  v_user_id uuid;
BEGIN
  v_user_id := auth.uid();
  
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;
  
  -- Verify user is admin
  IF NOT EXISTS (
    SELECT 1 FROM profiles 
    WHERE user_id = v_user_id AND role = 'admin'
  ) THEN
    RAISE EXCEPTION 'Admin access required';
  END IF;
  
  -- Validate status
  IF p_status NOT IN ('active', 'resolved', 'archived') THEN
    RAISE EXCEPTION 'Invalid status. Must be: active, resolved, or archived';
  END IF;
  
  -- Update conversation
  UPDATE conversations
  SET status = p_status, updated_at = NOW()
  WHERE id = p_conversation_id
  RETURNING * INTO v_conversation;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Conversation not found';
  END IF;
  
  RETURN v_conversation;
END;
$$;

-- Grant execute to authenticated users
GRANT EXECUTE ON FUNCTION update_conversation_status(uuid, text) TO authenticated;


-- ============================================================================
-- STEP 6: Enable Supabase Realtime for tables
-- ============================================================================

-- Enable realtime for conversations table
ALTER PUBLICATION supabase_realtime ADD TABLE conversations;

-- Enable realtime for chat_messages table
ALTER PUBLICATION supabase_realtime ADD TABLE chat_messages;

-- ============================================================================
-- COMMIT TRANSACTION
-- ============================================================================

COMMIT;

-- ============================================================================
-- ROLLBACK SCRIPT (run manually if needed)
-- ============================================================================
/*
BEGIN;

-- Remove from realtime
ALTER PUBLICATION supabase_realtime DROP TABLE IF EXISTS conversations;
ALTER PUBLICATION supabase_realtime DROP TABLE IF EXISTS chat_messages;

-- Drop RPC functions
DROP FUNCTION IF EXISTS create_or_get_conversation();
DROP FUNCTION IF EXISTS send_chat_message(uuid, text);
DROP FUNCTION IF EXISTS mark_messages_read(uuid);
DROP FUNCTION IF EXISTS get_customer_unread_count();
DROP FUNCTION IF EXISTS get_admin_unread_count();
DROP FUNCTION IF EXISTS update_conversation_status(uuid, text);

-- Drop RLS policies
DROP POLICY IF EXISTS "conversations_select_own" ON conversations;
DROP POLICY IF EXISTS "conversations_select_admin" ON conversations;
DROP POLICY IF EXISTS "conversations_insert_own" ON conversations;
DROP POLICY IF EXISTS "conversations_update_own" ON conversations;
DROP POLICY IF EXISTS "conversations_update_admin" ON conversations;

DROP POLICY IF EXISTS "chat_messages_select_own" ON chat_messages;
DROP POLICY IF EXISTS "chat_messages_select_admin" ON chat_messages;
DROP POLICY IF EXISTS "chat_messages_insert_own" ON chat_messages;
DROP POLICY IF EXISTS "chat_messages_insert_admin" ON chat_messages;
DROP POLICY IF EXISTS "chat_messages_update_own" ON chat_messages;
DROP POLICY IF EXISTS "chat_messages_update_admin" ON chat_messages;

-- Disable RLS
ALTER TABLE conversations DISABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages DISABLE ROW LEVEL SECURITY;

-- Drop indexes
DROP INDEX IF EXISTS idx_conversations_status_last_message;
DROP INDEX IF EXISTS idx_chat_messages_conversation_created;
DROP INDEX IF EXISTS idx_chat_messages_unread;

-- Drop constraints
ALTER TABLE chat_messages DROP CONSTRAINT IF EXISTS chk_messages_length;
ALTER TABLE conversations DROP CONSTRAINT IF EXISTS uq_conversations_user_id;

-- Restore old status CHECK (if needed)
ALTER TABLE conversations DROP CONSTRAINT IF EXISTS conversations_status_check;
ALTER TABLE conversations 
ADD CONSTRAINT conversations_status_check 
CHECK (status IN ('active', 'archived', 'closed'));

-- Revert status values
UPDATE conversations SET status = 'closed' WHERE status = 'resolved';

COMMIT;
*/
