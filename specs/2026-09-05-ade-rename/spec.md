# Spec: Rename Inkrail → ADE (product + GitHub identity)

Author: Designito (Stage 2). Status: accepted. Signed off by Behzad (PO) on 2026-09-05. Event: spec_signed_off — Develito plan mode.
Date: 2026-09-05.
Title / intent-id: `2026-09-05-ade-rename`
Source intent: accepted by Behzad (PO) on 2026-09-05.
Repo today: `https://github.com/bhzdcz/inkrail` (private), `main` @ ~`8289c7c` (Phase B re-land done).
Target identity: product **ADE**, repo `bhzdcz/ade`, promo site stamp `https://ade.ir`.
Event chain: `spec_signed_off` → Develito plan mode. **Leadito does not Build.**

## 1. Summary

Rename the AI-native SDLC platform from **Inkrail** to **ADE** everywhere it is promoted or identified: product strings, GitHub repo `bhzdcz/inkrail` → `bhzdcz/ade`, clone/remote URLs, in-repo identity links, and stamp **https://ade.ir** on README + primary docs branding.

**Playbook substance is unchanged** — artifact chain, hooks, gates, stage ownership, Claude Code as worker. This is identity + pointer hygiene, not a platform redesign.

Out of scope: building the ade.ir site, Braiins product adoption, AI-DD integration, git history rewrite, playbook v2.

## 2. Goals and non-goals

### Goals

1. Product name **ADE** in all **promoted / current-identity** surfaces (README, CLAUDE.md, how-to-run, conventions, scripts’ user-facing identity lines, CODEOWNERS comment, CI-enforced identity checks).
2. Stamp `https://ade.ir` on README and primary docs branding (how-to-run and/or conventions as appropriate).
3. Rename GitHub private repo `bhzdcz/inkrail` → `bhzdcz/ade`; update remotes, clone URLs, and in-repo links to the new name.
4. Keep playbook contracts (chain, hooks, gates, ownership) behaviorally identical.
5. Leave git history intact; rely on GitHub’s rename redirect from the old name when available.
6. If GitHub rename is blocked: land branding + in-repo URL updates first (pointing at intended `bhzdcz/ade` or documenting interim), then open a **follow-up intent** for the actual rename — do not silently stop halfway without a recorded follow-up.

### Non-goals

- Building, hosting, or designing ade.ir (stamp/link only)
- Braiins `/Users/behzad/Braiins/analyst-agent/codebase` adoption
- AI-DD orchestrator / SPA work
- Rewriting git history or force-pushing rewrites of past commits
- Playbook v2 features
- Renaming historical artifact **paths** / intent-ids that already shipped (`…-inkrail-v1-finish-redo`, etc.) — those remain audit trail
- Leadito authoring Build

## 3. Stage ownership (binding)

| Stage | Owner | Must |
| --- | --- | --- |
| Plan | Planito | Accepted intent (done) |
| Design | Designito | This `spec.md` |
| Build | **Develito** | `plan.md` then rename PR(s) |
| Test | Testito | Evidence vs §9 |
| Review / Deploy gates | Reviwito → Leadito | Findings never approve; Behzad merges |
| PO / code owner / release manager | Behzad | Merge + any GitHub Settings rename |

**Hard rule:** Leadito does not implement. Chain: Planito → Designito → Develito → Testito → Reviwito → Leadito → Behzad merge.

## 4. File / surface inventory (base `8289c7c`)

Inventory from clone of `bhzdcz/inkrail` @ `8289c7c`. Build must re-verify on current `main` before editing.

### 4.1 Must update (current identity / promoted)

| Path | What changes |
| --- | --- |
| `README.md` | Title/intro **ADE**; GitHub links `bhzdcz/ade`; stamp `https://ade.ir`; “How to run ADE”; Identity section |
| `CLAUDE.md` | Heading + purpose line: **ADE** (not Inkrail) |
| `docs/how-to-run.md` | Title, body product name, clone URL `git@github.com:bhzdcz/ade.git`, `cd ade` |
| `docs/conventions.md` | Placeholders: GitHub identity `bhzdcz/ade` |
| `CODEOWNERS` | Comment: code owners for `bhzdcz/ade` |
| `tests/validate-templates.sh` | Identity assertion: require `bhzdcz/ade` in `README.md` (replace `bhzdcz/inkrail` check) |
| `scripts/promote.sh` | User-facing identity string → `bhzdcz/ade` / ADE |
| `scripts/finding-to-intent.sh` | Operator line mentioning repo → `bhzdcz/ade` |

