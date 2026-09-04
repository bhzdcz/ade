# Play: Design — intent + skills → spec.md

**Input:** accepted `intent.md` + org skills.
**Output:** `specs/<intent-id>/spec.md`.
**Human gate:** PO sign-off → `spec_signed_off` → **plan mode**.

## Steps

1. Read accepted intent; load `.claude/skills/design-spec/SKILL.md` and `security-policy`.
2. Copy `specs/_template.md`; compress requirements + design in one session.
3. Flag concerns in a visible section — never bury.
4. UI work: mock first (Figma URL); do **not** write `plan.md` or production code in Design.
5. PO sets `status: accepted` / `spec_signed_off` → Build starts in plan mode.

## Must-holds

- Required sections per template / spec §7.2.
- No implementation edits in Design.
