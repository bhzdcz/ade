# How to run Inkrail

Inkrail is not a long-running server. You run it as **git + Claude Code (or this Grok Bot roster) + GitHub PRs**.

## Prerequisites

1. Clone the repo: `git clone git@github.com:bhzdcz/inkrail.git && cd inkrail`
2. Install [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (CLI) for the worker path
3. Optional: use the Grok Bot stage conductors (Planito → Designito → Develito → Testito → Reviwito → Leadito → Maintito) — they draft/review artifacts; they are not the SoT

## Happy path (one change)

1. **Plan** — Describe the problem in your own words. Produce `intent/<YYYY-MM-DD-slug>.md` from `intent/_template.md` (or ask Planito). You (PO) accept → commit/merge the intent.
2. **Design** — From the accepted intent, produce `specs/<intent-id>/spec.md` (or Designito). You sign off.
3. **Build** — Start Claude Code in the repo. Set `.claude/active-intent` to the intent-id. Work in **plan mode** first: write `plans/<intent-id>/plan.md`, set `status: accepted` only after you accept it. Then implement. Hooks block non-allowlisted edits without an accepted plan.
4. **Test** — Before you call it done: `bash tests/validate-templates.sh` and `bash tests/validate-hooks.sh` (plus any change-specific tests). Paste the output in the PR.
5. **Review / Deploy** — Open a PR. Reviwito (or Claude) runs `REVIEW.md` three passes. Findings never approve. You (`@bhzdcz`) approve and merge. Production promote stays stubbed: `scripts/promote.sh` only succeeds with a valid attestation under `releases/attestations/` whose `release_manager` is listed in `releases/release-managers.txt`.
6. **Maintain** — For a finding too big for one PR: `bash scripts/finding-to-intent.sh findings/examples/dogfood-sample.md` (or your own finding) → new `intent.md`, back to Plan.

## Useful commands

```bash
# Validation (v1 CI mirrors these)
bash tests/validate-templates.sh
bash tests/validate-hooks.sh

# Maintain dry-run → draft intent
bash scripts/finding-to-intent.sh findings/examples/dogfood-sample.md

# Stub promote (blocked without allowlisted attestation)
bash scripts/promote.sh
```

## With Grok Bot conductors

Talk to **Planito** for a new idea → bring `intent.md` here for accept → **Designito** for `spec.md` → **Develito** for `plan.md` then code → **Testito** / **Reviwito** → **Leadito** for deploy gates. Artifacts must land in this git repo; chat is not the record.

## What v1 does *not* run yet

Live control-band watcher, eval suite, cloud deploy/MCP, multi-harness. Those are v2.
