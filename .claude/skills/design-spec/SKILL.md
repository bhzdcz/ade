# Skill: design-spec

**Play:** Design. **Strength:** advisory only.

## When to use

Accepted `intent.md` is ready. Compress intent + org skills into `specs/<intent-id>/spec.md`.

## Guidance

1. Start from `specs/_template.md`; cover Summary, Goals/non-goals, Actors, Artifact contracts/gates, Functional design, Non-functional, UX, Flagged concerns, Open questions, Acceptance criteria, Out of scope.
2. Flag policy conflicts visibly; route before Build.
3. Link intent path/SHA in frontmatter; set status `draft` until PO sign-off.
4. UI: mock first (Figma); then hand to Build.
5. Load `security-policy` skill when security/compliance claims appear.

## Must not

- Write production code or `plan.md` in Design.
- Bury flagged concerns.
- Invent PO sign-off.
