# streamingsecurity.live

The site for Streaming Security, the live cybersecurity show with Tom Lawrence and Matt Lee, every Tuesday (except when they can't). One page: the show, every episode newest first, and an about section. Built with [Hugo](https://gohugo.io/). Everything here is public.

The look is the show's brand: the `~# streaming_security` root prompt with the red block cursor on a phosphor green terminal. Colors `#0C1F17`, `#33FF33`, `#C8342B`. Fonts are JetBrains Mono and Space Grotesk, self-hosted, so pages make no third-party requests.

## Episodes come from YouTube

Nobody types episodes in. `scripts/fetch-episodes.py` reads the [@StreamingSecurity](https://www.youtube.com/@StreamingSecurity) uploads with [yt-dlp](https://github.com/yt-dlp/yt-dlp) (no API key) and writes:

- `data/episodes.json`: title, episode number, length, publish date, link, in YouTube's order (newest first)
- `assets/thumbs/<id>.jpg`: each thumbnail, resized at build time and served from this site

Both are generated and gitignored. The build script runs the fetch every time, so a new episode shows up on the next publish after it airs.

What gets listed: anything on the channel at least 5 minutes long that has finished airing. Shorts, clips, and live or scheduled streams are skipped (`MIN_SECONDS` changes the cutoff). Titles drop the trailing `| Streaming Security EP5` tag since the page already shows it. If YouTube cannot be reached, the build keeps the last list.

Publish dates are best effort. YouTube sometimes asks datacenter IPs to sign in before it gives out video details; when that happens the episode is listed without a date and the script tries again next run.

## Show notes

Each episode can have notes at `content/episodes/<number>.md`, published at `/ep/<number>/`. Start one with:

```bash
hugo new content episodes/6.md
```

The file holds only what YouTube does not know. Title, thumbnail, date, and length are matched in from `data/episodes.json` by episode number (or by `youtube:` video ID if the YouTube title has no "EP <number>").

| Front matter | What it does |
| --- | --- |
| `description` | One or two sentences at the top of the page and in search results |
| `forum` | Adds a "Discuss on the forum" button |
| `controls` | CIS Controls v8.1 numbers, as strings: `["7", "8"]`. Each one lists the episode on `/controls/<n>/` |
| `cves` | CVE IDs, linked to NVD |
| `chapters` | `{ t: "4:12", title: "..." }` entries that link to that point in the video |

The body is ordinary Markdown. Use `##` for each story.

When an episode has notes, its homepage card links to the notes page and shows a "Show notes" badge. Without notes it links straight to YouTube, so notes can arrive after the stream.

`/controls/` lists all 18 CIS Controls and how many episodes mapped a story to each. Control names live in `data/cis_controls.yaml`.

## The Laws

`/laws/` and the homepage "cat laws.txt" section come from `data/laws.yaml`. Add a new law at the end of the list; the numbering and the "The Two Laws" count update themselves. `episodes:` lists the episode numbers where a law came up, and links to their notes.

## Edit the site

| What | File |
| --- | --- |
| Headline, intro, about text, hosts | `content/_index.md` |
| Contact page (forwards to lawrencesystems.com/contact/ for now) | `content/contact.md` |
| Site description, YouTube link | `hugo.yaml` |
| Share image | `assets/og/og.png` (1200x630) |
| Layout and styles | `layouts/`, `assets/css/site.css` |

To turn `/contact/` into a real page, delete the `redirect:` line in `content/contact.md` and write the page below the front matter.

Preview locally:

```bash
scripts/fetch-episodes.py
hugo server   # http://localhost:1313
```

Hugo 0.146 or newer, standard edition. yt-dlp on PATH; keep it current (`yt-dlp -U`, or reinstall), since YouTube changes break old versions.

## Workflow

Same as thomaslawrence.com.

1. Changes go on a branch and arrive as a pull request on GitHub.
2. Tom reviews and merges to `main`.
3. Tom asks the Claude in his LXC container to publish. It runs `deploy/publish.sh`, the build script: pull `main`, refresh episodes from YouTube, build, check the build, rsync to the web server.

```bash
deploy/publish.sh --dry-run   # show what would change on the server
deploy/publish.sh             # publish
```

`publish.sh` refuses to run with uncommitted local changes, so the live site always matches `main` on GitHub plus the current episode list. It uses the `lsweb` SSH alias and writes to `/var/www/streamingsecurity/public/` (override with `PUBLISH_REMOTE`).

Protect `main` in GitHub (Settings, Branches) so nothing lands on it without a pull request.

## Web server

Add the blocks in `deploy/Caddyfile` to `/etc/caddy/Caddyfile`, create `/var/www/streamingsecurity/public` owned by the deploy user, and run `systemctl reload caddy`.

## Optional: let the server publish by itself

`deploy/server-pull/` has a script and a systemd timer that make the web server check GitHub and YouTube every 30 minutes and publish when either changed, with no LXC step. New episodes then appear on their own. Setup steps are at the top of `deploy/server-pull/update.sh`. Use one method or the other, not both.
