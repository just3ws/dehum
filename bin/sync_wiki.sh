#!/usr/bin/env bash
set -euo pipefail

# bin/sync_wiki.sh: Push docs/wiki/ markdown pages to the GitHub Wiki git endpoint
WIKI_REPO="https://github.com/just3ws/dehum.wiki.git"
WORK_DIR="/tmp/dehum_wiki_sync_$$"

echo "==> Cloning or initializing GitHub Wiki repository..."
rm -rf "$WORK_DIR"
if git clone "$WIKI_REPO" "$WORK_DIR" 2>/dev/null; then
  echo "==> Wiki repository cloned successfully."
else
  echo "==> Note: If cloning fails, create the first wiki page via the web UI at https://github.com/just3ws/dehum/wiki"
  echo "==> Once created, re-run this script to sync all pages automatically."
  exit 1
fi

echo "==> Syncing markdown pages from docs/wiki/..."
cp docs/wiki/*.md "$WORK_DIR/"

cd "$WORK_DIR"
git add .
if git diff --cached --quiet; then
  echo "==> Wiki is already up to date with docs/wiki/."
else
  git commit -m "docs(wiki): sync knowledge base from repository docs/wiki"
  git push origin master || git push origin main
  echo "==> Wiki pushed successfully!"
fi

rm -rf "$WORK_DIR"
