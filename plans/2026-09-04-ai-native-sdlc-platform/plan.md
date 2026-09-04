---
intent-id: 2026-09-04-ai-native-sdlc-platform
spec: specs/2026-09-04-ai-native-sdlc-platform/spec.md
spec-sha: c9f3ed2c8e92b406244c526c002c36b315cee346
status: accepted
engineer: Behzad
author: Develito
date: 2026-09-04
---

# Plan: AI-native SDLC platform (v1 dogfood)

## 1. Approach summary

Greenfield **dedicated GitHub repo** that *is* the platform (dogfood). Scaffold the full layout in one implementation pass after this plan is accepted. Worker is **Claude Code CLI/SDK only** — no multi-harness runtime.

**Repo strategy (decision):** Prefer create `bhzdcz/inkrail` on GitHub (name TBD by Behzad), then scaffold the full tree via Cursor cloud agent + `gh` into that empty repo. Until `bhzdcz/inkrail` is named, treat the tree as a local/placeholder scaffold with `bhzdcz/inkrail` literals everywhere identity is needed; first post-create task is rename placeholders + protect default branch. Do **not** start a multi-product monorepo.

**Bootstrap order after `plan_accepted`:**

1. Create empty private GitHub repo (or local git root) with placeholders.
2. Commit platform skeleton in dependency order so hooks can be tested as they land: templates → docs/`CLAUDE.md`/`REVIEW.md` → skills → hooks + settings → `bands.yaml` → minimal CI → seed this intent/spec/plan chain into the repo → one manual Maintain finding→intent dry-run.
3. Open a reviewable PR. Default: **one bootstrap PR** titled `feat: v1 AI-native SDLC platform dogfood scaffold`.

**Intent file convention:** flat `intent/YYYY-MM-DD-<slug>.md` (intent-id = filename without `.md`). Specs/plans nest under that id: `specs/<intent-id>/spec.md`, `plans/<intent-id>/plan.md`.

**Active intent for hooks:** file `.claude/active-intent` containing a single intent-id line. Plan-before-edit reads it to locate `plans/<id>/plan.md`.

Nothing in this plan implements application product code outside the platform contracts. Grok bots remain conductors only — not SoT and not in-repo product.

## 2. Files to add / change / delete

### Add (all new — empty repo)

| Path | Purpose |
| --- | --- |
| `README.md` | What this repo is; pointer to `docs/plays/`; placeholders `bhzdcz/inkrail` |
| `CLAUDE.md` | ≤1 page: artifact paths, gate rules, read intent→spec→plan before edit, link to plays |
| `REVIEW.md` | Three passes (bugs, security, compliance vs artifacts); Important vs Nit; skip rules; code-owner rule |
| `bands.yaml` | Schema + ≥2 example bands |
| `CODEOWNERS` | `* @bhzdcz` (placeholder until real GitHub identity) |
| `intent/_template.md` | Required sections per spec §7.1 |
| `intent/2026-09-04-ai-native-sdlc-platform.md` | Seed accepted intent (rev 3 content) for dogfood SoT |
| `specs/_template.md` | Required sections per spec §7.2 |
| `specs/2026-09-04-ai-native-sdlc-platform/spec.md` | Seed accepted Designito spec |
| `plans/2026-09-04-ai-native-sdlc-platform/plan.md` | This plan (status updated on accept) |
| `docs/plays/plan.md` | Plan play runbook |
| `docs/plays/design.md` | Design play runbook |
| `docs/plays/build.md` | Build play runbook (plan mode → implement) |
| `docs/plays/test.md` | Test play runbook (v1 self-check) |
| `docs/plays/deploy.md` | Deploy/review/gates; rollback documented only |
| `docs/plays/maintain.md` | Finding → intent; bands schema usage |
| `docs/feedback-loop.md` | Incidents / Important findings → regression coverage / next intent |
| `docs/conventions.md` | intent-id naming, status vocabulary, linkage fields, placeholders |
| `.claude/settings.json` | Register PreToolUse hooks (project-scoped, committed) |
| `.claude/active-intent` | Points at this intent-id after seed |
| `.claude/skills/intent-capture/SKILL.md` | Advisory: draft valid intent.md |
| `.claude/skills/design-spec/SKILL.md` | Advisory: compress intent → valid spec.md |
| `.claude/skills/security-policy/SKILL.md` | Policy skill: no secrets in artifacts |
| `.claude/hooks/plan-before-edit.sh` | Block Write/Edit/MultiEdit without accepted plan |
| `.claude/hooks/production-gate.sh` | Block prod promote without release-manager attestation |
| `.claude/hooks/lib/common.sh` | Shared JSON deny/allow helpers (exit 0 + hookSpecificOutput) |
| `.claude/hooks/lib/promote-patterns.txt` | Promote-command regex patterns for production-gate |
| `releases/release-managers.txt` | Allowed `release_manager` identities for prod attestations |
| `scripts/promote.sh` | Stub promote entrypoint (attestation only; no cloud deploy) |
| `scripts/finding-to-intent.sh` | Thin Maintain helper: finding → draft intent |
| `findings/_template.md` | Manual finding shape |
| `findings/examples/dogfood-sample.md` | Sample finding for manual path exercise |
| `releases/attestations/.gitkeep` | Attestation drop zone (writes require accepted plan; not allowlisted) |
| `.github/workflows/ci.yml` | Minimal: template presence + hook fixtures |
| `tests/validate-templates.sh` | Required headings/frontmatter keys |
| `tests/validate-hooks.sh` | Dry-run hooks with fixture stdin JSON |
| `tests/fixtures/hooks/` | Fixtures: allowlist, accepted plan, missing plan, prod with/without attestation |
| `.markdownlint.json` | Lenient rules for templates |
| `.gitignore` | settings.local.json, secrets, OS junk |

