#!/usr/bin/env bash
# The site build script. Run from the deploy machine (Tom's LXC container).
# Pulls main from GitHub, refreshes the episode list from YouTube, builds, checks the build,
# and rsyncs it to the web server.
# Usage: deploy/publish.sh [--dry-run]
#
# Expects the SSH host alias "lsweb" in ~/.ssh/config (the same one used for lawrencesystems.com)
# and yt-dlp on PATH. Override the target with PUBLISH_REMOTE if the folder differs.
set -euo pipefail

cd "$(dirname "$0")/.."
REMOTE="${PUBLISH_REMOTE:-lsweb:/var/www/streamingsecurity/public/}"
DRY=""
[[ "${1:-}" == "--dry-run" ]] && DRY="--dry-run"

# Publish exactly what is on GitHub's main branch, never local edits.
# (The episode list and thumbnails are gitignored, so refreshing them does not count.)
if [[ -n "$(git status --porcelain)" ]]; then
  echo "ERROR: uncommitted changes in $(pwd). Publish only what is merged to main on GitHub." >&2
  exit 1
fi
git fetch --quiet origin main
git checkout --quiet main
git reset --quiet --hard origin/main

# Newest episodes first, straight from the channel. If YouTube is unreachable, build with the last list.
if ! python3 scripts/fetch-episodes.py; then
  if [[ -s data/episodes.json ]]; then
    echo "WARNING: episode refresh failed, publishing the previous list." >&2
  else
    echo "ERROR: no episode list and YouTube could not be reached." >&2
    exit 1
  fi
fi

hugo --gc --minify --cleanDestinationDir

test -s public/index.html
grep -q "streaming_security" public/index.html
grep -q 'class=ep-link' public/index.html || { echo "ERROR: build has no episodes." >&2; exit 1; }

rsync -az --delete --checksum $DRY public/ "$REMOTE"
echo "Published $(git rev-parse --short HEAD) ($(git log -1 --pretty=%s)) with $(grep -o 'class=ep-link' public/index.html | wc -l) episodes to $REMOTE${DRY:+ (dry run)}"
