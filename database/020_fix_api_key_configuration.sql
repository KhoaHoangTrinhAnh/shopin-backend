-- Migration: Fix API key configuration
-- Move API key from api_settings.key to admin_settings table

-- Step 1: Extract the API key from api_settings (it's currently in the wrong column)
DO $$
DECLARE
  openrouter_key TEXT;
BEGIN
  -- Get the misplaced API key from api_settings.key column
  SELECT key INTO openrouter_key
  FROM public.api_settings
  WHERE name = 'article'
  AND key LIKE 'sk-or-v1-%';

  IF openrouter_key IS NOT NULL THEN
    -- Insert or update admin_settings with the correct API key
    INSERT INTO public.admin_settings (key, value, description)
    VALUES (
      'api_keys',
      jsonb_build_object('openrouter_key', openrouter_key),
      'API keys for external services (OpenRouter, etc.)'
    )
    ON CONFLICT (key) DO UPDATE SET
      value = jsonb_set(
        COALESCE(admin_settings.value, '{}'::jsonb),
        '{openrouter_key}',
        to_jsonb(openrouter_key)
      ),
      updated_at = now();

    RAISE NOTICE 'Moved API key to admin_settings successfully';
  ELSE
    RAISE NOTICE 'No API key found in api_settings.key column';
  END IF;
END $$;

-- Step 2: Clear the api_settings.key column (it should be a unique identifier, not the API key!)
UPDATE public.api_settings
SET key = 'openai_article_generation'
WHERE name = 'article';

COMMENT ON COLUMN public.api_settings.key IS 'Unique identifier for this API setting (NOT the API key!)';
