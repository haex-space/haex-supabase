#!/bin/bash
# =============================================================================
# Supabase Self-Hosted Setup Script
# =============================================================================
# This script generates all required secrets and outputs YAML for secrets.yml

set -e

echo "=============================================="
echo "  Supabase Self-Hosted Secret Generator"
echo "=============================================="
echo ""

# Generate random secrets
echo "Generating secrets..."

POSTGRES_PASSWORD=$(openssl rand -base64 24 | tr -dc 'a-zA-Z0-9' | head -c 32)
JWT_SECRET=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 40)
VAULT_ENC_KEY=$(openssl rand -base64 24 | head -c 32)
SECRET_KEY_BASE=$(openssl rand -base64 64 | tr -dc 'a-zA-Z0-9' | head -c 64)
REALTIME_SECRET_KEY_BASE=$(openssl rand -base64 64 | tr -dc 'a-zA-Z0-9' | head -c 64)
DASHBOARD_PASSWORD=$(openssl rand -base64 16 | tr -dc 'a-zA-Z0-9' | head -c 20)

# Generate JWT keys using Node.js
echo "Generating JWT keys..."

JWT_OUTPUT=$(JWT_SECRET="$JWT_SECRET" node "$(dirname "$0")/generate-jwt.js" 2>/dev/null)
ANON_KEY=$(echo "$JWT_OUTPUT" | grep "^ANON_KEY=" | cut -d= -f2)
SERVICE_ROLE_KEY=$(echo "$JWT_OUTPUT" | grep "^SERVICE_ROLE_KEY=" | cut -d= -f2)

# Generate htpasswd hash
echo "Generating password hash..."
if command -v htpasswd &> /dev/null; then
    DASHBOARD_PASSWORD_HASH=$(htpasswd -nbB admin "$DASHBOARD_PASSWORD" | cut -d: -f2)
    # Escape $ for YAML
    DASHBOARD_PASSWORD_HASH_ESCAPED=$(echo "$DASHBOARD_PASSWORD_HASH" | sed 's/\$/\$\$/g')
else
    echo "WARNING: htpasswd not found. Install apache2-utils to generate password hash."
    echo "         You can generate it manually with: htpasswd -nbB admin 'YOUR_PASSWORD'"
    DASHBOARD_PASSWORD_HASH_ESCAPED="GENERATE_MANUALLY"
fi

echo ""
echo "=============================================="
echo "  Generated Secrets"
echo "=============================================="
echo ""
echo "Add this to your ansible/secrets.yml:"
echo ""
echo "-------------------------------------------"
cat << EOF
  haex_supabase:
    postgres_password: "$POSTGRES_PASSWORD"
    jwt_secret: "$JWT_SECRET"
    anon_key: "$ANON_KEY"
    service_role_key: "$SERVICE_ROLE_KEY"
    dashboard_username: "admin"
    dashboard_password: "$DASHBOARD_PASSWORD"
    dashboard_password_hash: "$DASHBOARD_PASSWORD_HASH_ESCAPED"
    vault_enc_key: "$VAULT_ENC_KEY"
    secret_key_base: "$SECRET_KEY_BASE"
    realtime_secret_key_base: "$REALTIME_SECRET_KEY_BASE"
    disable_signup: "false"
    mailer_autoconfirm: "true"
    storage_backend: "file"
EOF
echo "-------------------------------------------"
echo ""
echo "=============================================="
echo "  Dashboard Login"
echo "=============================================="
echo ""
echo "URL:      https://studio.supabase.haex.space"
echo "Username: admin"
echo "Password: $DASHBOARD_PASSWORD"
echo ""
echo "=============================================="
echo "  Next Steps"
echo "=============================================="
echo ""
echo "1. Add the secrets above to: ~/Projekte/ansible/secrets.yml"
echo "2. Create GitHub repo: gh repo create haex-space/haex-supabase --private"
echo "3. Push this directory: git init && git add . && git commit -m 'Initial' && git push"
echo "4. Run Ansible: cd ~/Projekte/ansible && ansible-playbook haex.space.play.yml --tags haex-supabase"
echo ""