### 4.2 Do **not** rewrite (historical SoT) — default

Leave body text and paths as historical record unless a line is still acting as a **live** identity check (none of these should):

| Path | Reason |
| --- | --- |
| `intent/2026-09-04-inkrail-v1-finish-redo.md` | Accepted historical intent; path keeps slug |
| `specs/2026-09-04-inkrail-v1-finish-redo/spec.md` | Accepted historical spec |
| `plans/2026-09-04-inkrail-v1-finish-redo/plan.md` | Accepted historical plan |
| `intent/2026-09-04-ai-native-sdlc-platform.md` | Historical |
| `specs/2026-09-04-ai-native-sdlc-platform/spec.md` | Historical (may mention placeholders) |
| `plans/2026-09-04-ai-native-sdlc-platform/plan.md` | Historical |
| `intent/2026-09-04-dogfood-sample-finding.md` | Historical / sample |

Optional one-line **supersession note** at top of the redo intent/spec (“Product since renamed to ADE — see `2026-09-05-ade-rename`”) is allowed if engineer wants clarity; not required for acceptance.

### 4.3 Likely clean / verify only

Re-grep on Build; update only if a **live** Inkrail / `bhzdcz/inkrail` identity remains:

- `.claude/skills/**`, `.claude/hooks/**`, `docs/plays/**`, `docs/feedback-loop.md`, `REVIEW.md`, `bands.yaml`, templates (`intent/_template.md`, `specs/_template.md`, `findings/_template.md`), `.github/workflows/ci.yml` (runs validate scripts; no product name today beyond comments)
- Local clone directory name / remote URL on developer machines (operator action, document in how-to-run)

### 4.4 New artifacts for this change

| Path | Role |
| --- | --- |
| `intent/2026-09-05-ade-rename.md` | Accepted Planito intent (seed if not already in repo) |
| `specs/2026-09-05-ade-rename/spec.md` | This spec (accepted) |
| `plans/2026-09-05-ade-rename/plan.md` | Develito plan |

## 5. GitHub rename steps (human + Build)

Order preference:

1. **In-repo branding PR** (Develito): §4.1 updates + this artifact chain; CI green (`validate-templates` expects `bhzdcz/ade` in README — coordinate carefully with rename timing, see risk §10).
2. **GitHub Settings → General → Repository name:** `inkrail` → `ade` (Behzad). GitHub typically leaves a redirect from `bhzdcz/inkrail` → `bhzdcz/ade`.
3. **Remotes:** `git remote set-url origin git@github.com:bhzdcz/ade.git` (document in how-to-run).
4. Confirm `gh repo view bhzdcz/ade` and that old URL redirects.

**If rename blocked** (name taken, permissions, org policy):

- Merge branding that states product **ADE** + site `https://ade.ir`
- Keep clone URLs accurate to the **still-named** repo **or** document “pending rename to `bhzdcz/ade`”
- Open follow-up intent for the GitHub rename only — do not claim rename done

**Do not** rewrite history to purge “Inkrail” from old commits.

## 6. CI / identity / validate-templates touchpoints

| Check | Today | After |
| --- | --- | --- |
| `tests/validate-templates.sh` | `grep -q 'bhzdcz/inkrail' README.md` | `grep -q 'bhzdcz/ade' README.md` (and fail message updated) |
| `.github/workflows/ci.yml` | Runs validate-templates + validate-hooks | Unchanged flow; benefits from script update |
| Optional | — | Soft assert README or how-to-run contains `ade.ir` (recommended, not mandatory if it flakes on formatting) |

**Ordering note:** Landing the validate-templates change **before** README says `bhzdcz/ade` will fail CI. Single PR should update README identity + script assertion together. GitHub repo rename can happen before or after that PR merges; redirects cover old clones.

## 7. Branding copy requirements (ADE)

Minimum viable promoted copy:

- Product name **ADE** (not Inkrail) in README H1 and first paragraph
- One clear line that ADE is the AI-native SDLC platform (artifacts on rails / playbook loop — not stage-chat personas)
- Visible link or plain URL **https://ade.ir** (promotional site; no claim the site is built in this change)
- GitHub identity `bhzdcz/ade` with markdown link once rename is done (or interim note if blocked)
- how-to-run clone instructions use the live repo slug

