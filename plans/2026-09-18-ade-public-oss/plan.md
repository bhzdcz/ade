---
intent-id: 2026-09-18-ade-public-oss
spec: specs/2026-09-18-ade-public-oss/spec.md
spec-sha: 3d7ff71d5bc8556d3275df8f6e196c89d527ddf0d349e36b2d7d197230b0e0b0
status: accepted
engineer: Behzad
author: Develito
date: 2026-09-18
repos:
  - https://github.com/bhzdcz/ade (private → public)
  - https://github.com/bhzdcz/ade-site (public, ade.ir)
---

# Plan (thin): ADE v1 public OSS kit + product site

## Approach

Two-repo Build, **scrub-first while `ade` stays private**, then Behzad flips Visibility, then site rewrite. Author `Behzad <behzad@local>`. Leadito does not Build. Separate from airoweb / AI-DD. No Buy/Sponsors/checkout. Worked example: **WidgetCo status digest** (fictional).

**Rejected:** reopen ade-site PR #3; paid CTAs; Maintito; history rewrite (escalate if secrets found); alternate kit repo.

## Order of work

1. **PR A — `bhzdcz/ade` (still private):** scrub + `LICENSE` (Apache-2.0) + stranger README + `docs/how-to-run.md` + `docs/kit-map.md` + plan template if missing + `CLAUDE.md` roster fix (no Maintito; Leadito = Deploy+Maintain) + WidgetCo example chain under `intent/` `specs/` `plans/` `examples/widgetco-status-digest/`. Grep scrub: secrets, `/Users/`, Braiins, private-invite language, Maintito.
2. **Validators:** `bash tests/validate-templates.sh` + `bash tests/validate-hooks.sh` green.
3. **Human gate:** Behzad Settings → Visibility **Public** (Build does not claim public until confirmed).
4. **PR B — `bhzdcz/ade-site`:** rewrite landing sections What / Install / Docs / GitHub; In/Not v1 honest public-kit; footer Apache-2.0; strip banned CTAs. Keep existing dark pixel visual system.
5. Stop at reviewable PRs for Testito → Reviwito → Leadito → Behzad merge.

## Files (likely)

### `ade`
| Action | Path |
| --- | --- |
| Add | `LICENSE` (Apache-2.0) |
| Edit | `README.md`, `CLAUDE.md`, `docs/how-to-run.md` |
| Add | `docs/kit-map.md`, `plans/_template.md` (if absent) |
| Add | WidgetCo intent/spec/plan + `examples/widgetco-status-digest/{README.md,digest.md}` |
| Edit | any docs still saying private / Maintito / dogfood-only pitch |
| Do not | airoweb; AI-DD; real customer IP |

### `ade-site`
| Action | Path |
| --- | --- |
| Edit | landing HTML/CSS/JS (hero CTAs, Install, In/Not v1, footer) |
| Grep-ban | Buy, Sponsors, checkout, €, private CTA, request access |
| Do not | revive PR #3 commercial path |

## Test plan

T1 scrub grep clean of secrets/`/Users/`/Braiins/private-CTA · T2 LICENSE + README stranger-facing · T3 how-to-run HTTPS clone path · T4 validators green · T5 WidgetCo fictional only · T6 after flip: `gh repo view` PUBLIC · T7 ade.ir allowed CTAs only · T8 CI green both repos · T9 Behzad@local authorship

## Risks

| Risk | Mitigation |
| --- | --- |
| Sensitive history pre-flip | Scrub commit first; escalate history rewrite to Behzad if needed |
| Site ships before public | Prefer site PR after Visibility flip (or soft-gate links) |
| Over-scoping kit | Templates + one example only; no watcher/SaaS |

## Gate

**Status:** accepted — Build (PR A) in progress.
