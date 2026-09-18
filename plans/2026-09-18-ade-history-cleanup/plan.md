---
intent-id: 2026-09-18-ade-history-cleanup
spec: specs/2026-09-18-ade-history-cleanup/spec.md
spec-sha256: 987afd4104bf90bd83fcdbf4ece4caf955a1c7d16b3d0e6e9fb486aae5bc346e
status: accepted
author: Develito
engineer: Behzad <behzad@local>
date: 2026-09-18
base: main @ a3f8975 (a3f89758df5cda8392a6b0c17bdf8abb1f3fee24) — PR #9 merged
repo: https://github.com/bhzdcz/ade (PRIVATE — no visibility flip)
---

# Plan (thin): ADE history cleanup (pre-public)

## Approach

One cleanup PR on `bhzdcz/ade`: **normal git deletes** + active-intent fix + doc retargets. No filter-repo, no force-push rewrite, no soft-archive, no ade-site / Visibility work.

**Rejected:** history rewrite; soft-archive; editing substance of kept public-oss / WidgetCo chains.

## KEEP

- Templates: `intent/_template.md`, `specs/_template.md`, `plans/_template.md`, `findings/_template.md`
- `2026-09-18-ade-public-oss` chain
- WidgetCo: intent/spec/plan + `examples/widgetco-status-digest/`
- Kit runtime (docs/plays, `.claude/hooks|skills`, `CLAUDE.md`, `REVIEW.md`, `README.md`, `LICENSE`, tests, scripts, releases keepers, CI)
- This cleanup chain once seeded

## DELETE (re-list against tip before merge)

| Kind | Paths on tip `a3f8975` |
| --- | --- |
| Intents | `intent/2026-09-04-ai-native-sdlc-platform.md`, `…-inkrail-v1-finish-redo.md`, `…-dogfood-sample-finding.md`, `intent/2026-09-05-ade-rename.md`, `…-ade-site.md` |
| Spec trees | `specs/2026-09-04-ai-native-sdlc-platform/`, `…-inkrail-v1-finish-redo/`, `specs/2026-09-05-ade-rename/`, `…-ade-site/` |
| Plan trees | same four ids under `plans/` |
| Finding | `findings/examples/dogfood-sample.md` (empty dir → `.gitkeep` or remove) |
| Release | `releases/code-owner-acceptances/2026-09-04-ai-native-sdlc-platform.yaml` |

## FIX

| Path | Change |
| --- | --- |
| `.claude/active-intent` | exact line `2026-09-18-ade-public-oss` |
| `docs/how-to-run.md` | drop dogfood-sample; point at `findings/_template.md` / own finding |
| `CLAUDE.md` | same retarget for sample invocation |
| `README.md` | only if it uniquely cites a deleted id / dogfood path |
| Grep pass | deleted ids + `dogfood-sample` clean on promoted docs (history OK) |

## Order

1. Branch `chore/ade-history-cleanup` from `main`.
2. Seed this intent’s intent/spec/plan (accepted) into repo SoT.
3. Deletes + FIX in one PR; author Behzad `<behzad@local>`.
4. Run `bash tests/validate-templates.sh` + `bash tests/validate-hooks.sh` (names as on tip).
5. Open PR → Testito tip → Reviewito → Leadito → Behzad merge.
6. **Stop.** Visibility + ade-site PR B stay parked until Leadito cues.

## Test plan

T1 deleted paths absent · T2 KEEP present · T3 active-intent exact · T4 rg clean on README/CLAUDE/docs · T5 validators green · T6 no filter-repo / force-push

## Risks

| Risk | Mitigation |
| --- | --- |
| Blobs remain in git history | Intentional; escalate only if publicize scrub finds secrets |
| Spec path spellings ≠ tip | Build uses tip inventory above |
| Broken how-to-run demo | Template retarget is enough |

## Gate

**Status:** accepted — Build in progress (this PR).
