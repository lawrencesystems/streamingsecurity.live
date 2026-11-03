---
# Create with: hugo new content episodes/<number>.md   (publishes at /ep/<number>/)
# Title, thumbnail, date, and length come from YouTube automatically, matched by episode number.
title: "EP{{ .File.ContentBaseName }}: "
episode: {{ .File.ContentBaseName }}
# One or two sentences. Shown at the top of the page and in search results.
description: ""
# Optional. The video ID, only needed if the YouTube title has no "EP <number>" in it.
youtube: ""
# Optional. The forum thread for discussion.
forum: ""
# CIS Controls v8.1 numbers the stories were mapped to, as strings: ["7", "8", "12"]
controls: []
# CVE IDs discussed: ["CVE-2026-12345"]
cves: []
# Optional. Timestamps into the video.
# chapters:
#   - { t: "0:00", title: "Cold open" }
#   - { t: "4:12", title: "Advisory triage" }
chapters: []
---

## Story one

What happened, with sources. Mark anything unconfirmed as alleged.

### Which control would have caught this

### Sources

- 
