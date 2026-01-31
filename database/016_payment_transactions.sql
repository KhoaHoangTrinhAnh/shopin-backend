-- Migration: Add payment_transactions table for SePay integration
-- Date: 2026-01-22
-- Description: Creates table to store payment transactions from SePay payment gateway

-- Create payment_transactions table
CREATE TABLE IF NOT EXISTS public.payment_transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
  provider text NOT NULL DEFAULT 'sepay',
  transaction_id text UNIQUE,
  order_invoice_number text NOT NULL UNIQUE,
  amount numeric NOT NULL CONSTRAINT chk_payment_transactions_amount_nonnegative CHECK (amount >= 0),
  currency text NOT NULL DEFAULT 'VND',
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'success', 'failed', 'cancelled')),
  payment_method text,
  raw_response jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_payment_transactions_order_id ON public.payment_transactions(order_id);
CREATE INDEX IF NOT EXISTS idx_payment_transactions_transaction_id ON public.payment_transactions(transaction_id);
CREATE INDEX IF NOT EXISTS idx_payment_transactions_order_invoice_number ON public.payment_transactions(order_invoice_number);
CREATE INDEX IF NOT EXISTS idx_payment_transactions_status ON public.payment_transactions(status);

-- Add payment_status column to orders table for clearer payment tracking
ALTER TABLE public.orders 
  ADD COLUMN IF NOT EXISTS payment_status text DEFAULT 'pending' 
  CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded'));

-- Create trigger to update updated_at on payment_transactions
CREATE OR REPLACE FUNCTION update_payment_transactions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS payment_transactions_updated_at ON public.payment_transactions;
CREATE TRIGGER payment_transactions_updated_at
  BEFORE UPDATE ON public.payment_transactions
  FOR EACH ROW
  EXECUTE FUNCTION update_payment_transactions_updated_at();

-- Enable RLS
ALTER TABLE public.payment_transactions ENABLE ROW LEVEL SECURITY;

-- RLS policies: Users can only see their own payment transactions
CREATE POLICY "Users can view their own payment transactions" ON public.payment_transactions
  FOR SELECT
  USING (
    order_id IN (
      SELECT id FROM public.orders WHERE profile_id = auth.uid()
    )
  );

-- Admin can view all payment transactions
CREATE POLICY "Admins can view all payment transactions" ON public.payment_transactions
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Service role can do everything (for backend operations)
CREATE POLICY "Service role full access" ON public.payment_transactions
  FOR ALL
  USING (auth.role() = 'service_role');

COMMENT ON TABLE public.payment_transactions IS 'Stores payment transaction records from SePay payment gateway';
COMMENT ON COLUMN public.payment_transactions.provider IS 'Payment provider: sepay';
COMMENT ON COLUMN public.payment_transactions.transaction_id IS 'Unique transaction ID from SePay';
COMMENT ON COLUMN public.payment_transactions.order_invoice_number IS 'Invoice number sent to SePay (maps to order)';
COMMENT ON COLUMN public.payment_transactions.status IS 'Payment status: pending, success, failed, cancelled';
COMMENT ON COLUMN public.payment_transactions.raw_response IS 'Full JSON response from SePay for debugging';
