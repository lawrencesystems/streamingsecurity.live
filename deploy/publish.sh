#!/usr/bin/env bash
# The site build script. Run from the deploy machine (Tom's LXC container).
# Pulls main from GitHub, refreshes the episode list from YouTube, builds, checks the build,
# and rsyncs it to the web server.
# Usage: deploy/publish.sh [--dry-run]
#
# Expects the SSH host alias "lsweb" in ~/.ssh/config (the same one used for lawrencesystems.com)
# and yt-dlp on PATH. Override the target with PUBLISH_REMOTE if the folder differs.
#
# Safe to run unattended: it publishes only what is on main, keeps the previous episode
# list when YouTube cannot be reached, and fails closed (no rsync) if the build would have
# no episodes. It also verifies the live page afterwards, so a broken publish is reported
# rather than passing silently.
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

# Confirm the live page came up with its episodes, so an unattended run cannot
# report success while the site is broken.
if [[ -z "$DRY" ]]; then
  tmp=$(mktemp)
  code=$(curl -s -o "$tmp" -w '%{http_code}' https://streamingsecurity.live/) || code="000"
  if [[ "$code" != "200" ]]; then rm -f "$tmp"; echo "ERROR: live homepage returned $code" >&2; exit 1; fi
  if ! grep -q 'class=ep-link' "$tmp"; then rm -f "$tmp"; echo "ERROR: live homepage has no episodes" >&2; exit 1; fi
  rm -f "$tmp"
fi

echo "Published $(git rev-parse --short HEAD) ($(git log -1 --pretty=%s)) with $(grep -o 'class=ep-link' public/index.html | wc -l) episodes to $REMOTE${DRY:+ (dry run)}"
