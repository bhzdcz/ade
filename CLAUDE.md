# CLAUDE.md — AI-native SDLC platform

Repo purpose: **platform contracts + dogfood SoT** for Anthropic’s AI-native SDLC. Worker is Claude Code CLI/SDK only. Chat is not SoT; acceptance = git/PR state only.

## Artifact paths

| Kind | Path |
| --- | --- |
| Intent | `intent/YYYY-MM-DD-<slug>.md` |
| Spec | `specs/<intent-id>/spec.md` |
| Plan | `plans/<intent-id>/plan.md` |
| Active intent | `.claude/active-intent` (one intent-id line) |
| Plays | `docs/plays/{plan,design,build,test,deploy,maintain}.md` |
| Skills / hooks | `.claude/skills/`, `.claude/hooks/` |
| Review / bands | `REVIEW.md`, `bands.yaml` |

**Before any product/framework edit:** read intent → spec → plan for `.claude/active-intent`.

## Gate rules

1. **No Write/Edit** outside the allowlist without `plans/<id>/plan.md` frontmatter `status: accepted` (hook: `plan-before-edit.sh`).
2. **Allowlist:** `intent/_template.md`, `specs/_template.md`, `docs/**`, `findings/**`, `releases/attestations/**`, `.markdownlint.json`, `.gitignore`, `README.md`.
3. **Findings never approve PRs.** Human code owner required (`CODEOWNERS`: `@OWNER` placeholder; Behzad for v1).
4. **Agents stop at the production gate.** Promote needs `releases/attestations/*.yaml` with non-empty `release_manager` (hook: `production-gate.sh`).
5. If the diff departs from the plan, update `plan.md` in the same commit/PR.

## Commands

```bash
bash tests/validate-templates.sh
bash tests/validate-hooks.sh
bash scripts/finding-to-intent.sh findings/examples/dogfood-sample.md
bash scripts/promote.sh   # stub; requires attestation
```

## Further reading

- Play runbooks: `docs/plays/`
- Feedback loop: `docs/feedback-loop.md`
- Conventions: `docs/conventions.md`
