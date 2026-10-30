#!/usr/bin/env python3
"""Pull the Streaming Security episode list from YouTube into data/episodes.json.

Reads the channel's uploads playlist with yt-dlp (no API key), keeps YouTube's
order (newest first), and downloads each thumbnail to assets/thumbs/<id>.jpg so
the published site makes no requests to YouTube until someone clicks play.

Both outputs are generated and gitignored. If YouTube cannot be reached, the
previous episodes.json is left alone and the script exits 1, so a build still
has the last good list.

Usage: scripts/fetch-episodes.py [--quiet]
Needs yt-dlp on PATH (or set YTDLP=/path/to/yt-dlp). Python standard library otherwise.

Settings (environment variables):
  CHANNEL_ID   YouTube channel ID          (default: Streaming Security)
  MIN_SECONDS  skip videos shorter than this, so Shorts and clips stay off the list (default 300)
"""
import json
import os
import re
import subprocess
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / "data" / "episodes.json"
THUMBS = ROOT / "assets" / "thumbs"
CHANNEL_ID = os.environ.get("CHANNEL_ID", "UC9zx73lifodRvMEfUHJodcw")
MIN_SECONDS = int(os.environ.get("MIN_SECONDS", "300"))
YTDLP = os.environ.get("YTDLP", "yt-dlp")
QUIET = "--quiet" in sys.argv


def log(msg):
    if not QUIET:
        print(msg)


def ytdlp_json(url, *args, timeout=120):
    out = subprocess.run(
        [YTDLP, "--quiet", "--no-warnings", "--skip-download", "-J", *args, url],
        capture_output=True, text=True, timeout=timeout,
    )
    if out.returncode != 0 or not out.stdout.strip():
        raise RuntimeError(out.stderr.strip() or f"yt-dlp exited {out.returncode}")
    return json.loads(out.stdout)


def episode_number(title):
    m = re.search(r"\b(?:EP|Episode)\s*#?(\d+)\b", title, re.I)
    return int(m.group(1)) if m else None


def display_title(title):
    """Drop the show name and episode tag that YouTube titles carry for search."""
    t = re.sub(r"\s*[|\-:]\s*Streaming Security\s*(?:EP|Episode)\s*#?\d+\s*$", "", title, flags=re.I)
    t = re.sub(r"^\s*Streaming Security\s*(?:EP|Episode)\s*#?\d+\s*[:|\-]\s*", "", t, flags=re.I)
    return re.sub(r"\s{2,}", " ", t).strip() or title.strip()


def publish_date(video_id):
    """Exact upload date. YouTube sometimes blocks this from datacenter IPs; that is fine."""
    try:
        d = ytdlp_json(f"https://www.youtube.com/watch?v={video_id}", timeout=90)
    except Exception as e:  # noqa: BLE001
        log(f"  no date for {video_id} ({str(e).splitlines()[-1][:90]})")
        return ""
    ymd = d.get("release_date") or d.get("upload_date") or ""
    return f"{ymd[:4]}-{ymd[4:6]}-{ymd[6:8]}" if len(ymd) == 8 else ""


def fetch_thumb(video_id):
    dest = THUMBS / f"{video_id}.jpg"
    if dest.exists() and dest.stat().st_size > 2000:
        return True
    for name in ("maxresdefault", "sddefault", "hqdefault"):
        url = f"https://i.ytimg.com/vi/{video_id}/{name}.jpg"
        try:
            with urllib.request.urlopen(url, timeout=30) as r:
                body = r.read()
        except Exception:  # noqa: BLE001
            continue
        if len(body) > 2000:  # YouTube serves a tiny grey placeholder for missing sizes
            dest.write_bytes(body)
            return True
    return False


def main():
    THUMBS.mkdir(parents=True, exist_ok=True)
    DATA.parent.mkdir(parents=True, exist_ok=True)
    old = {}
    if DATA.exists():
        try:
            old = {e["id"]: e for e in json.loads(DATA.read_text())["episodes"]}
        except Exception:  # noqa: BLE001
            old = {}

    uploads = "https://www.youtube.com/playlist?list=UU" + CHANNEL_ID[2:]
    try:
        listing = ytdlp_json(uploads, "--flat-playlist")
    except Exception as e:  # noqa: BLE001
        print(f"ERROR: could not read the channel from YouTube, keeping the old list: {e}", file=sys.stderr)
        return 1

    episodes = []
    for item in listing.get("entries") or []:
        vid, title, secs = item.get("id"), (item.get("title") or "").strip(), item.get("duration")
        # No duration means live right now, scheduled, or a stream placeholder: list it once it has aired.
        if not vid or not title or not secs or secs < MIN_SECONDS:
            continue
        prev = old.get(vid, {})
        date = prev.get("published") or publish_date(vid)
        episodes.append({
            "id": vid,
            "episode": episode_number(title),
            "title": display_title(title),
            "youtubeTitle": title,
            "published": date,
            "seconds": int(secs),
            "url": f"https://www.youtube.com/watch?v={vid}",
            "thumb": f"thumbs/{vid}.jpg" if fetch_thumb(vid) else "",
        })

    if not episodes and old:
        print("ERROR: YouTube returned no episodes, keeping the old list.", file=sys.stderr)
        return 1

    # Forget thumbnails for videos that are gone
    keep = {f"{e['id']}.jpg" for e in episodes}
    for f in THUMBS.glob("*.jpg"):
        if f.name not in keep:
            f.unlink()

    new_text = json.dumps({"channelId": CHANNEL_ID, "episodes": episodes}, indent=2, ensure_ascii=False) + "\n"
    changed = not DATA.exists() or DATA.read_text() != new_text
    if changed:
        DATA.write_text(new_text)
    added = [e["title"] for e in episodes if e["id"] not in old]
    log(f"{len(episodes)} episodes" + (f", new: {'; '.join(added)}" if added and old else "") + ("" if changed else " (no change)"))
    return 0


if __name__ == "__main__":
    sys.exit(main())
