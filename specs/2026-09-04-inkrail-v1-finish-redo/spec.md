# Spec: Re-land Inkrail v1 finish under correct stage ownership

Author: Designito (Stage 2). Status: accepted. Signed off by Behzad (PO) on 2026-09-04. Event: spec_signed_off — Develito plan mode.
Date: 2026-09-04. Product: **Inkrail**.
Repo: `https://github.com/bhzdcz/inkrail` (private).
Source: Planito redo intent — accepted by Behzad (PO) on 2026-09-04.
Event chain target: `spec_signed_off` → Develito plan mode (Leadito does **not** author Build).

## 1. Summary

PR #1 (merge `46c75ed` on `main`, or equivalent Leadito-authored Build landing) shipped Inkrail v1 finish outcomes under the **wrong stage owner**. This change **hard-reverts** that landing, then **re-lands the same four v1 outcomes** through the correct chain with **Develito** as Build author. Leadito remains **Deploy / gate conductor only**.

Scope is this redo only. No v2 features. Product name stays **Inkrail**.

## 2. Goals and non-goals

### Goals

1. Hard-revert PR #1 / merge `46c75ed` on `main` (or equivalent revert that removes Leadito Build authorship from `main`).
2. Re-land via Develito, through plan.md → diff + tests → review gates, these **four outcomes**:
   - Inkrail branding in `README.md` and `CLAUDE.md`
   - `docs/how-to-run.md`
   - `promote.sh` deny-text vs `release-managers.txt`
   - Document free-private **branch-protection Pro limit** (GitHub free private repos lack required reviews / full protection available on Pro)
3. Preserve / restore artifact chain + gate events for this change; publish stage ownership table.
4. Define success criteria and test expectations for Testito.

### Non-goals

- New product features beyond the four outcomes above
- v2 (eval suite, live watcher, CI Claude judgment, deploy automation beyond current promote gate)
- Leadito writing Build diffs, `plan.md`, or re-implementing the four outcomes
- Renaming the product away from Inkrail
- Changing SoT off GitHub `bhzdcz/inkrail`

## 3. Problem / why redo

Accepted platform rule: **Build owns implementation**; Leadito owns Deploy / loop conduct and stops at human gates. Shipping PR #1 as Leadito Build authorship breaks auditability (who implemented vs who gated) and dogfood credibility. Chat or conductor convenience is not a substitute for stage ownership.

## 4. Stage ownership table (binding for this change)

| Stage | Owner | Artifact / action | Must not |
| --- | --- | --- | --- |
| Plan | Planito | Accepted redo `intent.md` | Write `spec.md` / code |
| Design | Designito | This `spec.md` (PO sign-off) | Write `plan.md` / production code |
| Build | **Develito** | `plan.md` then revert + re-land diff | Skip plan mode; let Leadito author |
| Test | Testito | Evidence vs §10 expectations | Weaken checks to pass |
| Deploy (review/gate) | Reviwito → **Leadito** | `REVIEW.md` passes; human gates; release-manager gate | Author Build; merge past prod without Behzad |
| Maintain | Maintito | N/A for this redo unless a finding opens | Bypass Deploy |

**Hard rule:** Leadito must not author Build for the re-land. If a Conductor drafts text, Develito still owns the commits/PR as Build.

## 5. Approach

### Phase A — Hard revert

1. From current `main`, create a Build branch owned by Develito workstream.
2. Revert merge `46c75ed` / PR #1 with a proper revert commit (or sequence) so `main` no longer contains that Leadito-authored finish as the authoritative landing.
3. Revert PR goes through normal gates: plan (may be short, explicit “revert-only”), tests as applicable, human code-owner (Behzad), then merge.
4. Success of Phase A: `main` history shows clear revert; tree matches pre-PR#1 finish state for the touched paths (or documented equivalent).

### Phase B — Re-land four outcomes (Develito)

After revert is on `main` (or stacked only if engineer explicitly accepts a stacked plan — default is sequential: revert merged, then re-land):

