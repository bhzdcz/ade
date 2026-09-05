---
intent-id: 2026-09-05-ade-rename
spec: specs/2026-09-05-ade-rename/spec.md
spec-sha: 5b8ae5fc926b0ba16bb19886972db46927cb6fb47c9273d8d38d9cc9cd4e0a57
status: accepted
engineer: Behzad
author: Develito
date: 2026-09-05
product: ADE
repo: https://github.com/bhzdcz/inkrail
target-repo: https://github.com/bhzdcz/ade
---

# Plan: Rename Inkrail → ADE (product + GitHub identity)

## 1. Approach summary

Rename the dogfood platform’s **promoted identity** from Inkrail to **ADE**, stamp **https://ade.ir**, and retarget GitHub identity to **`bhzdcz/ade`**. Playbook behavior (hooks, gates, artifact chain, ownership) stays unchanged. Leadito does **not** Build.

**Base:** `bhzdcz/inkrail` `main` @ `8289c7c` (verified on clone).

**Strategy — single branding PR + human Settings rename:**

1. Set `.claude/active-intent` to `2026-09-05-ade-rename`.
2. One PR `chore/ade-rename` from `main` updating all §4.1 live surfaces **together** (README identity + `tests/validate-templates.sh` assertion in the same commit/PR so CI stays green).
3. Seed `intent/`, `specs/`, `plans/` for this intent-id.
4. Behzad renames GitHub repo Settings: `inkrail` → `ade` (same day preferred). Build documents remote update in `docs/how-to-run.md`.
5. After merge (and rename if done), re-grep `inkrail` case-insensitive; remaining hits must be §4.2 historical only.
6. Stop at reviewable PR for Testito → Reviwito → Leadito → Behzad. No merge without code-owner.

**If GitHub rename is blocked:** still land ADE branding + `ade.ir` stamp; keep clone URLs accurate to the still-named repo **or** mark “pending rename to `bhzdcz/ade`”; open a follow-up intent for Settings rename only — do not claim rename done.

**Rejected alternatives:** history rewrite / filter-branch; renaming historical `*inkrail*` intent-id paths; weakening hooks; Braiins/AI-DD/ade.ir site build; Leadito-authored commits; split PR that breaks validate-templates mid-flight.

**Git author:** `Behzad <behzad@local>` (Develito workstream; not Leadito).

## 2. Files to add / change / delete

### Change (live identity — must update)

| Path | Change |
| --- | --- |
| `README.md` | H1/intro **ADE**; links `bhzdcz/ade`; stamp `https://ade.ir`; how-to-run label; Identity section |
| `CLAUDE.md` | Heading + purpose: **ADE** |
| `docs/how-to-run.md` | Title/body ADE; clone `git@github.com:bhzdcz/ade.git && cd ade`; remote-update note after Settings rename; `ade.ir` stamp |
| `docs/conventions.md` | GitHub identity `bhzdcz/ade` |
| `CODEOWNERS` | Comment → `bhzdcz/ade` (`* @bhzdcz` unchanged) |
| `tests/validate-templates.sh` | Assert `bhzdcz/ade` in README (replace `bhzdcz/inkrail`); update fail message |
| `scripts/promote.sh` | User-facing identity → `bhzdcz/ade` / ADE |
| `scripts/finding-to-intent.sh` | Operator line → `bhzdcz/ade` |
| `.claude/active-intent` | `2026-09-05-ade-rename` |

### Add

| Path | Role |
| --- | --- |
| `intent/2026-09-05-ade-rename.md` | Accepted Planito intent (seed) |
| `specs/2026-09-05-ade-rename/spec.md` | Accepted Designito spec (seed; status accepted) |
| `plans/2026-09-05-ade-rename/plan.md` | This plan (`status: accepted` after engineer gate) |

### Verify-only (update only if live Inkrail / `bhzdcz/inkrail` remains)

`.claude/skills/**`, `.claude/hooks/**`, `docs/plays/**`, `docs/feedback-loop.md`, `REVIEW.md`, `bands.yaml`, templates, `.github/workflows/ci.yml` — re-grep; expect clean for live identity.

### Explicit will not change (historical SoT)

Do **not** rewrite bodies/paths of:

- `intent/2026-09-04-inkrail-v1-finish-redo.md`
- `specs/2026-09-04-inkrail-v1-finish-redo/**`
- `plans/2026-09-04-inkrail-v1-finish-redo/**`
- `intent/2026-09-04-ai-native-sdlc-platform.md`
- `specs/2026-09-04-ai-native-sdlc-platform/**`
- `plans/2026-09-04-ai-native-sdlc-platform/**`
- `intent/2026-09-04-dogfood-sample-finding.md` (historical sample; may still say `bhzdcz/inkrail` — leave unless Testito/engineer demands a one-line supersession note)

