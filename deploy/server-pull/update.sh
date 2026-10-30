#!/usr/bin/env bash
# Optional: runs on the web server from a systemd timer instead of publishing from the LXC.
# Pulls main from GitHub and refreshes the episode list from YouTube; when either changed,
# rebuilds and publishes. The server only reads a public repo: no deploy keys, and nothing
# in GitHub can log in to the server.
#
# Paths (override in the systemd unit's Environment= lines):
#   REPO_DIR  the clone of the repo
#   WEB_ROOT  the folder Caddy serves
#
# One-time setup, as root on the web server:
#   apt install -y git rsync python3 && install Hugo 0.146+ from the official GitHub release .deb
#   curl -L -o /usr/local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux && chmod +x /usr/local/bin/yt-dlp
#   useradd --system --no-create-home --shell /usr/sbin/nologin sitebuild
#   git clone https://github.com/lawrencesystems/https-streamingsecurity.live-.git /srv/streamingsecurity
#   mkdir -p /var/www/streamingsecurity/public
#   chown -R sitebuild:sitebuild /srv/streamingsecurity /var/www/streamingsecurity
#   cp /srv/streamingsecurity/deploy/server-pull/streamingsecurity-update.{service,timer} /etc/systemd/system/
#   systemctl daemon-reload && systemctl enable --now streamingsecurity-update.timer
set -euo pipefail

REPO_DIR="${REPO_DIR:-/srv/streamingsecurity}"
WEB_ROOT="${WEB_ROOT:-/var/www/streamingsecurity/public}"
BRANCH="${BRANCH:-main}"

cd "$REPO_DIR"
git fetch --quiet origin "$BRANCH"
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse "origin/$BRANCH")
git reset --quiet --hard "origin/$BRANCH"

BEFORE=$(sha256sum data/episodes.json 2>/dev/null || true)
python3 scripts/fetch-episodes.py --quiet || echo "WARNING: episode refresh failed, keeping the previous list." >&2
AFTER=$(sha256sum data/episodes.json 2>/dev/null || true)

if [[ "$LOCAL" == "$REMOTE" && "$BEFORE" == "$AFTER" && -s "$WEB_ROOT/index.html" && "${1:-}" != "--force" ]]; then
  exit 0
fi

BUILD=$(mktemp -d)
trap 'rm -rf "$BUILD"' EXIT
hugo --gc --minify --quiet --destination "$BUILD"

# Refuse to publish an obviously broken build
test -s "$BUILD/index.html"
grep -q "streaming_security" "$BUILD/index.html"
grep -q 'class=ep-link' "$BUILD/index.html"

rsync -a --delete "$BUILD/" "$WEB_ROOT/"
echo "Published $(git rev-parse --short HEAD): $(git log -1 --pretty=%s)"
