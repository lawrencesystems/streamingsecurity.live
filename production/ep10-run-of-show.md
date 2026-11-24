# Streaming Security, EP10: Production Run of Show

*Live stream Tue 2026-11-24 on the Lawrence Systems channel. Uploaded to the Streaming Security channel after the show. Hosts Tom Lawrence and Matt Lee.*

Published so Matt and anyone watching can follow the prep. This is the production doc,
not the show notes: it carries the running order, the per-story hooks, the deep dive plan,
and the chosen packaging. Show notes for aired episodes are in `content/episodes/<n>.md`.

| Field | Value |
|---|---|
| Episode | 10 |
| Live stream | Tue 2026-11-24, Lawrence Systems channel |
| Upload | Streaming Security channel, after the show |
| Hosts | Tom Lawrence, Matt Lee |
| Title | Two Million Canaries, Three Breached Providers |
| Thumb text | Prompts are egress |
| Cold open hook | Three AI hosting providers were compromised, and none of them knew until Dragos told them. |

### Story sheet (stories in order, then the deep dive)

Order rationale: story 1 is HD Moore's canary research, because it is the one story this
week that hands the audience something to build rather than something to patch, and because
it lands on the show's existing thread: the thing that moves your data is something you
chose for convenience and never mapped. It also links backwards to EP9, since the same
attacker in the Dragos telemetry added ARTEX on November 1. Story 2 is the RansomwareHelp
indictment and story 3 is the Cleverbridge breach. Every link dropped into the group since
EP9 aired is in this sheet; there is no shortlist step. The order of 2 and 3 is a proposal
and is easy to swap.

### The laws, and which one lands on which story

Law 1, The Law of Successive Exploitation: once a vulnerability has been found and exploited
in a product, another will be found, and another after that, so treat a first exploited CVE
as the start of a campaign and plan for compensating controls or replacement rather than
assuming one patch closes the chapter. Law 2, The Law of Collapsing Complexity: that which is
complex will no longer be too complex for threat actors, so exploit complexity is not a
reason to deprioritize anything. Both live at streamingsecurity.live/laws.

Name the law when one applies, and say plainly when neither does, because "no law applies"
is itself a finding.

Story 1 is the call that needs you, and it is the same shape of call as EP9 story 2. Law 1 is
the closest fit on the reading that provider compromise is now a repeating pattern rather
than an event: Dragos found three, Phala published its own incident, NEAR AI published one
the day before, and Fireworks disclosed two in October. The counter reading is that no
vulnerability is established here at all, since two of the three findings need no exploit,
so the law's trigger is not met and the honest answer is neither. Your call.

