# Streaming Security, EP9: Production Run of Show

*Airs Tue 2026-11-17. Hosts Tom Lawrence and Matt Lee.*

Published so Matt and anyone watching can follow the prep. This is the production doc,
not the show notes: it carries the running order, the per-story hooks, and the deep dive
plan as it stood when this snapshot was taken. Show notes for aired episodes are in
`content/episodes/<n>.md`.

| Field | Value |
|---|---|
| Episode | 9 |
| Air date | Tue 2026-11-17 |
| Hosts | Tom Lawrence, Matt Lee |
| Title | |
| Thumb text | |
| Cold open hook | |

Title candidates: "The Toolkit Waits For The Technician" / "Your Fix Tool Is The Attack Path" / "Tier Zero Called Back". Thumb text options, four words or fewer: "It waits for you" / "Triage triggered it" / "Do not remote in".

### Story sheet (stories in order, then the deep dive)

Order rationale: story 1 is the ScreenConnect campaign, because for this audience it is the
most urgent thing on the sheet and it teaches the beat no other story this month can: the
remote-access tool you investigate with is the attack path, so the first action is to stop
using it. Story 2 is ARTEX, the FBI FLASH advisory as the primary document with Appel's
analysis supplying the reality check and the Defender mapping. Story 3 and the deep dive
were both unconfirmed when this snapshot was taken.

### The laws, and which one lands on which story

Law 1, The Law of Successive Exploitation: once a vulnerability has been found and exploited
in a product, another will be found, and another after that, so treat a first exploited CVE
as the start of a campaign and plan for compensating controls or replacement rather than
assuming one patch closes the chapter. Law 2, The Law of Collapsing Complexity: that which is
complex will no longer be too complex for threat actors, so exploit complexity is not a
reason to deprioritize anything. Both live at streamingsecurity.live/laws.

Name the law when one applies, and say plainly when neither does, because "no law applies"
is itself a finding.

Story 1 is the open call. Law 1 is the closest fit, on the reading that the
September rogue-client flaw taught this same lesson and the remediation (reinstall host
clients, update access agents) is the part everyone skipped. The counter reading is that no
vulnerability is established here at all, so the law's trigger is not met and the honest
answer is neither. Either way it is a segment.

