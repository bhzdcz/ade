# ADE: a sustainable first business

Review date: September 5, 2026. This is a recommendation and a test plan, not a revenue forecast.

## Positioning

**Reviewable AI work, in your repository.** Start with solo developers and teams of 2–15 engineers already using Claude Code who lose context between request, implementation and PR review. The buyer is the person responsible for reviewing and shipping the work.

ADE should sell a working adoption path, useful examples and maintainer judgment. Generic prompt files are easy to copy. The durable advantage has to come from repeatable installation, practical team-specific conventions, trustworthy limitations and evidence from real adoption.

## What the review found

| Finding at baseline | Commercial implication | Response in this branch |
| --- | --- | --- |
| Product source private; all main site calls to action lead there | Public visitors cannot try or inspect the product | Public docs/example, explicit access request, no false open-source claim |
| No installer, package or onboarding diagnostics | Adoption requires maintainer intervention | Offline CLI, preview, safe merge, doctor, draft scaffolding, checksum bundle |
| Hooks use explicit permission allow on ordinary commands | A workflow tool may inadvertently grant tool permissions | Successful checks now abstain; normal Claude permissions apply |
| Docs allowlist accepts unnormalized traversal paths | A product edit can appear to be a doc edit | Canonical paths and symlink-aware checks with regressions |
| Test suite rewrites active intent and attestations, and uses GNU sed | Testing is risky in real projects and breaks on macOS | Temporary repositories and Python unittest on macOS/Linux CI |
| Release attestation checks a writable name only | Cannot honestly sell authenticated release control | Clearly documented simulation; protected environments are the real boundary |
| No defined offer, support scope or contact | No path from interest to a conversation | €490 proposed setup scope, public email, local inquiry builder |
| No evidence of external customers, savings or outcomes | Claims would weaken credibility | No fabricated testimonials, metrics, star counts or guarantees |

## Competitive reality

[GitHub Spec Kit](https://github.com/github/spec-kit) provides a public spec-driven workflow with an installer and numerous integrations. [GSD](https://github.com/gsd-build/get-shit-done) is another public workflow system around coding agents. Broad “AI-native SDLC” positioning is crowded. ADE’s initial focus should be a deliberately small, reviewable process for teams using Claude Code, including an honest explanation of what hooks cannot enforce.

This is a positioning inference from those projects and the ADE audit, not proof of demand or feature superiority. Avoid a public comparison table until it has reproducible criteria and a date.

## Revenue sequence

1. **Paid setup first: proposed €490 per repository.** A 45-minute workflow review, installation, one tailored example, up to 60-minute handover and one follow-up. Sell a bounded result, not unlimited access to the maintainer. Confirm availability, invoice identity, taxes, cancellation/refund terms and scope before payment.
2. **Publish a clean MIT core after review.** The private history includes internal acceptance records and old instructions. Prefer a reviewed, allowlisted source release or a new clean public-core repository over flipping the existing repo public blindly. The branch proposes MIT licensing; that proposal and all distribution contents still need the owner's release decision.
3. **Optional support.** Enable GitHub Sponsors after account onboarding, or add an owner-verified Bitcoin receiving address. Donations do not buy service hours or priority support by default.
4. **Only expand after evidence.** Consider team templates, a workshop or a support plan after repeated requests. Do not build hosted agents, billing infrastructure or a dashboard just to make it look like SaaS.

At an illustrative 4 hours of delivery per setup, €490 is €122.50 gross per delivery hour before sales/admin time, expenses, fees and taxes. Two setups would be €980 gross; four would be €1,960. These are arithmetic scenarios, not expected sales. If delivery consistently exceeds the scope, narrow it or raise the price before taking more customers.

## Payment choices

- **GitHub Sponsors:** good for one-time or recurring community support. GitHub lists Czech Republic among supported regions, but the owner's actual residency and eligibility must be confirmed during onboarding. Personal-account sponsorships currently have no GitHub fee; organization sponsorships can have fees. [Official overview](https://docs.github.com/en/sponsors/getting-started-with-github-sponsors/about-github-sponsors).
- **Stripe hosted invoice/payment link:** a straightforward way to charge for agreed setup work without building checkout. Account eligibility depends on the actual business and country. Hosted receipts/refunds and invoice features are described in [Stripe's Payment Links documentation](https://docs.stripe.com/payment-links). Use an invoice for individually scoped work; confirm local business/tax requirements with an appropriate professional before trading.
- **Bitcoin receiving address:** useful as an optional donation channel. The owner supplies and verifies a public native SegWit mainnet address; no private keys belong in this project. The site validates its checksum and opens a wallet URI, but does not verify payment or issue receipts. A reused address exposes a public payment history. For payment requests and confirmations at greater volume, evaluate [BTCPay Server](https://docs.btcpayserver.org/Guide/), which adds operational work.

No provider account, sponsor profile, checkout link or Bitcoin address was created for the owner. The supplied contact is behzad@airoweb.com.

## Launch and acquisition

### Before the first sale

- Owner reviews product/site PRs, actual product behavior and the proposed price/license.
- Configure a suitable host before operating the commercial site. [GitHub Pages policy](https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits) restricts online businesses and sites primarily facilitating commercial transactions.
- Confirm business identity, invoice/payment method, scope, availability and service terms. Test checkout if one is enabled. Do not use Bitcoin donations as proof of service purchase.
- Decide public-core distribution. Publish only reviewed contents, attach checksums and a release note, then replace access-request language with the actual public URL.

### First two weeks

Record a short demonstration from a fresh repository: preview, install, create drafts, show a blocked edit, accept as a human, then show a reviewable PR. Publish a truthful walkthrough on the chosen public repository and relevant communities, following their rules. Ask for feedback from people already reviewing Claude Code changes. No unsolicited automated outreach.

Offer a small number of setups only when actual delivery capacity exists. Capture recurring friction in findings. Ask customers for explicit permission before publishing case studies or logos.

### First month decision

Maintain a simple private sheet: inquiry date/source, workflow problem, qualified conversation, agreed scope, completed setup, delivery hours and permission to follow up. Count completed installations separately from downloads and stars. Use GitHub traffic statistics when a public core exists; do not invent precise conversion rates without measurement.

If conversations repeatedly value review consistency, improve the corresponding checks and examples. If people only want more prompt templates, test a lighter distribution before building a hosted product. GitHub fame and donations are possible outcomes, not a plan the project can guarantee.

## Technical roadmap after release

Prioritize installation feedback and trust before breadth: signed/pinned release artifacts, clean upgrade/remove support, stronger static verification of artifact links, additional real examples, and documented integrations with protected Git environments. Multi-agent and multi-harness support should follow demonstrated demand.
