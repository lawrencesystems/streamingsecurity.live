# Streaming Security, EP8: Production Run of Show

*Airs Tue 2026-11-10. Hosts Tom Lawrence and Matt Lee.*

Published so Matt and anyone watching can follow the prep. This is the production doc,
not the show notes: it carries the running order, the per-story hooks, the deep dive plan,
and the chosen packaging. Show notes for aired episodes are in `content/episodes/<n>.md`.

| Field | Value |
|---|---|
| Episode | 8 |
| Air date | Tue 2026-11-10 |
| Hosts | Tom Lawrence, Matt Lee |
| Title | SSL-VPN: The Gift That Keeps On Giving |
| Thumb text | MFA bypassed again |
| Cold open hook | An RMM vendor took its own hosted platform offline today, and told every on-prem customer to do the same. |

### Story sheet (eight stories, in order, then the deep dive)

Order rationale: story 1 is N-able, because for this audience the RMM going dark is the
most urgent story of the week and the best teaching beat in the set. Binance moves to 2
and keeps the most cinematic chain. Stories 3 and 4 are deliberately adjacent so the two
authentication bypasses reinforce each other instead of reading as separate patch notices.
Story 8 is Terminal2Shell, satire rather than a vulnerability, so it closes the show and is
the first cut if the clock bites. Matt tagged N-able as Law 2.

