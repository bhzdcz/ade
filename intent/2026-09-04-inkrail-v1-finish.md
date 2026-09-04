---
title: Finish Inkrail v1 branding and ops polish
author: Leadito
status: accepted
date: 2026-09-04
revision: 1
acceptor: Behzad
source: human
jira_key:
figma_url:
---

# Intent: Finish Inkrail v1 branding and ops polish

## Problem

v1 dogfood scaffold is on GitHub, but product copy still said generic "AI-native SDLC platform", `promote.sh` deny text was stale, and operators need a clear how-to-run. Branch protection on private repos needs GitHub Pro — that limit must be documented.

## Proposed outcome

- Brand the repo as **Inkrail** in README / CLAUDE.md
- Fix `promote.sh` deny message to match `release-managers.txt`
- Add `docs/how-to-run.md`
- Document branch-protection Pro limitation
- Land via PR as the first remote dogfood pass

## Constraints

- No cloud deploy; no live bands
- Do not invent GitHub Pro features that free private repos lack

## Open questions

None for this change.

## Success criteria

- README titled Inkrail; how-to-run present
- validate-templates / validate-hooks green
- PR opened against main for human merge
