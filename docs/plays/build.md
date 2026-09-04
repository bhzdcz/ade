# Play: Build — plan mode then implement

**Input:** signed-off `spec.md`.
**Outputs:** `plans/<intent-id>/plan.md`, then diff + tests; hooks/skills/`CLAUDE.md` as needed.

## Plan mode (mandatory)

1. Set `.claude/active-intent` to the intent-id.
2. Worker proposes file-level plan + tests; engineer accepts → `status: accepted` on `plan.md`.
3. `plan-before-edit` PreToolUse hook (matcher `Edit|Write|MultiEdit`) then **may** allow non-allowlisted paths only when `plan.md` is `status: accepted` for `.claude/active-intent`.
4. Pathless / unresolvable tool input is **denied** (fail-closed). MultiEdit checks every path in `edits[]`.

## Bootstrap exception

The first PR that creates the hooks is authorized by the accepted plan and may write all listed scaffold files. After merge, allowlist + accepted-plan rules apply.

## Implement

- Follow the plan file list; if departure is needed, update `plan.md` in the same PR.
- Run `tests/validate-*.sh` before human review.
- Bugfixes: failing test first; do not weaken checks.

## Allowlist reminder

`intent/_template.md`, `specs/_template.md`, `docs/**`, `findings/**`, `.markdownlint.json`, `.gitignore`, `README.md`.

**Not allowlisted:** `releases/attestations/**` (writing attestations requires an accepted plan), `CLAUDE.md`, `REVIEW.md`, `bands.yaml`, `.claude/**`, `scripts/**`, `.github/**`, `tests/**`, `CODEOWNERS`, seeded artifact content after bootstrap.