| # | Story | Source link | Why it matters | Control angle |
|---|---|---|---|---|
| 1 | **N-able took Hosted N-central offline** in the Americas, APAC and Europe and told on-prem customers to keep their N-central servers offline, citing a public disclosure of critical vulnerabilities in N-central. The disclosure is Able2Shell: 33 vulnerabilities published by Sean Bales (Oracle-Security) on Nov 9, with proof-of-concept code for four exploit chains, three reaching RCE and one reaching root, tested against N-central Appliance 2026.4.0.31 and likely earlier versions. No CVE IDs assigned. N-able has named neither the researcher nor the flaws and has published no technical detail. | [Status, incident 202580](https://uptime.n-able.com/event/202580/), [Able2Shell repo](https://github.com/Oracle-Security/CVEs/tree/main/0-Days/N-Central%20N-Able), [Huntress analysis](https://www.huntress.com/blog/n-able-disables-cloud-services-following-disclosure-of-able2shell-exploit-chains), [SecurityWeek](https://www.securityweek.com/n-able-takes-n-central-offline-as-researcher-drops-over-30-zero-days/), [Beazley advisory](https://labs.beazley.security/advisories/BSL-A1242) | As of Nov 10 at 15:16 UTC N-able reports scanning tied to the published PoCs and no evidence that any customer environment was successfully exploited. The hotfix was still pending, ETA mid-day Nov 10 EST, so re-check before air. On-prem guidance unchanged: stay offline until N-able confirms. An RMM server is one credential away from everything it manages. | CIS 7.4, 15.1, 15.4, 16.5, 16.11 |
| 2 | **Binance, TraderTraitor, and a coding assignment.** USD 6.34B taken Oct 29, attributed by the FBI, Secret Service and IRS-CI to DPRK's TraderTraitor. Chain: a tampered Homebrew installer for an AI coding tool in June, then a fake recruiter, two interviews and a "coding assignment" repo in September, then a container deployment token. | [Binance incident report](https://www.binance.com/en/blog/community/3229153443759566763) | The human path is the exploit chain: dev tooling, a real job platform, one deployment token. Endpoint protection missed the second stage. | CIS 5.4, 6.5, 6.8, 8.11, 14.2, 17.4 |
| 3 | **SonicWall SonicOS SSLVPN auth enforcement bypass, CVE-2026-19868** (CWE-308), one of seven flaws in SNWLID-2026-0014. Valid credentials for an alternate auth method bypass the SAML controls, and the MFA SAML was enforcing. In KEV the same day. | [PSIRT SNWLID-2026-0014](https://psirt.global.sonicwall.com/vuln-detail/SNWLID-2026-0014), [CISA KEV alert](https://www.cisa.gov/news-events/alerts/2026/11/06/cisa-adds-one-known-exploited-vulnerability-catalog) | KEV plus reported exploitation plus no workaround. CVE-2024-40766 is still being exploited two years on, so this appliance family is a proven repeat target. | CIS 4.1, 4.8, 5.4, 7.4 |
| 4 | **`*sshole` / CVE-2026-123158.** sshd on musl libc with no PAM accepts any password of 257 to 1024 bytes when the shadow field is exactly `*`. Fixed in OpenSSH 10.6p2 on Nov 5. Also the deep dive. | [sshhole.com](https://sshhole.com/), [OpenSSH 10.6p2 release notes](https://www.openssh.org/txt/release-10.6p2) | Exploited in the wild less than nine hours after publication. Recon only so far, and CISA has not added it to KEV. | CIS 4.1, 4.8, 5.4, 7.4 |
| 5 | **XCPE botnet.** 1.3M pre-infected Android set-top boxes. Google assesses with high confidence that Videostrong, a Chinese OEM/ODM, built and sold backdoor access. `x.cpe` ran in firmware at system UID; modules monetized devices as proxy exits and ad fraud. | [Google Threat Intelligence](https://cloud.google.com/blog/topics/threat-intelligence/shutting-the-door-on-the-xcpe-botnet), [Synthient report](https://synthient.com/blog/the-internals-of-a-badbox-operation) | The backdoor shipped in the firmware, so the trust unit is the hardware OEM, not the app. Google's answer was legal action and a certified-device ban, not a patch. | CIS 1.1, 2.1, 9.2, 12.2, 12.4, 15.1, 15.4 |
| 6 | **DigiCert CA compliance incident.** An internal system moved out of a VPN segment into an internet-reachable availability zone on 2025-02-04 and stayed 16 months. A self-registration feature skipped the MFA DigiCert otherwise requires, and one account read archived customer records in late June. | [Bugzilla 2084460](https://bugzilla.mozilla.org/show_bug.cgi?id=2084460), [The Record](https://therecord.media/digicert-certificate-authority-reports-data-breach) | Read-only and no certificates affected, but the detection timeline is the story: unknown accounts spotted in June, data access only confirmed October 19. | CIS 3.12, 4.1, 6.4, 6.8, 8.11 |
| 7 | **Residential proxy exits on the White House network** (AS2650). 236 exits from 6 addresses across 26 of 30 days, via 28 proxy services. The likely install named is Rave.io, a watch-party app bundling 12 proxy SDKs. | [Layer3 Intel](https://layer3intel.com/blog/residential-proxies-white-house-network), [The Register](https://www.theregister.com/security/2026/11/05/the-white-house-is-apparently-a-popular-residential-proxy-exit-spot/5307969) | Not a breach. Staff devices selling bandwidth, which is an inventory and egress problem rather than malware. Three source links deep, so treat it as the lighter close. | CIS 2.1, 2.5, 9.2, 12.4 |
| 8 | **Terminal2Shell (terminal2shell.com)**, a parody advisory for a "design-level vulnerability in terminal emulators": opening a terminal spawns a shell wired to your keyboard. "CVSS 11.0 out of 10", affected list includes the DEC VT100 over a serial cable, and the mitigations include removing the keyboard. Not a vulnerability: a joke about the 2Shell naming trend. | [terminal2shell.com](https://terminal2shell.com) | One minute of show that makes the point better than a lecture: a scary name, a logo and a website do not add up to a reachable exploit. It lands because the real ones beside it are real. | CIS 15.4, 16.5: read the advisory, not the logo. NIS2 21(2)(d) on supply chain claims |

Deep dive topic: reproduce CVE-2026-123158. Alpine container, unpatched sshd, log in as
root with a 257-byte password, then read the code path. Story 3 sets it up, the deep dive
takes it all the way down.
Framework(s) to map against: CIS Controls v8.1, NIS2 / ENISA Implementing Regulation 2024/2690.

### Story hooks and bullets

Per story: the hook sentence, three bullets, and the evidence tier to name out loud. Do not
script the rest.

**1. N-able and Able2Shell**

Hook: "An RMM vendor took its own hosted platform offline, and told every on-prem customer to do the same."

- Hosted N-central is offline across the Americas, APAC and Europe, and on-prem customers are told to keep their servers offline until N-able confirms they can safely come back. Incident 202580 replaced the earlier 202559 post. Status is Major Outage, still Investigating, last updated Nov 10 at 15:16 UTC.
- The disclosure is Able2Shell: 33 vulnerabilities from Sean Bales (Oracle-Security), published Nov 9 with proof-of-concept code for four exploit chains, three reaching RCE and one reaching root, tested against N-central Appliance 2026.4.0.31 and likely earlier. Bug classes in coverage: authentication bypass, credential disclosure, arbitrary file write, path traversal, XSS, XXE and RCE. No CVE IDs assigned, and N-able has named neither the researcher nor the flaws.
- The moving part, and the reason to re-check the status page right before air: N-able says it is "observing scanning activity associated with the published proof-of-concept code" and has "no evidence that any customer environment has been successfully exploited", with the hotfix "on track with no setbacks" and an ETA of mid-day Nov 10 EST. Beazley's November 10 update goes further and says researchers reported exploitation attempts in the wild. Report both and attribute both: scanning and attempts are not a confirmed compromise.

Tier to name: three layers, kept apart. The shutdown, the scanning and the hotfix ETA are vendor-attested on N-able's own status page. The 33 vulnerabilities are one researcher's claims with PoC code, reproduced by nobody else and not acknowledged by name by the vendor. The "exploitation attempts" line is a third-party advisory's assessment. No CVE, and no vendor advisory on the flaws themselves.
*Disclosure: Tom works at Huntress, which published analysis cited in this story.*

Before air: re-check incident 202580. The hotfix ETA was mid-day Nov 10 EST, so confirm whether it shipped, whether hosted environments are back up, and whether scanning is still the only activity N-able confirms. Story 1 changes if any of that moved.

Worth 30 seconds, because MSPs in chat will ask: Ecoverse services through N-able Login stay up (Asset View, Patching, Vulnerability Management, scripting, policies, tagging), along with N-able.app, Take Control from Asset View, and on-demand Windows Patching in preview. Huntress's guidance is to review login and audit logs from November 8 onward. One report says Kaseya disabled associated Autotask API users, which is the blast radius spreading sideways.
Context that makes it a pattern, not an incident: N-central 2026.4 HF1 went out on Nov 2 for CVE-2026-98432, CVE-2026-111497 and CVE-2026-114406. That is the Linux TCP bug from EP7 and the Brotli decoder bug from EP6, inside the RMM appliance. Beazley also notes researchers linked China-nexus Volt Typhoon to zero-day exploitation of two earlier N-central flaws in October 2026.

Matt's question, answered on air: a WAF is a compensating control at best. Terminating and inspecting TLS there can plausibly catch the payload-shaped chains (XXE, path traversal, OGNL, oversized SOAP fields, uploads that write JSP). It cannot see the auth and logic flaws at all: the derived MMS3 passcode, registration-token disclosure to a Technician role, zero-role policy download, MDM UDID impersonation, session and object mismatch, and the audit-record overwrite. And the agent-facing services (MMS/MMS2/MMS3) have to stay reachable from every managed endpoint, so they cannot be narrowed to an allowlist the way the admin console can.
On-air line: "Your RMM is one credential away from every machine you manage, which makes it the last place you want a 33-entry PoC repo pointed at."

**2. Binance**

Hook: "Binance lost 6.34 billion dollars, and the way in was a fake recruiter with a homework assignment."

- June: a Wallet DevOps engineer downloaded a tampered Homebrew installer for an AI coding tool from a search result, replacing `pyenv`. Binance caught it, swapped the device and rotated credentials, and the attacker still kept the role intelligence.
- September: a second engineer was approached by a fake recruiter on a real job platform, sat two interviews, then ran a "coding assignment" repo that called home. Binance calls the malware 0-day because endpoint protection did not detect it.
- Oct 29, 20:05 to 20:09 UTC: five hot wallets sent 233.46M XRP, about 970,500 SOL, 44.2M OP, then 18,270 BTC. EIP-7702 delegation gave an attacker contract execution rights over a hot wallet, and MPC meant there was no single key to revoke while transfers continued.

Tier to name: government attribution plus the victim's own incident report.
Attribute, do not assert: Pyongyang denies it, and Elliptic's 12,000 wallets across 11 chains is a separate tracking estimate, not Binance's number.

**3. SonicWall**

Hook: "SonicWall shipped a fix for an exploited MFA bypass with no workaround, and CISA added it to KEV the same day."

- CVE-2026-19868 is one of seven flaws in SNWLID-2026-0014. Valid credentials for an alternate authentication method bypass the SAML controls on SSLVPN, and the MFA that SAML was enforcing goes with them. It only bites where SAML is enabled for SSLVPN logins, so the first question is who can reach the service at all.
- Gen7 SonicOS 7.3.3-7015 and older, Gen8 8.2.2-8015 and older. Fixed in 7.3.4-7013 and 8.2.3-8015. No workaround, and the federal deadline is Nov 20.
- The history is the argument: CVE-2024-40766 at 9.3 is still being exploited in waves two years on, and CISA and the FBI tied Akira initial access to it in November 2025.

Tier to name: vendor PSIRT advisory plus CISA KEV. Nobody has published attack details, IoCs or an analysis of the intrusions.
On-air line, yours: "SSL-VPN really is the gift that keeps on giving... to threat actors."

**4. `*sshole`**

Hook: "Any password between 257 and 1024 bytes logs you in as root on Alpine, because musl's crypt() has returned the string `*` since 2012."

- Root and key-only accounts store `*` in the shadow field. musl's `crypt()` returns `*` on failure instead of NULL, and sshd started borrowing another account's salt in 2016 to fix the CVE-2016-6210 timing leak. `*` then compares equal to `*`.
- Affected: sshd with musl libc and no PAM, which means root on Alpine, key-only users, LDAP users via musl-nscd, and the `alpine` user on the official tiny-cloud images, which has passwordless `doas`.
- Fixed in OpenSSH 10.6p2 on Nov 5, and Alpine patched every branch back to 3.16. Exploited in the wild less than nine hours after publication against a honeypot, recon commands only. CISA has not added it to KEV.

Tier to name: release notes plus distro advisory plus CVE record. The in-the-wild claim is one vendor's honeypot, unconfirmed.
Two precision notes for air: the CVE record says 256 to 1024 characters and everyone else says 257, because 256 fails in the lab. And OpenSSH describing the root cause as "outside sshd" is a live ownership dispute with musl, not a settled fact.

**5. XCPE**

Hook: "The backdoor was not installed after you bought the box. It shipped in the firmware, from the company that made the box."

- `x.cpe` ran at `android.uid.system`, reinstalling itself from `/oem/` on reboot if a user uninstalled it. The MQTT C2 could silently install apps, disable Play Protect by setting `package_verifier_user_consent` to -1, run shell as system UID, capture the screen and inject keystrokes. Newer droppers use `libexploit.so` to restart `adbd` as root.
- The monetization modules turned boxes into residential proxy exits (Linkfog, Honeygain, NetNut, Gaganode, IPWeb and others) plus ad fraud. Synthient counts 1.3M backdoored devices with about 500,000 online daily, and recommends disposal rather than cleanup.
- Google took legal action against the C2, banned Videostrong from certified Android devices, and tightened firmware integrity checks. There is no patch for a device you already own.

Tier to name: one vendor's threat intelligence plus a second vendor's teardown and IOC list.
Widen the inventory question: the same code was found on telehealth devices, karaoke machines and digital signage, so this is not a "which TVs" question.

**6. DigiCert**

Hook: "A certificate authority moved an internal system onto the internet and did not notice for sixteen months."

- The system left a VPN segment for an internet-reachable availability zone on 2025-02-04 and stayed there. It carried a self-registration feature that was never meant to be on it, and accounts registered that way skipped the MFA DigiCert otherwise requires while still reading archived data.
- One such account read customer records between 2026-06-27 and 2026-07-02: names, business contact details, and for a minority a customer-supplied ID document. DigiCert says read-only, zero certificates affected, no validation actions, and it reports non-compliance from 2026-06-21.
- The timeline is the lesson. An internal team saw non-DigiCert accounts on 2026-06-18 and concluded they had no data access. A managed security program report the same week flagged account creation. The system was patched 2026-07-02. Data access was only confirmed 2026-10-19.

Tier to name: the CA owner's own compliance filing to a root program. Vendor-attested narrative, and the record count is still undisclosed.
Class problem, not one company: TWCA and D-Trust filed archive incidents in the same fortnight.

**7. White House proxy exits**

Hook: "236 residential proxy exits were observed on the Executive Office of the President's network, from devices that were never compromised."

- Layer3 Intel's observatory recorded 236 exits from 6 addresses across 26 of 30 days, Oct 5 to Nov 3, via 28 separate proxy services. Synthient's per-session detection named Windows 10 and 11 devices beaconing to Geonode, Infatica and Mellowtel.
- The likely install named is Rave.io, a watch-party streaming app bundling 12 proxy SDKs. Not malware: consent buried in a EULA, then your bandwidth on the market.
- The honest framing is proxy access, not a breach. No evidence any rented exit was used to attack anything, and the activity reportedly stopped the night after the blog went live.

Tier to name: independent vendor telemetry, corroborated by a second detection vendor and independent coverage.
On-air line: "Free streaming app, monetized twice."

**8. Terminal2Shell**

Hook: "A design-level flaw in every terminal since 1971 lets anyone who opens a terminal get a shell. It is also not a vulnerability, and that is the whole point."

- terminal2shell.com is a parody advisory, registered Oct 24: "CVSS 11.0 out of 10", "also tracked as TermGeddon", "CVE ID pending", a proof of concept that is an input box, and an affected list with the DEC VT100 over a serial cable on it.
- It exists because the real ones beside it are real: PHP2Shell (CVE-2026-109618 and -109619) went out Oct 20 to 21, the Brotli decoder bug shipped as Node2Shell, then Python2Shell, then HTTP2Shell (CVE-2026-111497), and Able2Shell put 33 N-central PoCs out this morning.
- Say out loud that it is a joke before the audience clicks it, then use it: the naming contest has outrun the reporting, and a logo is not an exploit.

Tier to name: satire. No CVE, no vendor, nobody credited on the page.
On-air line: "CVSS 11 out of 10, which is one more than the maximum, and about as real as the rest of it."

## Deep dive: reproduce CVE-2026-123158

Show the thing, in an Alpine container:

1. Read the shadow field. Root and key-only accounts are exactly `*`. Show it, do not describe it.
2. `ssh` with a 257-byte password, land as root, then read the code path: musl's `crypt()` returning `*` on failure since 2012, sshd borrowing another account's salt since 2016 to fix the CVE-2016-6210 timing leak, and `*` comparing equal to `*`.
3. Patch to OpenSSH 10.6p2 and run the same attempt. It fails.

The control answer: no password authentication for root or key-only accounts, no root login, and vendor packages current. The honest part: for the Alpine boxes in the room, someone tried this within nine hours of publication.
Rehearse it: the behaviour depends on the musl version and whether PAM is compiled in, so verify the container before air rather than discovering it live.

---

## Open loops carried from EP7

Answer these on air, or say "still no fix". Full detail and sources in `backlog.md`.

| Loop | What to check before air | Control angle |
|---|---|---|
| Cursor marketplace root cause | What access allowed the tampered `Anthropic.claude-code` 2.1.312 and 2.1.313 builds to be published. Cursor and Anthropic have still not disclosed it. | CIS 2.5, 16.5 |
| CVE-2026-98432 on Ubuntu and RHEL CoreOS | Ubuntu was "not fixed, work in progress" as of Nov 2 to 3; OpenShift 4 (RHEL CoreOS) was still affected. Check both vendor pages. | CIS 7.3, 7.7 |
| Refrigeration, wave two | Whether the November 2 seven-country wave links to the October France attacks, and what the Pentagon found at the six commissaries. No claim in either. | CIS 1.1, 12.4, 15.1 |

One verification item is in `backlog.md` rather than here: the GoAhead Mbed TLS
one-byte DH modulus value (the X post says "04"). Confirm it with FoxIO before it
is cited on air again.

---

## Beats that never drop

- Which control would have caught this.
- Framework mapping with a specific control to go check.
- Open unknowns named on air and followed up next week.
- Chat questions answered live, in order.
- Evidence tier named for every claim.
