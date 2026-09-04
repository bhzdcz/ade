# Skill: intent-capture

**Play:** Plan. **Strength:** advisory only.

## When to use

Originator describes a problem (person, ticket, or Maintain finding). Draft a valid `intent.md` from `intent/_template.md`.

## Guidance

1. Keep the originator's words in **Problem**; do not silently rewrite meaning.
2. Fill all required sections: Problem, Proposed outcome, Constraints, Open questions (with defaults), Success criteria (leading / lagging).
3. Frontmatter: `title`, `author`, `status: draft`, `date`, `revision`, `acceptor` (empty until PO), `source` (`human` | `maintain` | `ticket`), `jira_key` only if a ticket exists.
4. Stop at draft; PO accept/reject is the gate. Do not invent acceptance.
5. Repeat shapes may become future skills — note them in Open questions.

## Must not

- Skip sections to go fast.
- Treat chat as SoT — commit the file.
- Write `spec.md` / `plan.md` / code in Plan.