1. Develito starts in **plan mode**; engineer (Behzad / designee) accepts `plan.md`.
2. Implement only the four outcomes (§6).
3. Update `plan.md` if the diff departs.
4. PR by Develito workstream; Reviwito findings never approve; Leadito conducts Deploy gates; Behzad code-owner + release-manager as today.

## 6. Functional design — four outcomes

### 6.1 Inkrail branding — `README.md` + `CLAUDE.md`

- Product name **Inkrail** visible in README title/intro and in `CLAUDE.md` operating context.
- Describe the platform as the AI-native SDLC loop (plays, artifacts, gates), not a stage-chat product.
- Point to artifact paths (`intent/`, `specs/`, `plans/`, `REVIEW.md`, hooks/skills) consistent with platform contracts already in repo post-re-land.
- No persona roster as the product definition.

### 6.2 `docs/how-to-run.md`

- Operator steps to run Inkrail locally / with Claude Code CLI for dogfood.
- Prerequisites, clone, key files, plan-before-edit expectation, how promote gate works at a high level.
- Linkage notes for Jira/Figma fields when present.
- Readable by a person who missed chat.

### 6.3 `promote.sh` deny-text vs `release-managers.txt`

- Promote / prod-gate script refuses promotion unless actor is listed in `release-managers.txt`.
- Deny path prints clear text (who is allowed, how to update the list, that agents cannot self-approve prod).
- Behzad remains sole release manager unless file updated by human process.
- Behavior is must-hold (script/hook); not “skill advice only.”

### 6.4 Document free-private branch-protection Pro limit

- Docs (README and/or `docs/how-to-run.md`) state that GitHub **free private** repos do not get the full branch-protection / required-review feature set that **Pro** unlocks.
- Call out what Inkrail therefore relies on instead for v1 (e.g. human discipline, `promote.sh` + `release-managers.txt`, PR norms) so the limitation is not a silent footgun.
- No requirement to buy Pro in this change; documentation only.

## 7. Artifact chain and gate events (this change)

```
accepted redo intent
  → this spec.md (PO sign-off)     # Designito; starts plan mode
  → plan.md (engineer accept)      # Develito; Leadito does not author
  → Phase A revert diff + evidence
  → Phase B re-land diff + evidence
  → REVIEW.md passes + findings    # never auto-approve
  → human code-owner (Behzad)
  → promote gate (release-managers.txt)
```

| Event | Meaning for this redo |
| --- | --- |
| `spec_signed_off` | Behzad accepts this spec → Develito plan mode |
| `plan_accepted` | Engineer accepts Develito `plan.md` → edits allowed |
| `revert_merged` | Phase A on `main` |
| `reland_pr_opened` | Phase B PR by Develito |
| `code_owner_approved` | Behzad on re-land PR |
| `prod_gate_blocked` / allow | `promote.sh` vs `release-managers.txt` |

Status vocabulary: `draft` | `in_review` | `accepted` | `rejected` | `superseded` | `implemented` | `closed`.

## 8. Repo layout touchpoints (expected paths)

Exact tree may already exist from prior work; after redo, at minimum:

- `README.md`, `CLAUDE.md` — Inkrail branding
- `docs/how-to-run.md` — new or restored
- `promote.sh`, `release-managers.txt` — gate behavior + deny text
- Docs stating GitHub free-private Pro limit
- `plans/<intent-id>/plan.md` — Develito
- Prior platform artifacts (`intent/`, `specs/`, `REVIEW.md`, hooks/skills) remain coherent with branding

Design does not prescribe every line of prior platform scaffolding — only that re-land restores the four outcomes without Leadito Build authorship.

## 9. Security / compliance / audit

- Audit trail must show **revert** then **Develito-authored re-land**, not a silent amend that hides Leadito Build.
- No secrets in markdown or scripts; release-manager list is not a secret but is a control file.
- Agents must not bypass `promote.sh` / `release-managers.txt`.
- Findings never approve PRs.

