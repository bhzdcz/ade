# How to run ADE

**ADE** is not a long-running server. You run it as **git + Claude Code + GitHub PRs**. Grok Bot stage conductors are optional; strangers do not need them.

Product site: [https://ade.ir](https://ade.ir)

## Prerequisites

1. git
2. [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI (worker path)
3. A GitHub account (for PRs)

## Clone

HTTPS (preferred for strangers):

```bash
git clone https://github.com/bhzdcz/ade.git
cd ade
```

SSH (alternate):

```bash
git clone git@github.com:bhzdcz/ade.git
cd ade
```

## Happy path (one change)

Stage names below are roles, not required bots. You can do every step yourself with Claude Code + git.

1. **Plan** — Describe the problem. Copy `intent/_template.md` → `intent/<YYYY-MM-DD-slug>.md`. PO accepts → commit/merge the intent (`status: accepted`).
2. **Design** — From the accepted intent, write `specs/<intent-id>/spec.md` from `specs/_template.md`. PO signs off.
3. **Build** — Start Claude Code in the repo. Set `.claude/active-intent` to the intent-id. Write `plans/<intent-id>/plan.md` from `plans/_template.md` (plan mode first). Set `status: accepted` only after you accept it. Then implement. Hooks block non-allowlisted edits without an accepted plan.
4. **Test** — Run validators (and any change-specific tests). Paste output in the PR:

   ```bash
   bash tests/validate-templates.sh
   bash tests/validate-hooks.sh
   ```

5. **Review / Deploy** — Open a PR. Run three passes per `REVIEW.md`. Findings never approve. Human code owner (`@bhzdcz`) approves and merges. Production promote stays stubbed: `scripts/promote.sh` only succeeds with a valid attestation under `releases/attestations/` whose `release_manager` is listed in `releases/release-managers.txt`.
6. **Maintain** — For a finding too big for one PR: `bash scripts/finding-to-intent.sh findings/_template.md` (copy to `findings/<slug>.md` first, or pass your own finding) → new `intent.md`, back to Plan. **Leadito** (if you use conductors) owns the Deploy + Maintain gate; Leadito does not Build.

Walk the fictional example: [examples/widgetco-status-digest/](../examples/widgetco-status-digest/).

## Useful commands

```bash
bash tests/validate-templates.sh
bash tests/validate-hooks.sh
bash scripts/finding-to-intent.sh findings/_template.md
bash scripts/promote.sh   # stub; needs allowlisted release_manager attestation
```

## Appendix: optional Grok Bot conductors

If you use Grok Bot stage conductors, a typical handoff is:

**Planito → Designito → Develito → Testito → Reviwito → Leadito**

- Conductors draft and review artifacts; they are **not** the SoT.
- Artifacts must land in this git repo; chat is not the record.
- **Leadito** = Deploy + Maintain gate / loop conduct. Leadito does **not** Build.
- Maintain is under Leadito (not a separate conductor role).

Strangers succeed with Claude Code + git alone; skip this appendix if unused.

## Branch protection (public free)

On a **public** GitHub repo, free accounts can enable branch protection / required reviews (Settings → Branches / Rulesets). Enabling that is a human Settings step for the owner (`@bhzdcz`). This doc does not flip Settings. Until protection is on, rely on PRs, `CODEOWNERS`, `scripts/promote.sh` + `releases/release-managers.txt`, and never push straight to `main` without review.

## What v1 does *not* run yet

Live control-band watcher, eval suite, cloud deploy/MCP, multi-harness, paid installs/SaaS. Those are out of v1.
