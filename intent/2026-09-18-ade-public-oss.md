---
title: "ADE v1 public OSS kit"
author: Planito
status: accepted
date: 2026-09-18
revision: 1
acceptor: Behzad
source: human
jira_key: ""
figma_url: ""
---

# Intent: ADE v1 public OSS kit

intent-id: `2026-09-18-ade-public-oss`
Author: Planito (from Leadito / Behzad reset). Status: **accepted**.
Date: 2026-09-18.
Accepted by Behzad (PO) on 2026-09-18 with defaults: public `bhzdcz/ade`; Apache-2.0; fictional tiny in-repo worked example; Sponsors omit from v1 site.
Product: ADE. Sites/repos: https://ade.ir, `bhzdcz/ade`, `bhzdcz/ade-site`.

## Problem

ADE was drifting toward a private / commercial kit story (private source, paid setup, Buy/checkout on ade.ir). Behzad locked a reset: ADE is a full public OSS kit that strangers can install and run — not dogfood-only, not paid setup. Commercial ade-site work (e.g. PR #3 / €490 path) is closed. Until source is public, the kit is finished as an installable product, and ade.ir is a product site (what / install / docs / GitHub), ADE cannot be the open playbook product he wants.

## Proposed outcome

Ship ADE v1 as a public, installable OSS SDLC kit/playbook.

v1 ships:
1. Public source — make `bhzdcz/ade` public (default).
2. Finished kit product — how-to-run; templates intent→spec→plan→REVIEW→hooks/gates; starter CLAUDE.md; example skill(s)/hook(s); one worked example end-to-end.
3. Rewrite ade.ir as product site (what / install / docs / GitHub) — no Buy, no private links, no checkout.
4. Sponsors omitted from v1 site; paid packs/installs/SaaS out.

## Constraints

- Separate from airoweb and AI-DD.
- Leadito does not Build. No Maintito — Leadito owns Deploy + Maintain gate.
- Visibility flip is Behzad human Settings step after scrub PR merges.
- Do not rewrite git history by default.

## Open questions

1. Make `bhzdcz/ade` public (default) — locked.
2. License Apache-2.0 (default) — locked.
3. Worked example: fictional tiny in-repo (Design picks) — locked WidgetCo.
4. Sponsors on ade.ir in v1: omit (default) — locked.

## Success criteria

### Leading

- Scrub + LICENSE + stranger README/how-to-run + kit-map + WidgetCo example landed while repo still private.
- Validators green.

### Lagging

- Behzad flips Visibility → Public; ade.ir rewritten as product site (PR B).
