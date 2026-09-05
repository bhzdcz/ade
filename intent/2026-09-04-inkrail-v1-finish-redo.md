---
title: "Re-land Inkrail v1 finish under correct stage ownership"
author: Planito
status: accepted
date: 2026-09-04
revision: 1
acceptor: Behzad
jira_key: ""
figma_url: ""
source: human
---

# Intent: Re-land Inkrail v1 finish under correct stage ownership

## Problem

PR #1 shipped Inkrail v1 finish (branding, how-to-run, promote deny-text, Pro branch-protection note) under **Leadito Build authorship**. Build must be Develito; Leadito is Deploy/conductor only. Wrong-owner landing breaks auditability and dogfood credibility.

## Proposed outcome

1. Hard-revert PR #1 / merge `46c75ed` on `main`.
2. Re-land via Develito the four outcomes: Inkrail branding (`README.md` + `CLAUDE.md`), `docs/how-to-run.md`, `promote.sh` deny-text vs `release-managers.txt`, document free-private GitHub branch-protection Pro limit.
3. Preserve artifact chain + gates; Leadito must not author Build.

## Constraints

- No v2 features
- Product name stays Inkrail
- SoT remains `bhzdcz/inkrail`
- Two sequential merges preferred (revert, then re-land)

## Open questions

Defaults stand: Behzad sole acceptor/release manager; sequential PRs.

## Success criteria

### Leading

- Accepted intent → spec → plan → revert merged → re-land PR

### Lagging

- No Leadito-authored Build commits on the re-land PR
- Four outcomes present on `main` after merge
- Validators green; promote deny path verified
