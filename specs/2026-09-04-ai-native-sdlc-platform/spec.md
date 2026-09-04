---
title: AI-native SDLC platform
author: Designito
status: accepted
date: 2026-09-04
intent: intent/2026-09-04-ai-native-sdlc-platform.md
intent_revision: 3
acceptor: Behzad
spec_signed_off: true
event: spec_signed_off
---

# Spec: AI-native SDLC platform

Author: Designito (Stage 2). Status: accepted. Signed off by Behzad (PO) on 2026-09-04. Event: spec_signed_off — plan mode may start.
Date: 2026-09-04. Source intent: revision 3 (accepted 2026-09-04).
Product owner acceptor: Behzad (sole for now).

## 1. Summary

Build a **runnable Git-backed platform** that executes Anthropic’s AI-native SDLC: six plays, a committed markdown artifact chain, human judgment gates, Claude Code as the worker, and a Maintain loop that can write the next `intent.md`.

The product is **the loop and its contracts**, not a roster of stage-named chat personas. People (and later optional operators such as Grok Bot agents) may *conduct* a play; they are not the system of record and are out of product scope for v1.

**MVP worker:** Claude Code SDK / Claude Code CLI (`claude`, including `claude -p` where CI is in scope later). Artifacts stay markdown and harness-agnostic. No multi-harness runtime in v1.

## 2. Goals and non-goals

### Goals (v1)

1. Dedicated GitHub repo as system of record for markdown + code, with `intent/` as the intent home.
2. End-to-end **artifact chain + gate events** dogfooded on this repo first.
3. Templates + skills so Plan and Design produce valid `intent.md` / `spec.md`.
4. `plan.md` contract and Claude Code **plan mode** before any product/framework code edit.
5. Repo `CLAUDE.md`, ≥1 policy skill, ≥1 enforceable hook, feedback-loop instructions.
6. `REVIEW.md` (three passes) + human code-owner rule; findings never auto-approve.
7. Production-gate hook **specified and present** (blocks past prod without named release manager).
8. Maintain path: a finding → new `intent.md`; `bands.yaml` **schema** (watcher may be thin).
9. Linkage fields for Jira / Figma / GitHub (key only when a ticket exists).

### Non-goals (v1)

- Multi-harness SDK / plugin layer.
- Full eval suite; CI judgment sandbox; automated deploy/status/rollback tooling.
- Live production watcher, scans, or on-call routing (schema + thin stub only for bands).
- Replacing Jira or Figma.
- A Grok-Bot-native SDLC or generic chat-agent framework.
- Auto/parallel default merges; `bands.yaml` live enforcement; production MCP deploy.

### Deferred (v2 — named, not designed here in depth)

Eval suite; CI Claude sandboxed judgment; deploy/status/rollback tools; live watcher + scans + on-call; richer tiered autonomy beyond the production gate.

## 3. Actors and runtime split

| Role | Responsibility | Must not |
| --- | --- | --- |
| **Product owner** | Accept/reject `intent.md`; sign off `spec.md` | Write the spec for the agent; bypass gates |
| **Engineer** | Accept/reject `plan.md`; own implementation quality | Skip plan mode for scoped work |
| **Code owner** | Human PR approval on risk / Important findings | Treat AI findings as approval |
| **Release manager** | Prod gate; rollback authority (Behzad for now) | Let agents past prod gate |
| **Claude Code (worker)** | Read artifacts; plan mode; edit repo; run hooks/tests; draft reviews | Cross prod gate; invent missing human accept |
| **Conductor (optional)** | Talk, draft/review artifacts, stop at human gate | Be the SoT; implement product code |

Conductors are an **operator surface**, not a v1 deliverable. Platform contracts must work with Claude Code CLI alone.

## 4. System of record and linkage

- **SoT:** Git (GitHub). Every play ends by committing a readable artifact (or PR + findings). Chat is never the record.
- **Intent home:** `intent/` in the dedicated platform repo (dogfood). Later products may use the same layout in their own repos.
- **Linkage (v1 fields, optional until real):**
  - `jira_key` — only when a ticket exists; keep empty-allowed field on templates.
  - `figma_url` — required when the change is UI-facing; otherwise omit/N/A.
  - `github` — PR URL, commit SHA of accepting merge, and back-link from PR body to `intent/` + `spec` paths.