Optional supersession one-liner on redo intent/spec: **not required** (default off).

### Will not do

- ade.ir site build; Braiins adoption; AI-DD; git history rewrite; playbook v2; hooks weakening; Leadito Build commits; claim GitHub rename done if Settings blocked.

## 3. Test plan

| # | Check | Owner | How |
| --- | --- | --- | --- |
| T1 | Validators green | Develito / CI | `bash tests/validate-templates.sh` && `bash tests/validate-hooks.sh` |
| T2 | Product name | **Testito** | README + CLAUDE identify **ADE**, not Inkrail, as current product |
| T3 | Site stamp | **Testito** | `https://ade.ir` in README (ideally how-to-run too) |
| T4 | Repo identity in-tree | **Testito** | live docs/scripts/CODEOWNERS comment / validate-templates use `bhzdcz/ade` |
| T5 | GitHub rename | **Testito** / Behzad | `bhzdcz/ade` exists **or** follow-up intent + honest interim docs |
| T6 | Clone path | **Testito** | how-to-run matches live repo slug |
| T7 | History intact | **Testito** | historical `*inkrail*` paths/bodies remain; no filter-branch |
| T8 | Ownership | **Testito** | Build commits `Behzad <behzad@local>` / not Leadito |
| T9 | Playbook intact | **Testito** | plan-before-edit + production-gate still enforce |
| T10 | Post-grep | Develito / Testito | `grep -Ri inkrail` remaining hits classified historical-only |

Develito self-check: T1 + promote.sh still denies without attestation; paste in PR body. Include post-edit `inkrail` grep summary in PR.

## 4. Hooks / skills / CLAUDE.md touchpoints

- **Hooks:** no behavior change; only `scripts/promote.sh` identity echo string.
- **CLAUDE.md:** branding/purpose only — preserve gate rules (Edit\|Write\|MultiEdit, pathless deny, attestations not allowlisted, release-managers.txt).
- **Skills:** none new.
- **active-intent:** `2026-09-05-ade-rename` for the implementation session.
- **CI:** `.github/workflows/ci.yml` unchanged flow; picks up validate-templates assertion change.

## 5. Risks and rollback

| Risk | Mitigation / rollback |
| --- | --- |
| CI red if README/script split | Single PR updates both |
| `ade` name collision / Settings blocked | Interim honest docs + follow-up intent; don’t invent alternate slug |
| ade.ir 404 | Stamp only; no claim site ships here |
| Historical Inkrail greps confuse Testito | §4.1 vs §4.2 table in PR body |
| Stale local remotes | Document `git remote set-url origin git@github.com:bhzdcz/ade.git` |
| Scope creep (Braiins / AI-DD / site) | Non-goals; Testito T scope |
| Leadito Build relapse | Authorship check T8 |

**Rollback:** revert the branding PR. GitHub Settings rename reverse is Behzad’s if needed (redirects usually remain from old name).

## 6. Open assumptions

1. GitHub Settings rename (`inkrail`→`ade`) is Behzad’s human step ASAP after or same day as branding PR merge.
2. Branding PR lands while remote may still be `bhzdcz/inkrail` briefly; README will already say `bhzdcz/ade` (redirects / pending rename acceptable per spec).
3. Spec seed SHA-256 of Designito accepted file: `5b8ae5fc926b0ba16bb19886972db46927cb6fb47c9273d8d38d9cc9cd4e0a57` (recompute after land into `specs/.../spec.md` and update frontmatter if needed — same lesson as redo).
4. No supersession banners on historical Inkrail artifacts (default).
5. Optional `ade.ir` assert in validate-templates: **skip** unless cheap one-liner; human README check is enough.
6. Commit author `Behzad <behzad@local>`.
7. Cloud Agents unavailable — implement via local clone + `gh` (as prior Inkrail work).

## 7. Implementation checklist (post `plan_accepted` only)

- [ ] Set plan frontmatter `status: accepted`; set `.claude/active-intent`
- [ ] Branch `chore/ade-rename` from `main`
- [ ] Update §4.1 files + seed intent/spec/plan
- [ ] Re-grep `inkrail`; justify leftovers
- [ ] Green validate-templates + validate-hooks
- [ ] Push + open PR; paste evidence + grep summary
- [ ] Document Behzad Settings rename + remote set-url
- [ ] Hand Testito → Reviwito → Leadito; no merge without Behzad
- [ ] If rename blocked: file follow-up intent (do not claim done)

## 8. Engineer gate

**Status:** `accepted` — Behzad accepted 2026-09-05. Implementation unlocked.

On accept: implement as above. On reject: revise plan; **no** branding PR / Settings rename instructions executed by Build.
