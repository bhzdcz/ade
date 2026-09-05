---
title: "Rename Inkrail → ADE (product + GitHub identity)"
author: Planito
status: accepted
date: 2026-09-05
revision: 1
acceptor: Behzad
jira_key: ""
figma_url: ""
source: human
---

# Intent: Rename Inkrail → ADE

## Problem

The dogfood platform is still promoted as **Inkrail** while the locked product name is **ADE** (site [ade.ir](https://ade.ir)). GitHub identity `bhzdcz/inkrail` should become `bhzdcz/ade`. Playbook substance is unchanged — this is identity hygiene.

## Proposed outcome

1. Product name **ADE** on all promoted/current-identity surfaces.
2. Stamp `https://ade.ir` on README and primary docs.
3. Retarget in-repo identity to `bhzdcz/ade`; Behzad renames the GitHub repo in Settings.
4. Leave historical `*inkrail*` artifact paths/bodies as audit trail.

## Constraints

- No ade.ir site build, Braiins adoption, AI-DD, history rewrite, or playbook v2.
- Leadito does not Build.
- Do not weaken hooks/CI.

## Open questions

Defaults: Settings rename ASAP after branding PR; no supersession banners on historical intents.

## Success criteria

### Leading

- Branding PR green; Settings rename done or follow-up intent filed

### Lagging

- Live docs say ADE / bhzdcz/ade / ade.ir; historical inkrail paths remain
