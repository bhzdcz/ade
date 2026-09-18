# Kit map

One-page index of ADE templates, skills, hooks, and plays.

## Templates

| Artifact | Path |
| --- | --- |
| Intent | `intent/_template.md` |
| Spec | `specs/_template.md` |
| Plan | `plans/_template.md` |
| Findings | `findings/_template.md` |
| Review policy | `REVIEW.md` |
| Control bands | `bands.yaml` |
| Operating context | `CLAUDE.md` |

## Plays

| Stage | Path |
| --- | --- |
| Plan | `docs/plays/plan.md` |
| Design | `docs/plays/design.md` |
| Build | `docs/plays/build.md` |
| Test | `docs/plays/test.md` |
| Deploy | `docs/plays/deploy.md` |
| Maintain | `docs/plays/maintain.md` |

## Skills (Claude Code)

| Skill | Path |
| --- | --- |
| Intent capture | `.claude/skills/intent-capture/` |
| Design spec | `.claude/skills/design-spec/` |
| Security policy | `.claude/skills/security-policy/` |

## Hooks

| Hook | Path |
| --- | --- |
| Plan-before-edit | `.claude/hooks/plan-before-edit.sh` |
| Production gate | `.claude/hooks/production-gate.sh` |
| Shared lib | `.claude/hooks/lib/` |

Project hook wiring: `.claude/settings.json`

## Scripts & checks

| Item | Path |
| --- | --- |
| Validate templates | `tests/validate-templates.sh` |
| Validate hooks | `tests/validate-hooks.sh` |
| Finding → intent | `scripts/finding-to-intent.sh` |
| Promote (stub) | `scripts/promote.sh` |

## Worked example

| Item | Path |
| --- | --- |
| WidgetCo status digest | `examples/widgetco-status-digest/` |
| Intent / spec / plan | `intent/2026-09-18-widgetco-status-digest.md`, `specs/…`, `plans/…` |

## Further reading

- Day-to-day runbook: `docs/how-to-run.md`
- Conventions: `docs/conventions.md`
- Feedback loop: `docs/feedback-loop.md`
