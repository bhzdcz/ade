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
| `figma_url` | Only when a design exists; otherwise omit |
| `github` | PR URL / accepting commit SHA in PR body back-links |

## Placeholders

Toolkit development is at `bhzdcz/ade`. In an installed project, use that project’s actual repository and human owners. The installer never assigns Behzad ownership of a customer repository.

## Active intent

`.claude/active-intent` contains a single intent-id line. Hooks use it to locate `plans/<id>/plan.md`.