| # | Story | Source link | Why it matters | Control angle | Law |
|---|---|---|---|---|---|
| 1 | **ConnectWise ScreenConnect campaign against MSPs.** From about 17:47 UTC on Nov 11 an attacker with access to partner ScreenConnect instances used the built-in Run Command to push a second, attacker-controlled ScreenConnect client to managed endpoints, then a PowerShell toolkit: a scheduled task running as SYSTEM every 10 seconds, a modified client that impersonates the legitimate one and hands the toolkit to any technician who connects (the reverse pivot), and lateral-movement payloads. Huntress counts 6 compromised MSPs, 286 plus endpoints and 47 downstream organizations, still rising. ConnectWise reports no evidence of compromise of its own infrastructure and no ScreenConnect vulnerability, with an unvalidated initial assessment that the deployment went through five third-party extensions. No CVE. | [ConnectWise Trust Center advisory](https://www.connectwise.com/company/trust/advisories), [Huntress support article](https://support.huntress.io/hc/en-us/articles/57422935234195-2026-November-ScreenConnect), [Huntress disclosure and IOC thread](https://www.reddit.com/r/msp/comments/1xts3f2/active_malware_campaign_abusing_screenconnect/), [BleepingComputer](https://www.bleepingcomputer.com/news/security/active-screenconnect-attacks-breach-msps-impact-dozens-of-organizations/) | The reverse pivot is the story: the infected endpoint recruits the person who connects to fix it, so triage through the same tool makes the technician the vector. An RMM console is tier zero, and this one shipped an extension family that put a remote-command API behind a single partner-set passphrase. | CIS 2.1, 2.5, 4.1, 4.8, 5.4, 6.4, 8.11, 12.4, 13.11 | Law 1 candidate, flagged above for your call |
| 2 | **ARTEX, and the reality check.** An open-source, LLM-driven penetration testing framework in Go with an embedded Next.js console, published July 2026 under AGPL-3.0 and closed by its developer on Oct 8 after it turned up in attacks on South Korean banks. A planner agent takes a goal and hands work to worker agents that scan, exploit, steal credentials and move laterally with ordinary tools. Microsoft has seen initial targeting to privileged cloud access in under three hours, and one case from a leaked GitHub secret to Key Vault exfiltration in five minutes. Microsoft attributes Storm-0940 to 2,250 plus Microsoft 365 tenants through stolen ConnectWise Cloud Backup app credentials. More than 800 exposed consoles have been counted, and Check Point counted 1,608 live panels. The techniques are old. The tempo is new. | [FBI FLASH-20261113-001 (IC3 PDF)](https://www.ic3.gov/CSA/2026/261113.pdf), [Jeffrey Appel analysis](https://jeffreyappel.nl/artex-old-attacks-at-machine-speed-and-how-microsoft-defender-keeps-up/) | The reality check is the story. Every technique in the published intrusions predates the tool by years, so the lesson is not a new attacker playbook, it is that a four hour triage window was already too slow and agentic speed makes it fatal. Most paths used valid credentials, so no phish and no MFA prompt. | CIS 5.4, 6.5, 6.8, 8.11, 12.4, 15.1 | Law 2 candidate, your call |
| 3 | Third story not yet confirmed at this snapshot | | | | |

Deep dive topic was also unconfirmed at this snapshot. Candidates: the RMM console as tier zero (what an extension
is, what a partner-set passphrase behind a remote-command API means, and how to inventory
both), or the strip-down of this campaign on a lab host: the rogue client service, the
RelayTrap folder, the TrapWatch task, and why only event logs show it after the cleanup stage
runs.

A third option, if you would rather the deep dive carry the ARTEX story: walk the six-stage
loop the planner runs (recon, initial access, cloud and directory discovery, privilege
escalation, credential harvesting and lateral movement, objective) against the Defender
component that sees each stage, and say out loud what has to be licensed and switched on for
the chain to correlate into one incident.

Framework(s) to map against: CIS Controls v8.1, NIS2 / ENISA Implementing Regulation 2024/2690.

### Story hooks and bullets

Per story: the hook sentence, three bullets, and the evidence tier to name out loud. Do not
script the rest.

**1. ScreenConnect, and the technician who became the vector**

Hook: "An MSP's own remote-support tool pushed a second client to every endpoint it could
reach, and then waited for a technician to connect and investigate."

- Initial access is not established. Huntress telemetry points at compromised credentials or hijacked operator sessions, and its read is that the toolkit's design implies stolen operator sessions. ConnectWise's initial assessment is the five extensions in the RMM+ family (Labtech Plus, RMM Plus, RMM+, RMM Plus Password Link, RMM+ Password Link), which expose a remote-command API behind a partner-set passphrase, and roughly 400 partner environments have one of them. ConnectWise says the assessment is still being validated.
- Once in the panel, the attacker used Run Command to install a second ScreenConnect client reporting to attacker infrastructure, then a PowerShell toolkit. The modified client impersonates the legitimate one to the victim's own instance and delivers the toolkit to any technician who connects, which is how one compromised MSP spreads to the next. The kit drops `sqlite3.exe` to scrape saved browser sessions and auth tokens, then pivots into any other panels that technician can reach.
- Huntress's counts at publication: 6 compromised MSPs, 286 plus endpoints, 47 organizations, still rising. Sophos independently saw three likely compromised instances and two malicious deployment IDs, and the chain of `curl` to fetch an MSI from 185.99.255.28, `msiexec` to install it silently, then PowerShell with execution-policy bypass for a second stage.

Tier to name: three layers, kept apart. The ConnectWise advisory is the vendor's own, and its central claim is explicitly an unvalidated initial assessment. The counts and the toolkit behaviour are Huntress's own telemetry and incident reports. Sophos is a third vendor's independent sightings. The cleanup-stage and browser-cookie-scraping detail exists only as a Blackpoint analyst posting in the forum thread, so it goes out attributed that way or not at all.

*Disclosure: Tom works at Huntress, which found this campaign, published the IOCs, and is the source of the victim counts in this story.*

Before air: re-check the counts, whether ConnectWise has validated or dropped the extension assessment, and whether the panel version seen in the field (26.6.6.9747) says anything about the September rogue-client flaw, CVE-2026-84869. That flaw is a client-side file-transfer and execution issue, CVSS 9.9, in KEV since September 11, and its remediation required reinstalling host clients and updating access agents rather than only patching the server, so a patched panel does not close that path by itself. Nobody has confirmed the link, and Blackpoint says no new vulnerability was seen.

Worth 30 seconds, because chat will ask: the victim tag. Installer URLs carry a sequential `&c=Exploited<N>` tag and the observed tags start partway through the sequence, so MSPs were hit before this set, probably ones not running Huntress. The advice is to read Run Command history including the older entries.

On-air line: "Your RMM is one credential away from every machine you manage. This week it was one credential, and the attackers used your own console to enroll their second one."

The detection trap, if you want a beat nobody else has: Blackpoint's analyst says the kit runs a cleanup stage that removes the TrapWatch task, the Run key, the RelayTrap folder, the `sckit-*` temp directories and the payload files, and restores any ScreenConnect services it stopped. So live-state checks can come back clean on a host that was hit, and the answer is event logs: System 7045 for new ScreenConnect client service installs, Security 4698 or TaskScheduler 106 for TrapWatch, and MsiInstaller entries.

**2. ARTEX: fast, not new**

Hook: "The tool that supposedly rewrote the attacker playbook is running Nmap, password spraying and Kerberoasting. It just does it before your analyst finishes triage."

- What it is: a planner agent takes a goal and hands work to worker agents that scan, exploit, steal credentials and move laterally with ordinary tools, Bash, Nmap, curl and HTTP clients. Go, embedded Next.js console, any OpenAI-compatible model, with DeepSeek and other Chinese models dominant in observed abuse. The developer closed the source on Oct 8 after attacks on South Korean banks, but forks and archived copies circulate, and some clones ship a backdoor in the Docker image that gives unauthenticated root RCE. More than 800 exposed consoles have been counted, and Check Point counted 1,608 live panels. Microsoft's named actors: Storm-0940, China-state aligned, 2,250 plus Microsoft 365 tenants through stolen ConnectWise Cloud Backup app credentials, privileged access in under three hours. Storm-3358, Cambodia-based and financially motivated, hitting financial organizations from October 2026. Plus unnamed actors and opportunistic crews doing crypto theft, code-signing certificate theft and DDoS.

- The reality check, and the table that makes it: Nmap port and service scanning since 1997. Unpatched web app exploits, RCE, SSRF and file upload, since the OWASP Top 10 listed those classes in the early 2000s. Password spraying, a cloud identity staple for years. Secrets in public GitHub repos, documented for over a decade. Kerberoasting, publicly described in 2014. OAuth app and service principal abuse, seen in Solorigate in 2020 and Midnight Blizzard in 2024. Bulk Key Vault and storage key reads, as old as the cloud services themselves. Not one row is new. What changed is tempo and economics: sub three hours to privileged access, 2,900 failed sign-ins per minute at peak in Storm-0940, a campaign costing roughly 145 to 1,500 dollars mostly in model compute, and an agent that retries and adapts without getting tired. When an Azure Resource Manager call returned HTTP 400, it changed the API version or method and succeeded in 28 to 80 seconds. Wiz saw it rotate IPs within minutes of a block.

- The uncomfortable part for defenders: most successful paths used credentials that were already valid, so nobody was phished and MFA never fired. IP blocklists and static IOCs age in minutes. Behaviours to hunt instead: 27 cloud permission probes in 23 seconds, incrementing strings in file and account names, `artex-probe-*` files, `ArtexProbe` accounts. Do not key on user agents, they are inconsistent, and the same behaviour comes from CyberStrikeAI, HexStrike and PentAGI. Microsoft's answer is correlation across identity, cloud, SaaS and endpoint into one Defender XDR incident, with automatic attack disruption doing the containment, because a detection that reaches an analyst after four hours arrives after the data has left.

Tier to name: the FBI FLASH advisory is the primary document and checkable. Microsoft's telemetry, the Storm-0940 and Storm-3358 detail, and the Check Point and Wiz counts reach us through Appel's write-up, so they are reported second-hand and should be named that way. The technique-age table is Appel's analysis, not a vendor claim, so label it as analysis and say so.

*Disclosure: Tom works at Huntress. Nothing in this story rests on Huntress reporting, and the article it draws on is independent.*

On-air line: "ARTEX is fast, not new. It has not reinvented offensive security. It runs techniques that have worked for twenty years, just faster. Your four hour triage was survivable against a human. It is not survivable against this."

Before air: re-check whether the IC3 advisory page is still up and whether Microsoft has published a follow-up with updated tenant counts. The 800 plus and 1,608 console counts come from different scanners on different days, so cite them as separate counts rather than one number.

## Deep dive: unconfirmed at this snapshot

Show the thing. Screens or it did not happen.

1.
2.
3.

The control answer:
Rehearse it:

---

## Open loops carried from EP8

Answer these on air, or say "still no fix". Full detail and sources in `backlog.md`.

Which of these were answered live on November 10 is not recorded here, so confirm before air.

| Loop | What to check before air | Control angle |
|---|---|---|
| N-able and Able2Shell | Whether the hotfix shipped, whether hosted N-central is back up, and whether N-able still reports scanning only with no confirmed exploitation. The EP8 sheet said the hotfix ETA was mid-day Nov 10 EST, and Beazley claimed exploitation attempts. | CIS 7.4, 15.1, 15.4 |
| `*sshole` aftermath | Whether anything beyond recon has been observed, and whether CISA added CVE-2026-123158 to KEV after passing on it at disclosure. | CIS 4.1, 4.8, 7.4 |
| SonicWall CVE-2026-19868 | Whether any vendor has published attack details or IoCs. At publication nobody had, including SonicWall and CISA. | CIS 6.4, 6.5, 8.11 |
| DigiCert record count | Still undisclosed, and the second request for numbers in the bug is unanswered. Check whether Mozilla or Chrome has issued a determination. | CIS 3.12, 8.11 |
| XCPE device remediation | Whether the affected models are being pulled from retail, and whether anyone acts on the other device classes Google named (telehealth, karaoke, signage). | CIS 1.1, 2.1, 12.2 |
| CVE-2026-98432 on Ubuntu and RHEL CoreOS | Carried from EP7 and possibly answered on EP8. Check both vendor pages. | CIS 7.3, 7.7 |
| Refrigeration, wave two | Carried from EP7: whether the November 2 wave links to the October France attacks, and what the Pentagon found at the six commissaries. | CIS 1.1, 12.4, 15.1 |

One verification item is in `backlog.md` rather than here: the GoAhead Mbed TLS one-byte DH
modulus value (the X post says "04"). Confirm it with FoxIO before it is cited on air.

---

## Beats that never drop

- Which control would have caught this.
- Framework mapping with a specific control to go check.
- Open unknowns named on air and followed up next week.
- Chat questions answered live, in order.
- Evidence tier named for every claim.
- Name the law when one applies, and say plainly when neither does.
