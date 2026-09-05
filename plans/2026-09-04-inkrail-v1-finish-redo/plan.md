---
intent-id: 2026-09-04-inkrail-v1-finish-redo
spec: specs/2026-09-04-inkrail-v1-finish-redo/spec.md
spec-sha: c8c46cd1565ec09cb19fdd4689c98fdc18a76eee42118f872236c50ac4f52e12
status: accepted
engineer: Behzad
author: Develito
date: 2026-09-04
product: Inkrail
repo: https://github.com/bhzdcz/inkrail
---

# Plan: Re-land Inkrail v1 finish under correct stage ownership

## 1. Approach summary

**Why:** PR #1 (`46c75ed` merge on `main`, commit `0412b2e` authored `Leadito <leadito@local>`) shipped the Inkrail v1 finish under the wrong stage owner. Build must be Develito; Leadito is Deploy/conductor only.

**Verified on clone (2026-09-04):**
- Merge SHA: `46c75ed05f07cc8dc76311ed718d0ef8ef7e7d3e` (PR #1 → `main`)
- Pre-merge parent: `56b57561e1280ac23c72d86d3d29e916710aa4fe`
- PR #1 files: `README.md`, `CLAUDE.md`, `docs/how-to-run.md`, `scripts/promote.sh`, plus Leadito-authored `intent/2026-09-04-inkrail-v1-finish.md` and `plans/2026-09-04-inkrail-v1-finish/plan.md`

**Strategy — two sequential merges (default):**

### Phase A — Hard revert (Develito-authored)
1. Branch from current `main`: `revert/pr-1-inkrail-v1-finish`.
2. `git revert -m 1 46c75ed` (merge revert; `-m 1` keeps first parent `56b5756` tree for touched paths).
3. Seed this redo’s artifact chain paths if missing on the branch (intent/spec/plan for `2026-09-04-inkrail-v1-finish-redo`) only as docs needed for the chain — prefer adding redo artifacts on Phase B if revert PR must stay minimal; **default:** include redo `intent` + accepted `spec` + this `plan.md` (status accepted after gate) on Phase B, and keep Phase A to pure `git revert` of `46c75ed` only.
4. Open PR A: title `revert: PR #1 Inkrail v1 finish (wrong Build owner)`. Body links this plan; states Leadito must not author commits.
5. CI: `validate-templates` / `validate-hooks` must stay green after revert (pre-PR#1 tree already green).
6. Behzad code-owner merge → event `revert_merged`.

### Phase B — Re-land four outcomes (Develito-authored)
1. Branch from post-revert `main`: `feat/inkrail-v1-finish-reland`.
2. Re-implement **only** the four outcomes (content may mirror PR #1’s outcome text, but **new commits by Develito workstream**):
   1. Inkrail branding in `README.md` + `CLAUDE.md`
   2. Add `docs/how-to-run.md`
   3. Align `scripts/promote.sh` deny-text with `releases/release-managers.txt` identity check (restore the post-PR#1 wording that cites exact match, not mere non-empty)
   4. Document GitHub **free-private vs Pro** branch-protection limit in README and/or `how-to-run.md`
3. Commit redo artifacts: `intent/2026-09-04-inkrail-v1-finish-redo.md`, `specs/2026-09-04-inkrail-v1-finish-redo/spec.md`, `plans/2026-09-04-inkrail-v1-finish-redo/plan.md` (this file, `status: accepted` after engineer gate).
4. Do **not** revive Leadito’s `intent/2026-09-04-inkrail-v1-finish.md` / `plans/2026-09-04-inkrail-v1-finish/plan.md` as authoritative (they were part of the wrong-owner landing). Leave them reverted away unless engineer asks to supersede-in-place; prefer new redo intent-id.
5. Open PR B: title `feat: re-land Inkrail v1 finish (Develito Build)`. Stop at reviewable PR for Testito → Reviwito → Leadito gates; Behzad merges.

**Rejected alternatives:**
- Soft rewrite / force-push `main` to hide Leadito authorship — breaks audit trail the redo exists to prove.
- Single stacked PR (revert+reland) — muddy authorship; only if engineer explicitly overrides.
- Leadito “fixing” authorship via amend — forbidden by ownership table.
- Expanding beyond four outcomes — needs new intent.

**Author identity for commits:** use Develito workstream attribution consistent with prior Build commits on this repo (e.g. `Behzad <behzad@local>` was used for Develito Build commits earlier; prefer an explicit `Develito <develito@local>` **or** continue Behzad-local author if that’s the repo convention for agent Build — **open assumption #1**. Testito will check “not Leadito”.

## 2. Files to add / change / delete

### Phase A (revert PR)
| Action | Path |
| --- | --- |
| Revert | All paths touched by `46c75ed` / `0412b2e` (git revert drives the diff) |

Expected revert restores pre-PR#1 versions of:
- `README.md`, `CLAUDE.md`, `scripts/promote.sh`
- Deletes `docs/how-to-run.md`, `intent/2026-09-04-inkrail-v1-finish.md`, `plans/2026-09-04-inkrail-v1-finish/plan.md`

### Phase B (re-land)

| Action | Path | Notes |
| --- | --- | --- |
| Change | `README.md` | Inkrail title/intro; platform = loop not stage-chat; Pro branch-protection limit callout |
| Change | `CLAUDE.md` | Inkrail product name in operating context; keep hardened gate rules intact |
| Add | `docs/how-to-run.md` | Prerequisites, clone, key paths, plan-before-edit, promote gate, Pro limit |
| Change | `scripts/promote.sh` | Deny text must cite `releases/release-managers.txt` exact match |
| Add | `intent/2026-09-04-inkrail-v1-finish-redo.md` | Accepted Planito redo intent (seed from PO-accepted text) |
| Add | `specs/2026-09-04-inkrail-v1-finish-redo/spec.md` | Accepted Designito redo spec |
| Add | `plans/2026-09-04-inkrail-v1-finish-redo/plan.md` | This plan (`status: accepted` after gate) |
| Maybe touch | `.claude/active-intent` | Point at redo intent-id during Build session |

### Explicit will not change
- No v2 features (evals, live bands watcher, CI Claude judgment, cloud deploy)
- No rename away from Inkrail; no SoT move off `bhzdcz/inkrail`
- No Leadito-authored Build commits on either PR
- No changes to hook allowlist/harden logic except as required if promote.sh self-check text drifts (prefer script-only deny-text fix)
- Do not revert `56b5756` (OWNER/REPO → `bhzdcz/inkrail`) unless engineer expands scope — out of this plan
- No merge without Behzad code-owner approval

## 3. Test plan

| # | Check | Owner | How |
| --- | --- | --- | --- |
| T1 | Validators green after Phase A | Develito / CI | `bash tests/validate-templates.sh` && `bash tests/validate-hooks.sh` |
| T2 | Validators green on Phase B PR | Develito / CI | same |
| T3 | Ownership / authorship | **Testito** | `git log` / PR commits on re-land: **no** `Leadito` / `leadito@local` as author of implementation commits; Develito workstream only |
| T4 | Revert precondition | **Testito** | `main` contains revert of `46c75ed` (or documented equivalent) before final green; `git log --grep` / merge graph |
| T5 | Branding | **Testito** | `README.md` + `CLAUDE.md` contain **Inkrail**; describe loop/platform not stage-chat roster |
| T6 | how-to-run | **Testito** | `docs/how-to-run.md` exists; covers prerequisites + promote gate pointer |
| T7 | Promote deny | **Testito** | Without valid allowlisted attestation, `bash scripts/promote.sh` exits non-zero and deny-text mentions `release-managers.txt` |
| T8 | Pro limit doc | **Testito** | Searchable mention of GitHub free-private vs Pro branch-protection limitation |
| T9 | No weaken | **Testito** | Hooks/CI not deleted or skipped to pass |
| T10 | Session self-check | **Testito** | Evidence recorded before human “ready” |

Develito pre-Testito self-check: run T1/T2/T7 locally on the Phase B branch and paste evidence in PR body.

## 4. Hooks / skills / CLAUDE.md touchpoints

- **plan-before-edit** / **production-gate**: no intentional behavior change; Phase B only edits docs/scripts named above. If editing `scripts/promote.sh`, accepted plan + active intent required (not allowlisted).
- **CLAUDE.md**: branding pass only — preserve gate rules (Edit\|Write\|MultiEdit, pathless deny, attestations not allowlisted, release-managers.txt identity).
- **Skills:** none new.
- **active-intent:** set to `2026-09-04-inkrail-v1-finish-redo` during Phase B implementation.

## 5. Risks and rollback

| Risk | Mitigation / rollback |
| --- | --- |
| Wrong revert parent / SHA drift | Verified `46c75ed` on clone; if remote moves, re-verify before `git revert -m 1` |
| Revert breaks validators | Run T1 before requesting merge; abort/fix on branch |
| Content drift vs PR #1 | Prefer four outcomes only; use `git show 0412b2e:PATH` as reference text, re-author under Develito |
| Leadito tempted to “help” Build | Ownership table + Testito T3; Leadito reviews/gates only |
| Pro limit doc creates false safety | Explicit “documentation only; does not enable protection” wording |
| Sequential delay | Acceptable; audit clarity > speed |
| Phase A deletes useful how-to-run until Phase B | Expected gap; do not leave `main` mid-gap longer than needed |

**Rollback:** revert the revert (restore `46c75ed` tree) only with new engineer-accepted plan — do not silently restore Leadito Build as SoT.

## 6. Open assumptions

1. Commit author string for Develito Build: **resolved** — `Behzad <behzad@local>` (engineer choice at plan accept). Testito criterion remains “not Leadito.”
2. Phase A is pure `git revert -m 1 46c75ed` with no extra file edits.
3. Redo intent/spec bodies are seeded in Phase B from accepted Planito/Designito text (spec content hash `c8c46cd1565ec09cb19fdd4689c98fdc18a76eee42118f872236c50ac4f52e12` attachment / `/workspace/sdlc-platform/specs/inkrail-v1-relend/spec.md`).
4. Two PRs sequential; no stack unless Behzad overrides at plan accept.
5. Do not revert `56b5756` identity commit in this change.
6. Private repo `bhzdcz/inkrail` remains SoT; Cursor cloud agent / `gh` used for PRs after `plan_accepted`.
7. Behzad sole code owner + release manager.

## 7. Implementation checklist (post `plan_accepted` only)

- [ ] Set plan frontmatter `status: accepted`
- [x] Phase A branch + `git revert -m 1 46c75ed` + PR A + green validators (PR #2, merge `409a470`)
- [x] Behzad merges Phase A
- [ ] Phase B branch + four outcomes + redo artifacts + PR B
- [ ] Local T1/T2/T7 evidence in PR body
- [ ] Hand Testito → Reviwito → Leadito; no merge without Behzad
- [ ] Leadito must not push Build commits

## 8. Engineer gate

**Status:** `accepted` — Behzad accepted 2026-09-05. Author convention: Behzad <behzad@local>. Implementation unlocked.

On accept: implement Phase A then Phase B as above. On reject: revise plan; **no** revert/push/implement.
