# Streaming Security, EP9: Production Run of Show

*Airs Tue 2026-11-17. Hosts Tom Lawrence and Matt Lee.*

Published so Matt and anyone watching can follow the prep. This is the production doc,
not the show notes: it carries the running order, the per-story hooks, the deep dive plan,
and the chosen packaging. Show notes for aired episodes are in `content/episodes/<n>.md`.

| Field | Value |
|---|---|
| Episode | 9 |
| Air date | Tue 2026-11-17 |
| Hosts | Tom Lawrence, Matt Lee |
| Title | ARTEX Didn't Rewrite the Playbook |
| Thumb text | Old tools, new tempo |
| Cold open hook | The tool the FBI just issued a FLASH advisory about is running Nmap and Kerberoasting, techniques that are twelve to twenty-nine years old, and it still reached privileged cloud access in under three hours. |

### Story sheet (seven stories, in order, then the deep dive)

Order rationale: ARTEX opens because it is the theme and it is the argument the whole show
hangs on, and because the FBI now documents AI-agent intrusions in an official advisory,
which is the news. ScreenConnect goes second because it is the most urgent thing on the
sheet for an MSP audience and it teaches the beat no other story this month can: the
remote-access tool you investigate with is the attack path, so the first action is to stop
using it. Stories 3, 4 and 5 are deliberately adjacent because all three are the same
mechanism in different plumbing: a credential or a delegated right that was never scoped,
never rotated, or sitting in the wrong place. Stories 6 and 7 close the show as the two
biggest technology failures of the week with no attacker in either, which is the second half
of the reality check: not everything that breaks your week is a breach. Story 7 is the
network story for this audience and the one with the jokes, so it takes the closer, and it
is the first cut if the clock bites.

### The laws, and which one lands on which story

Law 1, The Law of Successive Exploitation: once a vulnerability has been found and
exploited in a product, another will be found, and another after that, so treat a first
exploited CVE as the start of a campaign and plan for compensating controls or
replacement rather than assuming one patch closes the chapter. Law 2, The Law of Collapsing
Complexity: that which is complex will no longer be too complex for threat actors, so
exploit complexity is not a reason to deprioritize anything. Both live at
streamingsecurity.live/laws, and the Law column below says where each one lands.

Name the law when one applies, and say plainly when neither does, because "no law applies"
is itself a finding. This week four of the seven stories carry a law and three do not, and
the three that do not are the point: two of them were not attacks at all.

Story 2 is the one call that needs you. Law 1 is the closest fit, on the reading that the
September rogue-client flaw taught this same lesson and the remediation (reinstall host
clients, update access agents) is the part everyone skipped. The counter reading is that no
vulnerability is established here at all, so the law's trigger is not met and the honest
answer is neither. Your call, and either way it is a segment.

