---
intent-id: 2026-09-04-inkrail-v1-finish
spec: specs/2026-09-04-ai-native-sdlc-platform/spec.md
status: accepted
engineer: Behzad
author: Leadito
date: 2026-09-04
---

# Plan: Finish Inkrail v1 branding and ops polish

## Approach
Docs/branding + promote.sh message + how-to-run. No hook logic changes.

## Files
- README.md, CLAUDE.md, docs/how-to-run.md, scripts/promote.sh
- intent/2026-09-04-inkrail-v1-finish.md, plans/2026-09-04-inkrail-v1-finish/plan.md

## Won't change
Hook scripts behavior, CI workflow, bands.yaml live runner.

## Test plan
bash tests/validate-templates.sh && bash tests/validate-hooks.sh

## Risks
None material.
