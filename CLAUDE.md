# CLAUDE.md — ADE

Repo purpose: **ADE** — public open-source AI-native SDLC kit (markdown artifacts on rails, humans at the gates). Worker is Claude Code CLI/SDK. Chat is not SoT; acceptance = git/PR state only.

Optional Grok Bot conductors may draft/review artifacts; they are not required. Roster is optional. **Leadito** owns Deploy + Maintain gate / loop conduct and does **not** Build. Maintain is not a separate conductor role.

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
| Release managers | `releases/release-managers.txt` |
| Attestations | `releases/attestations/*.yaml` (write requires accepted plan) |
| Kit map | `docs/kit-map.md` |

**Before any product/framework edit:** read intent → spec → plan for `.claude/active-intent`.

## Gate rules

1. **PreToolUse matcher `Edit|Write|MultiEdit`** (`plan-before-edit.sh`). Pathless / unresolvable tool input is **denied**. MultiEdit checks every path in `edits[]`.
2. **No edit** outside the allowlist without `plans/<id>/plan.md` frontmatter `status: accepted`.
3. **Allowlist:** `intent/_template.md`, `specs/_template.md`, `docs/**`, `findings/**`, `.markdownlint.json`, `.gitignore`, `README.md`. **Not allowlisted:** `releases/attestations/**` (writing attestations requires an accepted plan).
4. **Findings never approve PRs.** Human code owner required (`CODEOWNERS`: `@bhzdcz` placeholder; Behzad for v1).
5. **Agents stop at the production gate.** Promote needs `releases/attestations/*.yaml` whose `release_manager` **exactly matches** a non-comment line in `releases/release-managers.txt` (v1: `Behzad`, `@bhzdcz`). Mere non-empty values (e.g. forged `Eve`) are denied (`production-gate.sh`).
6. If the diff departs from the plan, update `plan.md` in the same commit/PR.

## Commands

```bash
bash tests/validate-templates.sh
bash tests/validate-hooks.sh
bash scripts/finding-to-intent.sh findings/_template.md
bash scripts/promote.sh   # stub; requires allowlisted release_manager attestation
```

## Further reading

- How to run: `docs/how-to-run.md`
- Kit map: `docs/kit-map.md`
- Play runbooks: `docs/plays/`
- Feedback loop: `docs/feedback-loop.md`
- Conventions: `docs/conventions.md`
