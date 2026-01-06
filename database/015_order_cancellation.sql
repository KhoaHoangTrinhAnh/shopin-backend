-- ============================================================================
-- Migration 015: Order Cancellation Feature
-- ============================================================================
-- Adds order cancellation request functionality:
-- - Users can request cancellation when status is 'pending' or 'confirmed'
-- - Admin can approve or reject cancellation requests
-- ============================================================================

-- Add cancellation fields to orders table
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS cancellation_requested boolean DEFAULT false,
ADD COLUMN IF NOT EXISTS cancellation_requested_at timestamp with time zone,
ADD COLUMN IF NOT EXISTS cancellation_reason text,
ADD COLUMN IF NOT EXISTS cancellation_approved boolean,
ADD COLUMN IF NOT EXISTS cancellation_approved_at timestamp with time zone,
ADD COLUMN IF NOT EXISTS cancellation_approved_by uuid REFERENCES profiles(id);

-- Add comment for documentation
COMMENT ON COLUMN orders.cancellation_requested IS 'Whether user has requested order cancellation';
COMMENT ON COLUMN orders.cancellation_requested_at IS 'When user requested cancellation';
COMMENT ON COLUMN orders.cancellation_reason IS 'Reason for cancellation provided by user';
COMMENT ON COLUMN orders.cancellation_approved IS 'Whether admin approved cancellation (null = pending, true = approved, false = rejected)';
COMMENT ON COLUMN orders.cancellation_approved_at IS 'When admin processed cancellation request';
COMMENT ON COLUMN orders.cancellation_approved_by IS 'Admin who processed cancellation request';

-- Create index for finding pending cancellation requests
CREATE INDEX IF NOT EXISTS idx_orders_cancellation_pending 
ON orders (cancellation_requested, cancellation_approved) 
WHERE cancellation_requested = true AND cancellation_approved IS NULL;

-- ============================================================================
-- RLS Policies for order cancellation
-- ============================================================================

-- Users can update their own orders to request cancellation
-- (Only when status is pending or confirmed)
DROP POLICY IF EXISTS orders_user_cancellation_request ON orders;

CREATE POLICY orders_user_cancellation_request ON orders
  FOR UPDATE
  USING (profile_id = auth.uid())
  WITH CHECK (
    profile_id = auth.uid() 
    AND status IN ('pending', 'confirmed')
    AND cancellation_requested = true
  );

-- ============================================================================
-- End of Migration 015
-- ============================================================================