| # | Story | Source link | Why it matters | Control angle | Law |
|---|---|---|---|---|---|
| 1 | **ARTEX, and the reality check.** An open-source, LLM-driven penetration testing framework in Go with an embedded Next.js console, published mid 2026 under AGPL-3.0 and taken down by its developer on Oct 8 after it turned up in attacks on South Korean banks. A planner agent takes a goal and hands work to worker agents that scan, exploit, steal credentials and move laterally with ordinary tools, Bash, Nmap, curl and HTTP clients. The FBI says a variety of actors have weaponised it since at least August 2026, that some intrusions reach privileged access in under three hours, and that the attacks are noisy enough to generate alerts defenders cannot answer fast enough. Microsoft attributes Storm-0940 to more than 2,250 Microsoft 365 tenants through stolen ConnectWise Cloud Backup application credentials, and tracks Storm-3358, Cambodia-based and financially motivated, against financial organizations from October 2026. The techniques are old. The tempo is new. | [FBI FLASH-20261113-001 (IC3 PDF)](https://www.ic3.gov/CSA/2026/261113.pdf), [Jeffrey Appel analysis](https://jeffreyappel.nl/artex-old-attacks-at-machine-speed-and-how-microsoft-defender-keeps-up/), [BleepingComputer](https://www.bleepingcomputer.com/news/security/fbi-warns-artex-ai-hacking-tool-is-powering-global-cyberattacks/), [The Record](https://therecord.media/artex-ai-tool-fbi-flash-alert) | The reality check is the story. Every technique in the published intrusions predates the tool by years, so the lesson is not a new attacker playbook, it is that a four hour triage window was already too slow and agentic speed makes it fatal. Most successful paths used credentials that were already valid, so no phish and no MFA prompt. | CIS 5.4, 6.5, 6.8, 8.11, 12.4, 15.1: hunt the behaviour, not the user agent. 27 cloud permission probes in 23 seconds, incrementing strings in file and account names, `artex-probe-*` files and `ArtexProbe` accounts. | Law 2, and the FBI put its name on it. A six-stage chain nobody would have rated as likely is now a tool an operator runs. |
| 2 | **ConnectWise ScreenConnect campaign against MSPs.** From about 17:47 UTC on Nov 11 an attacker with access to partner ScreenConnect instances used the built-in Run Command to push a second, attacker-controlled ScreenConnect client to managed endpoints, then a PowerShell toolkit: a scheduled task running as SYSTEM every 10 seconds, a modified client that impersonates the legitimate one and hands the toolkit to any technician who connects (the reverse pivot), and lateral-movement payloads. Huntress counts 6 compromised MSPs, 286 plus endpoints and 47 downstream organizations, still rising. ConnectWise reports no evidence of compromise of its own infrastructure and no ScreenConnect vulnerability, with an unvalidated initial assessment that the deployment went through five third-party extensions. No CVE. | [ConnectWise Trust Center advisory](https://www.connectwise.com/company/trust/advisories), [Huntress support article](https://support.huntress.io/hc/en-us/articles/57422935234195-2026-November-ScreenConnect), [Huntress disclosure and IOC thread](https://www.reddit.com/r/msp/comments/1xts3f2/active_malware_campaign_abusing_screenconnect/), [BleepingComputer](https://www.bleepingcomputer.com/news/security/active-screenconnect-attacks-breach-msps-impact-dozens-of-organizations/) | The reverse pivot is the story: the infected endpoint recruits the person who connects to fix it, so triage through the same tool makes the technician the vector. An RMM console is tier zero, and this one shipped an extension family that put a remote-command API behind a single partner-set passphrase. | CIS 2.1, 2.5, 4.1, 4.8, 5.4, 6.4, 8.11, 12.4, 13.11: inventory every extension and the API credentials behind it, and detect from logs rather than live state, because the kit cleans up after itself. | Law 1 candidate, flagged above for your call. |
| 3 | **wfx-loot, a CI credential stealer.** From about 12:45 UTC on Nov 10, 4,837 compromised accounts opened probe pull requests from a `wfx-docs` branch into 61,764 repositories, 10,431 of which the account does not own but can write to through collaborator or organization access. Where write access allowed, the payload landed one of three ways: a roughly 1,500 line addition to an existing workflow, an npm postinstall hook that runs on a developer laptop rather than only a runner, or a new workflow file in an empty repository. It reverts within about a minute and deletes the run and its logs, so a gap in the workflow run numbers is often the only trace. It reads Actions secrets and variables, `GITHUB_TOKEN`, the OIDC and Actions runtime tokens, cloud and registry credential files, AI provider keys, shell histories and kubeconfigs, then escalates through the OIDC token into AWS, GCP and Azure, chains IAM roles, calls `iam:CreateAccessKey`, and persists by forging success status checks under the repository's own required-check context names, rewriting a chained AWS role trust policy to `Principal: *`, and adding Entra federated identity credentials named `wfx-ci`. | [Aikido write-up](https://www.aikido.dev/blog/compromised-github-accounts-push-ci-secret-stealer-to-tens-of-thousands-of-repositories), [SafeDep write-up](https://safedep.io/blog/github-actions-wfx-credential-stealer), [SecurityWeek](https://www.securityweek.com/attacker-targets-60000-github-repositories-in-credential-theft-campaign/), [Help Net Security](https://www.helpnetsecurity.com/2026/11/12/wfx-loot-github-actions-secret-stealer/) | Keep the three counts apart: 61,764 repositories received a pull request, 8,093 received malicious commits, and 1,806 to 1,835 actually ran the payload. Do not call it a supply chain attack, since the two tainted packages are a side effect of automated publishing triggers. Workflow write access is tier zero, the run logs were deleted, so a clean audit is not a clean bill. | CIS 4.1, 4.8, 5.4, 6.4, 6.5, 8.11, 12.4, 12.6, 13.11, 15.4, 16.5: rotate every secret the workflows could reach rather than the ones you think were used, then hunt Entra federated credentials named `wfx-ci`, AWS sessions named `wfx` followed by `CreateAccessKey` or `UpdateAssumeRolePolicy`, and Vault JWT logins from the GitHub OIDC issuer. | Law 1. Rotation does not end it, the persistence is built to survive rotation, and the npm postinstall variant refills the same stolen-token pool for the next wave. |
| 4 | **Cursor post-mortem, which closes the EP7 open loop.** The chain started at Cursor's training and inference vendor, not at Cursor: an access key Cursor issued to Fireworks was exposed at Fireworks, and the attacker read a bucket of coding agent traces, mostly from 2025, from sessions not in Privacy Mode. A small number of traces held unredacted credentials, under 0.01% of customers had API credentials exposed, and from those the attacker reached select SaaS tools, then archived non-production source repositories, limited support data and email, product usage metrics, and credentials users had sent to support. On Oct 29 a credential taken from that data placed malicious copies of Anthropic's Claude Code extension on the cache serving the Cursor marketplace, live for about 11 hours, 2:27am to 1:35pm PT. Payload: environment collection, an attacker SSH key labelled `svc-telemetry` appended to `authorized_keys`, the local SSH service enabled, and a reverse tunnel with LaunchAgent or SYSTEM-level scheduled-task persistence retrying about every 60 seconds. Enabling SSH needs admin, which the extension did not have on most hosts, so the tunnel mostly failed. | [Cursor investigation update](https://cursor.com/blog/security-incident-update), [Cursor security notice](https://cursor.com/blog/claude-code-extension-security-notice), [BleepingComputer](https://www.bleepingcomputer.com/news/security/cursor-confirms-security-breach-led-to-malicious-claude-code-extension/), [Microsoft Threat Intelligence](https://www.microsoft.com/en-us/security/blog/2026/10/30/inside-malicious-claude-code-branded-cursor-extension-persistent-ssh-backdoor/) | Root cause is closed: Anthropic did not publish the build, it was not an Anthropic vulnerability, and the package never appeared in the VS Marketplace, npm or Open VSX. Keep three populations apart: at most 5,000 users received the tampered extension, under 0.05% of users had traces exposed, under 0.01% had API credentials exposed. The uncomfortable line is the plain one, the credentials were sitting unredacted inside agent traces being used for model training. | CIS 2.1, 3.1, 3.2, 4.1, 6.8, 15.1, 15.3, 15.4: the sub-processor is the control surface, secrets in training and support data are the leak, and a serving cache needs its own integrity check rather than trusting the upstream source. Practical: no credentials pasted into agent sessions or support tickets, short-lived scoped tokens, Privacy Mode for sensitive code. | Law 2. A five hop chain across a vendor, a bucket, training traces, SaaS tools and an internal system is exactly the complexity nobody rates as likely until it happens. |
| 5 | **Infoblox and the migration contractor.** Infoblox confirmed on Nov 16 that it is investigating unauthorized access to company information through a compromised third-party data migration vendor. The vendor did SharePoint migration work and held trusted access to Infoblox's SharePoint, and per The Register's sources the intruders used the vendor's accounts to exfiltrate data directly from SharePoint. Reported taken: configuration information for some customers' NIOS deployments, meaning saved snapshots of DNS and DHCP configuration, Grid databases and reporting logs, plus employee data from a CEO email the outlet says it saw, including direct deposit details, dates of birth and Social Security numbers for employees and dependents. Infoblox says it contained the incident and has no indication that its products, cloud services, updates or build pipeline were involved. It will not say how many customers or employees are affected, whether the attacker made contact, or whether demands were made. No group has claimed it. | [TechCrunch](https://techcrunch.com/2026/11/16/cyber-giant-infoblox-confirms-security-incident-after-hackers-access-company-information/), [The Register](https://theregister.com/security/2026/11/16/infoblox-customer-and-staff-data-exposed-in-sharepoint-breach/5310280), [Security Affairs](https://securityaffairs.com/203309/data-breach/infoblox-confirms-supply-chain-breach-after-attackers-access-sensitive-data.html) | Everything specific about severity is third-party reporting rather than the vendor's own words, and the not-affected line covers products, cloud services, updates and the build pipeline, which is narrower than it sounds. Nobody has confirmed whether those snapshots held credentials, TSIG keys or API tokens, so do not assume either way, and a missing customer notification is not an all clear. A DNS and DHCP snapshot is a map of the network even with no logins in it. | CIS 3.1, 3.2, 3.12, 6.8, 15.1, 15.3, 15.4, 16.11 and NIS2 21(2)(d) and Art 28: a migration contractor needs broad rights across document libraries, usually through a service account or app registration with tenant-wide scope. Ask in writing whether your NIOS backups, support bundles or Grid exports were in scope, then rotate anything those files could hold. | Neither law. Vendor-mediated access and a disclosure problem, with no exploit and no vulnerability established. |
| 6 | **Microsoft 365 and Exchange Online outage**, incidents EX1550543 and MO1550821. Impact window 12 Nov 16:20 UTC to 13 Nov 16:10 UTC, just under 24 hours. Three factors: a latent defect in a fix written specifically for the Microsoft 365 networking gateway servers and deployed from July, which caused lock contention in an internal Windows process and exhausted CPU and memory; a load surge after Teams failed over to the primary gateway about 15 hours earlier; and nearly 14 percent of gateway capacity already out of service from an unrelated issue the day before. Load testing missed it because the labs ran weaker hardware with fewer cores, and the defect worsens on newer machines with more cores. Automatic rerouting spread the fault and the bulkheads between capacity units failed to contain it, so within two hours more than 80 percent of gateway servers were unresponsive. Rollback was impossible because the defect was months old, so engineers wrote an update that returned the code path to the known good state. Exchange Online could not fail out of the gateway and Microsoft has not said why. The final report is due Nov 20. | [The Register, the July fix](https://www.theregister.com/saas/2026/11/16/microsoft-blames-monster-email-outage-on-software-defect-introduced-in-july-fix/5310026), [The Register, a crash course in dependence](https://www.theregister.com/saas/2026/11/13/microsoft-outage-gives-customers-a-crash-course-in-dependence-on-redmond/5309805), [Lamanna on X, abridged report](https://x.com/clamanna/status/2122209697226948729), [RTE, HSE and paper prescriptions](https://www.rte.ie/news/2026/1114/1599205-microsoft-outage/) | No attacker, and that is the finding. Three precision notes: "more than 80 percent of servers unresponsive" means gateway servers, and some headlines inflated it to 80 percent of Microsoft. The duration depends on what you measure, the impact window is just under 24 hours while the social media version is 30 or 36. And Microsoft ruled out AI and cyber before it had published a cause, which is worth noting rather than accepting. | CIS 4.1, 4.8, 7.4, 16.7, 17.x: you cannot fix this from your tenant, so what you control is detection, what your users are told, and the dependency map that exists before the outage. The load-testing lesson generalises, test on production-like hardware. The cascade lesson generalises too, health checks and failover can amplify a fault and bulkheads are only as good as the isolation behind them. | Neither law. Nothing was exploited, so there is no attacker for either law to describe. |
| 7 | **Nationwide US ground stop, traced to two newly installed routers.** Friday Nov 13. Communications trouble started at the Indianapolis Center when controllers could not talk to flight crews, and the FAA traced the traffic to a radio site in El Dorado, Arkansas and a radar site in Amarillo, Texas, where L3Harris had recently installed new Juniper routers. FAA technology chief Rebecca Guy, on record: the two sites were pinging the network at a very high rate, a thousand connections over every four to five seconds. That traversed the FAA Telecommunications Infrastructure, a decades-old mix of copper and fiber, and 17 of the 22 air route traffic control centers lost communications, which is what produced the ground stop. Disabling the two routers stabilized the network, and the FAA then turned off a specific router feature across all of its roughly 60 Juniper routers. About four hours end to end, more than 8,200 flights canceled Friday and at least another 3,000 on the Saturday. Third nationwide ground stop of the century, and the FAA has not established a root cause. | [Tom's Hardware](https://www.tomshardware.com/networking/two-hpe-juniper-network-routers-grounded-all-the-us-flights-on-friday-faas-decades-old-copper-network-buckled-under-a-feature-hpe-says-worked-as-intended-creaking-air-traffic-communication-system-became-overloaded-by-very-high-rate-pinging), [WSJ](https://www.wsj.com/business/airlines/the-single-router-in-southern-arkansas-that-ground-air-travel-to-a-halt-eedc326c), [CNBC, root cause unknown](https://cnbc.com/2026/11/14/root-cause-of-nationwide-ground-stop-is-unknown-faa-says.html), [TechCrunch, the Saturday press conference](https://techcrunch.com/2026/11/14/transportation-secretary-blames-routine-equipment-upgrade-for-grounding-flights-nationwide) | Two conflations to avoid. The FAA said not to conflate this with the 12.5 billion dollar modernization program, and "the decades-old copper is the problem" does not stand, because without the flood the copper carried the load it always carried. HPE saying the devices did not fail is the story rather than a defence: if a default feature floods the network, the answer was to disable it on all 60 routers. The r/sysadmin thread is 500 plus comments of confident diagnosis from people who have not seen the config, so nothing in it is evidence. | CIS 4.1, 4.8, 12.4, 12.6, 17.x: control-plane protection and change validation on the network itself. The question the thread asks better than the coverage does, why was traffic from one or two remote sites allowed to compromise communications across most of the national network. | Neither law. An engineering failure, with nobody attacking anything. |

Deep dive topic: walk the six-stage ARTEX loop (recon, initial access, cloud and directory
discovery, privilege escalation, credential harvesting and lateral movement, objective)
against what each stage leaves behind, and show the hunt for it rather than describing it.
Close by saying out loud what has to be licensed and switched on for the chain to correlate
into one incident instead of six unrelated alerts.
Framework(s) to map against: CIS Controls v8.1, NIS2 / ENISA Implementing Regulation 2024/2690.

### Story hooks and bullets

Per story: the hook sentence, three bullets, and the evidence tier to name out loud. Do not
script the rest.

**1. ARTEX: fast, not new**

Hook: "The tool that supposedly rewrote the attacker playbook is running Nmap, password spraying and Kerberoasting. It just does it before your analyst finishes triage."

- What it is: a planner agent takes a goal and hands work to worker agents that scan, exploit, steal credentials and move laterally with ordinary tools, Bash, Nmap, curl and HTTP clients. Go, embedded Next.js console, any OpenAI-compatible model, with DeepSeek and other Chinese models dominant in observed abuse. The developer took the repository down on Oct 8, but forks, localised versions, archived copies and a commercial build called ARTEX PRO circulate. Censys counted more than 1,600 publicly exposed consoles by early November and says total deployments are higher.

- The reality check, and the table that makes it: Nmap port and service scanning since 1997. Unpatched web app exploits, RCE, SSRF and file upload, since the OWASP Top 10 listed those classes in the early 2000s. Password spraying, a cloud identity staple for years. Secrets in public GitHub repos, documented for over a decade. Kerberoasting, publicly described in 2014. OAuth app and service principal abuse, seen in Solorigate in 2020 and Midnight Blizzard in 2024. Bulk Key Vault and storage key reads, as old as the cloud services themselves. Not one row is new. What changed is tempo and economics: sub three hours to privileged access, 2,900 failed sign-ins per minute at peak in Storm-0940, a campaign costing roughly 145 to 1,500 dollars mostly in model compute, and an agent that retries and adapts without getting tired. When an Azure Resource Manager call returned HTTP 400, it changed the API version or method and succeeded in 28 to 80 seconds. Wiz saw it rotate IPs within minutes of a block.

- The uncomfortable part for defenders: most successful paths used credentials that were already valid, so nobody was phished and MFA never fired. IP blocklists and static IOCs age in minutes. Behaviours to hunt instead: 27 cloud permission probes in 23 seconds, incrementing strings in file and account names, `artex-probe-*` files, `ArtexProbe` accounts. Do not key on user agents, they are inconsistent, and the same behaviour comes from CyberStrikeAI, HexStrike and PentAGI. Microsoft's answer is correlation across identity, cloud, SaaS and endpoint into one Defender XDR incident, with automatic attack disruption doing the containment, because a detection that reaches an analyst after four hours arrives after the data has left.

Tier to name: the FBI FLASH advisory is the primary document and checkable, which is itself the news, since the bureau is now documenting AI-agent intrusions in an official advisory. Microsoft's telemetry, the Storm-0940 and Storm-3358 detail, and the Check Point and Wiz counts reach us through Appel's write-up, so they go out named as reported second-hand. The technique-age table is Appel's analysis, not a vendor claim, so label it as analysis and say so.

*Disclosure: Tom works at Huntress, whose telemetry is cited in this story. Nothing here rests on it, and the article it draws on is independent.*

On-air line: "ARTEX is fast, not new. It has not reinvented offensive security. It runs techniques that have worked for twenty years, just faster. Your four hour triage was survivable against a human. It is not survivable against this."

Before air: re-check the IC3 advisory page, whether Microsoft has published updated tenant counts, and whether anyone has published a real Censys or Check Point console number to replace the two scanner counts. The advisory's ConnectWise figures are attempts, not compromises, and one report already inflated them, so say reach against more than 2,250 tenants, never access.

**2. ScreenConnect, and the technician who became the vector**

Hook: "An MSP's own remote-support tool pushed a second client to every endpoint it could reach, and then waited for a technician to connect and investigate."

- Initial access is not established. Huntress telemetry points at compromised credentials or hijacked operator sessions, and its read is that the toolkit's design implies stolen operator sessions. ConnectWise's initial assessment is the five extensions in the RMM+ family (Labtech Plus, RMM Plus, RMM+, RMM Plus Password Link, RMM+ Password Link), which expose a remote-command API behind a partner-set passphrase, and roughly 400 partner environments have one of them. ConnectWise says the assessment is still being validated.

- Once in the panel, the attacker used Run Command to install a second ScreenConnect client reporting to attacker infrastructure, then a PowerShell toolkit. The modified client impersonates the legitimate one to the victim's own instance and delivers the toolkit to any technician who connects, which is how one compromised MSP spreads to the next. The kit drops `sqlite3.exe` to scrape saved browser sessions and auth tokens, then pivots into any other panels that technician can reach.

- Huntress's counts at publication: 6 compromised MSPs, 286 plus endpoints, 47 organizations, still rising. Sophos independently saw three likely compromised instances and two malicious deployment IDs, and the chain of `curl` to fetch an MSI from 185.99.255.28, `msiexec` to install it silently, then PowerShell with execution-policy bypass for a second stage.

Tier to name: three layers, kept apart. The ConnectWise advisory is the vendor's own, and its central claim is explicitly an unvalidated initial assessment. The counts and the toolkit behaviour are Huntress's own telemetry and incident reports. Sophos is a third vendor's independent sightings. The cleanup-stage and browser-cookie-scraping detail exists only as a Blackpoint analyst posting in the forum thread, so it goes out attributed that way or not at all.

*Disclosure: Tom works at Huntress, which found this campaign, published the IOCs, and is the source of the victim counts in this story.*

Before air: re-check the counts, whether ConnectWise has validated or dropped the extension assessment, and whether the panel version seen in the field (26.6.6.9747) says anything about the September rogue-client flaw, CVE-2026-84869. That flaw is a client-side file-transfer and execution issue, CVSS 9.9, in KEV since September 11, and its remediation required reinstalling host clients and updating access agents rather than only patching the server, so a patched panel does not close that path by itself. Nobody has confirmed the link, and Blackpoint says no new vulnerability was seen.

Worth 30 seconds, because chat will ask: the victim tag. Installer URLs carry a sequential `&c=Exploited<N>` tag and the observed tags start partway through the sequence, so MSPs were hit before this set, probably ones not running Huntress. The advice is to read Run Command history including the older entries.

On-air line: "Your RMM is one credential away from every machine you manage. This week it was one credential, and the attackers used your own console to enroll their second one."

The detection trap, if you want a beat nobody else has: Blackpoint's analyst says the kit runs a cleanup stage that removes the TrapWatch task, the Run key, the RelayTrap folder, the `sckit-*` temp directories and the payload files, and restores any ScreenConnect services it stopped. So live-state checks can come back clean on a host that was hit, and the answer is event logs: System 7045 for new ScreenConnect client service installs, Security 4698 or TaskScheduler 106 for TrapWatch, and MsiInstaller entries.

**3. wfx-loot, and the CI pipeline as a credential store**

Hook: "Sixty thousand repositories got a pull request from a branch that only wanted one thing, and it was not a code review."

- The scan is the cheap part. 4,837 compromised accounts opened pull requests from `wfx-docs` into 61,764 repositories, and 10,431 of those repositories the account does not own but can write to through collaborator or organization access. Where write access allowed, the payload went in as a 1,500 line addition to an existing workflow, an npm postinstall hook that runs on a developer laptop rather than only a runner, or a new workflow file in an empty repository.

- It reverts within about a minute and deletes the run and its logs, so a gap in the workflow run numbers is often the only trace. That is why the negative result is not evidence of safety.

- What it takes is everything the pipeline can reach: Actions secrets and variables, `GITHUB_TOKEN`, the OIDC and runtime tokens, cloud and registry credential files, AI provider keys, shell histories, kubeconfigs, then escalation through the OIDC token into AWS, GCP and Azure, `iam:CreateAccessKey`, and three persistence mechanisms.

Tier to name: two independent vendor analyses of the same campaign, a third vendor's coverage, and a fourth's write-up, all of them telemetry from their own sensors. Nobody has a victim list, and neither analysis establishes how the 4,837 accounts were taken in the first place.

Attribute, do not assert: the count that matters is which count you mean. 61,764 repositories received a pull request, 8,093 got malicious commits on default branches of public repositories, 1,806 to 1,835 ran the payload, and both vendors say their own numbers may understate it because the runs were deleted.

On-air line: "They did not steal your secrets. They read them at runtime from the place you were told was safe, then deleted the receipt."

**4. Cursor, and the credential that was sitting in the training data**

Hook: "The extension marketplace was not hacked. A bucket of coding agent traces was read, and a credential that someone pasted into a chat was sitting inside it."

- The chain starts at a vendor, not at the victim: an access key Cursor issued to Fireworks was exposed at Fireworks. That key read a bucket of coding agent traces, mostly from 2025, from sessions not in Privacy Mode. Reading a read-only bucket was enough, because a small number of traces held unredacted credentials.

- From those, the attacker reached SaaS tools, then archived non-production source repositories, support data and email, product usage metrics, and credentials users had sent to support. On Oct 29 a credential taken from that data placed malicious copies of the Claude Code extension directly on the cache that serves the Cursor marketplace, live for about 11 hours.

- The payload appended an attacker SSH key labelled `svc-telemetry` to `authorized_keys`, enabled the local SSH service, and set up a reverse tunnel with LaunchAgent or SYSTEM-level scheduled-task persistence, retrying about every 60 seconds. Enabling SSH needs admin, which the extension did not have on most hosts, so the tunnel mostly failed, though keys and persistence artifacts may still have been written.

Tier to name: the vendor's own incident report, plus Microsoft Threat Intelligence's independent analysis of the injected code and Anthropic's confirmation that it did not publish the build.

Two things to say plainly: Anthropic was not hacked, and the package never appeared in the VS Marketplace, npm or Open VSX. And keep three populations apart, at most 5,000 users received the tampered extension, under 0.05% of users had traces exposed, under 0.01% of customers had API credentials exposed.

On-air line: "Read only is not harmless when the thing being read is a credential."

**5. Infoblox, and what a DNS snapshot is worth**

Hook: "A migration contractor owned a trusted path into a DNS vendor's SharePoint, and the customers finding out first are the ones reading the news."

- Infoblox confirmed on Nov 16 that it is investigating unauthorized access to company information through a compromised third-party data migration vendor. The intruders used the vendor's accounts to exfiltrate directly from SharePoint.

- Reported taken: configuration information for some customers' NIOS deployments, which is saved DNS and DHCP snapshots, Grid databases and reporting logs, plus employee data per a CEO email the outlet says it saw. Infoblox will not say how many customers or employees are affected.

- The disclosure shape is the story. No vendor advisory of its own, no filing because the company is private, no threat actor claim, and a not-affected line that covers products, cloud services, updates and the build pipeline, which is narrower than it sounds.

Tier to name: a narrow vendor statement made through a spokesperson, plus third-party reporting. The NIOS snapshot detail and the employee data categories come from The Register's unnamed sources and a CEO email that outlet says it saw, not from a published advisory.

Do not assume either way: nobody has publicly confirmed whether those snapshots held credentials, TSIG keys or API tokens. A DNS and DHCP snapshot is a map of the network even with no logins inside it, so treat the file as sensitive regardless.

On-air line: "Ask your DNS vendor in writing whether your backups were in scope. The answer belongs in your incident ticket, not in your memory."

**6. Microsoft 365, and the fix that broke it five months later**

Hook: "The outage was caused by a fix Microsoft wrote for the gateway, deployed in July, and nobody could roll it back because it was months old."

- Three factors, per Microsoft's own preliminary report: a latent defect in a fix prepared specifically for the Microsoft 365 networking gateway servers and deployed from July, causing lock contention in an internal Windows process and exhausting CPU and memory; a load surge after Teams failed over to the primary gateway about 15 hours earlier; and nearly 14 percent of gateway capacity already out of service from an unrelated issue the day before.

- Load testing missed it because the labs ran weaker hardware with fewer cores, and the defect gets worse on newer machines with more cores. Automatic rerouting spread the fault and the bulkheads between capacity units failed to contain it, so within two hours more than 80 percent of gateway servers were unresponsive, which means gateway servers, not Microsoft.

- Rollback was impossible because the defect was months old, so engineers wrote an update that returned the code path to the known good state. The line in the report that matters most is the one about scope: not all services, like Exchange Online, can fail out of this network gateway for scale reasons. Teams, OneDrive, SharePoint and the Office apps did fail out, which is why chat and meetings kept working. Exchange could not, so the only lever anyone had was what sat in front of it. A forum-tier reading adds that Microsoft extended the mail timeout window to 48 hours so queued mail did not come back undeliverable, which needs the report itself before it goes on air. The final report is due Nov 20, after this show, so anything said about remediation is provisional.

Tier to name: the vendor's own preliminary incident report, quoted second-hand where the admin centre is login gated, plus mainstream coverage and aggregator timelines. No independent technical analysis of the defect exists.

What the room says, and it is a validation signal rather than evidence: the r/sysadmin thread on the report went from 1,445 points and 275 comments to 2,782 and 552 in a day. The root cause is broadly believed and the status updates from during the incident are what get torn apart. One of the top comments calls those updates AI slop in the same breath as praising the report as the work of an engineer, and the joke running through the thread is that avoiding em dashes and writing run on sentences is how a machine gets mistaken for a human. Two lines worth borrowing on air: over-sensitive health checks are more likely to cause a cascade than to prevent one, because ejecting one slow node is fine and ejecting all of them is not. And the room reads the fail-out line as Exchange having no real redundancy there, since the alternative gateway sounds like it would have gone down the same way. The sharpest technical critique, at 236 points, is that Microsoft seemed unaware contention exhaustion is more probable with more cores, which restates the load-testing gap as a knowledge gap rather than a hardware gap. The room also corrects one talking point on its own: the 60,000 figure is a voluntary buyout with people leaving on Dec 31, not a cut that removed the engineers who would have caught this. Full notes, scores and links in `reddit-msft-outage-2026-11.md`.

Worth noting rather than accepting: Microsoft moved quickly to rule out AI and cyber before it had published a cause.

On-air line: "There was no attacker. The most disruptive thing this week was a patch, and that should be in your tabletop."

Second on-air option, if you want the joke: "The thread's theory is that avoiding em dashes and using run on sentences is the tell of human writing. I am not going to say which half of that is my editorial policy."

**7. The FAA, two routers, and a feature that worked as intended**

Hook: "Two newly installed routers ground-stopped the entire country, and the vendor's answer is that the devices did not fail."

- Communications trouble started at the Indianapolis Center. The FAA traced the traffic to a radio site in El Dorado, Arkansas and a radar site in Amarillo, Texas, where L3Harris had recently installed new Juniper routers. FAA technology chief Rebecca Guy, on record: the sites were pinging the network at a very high rate, a thousand connections over every four to five seconds. 17 of the 22 air route traffic control centers lost communications.

- Disabling the two routers stabilized the network, and the FAA then found a specific router feature generating the excess traffic and turned it off across all roughly 60 Juniper routers. About four hours end to end, more than 8,200 flights canceled Friday and at least another 3,000 Saturday, and the FAA has not established a root cause.

- Do not let "the decades-old copper is the problem" stand. Without the flood the copper carried the load it always carried. The load was new.

Tier to name: on-record statements from the Saturday press conference, plus the contractor's own public statement, plus reporting. Root cause is explicitly unresolved by the agency itself, and HPE's "they did not fail" is a spokesperson quote rather than a vendor statement.

Forum tier, and say so: the r/sysadmin thread is useful for the jokes and for the question better than the coverage asks, why traffic from one or two remote sites was allowed to compromise communications across most of the national network. Nothing in it is evidence, and three claims in it need a primary before they go near air.

On-air line: "It is a feature, and it took four hours and eleven thousand canceled flights to find the checkbox."

## Deep dive: the six-stage ARTEX loop, and where each stage shows up

Show the thing. Screens or it did not happen.

1. Stage by stage, with the artefact: recon (the scan volume and the source), initial access (which credential, and whether it was valid), cloud and directory discovery (the 27 permission probes in 23 seconds), privilege escalation, credential harvesting and lateral movement, then the objective. For each one, the event or log line that shows it.
2. The hunt, live: the queries for `artex-probe-*` files, `ArtexProbe` accounts, incrementing strings in names, the sign-in volume against a single identity, and the OAuth or app-registration grants that appeared in the window.
3. The finish: patch and rotate, then show what remains. On a host where nothing was patched, the same queries still return the behaviour, which is the point of the whole show.

The control answer: CIS 5.4, 6.5, 6.8, 8.11, 12.4, 15.1 and NIS2 21(2)(d), (e) and (i), with the honest part named on air: the chain only correlates if the identity, cloud, SaaS and endpoint data land in one place with automatic containment switched on, and most of the room is not licensed for that today.
Rehearse it: the hunt queries matter more than the loop description, so run them against a lab tenant before air and confirm each one fires. If they do not, that is the segment, say so live.

---

## Open loops carried from EP8

Answer these on air, or say "still no fix". Full detail and sources in `backlog.md`.

I do not have the EP8 transcript, so I cannot tell which of these were answered live. Confirm
before air and delete the ones that were closed. The Cursor marketplace root cause was the
open loop carried from EP7 and it is now answered in full, so it is story 4 on this sheet
rather than a loop.

| Loop | What to check before air | Control angle |
|---|---|---|
| N-able and Able2Shell | Whether the hotfix shipped, whether hosted N-central is back up, and whether N-able still reports scanning only with no confirmed exploitation. The EP8 sheet said the hotfix ETA was mid-day Nov 10 EST, and Beazley claimed exploitation attempts. | CIS 7.4, 15.1, 15.4 |
| `*sshole` aftermath | Whether anything beyond recon has been observed, and whether CISA added CVE-2026-123158 to KEV after passing on it at disclosure. | CIS 4.1, 4.8, 7.4 |
| SonicWall CVE-2026-19868 | Whether any vendor has published attack details or IoCs. At publication nobody had, including SonicWall and CISA. The federal deadline was Nov 20. | CIS 6.4, 6.5, 8.11 |
| DigiCert record count | Still undisclosed, and the second request for numbers in the bug is unanswered. Check whether Mozilla or Chrome has issued a determination. | CIS 3.12, 8.11 |
| XCPE device remediation | Whether the affected models are being pulled from retail, and whether anyone acts on the other device classes Google named (telehealth, karaoke, signage). | CIS 1.1, 2.1, 12.2 |
| CVE-2026-98432 on Ubuntu and RHEL CoreOS | Ubuntu was not fixed as of Nov 2 to 3, and OpenShift 4 (RHEL CoreOS) was still affected. Check both vendor pages. | CIS 7.3, 7.7 |
| Refrigeration, wave two | Carried from EP7: whether the November 2 wave links to the October France attacks, and what the Pentagon found at the six commissaries. No claim in either. | CIS 1.1, 12.4, 15.1 |

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
