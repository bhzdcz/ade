# Play: Build — plan mode then implement

**Input:** signed-off `spec.md`.
**Outputs:** `plans/<intent-id>/plan.md`, then diff + tests; hooks/skills/`CLAUDE.md` as needed.

## Plan mode (mandatory)

1. Set `.claude/active-intent` to the intent-id.
2. Worker proposes file-level plan + tests; engineer accepts → `status: accepted` on `plan.md`.
3. `plan-before-edit` hook then allows Write/Edit for non-allowlisted paths.

## Bootstrap exception

The first PR that creates the hooks is authorized by the accepted plan and may write all listed scaffold files. After merge, allowlist + accepted-plan rules apply.

## Implement

- Follow the plan file list; if departure is needed, update `plan.md` in the same PR.
- Run `tests/validate-*.sh` before human review.
- Bugfixes: failing test first; do not weaken checks.

## Allowlist reminder

`intent/_template.md`, `specs/_template.md`, `docs/**`, `findings/**`, `releases/attestations/**`, `.markdownlint.json`, `.gitignore`, `README.md`.