**Open default:** repo owner/name/visibility TBD — templates use placeholders `OWNER/REPO`.

## 5. Artifact chain and gate events

```
intent.md (PO accept)
    → spec.md (PO sign-off)          # starts plan mode
    → plan.md (engineer accept)      # unlocks edits
    → diff + tests
    → REVIEW.md passes + PR findings # human code owner
    → deploy hooks as gates          # up to prod; release manager for prod
    → Maintain finding
    → new intent.md                  # loop
```

### Gate event table

| Event | Trigger | Actor | Next |
| --- | --- | --- | --- |
| `intent_accepted` | PO merges/accepts `intent.md` | PO | Design play → draft `spec.md` |
| `intent_rejected` | PO closes/rejects | PO | Stop; record reason in git/PR |
| `spec_signed_off` | PO accepts `spec.md` | PO | Build play starts in **plan mode** |
| `plan_accepted` | Engineer accepts `plan.md` | Engineer | Implementation edits allowed |
| `plan_rejected` | Engineer sends back | Engineer | Revise plan; no code edits for that scope |
| `ci_passed` / `ci_failed` | CI on PR | CI | Deploy review / fix |
| `review_findings_posted` | Reviewer agent/tool | Worker | Human triage; **never auto-approve** |
| `code_owner_approved` | Human approval | Code owner | Merge eligible (policy permitting) |
| `prod_gate_blocked` | Production-gate hook | Hook | Requires named release manager |
| `prod_released` | Release manager action | Release manager | Maintain watches |
| `band_breached` / `finding_opened` | Maintain | Maintain play | New `intent.md` (or runbook PR) |

Status vocabulary (use consistently in frontmatter):

`draft` | `in_review` | `accepted` | `rejected` | `superseded` | `implemented` | `closed`

## 6. Repository layout (v1)

```
/
  CLAUDE.md                 # one-page operating context for Claude Code
  REVIEW.md                 # three-pass review policy
  bands.yaml                # schema + example bands (watcher thin)
  intent/
    _template.md
    YYYY-MM-DD-<slug>.md    # or nested by id; pick one convention in Build
  specs/
    _template.md
    <intent-id>/spec.md
  plans/
    <intent-id>/plan.md
  .claude/
    skills/                 # advisory skills (brand, security, ux, intent-capture, …)
    hooks/                  # must-hold enforcement
  docs/
    plays/                  # play runbooks (Plan…Maintain)
    feedback-loop.md        # how findings become intent / evals
  .github/
    workflows/              # minimal CI in v1 (lint/templates); judgment in v2
```

**Convention:** one active chain per `intent-id`. Superseded intents set `status: superseded` and point to the replacement.

## 7. Play specifications

### 7.1 Plan — capture `intent.md`

**Input:** idea, ticket, or Maintain finding.  
**Output:** `intent/<id>.md` committed.  
**Human gate:** PO accept/reject → `intent_accepted` / `intent_rejected`.

**Required sections (template):**

1. Frontmatter: `title`, `author`, `status`, `date`, `revision`, `acceptor`, `jira_key?`, `figma_url?`, `source` (human | maintain | ticket)
2. Problem
3. Proposed outcome
4. Constraints
5. Open questions (with defaults)
6. Success criteria (leading / lagging)

**Skills:** intent-capture / synthesis skill for repeat shapes. Advisory only.  
**Must-hold:** template section check may be a hook or CI later; v1 at least documents the check.

### 7.2 Design — `intent` + org skills → `spec.md`

**Input:** accepted `intent.md` + versioned skills (brand, security, compliance, UX as applicable).  
**Output:** `specs/<intent-id>/spec.md`.  
**Human gate:** PO sign-off → `spec_signed_off` → **plan mode**.

**Required sections:**

1. Frontmatter (links to intent path/SHA, status, acceptor)
2. Summary
3. Goals / non-goals
4. Actors & runtime
5. Artifact contracts & gates (or reference platform docs once stable)
6. Functional design (plays, hooks, skills, layouts)
7. Non-functional: security, compliance, auditability
8. UX notes (operator UX for templates/CLIs; UI mock link if product UI)
9. Flagged concerns (analyst escalations — never bury)
10. Open questions & defaults
11. Acceptance criteria for this change
12. Out of scope

