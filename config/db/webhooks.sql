-- Webhooks/Triggers setup for Supabase
-- Required for database webhooks functionality

-- Create supabase_functions schema
CREATE SCHEMA IF NOT EXISTS supabase_functions;

-- Grant usage
GRANT USAGE ON SCHEMA supabase_functions TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA supabase_functions TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL ROUTINES IN SCHEMA supabase_functions TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA supabase_functions TO postgres, anon, authenticated, service_role;

-- Default privileges
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON TABLES TO postgres, anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON ROUTINES TO postgres, anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO postgres, anon, authenticated, service_role;

-- Enable pg_net extension for HTTP requests (if available)
-- This is optional and may not be available in all Postgres images
DO $$
BEGIN
  CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;
EXCEPTION
  WHEN undefined_file THEN
    RAISE NOTICE 'pg_net extension not available, skipping';
  WHEN others THEN
    RAISE NOTICE 'Could not create pg_net extension: %', SQLERRM;
END
$$;
