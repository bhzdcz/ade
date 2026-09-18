---
title: "ADE v1 public OSS kit + product site"
author: Designito
status: accepted
date: 2026-09-18
intent: intent/2026-09-18-ade-public-oss.md
intent_sha: ""
acceptor: Behzad
---

# Spec: ADE v1 public OSS kit + product site

Author: Designito (Stage 2). Status: **accepted**. Signed off by Behzad (PO) on 2026-09-18 (WidgetCo worked example locked). Event: `spec_signed_off` — Develito plan mode.
Date: 2026-09-18.
Intent-id: `2026-09-18-ade-public-oss`
Source intent: accepted by Behzad (PO) on 2026-09-18 with Planito defaults.
Product repo: `https://github.com/bhzdcz/ade` (today **PRIVATE** → target **PUBLIC**)
Site repo: `https://github.com/bhzdcz/ade-site` (public) · Canonical URL: `https://ade.ir`
**Separate from airoweb and AI-DD.** Leadito does not Build. No Maintito — Leadito owns Deploy + Maintain gate.
Spec accepted — Develito plan then Build. Worked example: WidgetCo status digest.

## 1. Summary

Ship ADE as a **full public open-source product** strangers can find, clone, and run — not a private dogfood kit and not a paid-setup story.

This workstream has three coupled deliverables:

1. **Publicize** `bhzdcz/ade` (Apache-2.0) after a privacy/ops scrub.
2. **Finish the kit** so a stranger can follow `docs/how-to-run.md`, use templates + hooks, and walk one **fictional** worked example end-to-end in-repo.
3. **Rewrite `ade.ir`** as a product site: **What / Install / Docs / GitHub** — zero Buy, Sponsors, checkout, or private-repo CTAs.

Commercial `ade-site` PR #3 is already **closed** (2026-09-18). Do not reopen that path.

## 2. Goals and non-goals

### Goals

1. `bhzdcz/ade` is **public** on GitHub with an `LICENSE` (Apache-2.0) and a stranger-facing README.
2. Kit is installable: clear clone (HTTPS + SSH), prerequisites, happy path, validation commands.
3. Templates + docs cover intent → spec → plan → REVIEW → hooks/gates; starter `CLAUDE.md`; at least the existing skills/hooks remain documented and runnable.
4. One **fictional tiny** worked example lives in-repo (see §6) — not Braiins, not airoweb, not real customer IP.
5. `ade.ir` matches the public product (links work; “repo may stay private” / dogfood-only framing gone).
6. Roster wording updated: **no Maintito**; Leadito = Deploy + Maintain; Grok Bot conductors optional, not required.
7. Humans stay at gates; Leadito does not Build.

### Non-goals

- Paid packs, installs, SaaS, Ledger, checkout, € setup offers, GitHub Sponsors CTAs on v1 site
- AI-DD merge / airoweb changes
- Live Maintain watcher, eval suite, multi-harness, cloud deploy automation
- Rewriting historical Inkrail artifact paths / accepted historical specs
- Building an agent IDE or in-browser console
- Leadito authoring Build

## 3. Locked decisions (from accepted intent)

| Topic | Lock |
| --- | --- |
| Source home | Make **`bhzdcz/ade` public** (not an alternate kit repo) |
| License | **Apache-2.0** |
| Worked example | **Fictional tiny in-repo** (Design picks topic — §6) |
| Sponsors on ade.ir | **Omit** from v1 |
| CTAs | GitHub / Install (how-to-run) / Docs only — **no Buy / private / checkout** |
| Commercial PR #3 | Already closed — leave closed |

## 4. Stage ownership (binding)

| Stage | Owner | Action |
| --- | --- | --- |
| Plan | Planito | Accepted intent (done) |
| Design | Designito | This `spec.md` |
| Build | **Develito** | `plan.md` then PRs on `ade` + `ade-site` |
| Test | Testito | §11 checklist |
| Review | Reviwito | Findings only |
| Deploy / Maintain gate | Leadito | Conduct loop; does **not** Build |
| PO / GitHub Settings | Behzad | Merge; flip Visibility → Public; enable branch protection once public |

Chain: Planito → Designito → Develito → Testito → Reviwito → Leadito → Behzad.

## 5. Product repo (`bhzdcz/ade`) — public kit

### 5.1 Pre-public scrub (must before Visibility flip)

Audit and remove or rewrite anything unsafe for strangers:

