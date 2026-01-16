# HaexHub Supabase Self-Hosted

## Purpose
Self-hosted Supabase instance replacing the Supabase Cloud for haex-sync-server and related projects.

## URLs
- API: `https://supabase.haex.space`
- Studio: `https://studio.supabase.haex.space`

## Tech Stack
- PostgreSQL 15 (supabase/postgres image)
- Kong API Gateway
- GoTrue (Auth)
- PostgREST
- Realtime (WebSockets)
- Storage API
- Supabase Studio

## Deployment
- **Initial Setup**: Ansible (`haex-supabase` role)
- **Updates**: Watchtower (automatic image pulls)
- **Reverse Proxy**: Traefik with Let's Encrypt

## Related Projects
- `/home/haex/Projekte/haex-sync-server` - Sync Server (main consumer)
- `/home/haex/Projekte/haex-space` - Frontend
- `/home/haex/Projekte/haex-marketplace` - Marketplace
- `/home/haex/Projekte/ansible` - Ansible roles for deployment

## Key Files
- `docker-compose.yml` - All services
- `config/kong.yml` - API Gateway routes
- `config/db/*.sql` - Database init scripts
- `.env.example` - Environment template

## Secrets (in ansible/secrets.yml)
```yaml
secrets:
  haex_supabase:
    postgres_password: ""
    jwt_secret: ""
    anon_key: ""
    service_role_key: ""
    dashboard_username: ""
    dashboard_password: ""
    dashboard_password_hash: ""
    vault_enc_key: ""
    secret_key_base: ""
    realtime_secret_key_base: ""
```
