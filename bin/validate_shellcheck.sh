#!/usr/bin/env bash
# bin/validate_shellcheck.sh: Rigorous shellcheck quality gate for all repo shell scripts
set -euo pipefail

echo "🔍 [Quality Gate] Running shellcheck audit across repository scripts..."

if ! command -v shellcheck >/dev/null 2>&1; then
  echo "⚠️ Warning: shellcheck not found on PATH. Skipping static analysis."
  exit 0
fi

FAILED=0
SCRIPTS=$(find . -name "*.sh" -not -path "*/archive/*" -not -path "*/tmp/*" -not -path "*/.git/*")

for s in $SCRIPTS; do
  echo "  Checking $s..."
  if ! shellcheck -x "$s"; then
    echo "❌ shellcheck failed on $s"
    FAILED=1
  fi
done

# Also check git hooks
for h in .git/hooks/pre-commit .git/hooks/pre-push; do
  if [ -f "$h" ]; then
    echo "  Checking $h..."
    if ! shellcheck "$h"; then
      echo "❌ shellcheck failed on $h"
      FAILED=1
    fi
  fi
done

if [ "$FAILED" -eq 0 ]; then
  echo "✅ [Quality Gate] All shell scripts and hooks passed shellcheck cleanly."
  exit 0
else
  echo "❌ [Quality Gate] Shellcheck failures detected."
  exit 1
fi
