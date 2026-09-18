# Spec: ADE history cleanup (pre-public)

Author: Designito (Stage 2). Status: **accepted**. Signed off by Behzad (PO) on 2026-09-18. Event: `spec_signed_off` — Develito plan mode.
Date: 2026-09-18.
Intent-id: `2026-09-18-ade-history-cleanup`
Source intent: accepted by Behzad (PO) on 2026-09-18 with Planito defaults.
Repo: `https://github.com/bhzdcz/ade` (still **PRIVATE** — this workstream does **not** flip visibility).
Parent / keep chain: `2026-09-18-ade-public-oss` (+ WidgetCo example).
**Separate from airoweb / AI-DD.** Leadito does not Build. No Maintito.
Spec accepted — Develito plan then Build.

## 1. Summary

Clean `bhzdcz/ade` of obsolete historical artifact chains **before** the public visibility flip (owned by the public-oss workstream). Use **normal git delete commits on a PR** — no `git filter-repo`, no history rewrite, no soft-archive.

Also set `.claude/active-intent` to `2026-09-18-ade-public-oss`.

## 2. Locked decisions

| Topic | Lock |
| --- | --- |
| Delete method | **Normal delete commits** in a PR to `main` (no filter-repo / BFG / force-push rewrite) |
| Sibling folders | **Yes** — delete entire `specs/<id>/` and `plans/<id>/` dirs for deleted intent-ids |
| active-intent | Set to **`2026-09-18-ade-public-oss`** |
| Visibility / ade.ir | **Out of scope** (public-oss / site PR B) |

## 3. Stage ownership

| Stage | Owner |
| --- | --- |
| Plan | Planito (accepted intent) |
| Design | Designito (this spec) |
| Build | **Develito** — thin `plan.md` then PR |
| Test | Testito |
| Review / Deploy gate | Reviwito → Leadito (Leadito does not Build) |
| PO merge | Behzad |

## 4. KEEP (do not delete)

### 4.1 Templates
- `intent/_template.md`
- `specs/_template.md`
- `plans/_template.md`
- `findings/_template.md`

### 4.2 Active product chains
- **Public OSS:** `intent/2026-09-18-ade-public-oss.md`, `specs/2026-09-18-ade-public-oss/`, `plans/2026-09-18-ade-public-oss/`
- **WidgetCo example:** `intent/2026-09-18-widgetco-status-digest.md`, `specs/2026-09-18-widgetco-status-digest/`, `plans/2026-09-18-widgetco-status-digest/`, `examples/widgetco-status-digest/`

### 4.3 This cleanup chain (once landed)
- `intent/2026-09-18-ade-history-cleanup.md`, `specs/2026-09-18-ade-history-cleanup/`, `plans/2026-09-18-ade-history-cleanup/`

### 4.4 Kit runtime (untouched except doc retargets in §6)
`docs/` (incl. plays), `.claude/hooks/`, `.claude/skills/`, `CLAUDE.md`, `REVIEW.md`, `README.md`, `LICENSE` (if present), `tests/`, `scripts/`, `bands.yaml`, `CODEOWNERS`, `releases/attestations/.gitkeep`, `releases/release-managers.txt`, CI workflows, `.gitignore`, `.markdownlint.json`.

Do **not** rewrite substance of kept public-oss / WidgetCo artifacts in this PR.

## 5. DELETE (hard-delete via PR)

Inventory verified on `main` (2026-09-18). Build re-lists before merge.

### 5.1 Intent files
| Path |
| --- |
| `intent/2026-09-04-ai-native-sdlc-platform.md` |
| `intent/2026-09-04-inkrail-v1-finish-redo.md` |
| `intent/2026-09-04-dogfood-sample-finding.md` |
| `intent/2026-09-05-ade-rename.md` |
| `intent/2026-09-05-ade-site.md` |

