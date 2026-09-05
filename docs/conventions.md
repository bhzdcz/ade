# Conventions

## intent-id

- Format: `YYYY-MM-DD-<slug>` (filename without `.md`).
- Flat under `intent/`; nested under that id for specs/plans:
  - `specs/<intent-id>/spec.md`
  - `plans/<intent-id>/plan.md`

## Status vocabulary

`draft` | `in_review` | `accepted` | `rejected` | `superseded` | `implemented` | `closed`

Use consistently in YAML frontmatter.

## Linkage fields

| Field | Rule |
| --- | --- |
| `jira_key` | Only when a ticket exists; empty string allowed |
| `figma_url` | Required when UI-facing; else omit/N/A |
| `github` | PR URL / accepting commit SHA in PR body back-links |

## Placeholders

GitHub identity is `bhzdcz/ade`; code owner handle is `@bhzdcz`.

## Active intent

`.claude/active-intent` contains a single intent-id line. Hooks use it to locate `plans/<id>/plan.md`.