### Change

None (greenfield). After repo exists: replace bhzdcz/inkrail placeholders and CODEOWNERS handle in a follow-up commit.

### Delete

None.

### Explicit will not change

- No Jira or Figma replacement product/UI.
- No eval suite / sandboxed Claude CI judgment (v2).
- No live bands watcher, scans, or on-call routing.
- No production MCP deploy / cloud deploy automation (gate stubs local scripts/promote.sh only).
- No multi-harness / plugin runtime.
- No Grok-Bot-native product code or stage-persona framework in this repo.
- No auto-merge or parallel default merge policy.
- Do not invent a real GitHub bhzdcz/inkrail — placeholders until Behzad names them.
- Do not implement a second product after dogfood in this PR.

## 3. Test plan

v1 tests validate templates/hooks/CI, not app unit tests.

| # | Check | How |
| --- | --- | --- |
| T1 | Template section presence | tests/validate-templates.sh fails if templates miss required H2s / frontmatter keys |
| T2 | Plan-before-edit deny | Write to CLAUDE.md without accepted plan → hook deny |
| T3 | Plan-before-edit allow (accepted plan) | Matching active intent + status accepted → allow |
| T4 | Plan-before-edit allowlist | Write under docs/** or template paths without accepted plan → allow |
| T5 | Production-gate deny | Promote without attestation → deny |
| T6 | Production-gate allow | Attestation with release_manager on release-managers.txt → allow (no cloud side effects) |
| T7 | CI green on scaffold | Workflow runs template + hook validation |
| T8 | Dogfood chain readable | Seeded intent/spec/plan paths exist; statuses consistent |
| T9 | Maintain manual once | scripts/finding-to-intent.sh on sample finding → new draft intent |

Run T2–T6 via tests/validate-hooks.sh in CI. For later hook bugfixes: failing fixture first.

## 4. Hooks / skills / CLAUDE.md touchpoints

### CLAUDE.md (must fit about one page)

- Repo purpose: platform contracts + dogfood SoT.
- Paths: intent/, specs/, plans/, docs/plays/, .claude/skills|hooks, REVIEW.md, bands.yaml.
- Gate rules: no product/framework edits without accepted plan.md for .claude/active-intent; findings never approve PRs; agents stop at prod gate.
- Commands: tests/validate-*.sh, scripts/promote.sh, scripts/finding-to-intent.sh.
- Link docs/feedback-loop.md and play runbooks.
- Encode: chat is not SoT; acceptance = git/PR state only.

### Skills (advisory)

1. intent-capture — Plan play; draft valid intent.md from idea/ticket/finding.
2. design-spec — Design play; required sections; flag concerns; no plan.md/code.
3. security-policy — no secrets in markdown; Important security findings block merge narrative.

### Hooks (must-hold)

**A. plan-before-edit (PreToolUse, matcher Edit|Write|MultiEdit)**

1. Parse tool input path(s). For MultiEdit: use tool_input.file_path if set, else each tool_input.edits[].file_path / path. Check every path.
2. If no resolvable path (pathless/unresolvable tool input) → **deny** (fail-closed).
3. If all paths match allowlist → allow.
4. Else read .claude/active-intent; require plans/<id>/plan.md frontmatter status: accepted (covers attestation writes too).
5. Else deny with reason pointing at engineer gate.

**Allowlist (flagged concern #5):**

- intent/_template.md
- specs/_template.md
- docs/**
- findings/**
- .markdownlint.json
- .gitignore
- README.md

**Not allowlisted:** CLAUDE.md, REVIEW.md, bands.yaml, .claude/**, scripts/**, .github/**, tests/**, CODEOWNERS, `releases/attestations/**` (writing attestations requires an accepted plan — not allowlisted), seeded artifact content after bootstrap.

**Bootstrap exception:** The first PR that creates the hook is authorized by this accepted plan and may write all listed files. After merge, allowlist + accepted-plan rules apply. Document in docs/plays/build.md.

**B. production-gate (PreToolUse, matcher Bash)**

- If command matches promote patterns (from `.claude/hooks/lib/promote-patterns.txt`: scripts/promote.sh, gh release create, npm publish, terraform apply, or SDLC_PROMOTE=1) → require releases/attestations/<id>.yaml with release_manager identity listed in releases/release-managers.txt (Behzad, @bhzdcz); empty or unknown identities invalid.
- Missing/invalid → deny (prod_gate_blocked).
- Integrations may no-op; block-without-attestation is required.
- Document in REVIEW.md / Deploy play: v1 guards a stub promote, not cloud prod (spec concern #3).

Hook I/O: exit 0; deny via hookSpecificOutput.permissionDecision=deny.

### CI

.github/workflows/ci.yml on PR/push: tests/validate-templates.sh → tests/validate-hooks.sh → optional markdownlint on docs/** and templates.

## 5. Risks and rollback

| Risk | Mitigation / rollback |
| --- | --- |
| bhzdcz/inkrail unknown | Placeholders; delay real CODEOWNERS/branch protection |
| Hook false positives on docs/templates | Explicit allowlist; expand only via plan update |
| Hook deny format / exit-code footguns | Shared lib/common.sh + fixtures T2–T6 |
| Prod gate stub ≠ real prod | Document in Deploy play + REVIEW; v2 for real deploy tools |
| Sole acceptor / release manager | Accept for dogfood; flag in README before shared prod |
| Forged attestation (any non-empty release_manager) | Mitigated by `releases/release-managers.txt` identity allowlist; unknown managers (e.g. Eve) fail prod gate |
| Bootstrap chicken-and-egg | Single plan-authorized PR; then hooks enforce |
| Conductor drift (chat as SoT) | CLAUDE.md + Deploy play: acceptance = merge/PR only |
| Plan departure during implement | Update this plan.md in the same PR before merge |

Rollback: revert the bootstrap PR; no prod traffic in v1. Delete attestation files to re-block promote.

## 6. Open assumptions

1. Behzad is sole engineer acceptor, code owner, and release manager for v1.
2. GitHub repo private unless Behzad says otherwise; visibility still TBD.
3. Committed .claude/settings.json project hooks work in dogfood environments (Claude Code CLI installed).
4. Spec SHA refreshed to git blob SHA of specs/.../spec.md (`c9f3ed2c8e92b406244c526c002c36b315cee346` via `git hash-object`).
5. Intent seed reconstructed from Planito rev 3 / accepted SoT without changing meaning if verbatim file missing at implement time.
6. CI on GitHub-hosted ubuntu-latest.
7. scripts/promote.sh is the only prod action in v1; extra Bash patterns are defense-in-depth.
8. One bootstrap PR preferred unless review load demands a split.

## 7. Implementation checklist (post plan_accepted only)

- [ ] Behzad names bhzdcz/inkrail (or says scaffold local-only with placeholders)
- [ ] Create empty repo / root
- [ ] Add files per section 2 in bootstrap PR
- [ ] Make hook scripts executable; register in .claude/settings.json
- [ ] Green tests/validate-*.sh locally and in CI
- [ ] Seed intent + spec + this plan; set .claude/active-intent
- [ ] Manual Maintain path once
- [ ] Stop at reviewable PR for Testito / Reviwito / Leadito — no merge without Behzad code-owner approval

## 8. Engineer gate

**Status:** accepted by Behzad on 2026-09-04 (`plan_accepted`). Implementation may begin.

On accept: set frontmatter status: accepted, commit under plans/2026-09-04-ai-native-sdlc-platform/plan.md in the platform repo (once it exists), then implementation may begin.

On reject: revise this plan; no product repo edits for this intent-id.