| Class | Action |
| --- | --- |
| Secrets, tokens, private emails beyond public contact policy | Remove / redact |
| Machine-local paths (`/Users/…`, Braiins trees) | Remove from promoted docs |
| “Private repo” / invite-only / request-access language | Delete |
| Dogfood-only framing as the product pitch | Replace with product pitch |
| Maintito references | Replace with Leadito (Deploy + Maintain) |
| Personal ops runbooks not meant for OSS | Move out or delete |

Build re-greps `main` before flip. Prefer a **scrub PR merged while still private**, then Behzad flips Visibility.

### 5.2 License

- Add root `LICENSE` — **Apache License 2.0** full text.
- README + site footer: “Licensed under Apache-2.0”.
- `licenseInfo` on GitHub should resolve after file lands (may need Behzad to confirm SPDX in Settings if not auto-detected).

### 5.3 README (stranger-facing)

Rewrite intro so the repo **is** the product:

- What ADE is (one paragraph): AI-native SDLC kit — markdown artifacts on rails, humans at the gates.
- What it is **not**: not an agent IDE; not a hosted SaaS; chat is not SoT.
- Badges optional (CI); keep restrained.
- Quickstart → link `docs/how-to-run.md`.
- Artifact chain diagram (keep).
- v1 scope honest list (kit + hooks + docs + worked example; no watcher/SaaS).
- License + link to `ade.ir`.
- Remove “(private; renamed from …)” as primary identity once public (one-line historical note OK in Identity).

### 5.4 `docs/how-to-run.md`

Make it work for a stranger with no Grok Bot:

1. Prerequisites: git, Claude Code CLI (link), GitHub account.
2. Clone via **HTTPS** first (`https://github.com/bhzdcz/ade.git`), SSH as alternate.
3. Happy path steps Plan→…→Maintain without requiring roster names; optional appendix: “If you use Grok Bot conductors…”
4. Validation commands stay: `bash tests/validate-templates.sh`, `bash tests/validate-hooks.sh`.
5. Drop/update free-private branch-protection paragraph: once **public**, note that Behzad can enable GitHub branch protection / required reviews on free public repos (Settings — human step).
6. Remove Maintito; Leadito owns Deploy/Maintain gate language if conductors mentioned.

### 5.5 Templates and kit completeness

Ensure discoverable templates (create if missing; keep existing if good):

| Artifact | Path |
| --- | --- |
| Intent template | `intent/_template.md` (exists — verify stranger-usable) |
| Spec template | `specs/_template.md` |
| Plan template | `plans/_template.md` (**add** if absent) |
| Findings template | `findings/_template.md` |
| REVIEW policy | `REVIEW.md` |
| Plays | `docs/plays/*.md` |
| Skills | `.claude/skills/{intent-capture,design-spec,security-policy}/` |
| Hooks | `.claude/hooks/{plan-before-edit,production-gate}.sh` + lib |

Add a short `docs/kit-map.md` (or README section) listing these paths in one table so strangers do not spelunk.

### 5.6 `CLAUDE.md`

- Product framing: public OSS kit SoT (not “dogfood SoT” only).
- Roster optional; no Maintito.
- Keep gate rules / allowlist / commands.

## 6. Worked example (fictional, tiny)

### 6.1 Topic (locked by Design)

**Example id:** `2026-09-18-widgetco-status-digest`  
**Fiction:** “WidgetCo” (invented; no real company).  
**Problem:** Engineering lead wants a one-page weekly status digest template for a 5-person team — scope only the **playbook artifacts**, not a real app.

Ship a **complete miniature chain** under the normal paths:

| Kind | Path |
| --- | --- |
| Intent | `intent/2026-09-18-widgetco-status-digest.md` |
| Spec | `specs/2026-09-18-widgetco-status-digest/spec.md` |
| Plan | `plans/2026-09-18-widgetco-status-digest/plan.md` |
| Demo output | `examples/widgetco-status-digest/README.md` + one sample `digest.md` (the “diff” stand-in: a filled markdown digest showing the outcome) |

Rules:

- All names/emails fictional (`eng-lead@widgetco.example`).
- No Braiins, airoweb, ADE internal ops, or personal data.
- Short: each artifact ≤ ~1–2 screens; teaches the rail, not a novel.
- README in `examples/` points back to how-to-run (“reproduce this chain”).

### 6.2 Why this topic

Status digests are universal, non-sensitive, and map cleanly to intent→spec→plan→artifact without needing application code or secrets.

## 7. Product site (`ade.ir` / `bhzdcz/ade-site`)

### 7.1 Information architecture (single scroll)

Keep **dark-first pixel** system from accepted `2026-09-05-ade-site` (tokens unchanged: bg `#0B0D12`, accent `#5CFF9A`, etc.).