## 10. Success criteria and Testito expectations

### Leading (this redo)

- Hours from accepted intent → accepted spec → accepted plan (track)
- Revert lands before re-land (or engineer-accepted stack documented)
- Plan.md exists and is accepted before Phase B implementation edits
- First-pass CI / checks on re-land PR
- Minutes to first review findings

### Lagging / quality

- No Leadito-authored Build commits in the re-land PR
- Four outcomes present and correct on `main` after merge
- Promote deny path verified when actor not in `release-managers.txt`
- Docs mention free-private Pro branch-protection limit

### Testito checklist (must evidence)

1. **Ownership:** git/PR authorship shows Develito workstream for re-land implementation commits (not Leadito).
2. **Revert:** `main` contains revert of PR #1 / `46c75ed` (or documented equivalent) before or as precondition of final green state.
3. **Branding:** `README.md` + `CLAUDE.md` say Inkrail; describe loop/platform not stage-chat product.
4. **how-to-run:** `docs/how-to-run.md` exists; covers run prerequisites + promote gate pointer.
5. **Promote gate:** running promote as non-listed user yields deny-text; listed release manager path documented; `release-managers.txt` present.
6. **Pro limit doc:** searchable mention of GitHub free-private vs Pro branch-protection limitation.
7. **No weaken:** do not delete/skip hooks or checks to make the re-land pass.
8. **Session self-check:** Testito records evidence before human sees the PR as ready.

## 11. UX notes

- Primary UX remains files + CLI + PR.
- `how-to-run.md` and deny-text must be plain language for Behzad as sole PO/release manager.
- No new product UI; no Figma required for this redo.

## 12. Flagged concerns (analyst escalations)

1. **Private repo visibility** — Designito could not fetch `bhzdcz/inkrail` from the public web (404). Spec assumes Leadito’s cited merge `46c75ed` / PR #1; Build must verify SHAs on clone and adjust revert target if history differs.
2. **Stacked vs sequential** — Default is revert merge then re-land. Stacking both in one PR risks muddy authorship/audit; only allow if engineer explicitly accepts that plan shape.
3. **“Same four outcomes” drift** — Prior PR #1 contents were not re-read here. If PR #1 had extra files beyond the four outcomes, Build must either re-land only the four (preferred) or flag extras in `plan.md` for PO/engineer.
4. **Branch protection gap** — Documenting the Pro limit does not create protection. Residual risk until Pro or external controls; acceptable for v1 dogfood only if called out in docs.
5. **Sole release manager** — Behzad remains single point of failure; unchanged default, still flagged.
6. **Conductor temptation** — Pressure to “just let Leadito finish” again. Binding ownership table forbids it; Testito ownership check is the backstop.

## 13. Open questions (defaults)

| # | Question | Default |
| --- | --- | --- |
| 1 | Exact revert target if `46c75ed` ≠ PR #1 merge | Develito verifies on clone; revert the Leadito Build merge that wrongly shipped finish |
| 2 | One PR vs two (revert, then re-land) | Two sequential merges preferred |
| 3 | Extra acceptors / release managers | Behzad sole (`release-managers.txt`) |
| 4 | Jira key | Only if ticket exists |

## 14. Acceptance criteria (PO sign-off)

- [ ] Spec limited to hard-revert + Develito re-land of four outcomes
- [ ] Leadito must not author Build — stated and testable
- [ ] Artifact chain + gates + ownership table present
- [ ] Testito expectations listed
- [ ] Concerns flagged, not buried
- [ ] No `plan.md` / production code in Design

**Sign-off:** Behzad sets status to `accepted` (or merges accepting record). That is `spec_signed_off` → Develito plan mode. Leadito puts plan acceptance and Deploy gates in front of Behzad; Leadito does not implement.

## 15. Out of scope

v2 features; new products; renaming Inkrail; Leadito Build authorship; Design writing plan/code; expanding beyond the four re-land outcomes without a new intent.
