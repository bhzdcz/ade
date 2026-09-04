---
title: AI-native SDLC platform
author: Planito
status: accepted
date: 2026-09-04
revision: 3
acceptor: Behzad
source: human
jira_key: ""
---

# Intent: AI-native SDLC platform

Accepted by Behzad (product owner) on 2026-09-04 (supersedes prior acceptance of rev 2).

## Problem

Teams can get Claude to write code in a session. They do not have a platform that runs Anthropic's AI-native SDLC: the six plays, the committed artifact chain, and the loop that writes the next intent from production.

A roster of chat bots named after the stages is not that platform. It does not capture `intent.md` in git, apply skills while a spec is written, start in plan mode, eval `CLAUDE.md` changes, review PRs against `REVIEW.md`, or turn a control-band breach into the next `intent.md`.

Code is no longer the bottleneck. Plan, review/test, and deploy still run at human speed. Controls still assume a person did every step. Chat is not a handoff.

## Proposed outcome

A runnable platform that does what the playbook describes, implemented with the Claude Code SDK (Claude Code CLI and `claude -p` in CI) so the plays actually execute. The product is the loop, not a set of personas.

**Artifact chain** (each stage commits; the next stage reads):

intent.md → spec.md → plan.md → diff + tests → REVIEW.md / PR findings → deploy (hooks as gates) → Maintain writes a new intent.md

**Six plays**

1. **Plan.** Originator (person, ticket, or Maintain finding) describes the problem in their own words. Brainstorm until concrete. Commit intent.md: problem, proposed outcome, affected users and systems, constraints, open questions. Product owner reviews and corrects before commit. Accept/reject is the gate into Design. Repeat processes become skills.

2. **Design.** Accepted intent.md plus org skills (brand, security, compliance, UX) become spec.md in one session. Flag concerns; route them before Build. UI: mock first, then hand to Build. Product owner signs off. Accepting spec.md starts plan mode.

3. **Build.** Nothing is implemented without an accepted plan.md from plan mode (files, order, tests, risks, options rejected). Then implement. CLAUDE.md is what a new joiner needs (commands, conventions, repeated mistakes; under a page). Skills encode institutional knowledge. Hooks are deterministic (protected paths, format/lint, no secrets). If the diff departs from the plan, update plan.md in the same commit. Auto mode and parallel worktrees come as those guardrails mature.

4. **Test.** The session checks itself before a human sees it: one-command test/build/lint; screenshot or browser for UI. For bugs: failing test first, then fix the code without editing that test. Do not weaken the check to go green. Continuous evals (20–50 real tasks) run when CLAUDE.md, skills, or hooks change; every production incident becomes a permanent eval.

5. **Deploy.** PRs reviewed against REVIEW.md in three passes: bugs/logic, security, compliance with spec.md / plan.md. Findings inform; they never approve. Branch protection still needs a human code owner. Hooks as approval gates (change sign-off, release authorization, protected paths). CI/CD: Claude non-interactively for judgment steps, sandboxed, no standing prod credentials. Deploy / status / rollback as tools. Autonomy tiered by environment. Agents may act up to the production gate and nothing past it. Named release manager for production. Rollback is the most rehearsed path.

6. **Maintain.** A trigger invokes Claude with no person in the path. Detection stays deterministic (bands.yaml). Diagnose; act only through a PR or a pre-approved runbook; write intent.md so Plan starts again. Recurring scans: small validated findings through the review gate; anything larger becomes intent.md. On-call: first responder, confirm baseline, write lessons. People triage and review; they no longer have to start the work.

**Source of truth.** Git is SoT for the markdown chain and the code. Jira, Figma, and GitHub stay where they already hold a record — linkage (Jira key, Figma URL, commit SHA) for v1. Do not dual-write.

**Intent home.** Dedicated GitHub repo for this platform; intent/ inside it. A product that later adopts the platform puts intent/ next to its code. Not a monorepo of all apps.

**Harness.** Claude Code SDK first. Multi-harness only if it still delivers this same platform (same artifacts, gates, loop). A chatbot roster that mimics stage names is not that.

**Operators vs product.** People (and later Grok Bot stage bots) may operate this platform. They are not the product.

**Phasing** (same product, not a smaller one):

- v1 (dogfood on this repo): templates + skills for intent.md and spec.md; plan-mode contract for plan.md; CLAUDE.md; at least one policy skill and one deterministic hook; feedback-loop instructions; REVIEW.md + human code-owner gate; production-gate hook specified; Maintain intent.md from a finding; bands.yaml schema in git (watcher can be thin).
- v2: eval suite gating config changes; non-interactive CI judgment, sandbox, deploy tools, rehearsed rollback; live control-band watcher, scheduled scans, on-call channel.

Out of scope: replacing Jira or Figma; a Grok-Bot-native SDLC; a generic chat-agent framework.

## Affected users and systems

- Behzad — product owner; default Plan/Design gate; works in Figma, Jira, GitHub
- Engineers running Claude Code against the repo
- Platform/engineering — intent home, hooks, CI, managed settings
- Tech lead — REVIEW.md, higher-risk plan accept
- Service owner / on-call — triage Maintain findings
- Future contributors who missed the originating chat
- Claude Code SDK/CLI, GitHub (repo, PRs, Actions)
- Jira and Figma as linked records
- Optional later: Grok Bot stage bots as operators

## Constraints

- Match the article's system. Do not substitute a stage-named chatbot layer.
- Humans stay at judgment gates. Agents act up to the production gate, not past it.
- Each play commits a readable artifact. Chat is not the record.
- Markdown-first for early artifacts in git.
- Skills are advisory; anything that must always hold is a hook or CI check.
- Fit around Jira / Figma / GitHub via linkage. Do not pretend they vanish.
- Claude Code SDK first.
- This intent does not authorize implementing code or writing spec.md.

## Open questions

Defaults are above. Product owner still needs to call:

1. GitHub owner/name for the platform repo, and whether it is private.
2. Who besides Behzad can accept Plan/Design; who is the named release manager when production exists.
3. First product repo to adopt after dogfood (none required for v1).
4. Jira key required on every intent, or only when a ticket already exists (default: only when it exists; keep the field on the template).

## Success criteria

Leading (from git / PR / CI):

- Hours from first conversation or Maintain finding to a committed intent.md
- Time from intent.md commit to spec.md commit for the same change
- Share of changes that merge from the first implementation pass; plan.md exists before the diff
- First-pass CI success for agent-written changes; time to first review measured in minutes
- Once Maintain is live: time from band breach to intent.md in the triage queue

Lagging:

- Survival rate of intent.md into Design (accept vs close), with small corrections not rewrites
- Rework: intent.md edits after the first spec.md; spec.md edits after the first plan.md
- Human review concentrates on intent and risk; fewer defects escaping to production
- Share of Maintain findings that become merged fixes; repeat incidents fall as evals accumulate

A person who missed the chat can continue from git alone.
