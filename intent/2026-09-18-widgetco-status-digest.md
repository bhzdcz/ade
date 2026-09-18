---
title: "WidgetCo weekly status digest playbook"
author: eng-lead@widgetco.example
status: accepted
date: 2026-09-18
revision: 1
acceptor: eng-lead@widgetco.example
source: human
jira_key: ""
figma_url: ""
---

# Intent: WidgetCo weekly status digest playbook

## Problem

WidgetCo’s five-person engineering team (fictional) lacks a consistent one-page weekly status digest. Updates scatter across chat; the eng lead wants a repeatable markdown template and ADE rail artifacts — not a new app.

## Proposed outcome

Ship a miniature ADE chain (intent → spec → plan) plus an `examples/widgetco-status-digest/` sample digest that shows the filled outcome. Scope is playbook artifacts only.

## Constraints

- Fictional company and contacts only (`eng-lead@widgetco.example`).
- No application code, secrets, or real customer data.
- Short artifacts; teach the rail.

## Open questions

1. Digest sections — default: Highlights, In progress, Risks, Next week.

## Success criteria

### Leading

- Intent, spec, plan, and sample digest committed under normal ADE paths.

### Lagging

- A stranger can reproduce the chain from `docs/how-to-run.md` using this example.