Tone: same as current Inkrail docs — plain, operator-facing, no marketing fluff required beyond the name + site stamp.

## 8. Approach for Build (Design constraints — not a plan.md)

Develito still writes `plan.md`. Design constraints:

1. One primary implementation PR preferred for §4.1 + artifact seeds; GitHub Settings rename is a human step Behzad owns (can be same day).
2. Set `.claude/active-intent` to `2026-09-05-ade-rename` during implementation.
3. Re-grep `inkrail` case-insensitive after edits; any remaining hits must be justified as historical (§4.2) or fixed.
4. Do not weaken hooks/CI to pass.
5. No playbook behavior changes in hooks beyond identity strings in scripts.

## 9. Acceptance criteria / Testito expectations

1. **Product name:** `README.md` and `CLAUDE.md` identify **ADE**, not Inkrail, as the current product.
2. **Site stamp:** `https://ade.ir` appears in README (and ideally how-to-run).
3. **Repo identity in-tree:** live docs/scripts/CODEOWNERS comment / validate-templates assert `bhzdcz/ade` (not `bhzdcz/inkrail`).
4. **GitHub rename:** repo exists as `bhzdcz/ade` **or** follow-up intent filed + interim docs honest about blockage.
5. **Clone path:** `docs/how-to-run.md` clone instructions match live repo.
6. **CI:** `bash tests/validate-templates.sh` and `bash tests/validate-hooks.sh` pass on the PR.
7. **History:** no history rewrite; historical `*inkrail*` intent-ids/paths remain.
8. **Ownership:** Develito authors Build commits; Leadito does not.
9. **Playbook intact:** hooks still enforce plan-before-edit + production-gate; no stage-ownership change.

## 10. Flagged concerns (analyst escalations)

1. **CI / rename race** — validate-templates hard-requires README identity string. Mitigate with single PR updating both; rename Settings can be independent thanks to redirects.
2. **Name collision** — `ade` may be taken under `bhzdcz` or confuse with other ADE acronyms. If blocked, follow-up intent — don’t force a different slug without PO.
3. **ade.ir not built** — stamping the URL may 404 until a later intent. Acceptable per this intent; don’t imply the site ships here.
4. **Historical “Inkrail” strings** — greps will still find old artifacts; Testito must distinguish live vs historical (§4.1 vs §4.2).
5. **Local paths / bookmarks** — developers with `/inkrail` checkouts need remote update; document only.
6. **External references** — Grok Bot memories, chat, and other repos may still say Inkrail until updated separately (out of scope here; Leadito/operators may sweep later).
7. **Braiins adoption desire** (shared memory) — explicitly out of this intent; do not sneak target-repo wiring into the rename PR.

## 11. Open questions (defaults)

| # | Question | Default |
| --- | --- | --- |
| 1 | GitHub rename timing vs branding PR | Branding+CI PR first or same day; Settings rename by Behzad ASAP after |
| 2 | Supersession banners on old Inkrail intents | Optional; not required |
| 3 | Assert `ade.ir` in validate-templates | Optional soft check; README presence required for humans |
| 4 | Jira key | Only if ticket exists |

## 12. Risks

| Risk | Mitigation |
| --- | --- |
| Broken clones after rename | GitHub redirect; document new remote in how-to-run |
| CI red from split PR | Ship README + validate-templates together |
| Accidental history rewrite | Forbid filter-branch/rebase of `main` for this change |
| Scope creep into AI-DD / Braiins / site build | Non-goals + Testito scope check |
| Leadito Build relapse | Ownership table + authorship check |

## 13. Out of scope (explicit)

ade.ir site implementation; Braiins analyst-agent codebase adoption; AI-DD; git history rewrite; playbook v2; renaming historical intent-id directories; Leadito Build.

## 14. Sign-off

PO sets this file’s status to `accepted` (or merges accepting record) → `spec_signed_off` → Develito plan mode.

Checklist:

- [ ] ADE + ade.ir + `bhzdcz/ade` identity specified
- [ ] File inventory live vs historical split is clear
- [ ] GitHub rename + blocked fallback specified
- [ ] CI/validate-templates touchpoint specified
- [ ] Testito criteria listed
- [ ] Concerns flagged
- [ ] No plan.md / production code in Design
