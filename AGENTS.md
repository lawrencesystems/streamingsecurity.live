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
- Show notes in `content/episodes/` start from Tom's words and research. Convert his notes faithfully: keep every source link, keep "alleged" and other confidence wording exactly, and do not change a fact, source, CVE, or control mapping he gave. Research-added material is allowed under the intake rules below, and only there. Ask if a mapping is unclear.
- Run `scripts/fetch-episodes.py` then `hugo --gc --minify` before opening a pull request; the build must finish with no errors or warnings.
- Publishing is a separate step: only `deploy/publish.sh`, only from a clean checkout of `main`, and only when Tom asks.

## Story intake from Signal

Tom and Matt drop story links into the Signal group "Streaming show notes" and
mention the intake agent. The agent researches the link, checks the framing
against the primary source, and writes the entry into the next episode that has
not been published.

- A link on its own means the story is for the next unpublished episode. A
  request alongside the link means go deeper than the default.
- Research depth: one primary source plus one independent corroboration. A third
  when the coverage is contested or single-sourced. Deeper only when asked.
- Pull the primary source (vendor advisory, CVE record, court filing, the
  vendor's own statement), not just coverage of it.
- Hype check: when the coverage oversells the primary source, say so in the
  notes and point at the source that supports or undercuts the framing.
- Research-added facts, sources, CVEs, and control mappings must each trace to a
  real source, and must be listed in the pull request description as
  agent-added, so Tom can see what is new against what came from him.
- Never invent or infer a fact, CVE ID, version number, date, or control
  mapping. Mark anything unverifiable as unverified.

## Writing

- No em dashes. Use commas, colons, or a new sentence.
- Plain, direct sentences. No hype, no fear-selling, no "stay vigilant."
- State facts, not verdicts about the hosts.
