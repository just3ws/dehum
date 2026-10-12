#!/usr/bin/env bash
set -euo pipefail

# Extract body from LINKEDIN_POST.md
python3 -c "
with open('LINKEDIN_POST.md') as f:
    text = f.read()
body = text.split('Article Body:\n\n')[1]
print(body)
" | pandoc -f markdown -t html | textutil -stdin -format html -convert rtf -stdout | pbcopy -Prefer rtf

echo "Copied rich-text formatted article with real H1/H2 headers directly to your clipboard!"