### 5.2 Spec trees (delete whole folder)
| Path |
| --- |
| `specs/2026-09-04-ai-native-sdlc-platform/` |
| `specs/2026-09-04-inkrail-v1-finish-redo/` |
| `specs/2026-09-05-ade-rename/` |
| `specs/2026-09-05-ade-site/` |

Note: `2026-09-04-dogfood-sample-finding` has **no** `specs/` tree on main — intent-only.

### 5.3 Plan trees (delete whole folder)
| Path |
| --- |
| `plans/2026-09-04-ai-native-sdlc-platform/` |
| `plans/2026-09-04-inkrail-v1-finish-redo/` |
| `plans/2026-09-05-ade-rename/` |
| `plans/2026-09-05-ade-site/` |

### 5.4 Findings example
| Path |
| --- |
| `findings/examples/dogfood-sample.md` |

If `findings/examples/` becomes empty, remove the empty dir or leave a `.gitkeep` — Build choice; do not add a new dogfood sample in this PR.

### 5.5 Release acceptances tied only to deleted intents
| Path | Action |
| --- | --- |
| `releases/code-owner-acceptances/2026-09-04-ai-native-sdlc-platform.yaml` | **Delete** (safe — only serves deleted intent) |

Keep `releases/attestations/.gitkeep` and `releases/release-managers.txt`.

## 6. FIX / retarget (required with deletes)

| Path | Change |
| --- | --- |
| `.claude/active-intent` | Single line: `2026-09-18-ade-public-oss` (today: `2026-09-04-ai-native-sdlc-platform`) |
| `docs/how-to-run.md` | Replace `findings/examples/dogfood-sample.md` examples with `findings/_template.md` (copy-then-run) or “your own finding under `findings/`” |
| `CLAUDE.md` | Same retarget for `finding-to-intent.sh` sample invocation |
| `README.md` | Only if it uniquely points at a deleted intent-id or dogfood-sample path |

Do not reintroduce Maintito. Do not add Buy/Sponsors language.

## 7. Non-goals

- Visibility flip to public
- `ade.ir` / `ade-site` landing rewrite (public-oss PR B)
- Soft-archive / `archive/` moves
- Rewriting kept chain substance (public-oss, WidgetCo)
- `git filter-repo` / history rewrite / force-push of rewritten history
- AI-DD / airoweb

## 8. Implementation notes for Develito

1. Thin `plan.md` → one cleanup PR preferred (deletes + active-intent + doc retargets).
2. After deletes, run `bash tests/validate-templates.sh` and `bash tests/validate-hooks.sh`.
3. Grep for deleted intent-ids and `dogfood-sample` on kept docs; fix stragglers in the same PR.
4. Do not flip repo visibility in this PR.

## 9. Acceptance criteria

1. Listed DELETE paths gone from `main` after merge.
2. KEEP paths still present (templates, public-oss, WidgetCo + examples, kit runtime).
3. `.claude/active-intent` is exactly `2026-09-18-ade-public-oss`.
4. No remaining promoted-doc references to deleted intent-ids or `findings/examples/dogfood-sample.md`.
5. Validators green; no filter-repo / history rewrite used.
6. Leadito does not Build; Behzad merges.

## 10. Testito checklist

- [ ] `gh` / tree: deleted paths absent; keep paths present
- [ ] `cat .claude/active-intent` → `2026-09-18-ade-public-oss`
- [ ] `rg` for deleted ids + `dogfood-sample` clean on README/CLAUDE/docs (except git history)
- [ ] `validate-templates.sh` + `validate-hooks.sh` PASS
- [ ] CI green

## 11. Flagged concerns

1. **Git history still contains deleted blobs** — intentional (no rewrite). Acceptable for this intent; escalate only if scrub for publicize finds secrets in history (separate from this delete).
2. **how-to-run Maintain demo** loses the canned dogfood file — retarget to template is enough for v1.
3. Land this **before** visibility flip so public `main` tip is already clean.

## 12. Sign-off

**Accepted** 2026-09-18 — Develito may write `plan.md` then Build. Designito idle unless Build needs clarification.