| # | Story | Source link | Why it matters | Control angle | Law |
|---|---|---|---|---|---|
| 1 | **Two million canaries into the AI supply chain.** HD Moore's team at Dragos seeded roughly two million prompts between July and November 2026 with unique, trackable secrets (URLs, DNS names, real AWS keys tied to empty accounts with full logging, later a purpose-built seeding service) and watched what happened after inference. Three findings. First, at least three AI hosting providers were compromised: an attacker copied requests at the provider's front door, including requests the provider rejected before a model ran, and in two of the three cases requests marked Zero Data Retention. The earliest incident is mid-July, none of the three knew until Dragos told them, bait keys drew tens of thousands of AWS API calls (test the key, list S3, search Secrets Manager and Parameter Store, enable Bedrock models, create Bedrock API keys, add IAM users), one adversary hit two providers from a single rented server, and on November 1 that attacker added ARTEX. Second, marketplace resellers stole prompts with no exploit at all: list a model at the lowest price, turn on request logging, wait. Third, privacy and retention were ignored: a Chinese lab's systems fetched secret URLs from more than half the prompts sent to its models, including roughly two thirds of ZDR-flagged ones, the same scraper fired against US providers reselling that lab's models, one large US provider crawled a secret URL for over two months after a single search call, and 24 days after one ZDR request the secret link was posted into a Feishu chat and opened from three desktops and three phones in Beijing and Shanghai. | [Dragos, HD Moore](https://www.dragos.com/blog/ai-supply-chain-security-canary-tokens), [Ars Technica](https://arstechnica.com/security/2026/11/a-leaky-ai-supply-chain-is-exposing-secret-user-data-at-an-alarming-rate/), [Phala preliminary incident report, Nov 10](https://phala.com/posts/phala-november-preliminary-incident-report), [NEAR AI incident report, Nov 9](https://near.ai/blog/security-incident-report-sglang-vulnerability), [Privacy Affairs on the Phala window](https://www.privacyaffairs.com/phala-openrouter-deepseek-breach/), [Lauren Proehl, the companion experiment](https://dispatch.thorcollective.com/p/i-leaked-credentials-on-purpose-for), [HD Moore on Mastodon](https://infosec.exchange/@hdm/117644015777192488), [SANS ISC podcast, Nov 20](https://isc.sans.edu/podcastdetail/10188) | Not one of the three findings needs a vulnerability, which is the point: where your prompts go is a routing and retention decision, and if you do not make it the lowest price makes it for you. A privacy flag binds the first hop at best. The audience already sends credentials and source code through AI agents, and an agent will happily send whatever it can read. | CIS 3.1, 3.2, 3.13, 6.5, 8.11, 12.2, 12.4, 15.1, 15.4, 16.11 and NIS2 21(2)(d), (e) and Art 28: classify what may enter a prompt at all, control the egress path, and verify the suppliers' claims rather than reading their privacy page | Law 1 or neither, flagged above for your call |
| 2 | **RansomwareHelp indicted.** A Rhode Island grand jury indictment filed Nov 18 charges Juan Ricardo Palacio Escobar, 52, co-founder and CTO of ransomwarehelp.com, with wire fraud. The site claimed proprietary cryptographic tools, 100 percent recovery, a 99 percent success rate and that it never negotiated with or paid threat actors. The indictment alleges the opposite: it bought decryptors from the crews and billed victims a markup for work never performed. In the June 2026 sting the FBI posed as both a victim and a fictitious ransomware group; the fake victim said it would not pay, was charged a 2,750 dollar assessment and a 13,260 dollar quote and billed 16,010 dollars, while the decryptor cost about 6,003 dollars. The filing also describes a 314,150 dollar proposal to a Rhode Island victim in April 2025 and a 720,000 dollar payment from a Kansas firm in January 2024. Allegations only, no conviction. | [Krebs on Security](https://krebsonsecurity.com/2026/11/cto-of-ransomwarehelp-indicted-for-wire-fraud/), [indictment PDF](https://krebsonsecurity.com/wp-content/uploads/2026/11/palacio.pdf), [404 Media](https://www.404media.co/ransomware-fraud-attack-fbi-indictment/) | The intermediary gets chosen in the worst hour, and this one asked for remote access and deleted the ransom notes so the victim could not see who was negotiating. Your clients call you first, which makes you the vetting layer. | CIS 15.1, 15.3, 15.4, 17.2, 17.4: ask any recovery firm how it gets data back without the attacker's key, and treat proprietary as an answer that means no | Neither law |
| 3 | **Cleverbridge breach.** The merchant of record behind a lot of software checkouts notified customers on Nov 20 that a third party copied payment card data stored on its platform: card number, expiry date and the CVV/CVC code, per a notice seen by reporters. Detected Nov 4, systems restored the same day, 16 days to notification. Cleverbridge says it was not ransomware. It has not said how the attacker got in, how long they had access, how many customers or which clients are affected, whether the data was encrypted, or why the codes were accessible. Malwarebytes is the only named downstream vendor to confirm impact, a small subset of its customers. Two notice texts are circulating and they disagree on whether the CVV was taken. | [BleepingComputer](https://www.bleepingcomputer.com/news/security/cleverbridge-warns-hackers-stole-credit-card-numbers-cvvs-in-data-breach/), [The Register](https://www.theregister.com/cyber-crime/2026/11/23/cleverbridge-admits-attackers-stole-customers-credit-card-and-cvv-numbers-yep-you-read-that-right/5311573), [Help Net Security](https://www.helpnetsecurity.com/2026/11/23/cleverbridge-data-breach-card-numbers-cvv/) | PCI DSS prohibits retaining the card verification code after authorisation, even encrypted, and the company's own wording says the data was stored. Where it was kept and for how long is theirs to answer. The notice also looks exactly like phishing, because the brand on the card statement is the software vendor. | CIS 3.1, 3.2, 3.12, 4.1, 15.1, 15.4: know which of your payment paths is a merchant of record, and hold the processor's answers in writing | Neither law |

Deep dive topic: options, your call. Either seed a live canary in an agent pipeline on air
(free Thinkst Canarytoken in a system prompt or context file, then show the alert console
when something fires), or run the route trace: same prompt through a router and a direct
provider, compare where the image fetch came from, and show the hops the marketplace never
mentions.

Framework(s) to map against: CIS Controls v8.1, NIS2 / ENISA Implementing Regulation 2024/2690.

### Story hooks and bullets

Per story: the hook sentence, three bullets, and the evidence tier to name out loud. Do not
script the rest.

**1. Two million canaries, and where prompts really go**

Hook: "HD Moore put two million fake credentials into AI prompts and watched where they turned up. Three providers turned out to be compromised, and the privacy setting everybody relies on does not do what the checkbox says."

- The method is the part worth explaining on air, because it is reproducible by anyone in the audience. Every prompt carried a URL, a DNS name and an AWS key that existed nowhere else, all derived from a unique seed so any use could be traced back to the exact prompt, model, router and privacy setting that carried it. The AWS keys were real keys on empty accounts with full logging. Thinkst Canarytokens to start with, then a purpose-built service.
- What it found, in the order to tell it. Someone inside three providers was copying requests at the front door, including requests that were rejected before a model ran and including some marked ZDR. Marketplace resellers did not need an exploit at all: they listed a model at the lowest price, switched logging on, and waited, and in one case an individual on home broadband opened both secret URLs a day and a half later and started guessing usernames. And retention promises were ignored: a Chinese lab fetched more than half the secret URLs sent to its models and about two thirds of the ZDR-flagged ones, the same scraper fired when US resellers served that lab's models, and one ZDR request to a US provider ended up as a link in a Feishu chat 24 days later.
- The corroborating detail that makes it more than a vendor blog: Phala published a preliminary incident report that matches on dates and method, telling users whose DeepSeek V4 Flash 0731 requests went through OpenRouter between October 21 and November 8 to treat them as exposed, after an attacker chained a legacy internet-facing service with management interfaces that trusted local callers and took over an inference VM serving production traffic without full hardening. Dragos has not linked its three to Phala by name, and neither has Phala. Worth adding, because it kills the "just pick a safe provider" answer: OpenRouter's public list showed 27 endpoints for that model and Phala was not one of them, so a user could reach Phala without ever choosing it. NEAR AI, which also sells confidential inference, published its own report on November 9 after an attacker used an RCE in SGLang, the open-source engine running its models, and said requests in confidential mode could have been observed. Phala's report does not use the words TEE or attestation once.

Tier to name: vendor research with a published method, the vendor's own primary write-up, plus independent reporting and one provider's own incident report. The providers are unnamed and none has fully confirmed or disputed the findings, so say "Dragos observed" and "Phala confirmed" and keep them apart. Dragos will not release the service, the code or the data, and says the data contains raw secrets and provider names.

Note the commercial interest out loud, because the post ends with a runZero trial pitch and Dragos recently acquired runZero and NetRise: this is research that also sells visibility.

Before air: re-check whether any of the three providers has disclosed, whether Phala has published its full root cause analysis, and whether NEAR AI (Nov 9) and the two Fireworks disclosures in October are part of the same picture. Nobody has linked them yet, and the temptation to merge four incidents into one campaign is the exact overreach to avoid.

On-air line: "A privacy flag only binds the first hop, and the marketplace sold your prompt to whoever logged it. This is not a breach story, it is an egress story."

The number to keep in your pocket, from Dragos's own companion experiment by Lauren Proehl, which is a different dataset and should be labelled as such: of the stolen AWS keys that got used at all, the median time from theft to first use was 37 minutes, about a third were used within five minutes, and roughly half of the later months' activity was testing keys for Bedrock access, which is the cheapest way to turn a stolen key into GPU time.

**2. RansomwareHelp, and the middleman who charged for the victim's conscience**

Hook: "A recovery firm told victims it would never pay a ransom, demanded remote access to their networks, and deleted the ransom notes so nobody could check. The FBI posed as both the victim and the gang and caught it."

- The offer was a swap. The site promised proprietary cryptographic tools, 100 percent recovery and a 99 percent success rate, and said it never negotiated with or paid threat actors. The indictment says it bought decryptors from the crews and billed the difference. In the sting the decryptor cost about 6,003 dollars and the bill was 16,010.
- Why victims chose it is what makes this a show story rather than a court story. One of these is in Matt's own MSP911 case log: a victim paying the middleman specifically because, in the client's words, he did not want his money going to the ransomware actor, and who was staring at going out of business. The fraud monetises the victim's conscience and the victim's clock at the same time, and that combination is why almost nobody tested the technical claims.
- The tell to give the audience: a legitimate recovery firm asks you to send it the ransom note. This one insisted on unrestricted remote access over AnyDesk, and in the Lockbit case Soteria found only one copy of the note still on the network, recovered from a backup snapshot, with the attacker chat already days into a negotiation run by someone else.

Tier to name: the indictment is the primary and it charges wire fraud only, so allegations and no conviction, and the care notes in `backlog.md` apply. The AnyDesk and deleted-note account is Paul Ihme of Soteria, a witness interview in Krebs's reporting rather than a court finding.

We have run this shape before, and it is worth saying so on air: EP5, "Everybody Groaned, Nobody Patched," covered Zohar Pinhasi and MonsterCloud, which allegedly billed more than 19 million dollars while paying about 8 million in ransoms, including an 8,200 dollar ransom invoiced to the client at 150,000. Same crime, different logo.

*Disclosure: Matt runs MSP911, the nonprofit that advised the case referenced here. The victim is not identified and the case number is internal to MSP911.*

Law check to say out loud, and this is the beat rather than a footnote: neither law applies here. Law 1 is about a product being exploited again after the first time, and Law 2 is about exploitation that used to be too complex becoming reachable. Nothing was exploited in this story and nothing in it was technically hard. A supplier lied about what it was doing, which is fraud. The laws on this show are about exploitation, so the honest answer is that neither lands, and saying that is the finding.

On-air line: "The pitch was that your money would not reach the criminals. It reached them faster, and with a margin on top."

---

## Open loops carried from EP9

Answer these on air, or say "still no fix". Full detail and sources in `backlog.md`.

I do not have the EP9 transcript, so I cannot tell which of these were answered live on
November 17. Confirm before air and delete the ones that were closed. The Microsoft final
report was due November 20, the day after EP9 aired, so it is worth a check before this sheet
is final.

| Loop | What to check before air | Control angle |
|---|---|---|
| Microsoft final post-incident report | Was due November 20. Check what it adds beyond the preliminary one, especially the bulkhead isolation that failed to contain the cascade and why Exchange Online could not fail out of the gateway. | CIS 4.1, 16.7, 17.x |
| ScreenConnect campaign counts | Whether Huntress's numbers moved, whether ConnectWise validated or dropped the extension assessment, and whether anyone tied it to CVE-2026-84869. | CIS 2.1, 2.5, 13.11 |
| wfx-loot aftermath | Whether the automated publishing triggers that made two packages look like a supply chain attack were fixed, and whether GitHub or the registries changed anything. | CIS 16.1, 16.11 |
| Infoblox | Whether customers have been notified, and whether the NIOS configuration snapshots contained credentials, TSIG keys or API tokens. Nobody has confirmed either way. | CIS 3.12, 15.3, 15.4 |
| ARTEX detection numbers | Whether an accurate count of exposed consoles has replaced the two scanner estimates, and whether Microsoft updated its tenant figures. | CIS 8.11, 12.4 |
| N-able and Able2Shell | Carried from EP8: whether the hotfix shipped, whether hosted N-central came back, and whether N-able still reports scanning only with no confirmed exploitation. | CIS 7.4, 15.1, 15.4 |
| FAA router root cause | Carried from EP9: the agency had not established one. Check for the post-incident finding and whether the disabled feature came back on. | CIS 4.2, 12.4, 16.7 |
| `*sshole` aftermath | Whether anything beyond recon was observed, and whether CISA added CVE-2026-123158 to KEV. | CIS 4.1, 4.8, 7.4 |
| GoAhead Mbed TLS value | Still a verification item in `backlog.md`: the one-byte DH modulus value the X post calls "04". Confirm with FoxIO before citing it again. | CIS 16.4, 15.4 |

---

## Beats that never drop

- Which control would have caught this.
- Framework mapping with a specific control to go check.
- Open unknowns named on air and followed up next week.
- Chat questions answered live, in order.
- Evidence tier named for every claim.
- Name the law when one applies, and say plainly when neither does.
