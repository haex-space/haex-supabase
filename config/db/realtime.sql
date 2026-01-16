-- Realtime schema setup for Supabase
-- Required by the Realtime service

-- Create _realtime schema
CREATE SCHEMA IF NOT EXISTS _realtime;

-- Grant usage to supabase_admin
GRANT USAGE ON SCHEMA _realtime TO supabase_admin;
GRANT ALL ON ALL TABLES IN SCHEMA _realtime TO supabase_admin;
GRANT ALL ON ALL SEQUENCES IN SCHEMA _realtime TO supabase_admin;

-- Default privileges
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA _realtime GRANT ALL ON TABLES TO supabase_admin;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA _realtime GRANT ALL ON SEQUENCES TO supabase_admin;

-- Create supabase_realtime_admin role if not exists
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'supabase_realtime_admin') THEN
    CREATE ROLE supabase_realtime_admin NOLOGIN NOINHERIT;
  END IF;
END
$$;

GRANT ALL ON SCHEMA _realtime TO supabase_realtime_admin;
GRANT ALL ON ALL TABLES IN SCHEMA _realtime TO supabase_realtime_admin;
GRANT ALL ON ALL SEQUENCES IN SCHEMA _realtime TO supabase_realtime_admin;
