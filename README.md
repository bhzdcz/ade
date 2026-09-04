# AI-native SDLC platform (dogfood)

Dedicated GitHub repo (`OWNER/REPO` placeholders until named) that **is** the platform: six plays, a committed markdown artifact chain, human judgment gates, Claude Code as the worker, and a Maintain loop that can write the next `intent.md`.

This is not a roster of stage-named chat personas. Chat is never the system of record.

## Quick links

| Path | Role |
| --- | --- |
| [CLAUDE.md](CLAUDE.md) | One-page operating context for Claude Code |
| [REVIEW.md](REVIEW.md) | Three-pass PR review policy |
| [bands.yaml](bands.yaml) | Control-band schema + examples |
| [docs/plays/](docs/plays/) | Plan → Design → Build → Test → Deploy → Maintain runbooks |
| [docs/feedback-loop.md](docs/feedback-loop.md) | Findings / incidents → intent / evals |
| [docs/conventions.md](docs/conventions.md) | intent-id, status vocabulary, linkage |

## Artifact chain

```
intent.md → spec.md → plan.md → diff + tests → REVIEW.md / PR findings → deploy gates → Maintain → new intent.md
```

## v1 scope

Templates, skills, hooks (`plan-before-edit`, `production-gate`), `CLAUDE.md` / `REVIEW.md`, `bands.yaml` schema, minimal CI. No live watcher, no cloud deploy automation, no multi-harness runtime.

**Sole acceptor / release manager (v1):** Behzad. Replace `OWNER` / `CODEOWNERS` before shared production use.

## Local checks

```bash
bash tests/validate-templates.sh
bash tests/validate-hooks.sh
```

## Placeholders

Replace `OWNER` / `REPO` / `@OWNER` when the real GitHub identity exists. Do not invent one in this scaffold.
