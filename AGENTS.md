# Notes for agents working on this repo

The Streaming Security show site. Read README.md first.

## Rules

- Never push to `main`. Work on a branch and open a pull request; merging to `main` is what gets published.
- This repo is public. Never commit anything private: no booking links, private email addresses, tokens, cookies, or server details beyond what is already here.
- Episodes are generated. Do not hand-edit or commit `data/episodes.json` or `assets/thumbs/`; fix `scripts/fetch-episodes.py` instead.
- Do not invent facts about the show, the hosts, guests, or episodes. Copy comes from Tom. If something is missing, ask or leave it out.
- Keep to the brand: `#0C1F17` ground, `#33FF33` phosphor, `#C8342B` only for the cursor and the subscribe button. Red on green is hard for some colorblind viewers, so never let red alone carry meaning.
- No third-party requests from the published pages: fonts, thumbnails, and images are served from this site. Link to YouTube; do not embed players.
- Huntress is Tom's employer, not this show's sponsor. Do not describe Huntress products or make claims on Huntress's behalf.
- Run `scripts/fetch-episodes.py` then `hugo --gc --minify` before opening a pull request; the build must finish with no errors or warnings.
- Publishing is a separate step: only `deploy/publish.sh`, only from a clean checkout of `main`, and only when Tom asks.

## Writing

- No em dashes. Use commas, colons, or a new sentence.
- Plain, direct sentences. No hype, no fear-selling, no "stay vigilant."
- State facts, not verdicts about the hosts.
