# Play: Plan — capture intent.md

**Input:** idea, ticket, or Maintain finding.
**Output:** `intent/<YYYY-MM-DD-slug>.md` committed.
**Human gate:** PO accept/reject → `intent_accepted` / `intent_rejected`.

## Steps

1. Brainstorm until concrete; use `.claude/skills/intent-capture/SKILL.md` (advisory).
2. Copy `intent/_template.md`; fill required sections (Problem, Proposed outcome, Constraints, Open questions, Success criteria leading/lagging).
3. Frontmatter: `title`, `author`, `status: draft`, `date`, `revision`, `acceptor`, `source`, optional `jira_key` / `figma_url`.
4. PO reviews and corrects; set `status: accepted` and `acceptor` on accept.
5. Commit. Chat is not the record.

## Must-holds

- Template sections present (CI: `tests/validate-templates.sh`).
- Skills advisory only; accept/reject is human.
