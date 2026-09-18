---
title: "WidgetCo weekly status digest playbook"
author: Designito
status: accepted
date: 2026-09-18
intent: intent/2026-09-18-widgetco-status-digest.md
intent_sha: ""
acceptor: eng-lead@widgetco.example
---

# Spec: WidgetCo weekly status digest playbook

## 1. Summary

Define a one-page weekly status digest template for fictional WidgetCo’s five-person eng team, delivered as ADE artifacts plus one filled sample under `examples/widgetco-status-digest/`.

## 2. Goals and non-goals

### Goals

- Document digest sections: Highlights, In progress, Risks, Next week.
- Provide intent → spec → plan chain and a sample `digest.md`.
- Point strangers back to `docs/how-to-run.md`.

### Non-goals

- Building a web app, Slack bot, or dashboard.
- Real employee names, private URLs, or production metrics.

## 3. Actors and runtime

- **Author:** eng-lead@widgetco.example (fictional).
- **Runtime:** markdown in git; no services.

## 4. Artifact contracts and gates

Normal ADE chain. Example is illustrative; no production promote required.

## 5. Functional design

Sample digest fields:

| Section | Content |
| --- | --- |
| Week of | ISO date Monday |
| Highlights | 2–4 bullets shipped or decided |
| In progress | Owners + ETA (fictional) |
| Risks | Blockers / asks |
| Next week | Planned focus |

## 6. Non-functional (security, compliance, audit)

No secrets. Fictional emails only (`@widgetco.example`).

## 7. UX notes

Keep each artifact to ~1–2 screens.

## 8. Flagged concerns

None beyond keeping the example fictional.

## 9. Open questions and defaults

Digest cadence: weekly (locked).

## 10. Acceptance criteria

- Intent, spec, plan, `examples/widgetco-status-digest/{README.md,digest.md}` present.
- No real-company or personal data.

## 11. Out of scope

Apps, integrations, live data feeds.
