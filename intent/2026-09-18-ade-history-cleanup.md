# Intent: ADE history cleanup (pre-public)

intent-id: `2026-09-18-ade-history-cleanup`
Author: Planito (via Leadito). Status: **accepted**.
Date: 2026-09-18.
Accepted by Behzad (PO) with Planito defaults: active-intent → public-oss; normal delete commits (no filter-repo); delete sibling folders for deleted intent-ids.
Repo: `bhzdcz/ade` (private). Follow-on to `2026-09-18-ade-public-oss`.

## Problem
Historical dogfood / Inkrail / early ADE site-rename chains clutter the product repo before publicize. `.claude/active-intent` still points at `2026-09-04-ai-native-sdlc-platform`.

## Proposed outcome
Hard-delete obsolete intent/spec/plan trees via normal PR commits; keep templates + public-oss + WidgetCo chains + kit runtime; fix active-intent.

## Status
Accepted → Designito spec.md.
