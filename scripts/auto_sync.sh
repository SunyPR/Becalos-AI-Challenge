#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/home/sunik/Documentos/Learning/DEV.F"
cd "$REPO_DIR"

# Exit early if there are no changes
if [ -z "$(git status --porcelain)" ]; then
  exit 0
fi

git add -A

# Exit if nothing is staged after ignoring untracked/excluded files
if git diff --cached --quiet; then
  exit 0
fi

CHANGED_COUNT=$(git diff --cached --name-only | wc -l | tr -d ' ')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
git commit -m "chore: auto-sync (${CHANGED_COUNT} archivo(s)) - ${TIMESTAMP}"

# Pull any remote changes cleanly before pushing
if git remote get-url origin >/dev/null 2>&1; then
  git pull --rebase --autostash origin main || true
  git push -u origin main
fi
