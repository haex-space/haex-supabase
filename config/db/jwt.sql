-- JWT helper functions for Supabase
-- Required by PostgREST for JWT verification

-- Create extensions if not exists
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Create auth schema if not exists
CREATE SCHEMA IF NOT EXISTS auth;

-- Function to get the current user's JWT claims
CREATE OR REPLACE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  SELECT
    COALESCE(
      nullif(current_setting('request.jwt.claims', true), ''),
      '{}'
    )::jsonb
$$;

-- Function to get the current user's ID from JWT
CREATE OR REPLACE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  SELECT
    COALESCE(
      nullif(current_setting('request.jwt.claim.sub', true), ''),
      (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
    )::uuid
$$;

-- Function to get the current user's role from JWT
CREATE OR REPLACE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  SELECT
    COALESCE(
      nullif(current_setting('request.jwt.claim.role', true), ''),
      (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
    )::text
$$;

-- Function to get the current user's email from JWT
CREATE OR REPLACE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  SELECT
    COALESCE(
      nullif(current_setting('request.jwt.claim.email', true), ''),
      (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
    )::text
$$;

-- Grant execute to roles
GRANT USAGE ON SCHEMA auth TO anon, authenticated, service_role;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA auth TO anon, authenticated, service_role;