**Rules:** Compress requirements + design in one session. Flag policy conflicts; resolve or route before Build. For UI work: mock first (Figma URL on intent/spec), then hand to Build. **Do not** write production code or `plan.md` in Design.

### 7.3 Build — plan mode then implement

**Input:** signed-off `spec.md`.  
**Outputs:** `plans/<intent-id>/plan.md`, then diff + tests; updates to `CLAUDE.md` / skills / hooks as needed.

**Plan mode (mandatory before edits for the scoped change):**

- Worker reads spec + repo; proposes file-level plan and tests.
- Engineer accepts → `plan_accepted` unlocks Write/Edit for that scope.
- If implementation **departs** from plan, update `plan.md` in the same PR (or follow-up commit) before merge.

**`plan.md` required sections:**

1. Frontmatter: intent-id, spec path/SHA, status, engineer
2. Approach summary
3. Files to add/change/delete (and explicit **won’t change** boundary)
4. Test plan (incl. failing test first for bugfixes)
5. Hooks / skills / CLAUDE.md touchpoints
6. Risks & rollback notes
7. Open assumptions

**Hooks (v1 minimum):** ≥1 policy hook, e.g. block Write/Edit when no accepted `plan.md` exists for the active intent (or equivalent PreToolUse gate). Exact implementation is Build’s job; this spec requires the gate behavior.

### 7.4 Test — evidence inside the loop

**v1:**

- Session self-check before human review.
- Bugfixes: failing test first; do not weaken checks to pass.
- Instructions in `docs/feedback-loop.md`: incidents / Important review findings → permanent regression coverage when feasible.

**v2:** continuous eval suite on config/`CLAUDE.md`/skill change; 20–50 real tasks.

### 7.5 Deploy — review, gates, release

**`REVIEW.md` (repo root) — three passes:**

1. **Bugs / logic** — correctness, edge cases, regressions.
2. **Security / vulnerabilities** — authz, secrets, supply chain, unsafe tool use.
3. **Compliance vs artifacts** — diff vs `spec.md` + `plan.md` + stated design principles.

Also define: **Important** vs **Nit**, and what to skip.

**Rules:**

- Findings **never** approve a PR.
- Human code owner required for merge (Behzad sole for now).
- Hooks as gates (plan present, review policy path exists, etc.).
- Agents act **up to** the production gate, not past it.
- Named release manager for prod (Behzad).
- Production-gate hook: block prod promote/deploy without release-manager attestation (mechanism TBD in Build; behavior required).
- Rehearsed rollback: document the rollback path in play docs; automation is v2.

**CI:** v1 may run lightweight checks (markdown lint, template presence). Sandboxed `claude -p` judgment and deploy tools are **v2**.

### 7.6 Maintain — close the loop

**v1:**

- `bands.yaml` **schema** + example entries (metric, threshold, window, severity, owner, intent_template).
- Path from a finding (manual or thin stub) → draft `intent.md` via template; nothing bypasses Deploy for code changes.
- Prefer PR for fixes; pre-approved runbooks only where explicitly listed.

**v2:** live watcher, scans, on-call, automated band breach → intent.

## 8. Skills vs hooks vs CI

| Mechanism | Strength | v1 expectation |
| --- | --- | --- |
| **Skills** | Advisory guidance during generation | ≥1 policy skill (e.g. security or intent template) + Design/Plan skills as needed |
| **Hooks** | Must-hold, blocks tool use / local gate | ≥1 hook (plan-before-edit or equivalent) + production-gate hook specified |
| **CI** | Must-hold on shared main/PR | Minimal in v1; expand in v2 |

Anything that “must always hold” is a hook or CI check, not only a skill line.

## 9. Claude Code integration (MVP)

- Primary interface: Claude Code CLI / SDK in the repo working tree.
- `CLAUDE.md` at repo root (~one page): setup, artifact paths, gate rules, “read intent→spec→plan before editing,” link to play docs.
- Plan mode before implementation edits for each intent-scoped change.
- Hooks under `.claude/hooks/` (or project-supported hook paths) enforce must-holds.
- Skills under `.claude/skills/` versioned in git.
- No vendor-neutral plugin API in v1; if a second harness appears later, it must consume the **same markdown contracts**.