| # | Section | Content |
| --- | --- | --- |
| 1 | **Hero** | ADE pixel lockup + one-liner + CTAs: **View on GitHub** → `https://github.com/bhzdcz/ade`; **Install** → how-to-run on GitHub (blob/raw) |
| 2 | **What** | Three problem cards (keep essence) + one paragraph: public OSS kit you clone and run |
| 3 | **Artifact chain** | Keep rail 1–8; caption: humans at gates |
| 4 | **Install** | Numbered 1–2–3: clone → read how-to-run → run validate scripts; link Docs |
| 5 | **In v1 / Not in v1** | **Replace** “Public product source tree (may stay private)” and “Dogfood on real intents” with honest public-kit scope (templates, hooks, worked example, this site). Not in v1: SaaS, paid setup, Sponsors CTA, watcher, multi-harness, AI-DD |
| 6 | **Footer** | ade.ir · GitHub `ade` · GitHub `ade-site` · Apache-2.0 · no Sponsors · no Buy |

### 7.2 CTA / anti-pattern ban

**Allowed:** GitHub, Install/how-to-run, Docs (plays, conventions), mailto only if already public and non-sales.

**Banned on v1 site:** Buy, checkout, € prices, Sponsors button, “request access”, “private repo”, Bitcoin/payment config, inquiry builders for paid setup.

### 7.3 Motion / a11y

Keep existing restrained motion + `prefers-reduced-motion` from site spec. No new heavy frameworks required.

### 7.4 Mock

IA above is the design mock for this pass (pixel system already accepted). Optional HTML prototype in `ade-site` PR is fine; Figma not required if Build screenshots the landing.

## 8. Implementation shape for Develito (not a plan.md)

Suggested PR split (Build may adjust in `plan.md`):

1. **`ade` scrub + LICENSE + README/how-to-run/CLAUDE + kit-map + plan template + WidgetCo example** (still private).
2. Behzad: **Settings → Change visibility → Public** (human).
3. **`ade-site` landing rewrite** CTAs + In/Not v1 + footer license (after or in parallel once public URL is real).
4. Optional: enable branch protection on public `ade` (Behzad Settings) — document in how-to-run.

Artifacts SoT for this intent stay on **`bhzdcz/ade`**: `intent/`, `specs/2026-09-18-ade-public-oss/`, `plans/…`.

## 9. Flagged concerns (analyst escalations)

1. **Public forever** — scrub must be real; once public, history may still contain old private strings. Prefer scrub commit before flip; if sensitive history exists, escalate to Behzad (history rewrite is out of default scope).
2. **Grok Bot roster in docs** — keep optional only; strangers must succeed with Claude Code + git alone.
3. **Sponsors** — earlier “OSS + Sponsors” side-hustle lock is **superseded** for v1 site by this intent (Sponsors omit). Do not re-add without a new intent.
4. **ade-site PR #3** — closed; do not merge or revive paid paths.
5. **Visibility flip** is Behzad-only; Build must not claim “public” until Settings confirm.

## 10. Acceptance criteria

1. `bhzdcz/ade` visibility is **public**; `LICENSE` is Apache-2.0; README does not call the product private.
2. Stranger path: clone HTTPS → follow how-to-run → `validate-templates` + `validate-hooks` succeed on clean clone.
3. Templates for intent/spec/plan (+ findings) discoverable; kit-map or README table lists skills/hooks/plays.
4. WidgetCo fictional example chain present and linked from README or examples/.
5. `ade.ir` shows What / Install / Docs / GitHub; **no** Buy/Sponsors/checkout/private CTA; In/Not v1 matches public kit.
6. No Maintito in promoted docs; no airoweb/AI-DD coupling.
7. Testito evidence + Reviwito findings; Behzad merges; Leadito does not Build.

## 11. Testito checklist (evidence)

- [ ] Repo public (API/UI screenshot or `gh repo view` visibility PUBLIC)
- [ ] LICENSE present; clone HTTPS works without auth for read
- [ ] `bash tests/validate-templates.sh` and `validate-hooks.sh` green
- [ ] how-to-run has no private-only instructions as the primary path
- [ ] WidgetCo example files exist; grep finds no Braiins/airoweb/`/Users/behzad`
- [ ] ade.ir HTML: GitHub + Install links resolve; banned CTA strings absent
- [ ] CI green on both repos touched

## 12. Sign-off

**Accepted** 2026-09-18 — WidgetCo status digest locked as worked example. Develito may write `plan.md` then Build. Designito idle unless Build needs clarification.
