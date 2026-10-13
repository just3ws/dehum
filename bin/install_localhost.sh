#!/usr/bin/env bash
set -euo pipefail

# bin/install_localhost.sh: Sync docs/ to local nginx webroot for www.just3ws.localhost/dehum/
TARGET_DIR="/opt/homebrew/var/www/just3ws.github.io/dehum"
DOCS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../docs" && pwd)"

echo "==> Deploying dehum pages to local nginx webroot..."
echo "    Source: $DOCS_DIR"
echo "    Target: $TARGET_DIR"

mkdir -p "$TARGET_DIR"
cp -R "$DOCS_DIR"/* "$TARGET_DIR/"
chmod -R o+rX "$TARGET_DIR"

echo "==> Verifying local endpoint..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://www.just3ws.localhost/dehum/dashboard.html || true)

if [ "$STATUS" = "200" ]; then
  echo "✅ Deployed successfully! https://www.just3ws.localhost/dehum/dashboard.html is HTTP 200 OK."
else
  echo "⚠️ Deployment complete, but curl returned HTTP $STATUS. Check nginx status."
fi