## 10. Security, compliance, audit

- Audit trail = git history of artifacts + PR approvals + hook/CI logs.
- No secrets in markdown artifacts; use env / secret store.
- Review pass 2 covers security; Important security findings block merge until human resolution.
- Production changes require release manager; agents cannot self-approve prod.
- Compliance claims in a spec must map to a checkable artifact or hook/CI item — else flag as concern.

## 11. Operator / UX notes

- Primary UX is **files + CLI + PR**, not a custom app UI in v1.
- Templates must be fillable by a non-engineer PO (clear headings, examples in comments).
- If a future console UI is desired, mock in Figma first and link from intent/spec; out of v1 build scope unless dogfood requires a tiny doc site (optional, not required).

## 12. Dogfood plan (v1 acceptance of *this platform*)

Ship in the dedicated repo, used on itself:

1. `intent/_template.md` + ≥1 skill for intent capture  
2. `specs/_template.md` + Design constraints skill(s)  
3. `plan.md` contract + plan-before-edit hook  
4. Root `CLAUDE.md` + `docs/plays/*` + `docs/feedback-loop.md`  
5. `REVIEW.md` (three passes) + code-owner rule documented  
6. Production-gate hook specified and installed (may no-op integrations, but must block without attestation flag/file)  
7. Maintain: finding → new intent path exercised once manually; `bands.yaml` schema + examples  

Success: a person who missed chat can continue from git alone through a full chain for one dogfood change.

## 13. Flagged concerns (analyst escalations)

1. **Repo identity TBD** — templates and CI cannot be fully wired until `OWNER/REPO` exists. Mitigation: placeholders; first Build task after repo creation is rename + protect default branch.
2. **Sole acceptor / release manager (Behzad)** — bus factor and no separation of PO vs release duties. Acceptable for v1 dogfood; flag before any shared production use.
3. **Production-gate without real deploy tooling (v1)** — hook may guard a local or documented “promote” action rather than cloud deploy. Risk: false sense of prod safety. Call this out in `REVIEW.md` / play docs until v2 deploy tools exist.
4. **Conductor ambiguity** — Grok bots may draft artifacts, but platform must not depend on them. Risk of drifting back to chat-as-SoT. Mitigation: acceptance = git merge/PR state only.
5. **Plan-before-edit hook false positives** — docs-only or template edits may need an allowlist. Unresolved; Build must define allowlist explicitly in `plan.md` for the hook change.
6. **No first product after dogfood** — success metrics that need product traffic stay incomplete until a later intent. Track platform dogfood metrics only in v1.
7. **Playbook fidelity** — article fetch was partially unavailable during Design; this spec aligns to published playbook summaries + accepted intent rev 3. If Anthropic updates naming (e.g. Claude Tag), open a Maintain intent rather than silently renaming.

## 14. Open questions (defaults stand)

| # | Question | Default |
| --- | --- | --- |
| 1 | GitHub owner/name/private | TBD placeholders |
| 2 | Extra acceptors / release manager | Behzad sole |
| 3 | First product after dogfood | None required for v1 |
| 4 | Jira key | Only when ticket exists; field remains on templates |

## 15. Acceptance criteria (PO sign-off of this spec)

- [ ] Spec matches intent rev 3: platform = plays + artifact chain + loop; not stage chat personas  
- [ ] Artifact file names, required sections, status values, and gate events are specified  
- [ ] Claude Code SDK/CLI is the MVP worker; no multi-harness runtime in v1  
- [ ] v1 dogfood checklist is testable; v2 items clearly deferred  
- [ ] Flagged concerns are visible (not buried)  
- [ ] No production code and no `plan.md` produced in Design  

**Sign-off:** PO sets this file’s frontmatter/status to `accepted` (or merges the accepting PR). That event is `spec_signed_off` and starts plan mode for Build (Develito / Claude Code).

## 16. Out of scope (explicit)

Replace Jira/Figma; Grok-Bot-native SDLC product; generic multi-agent chat framework; implementing application code in Design; writing `plan.md` in Design; auto-merge / parallel default; live Maintain watcher beyond schema + thin stub.
