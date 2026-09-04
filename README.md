# Inkrail

**Inkrail** is an AI-native SDLC platform: markdown artifacts on rails, humans at the gates.

GitHub: [`bhzdcz/inkrail`](https://github.com/bhzdcz/inkrail) (private). The repo **is** the product — six plays, a committed artifact chain, Claude Code as the worker, and a Maintain loop that can write the next `intent.md`.

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
| [docs/how-to-run.md](docs/how-to-run.md) | How to run Inkrail day to day |

## Artifact chain

```
intent.md → spec.md → plan.md → diff + tests → REVIEW.md / PR findings → deploy gates → Maintain → new intent.md
```

## v1 scope

Templates, skills, hooks (`plan-before-edit`, `production-gate`), `CLAUDE.md` / `REVIEW.md`, `bands.yaml` schema, minimal CI. No live watcher, no cloud deploy automation, no multi-harness runtime.

**Sole acceptor / release manager (v1):** Behzad (`@bhzdcz`).

## Local checks

```bash
bash tests/validate-templates.sh
bash tests/validate-hooks.sh
```

## Identity

GitHub: [`bhzdcz/inkrail`](https://github.com/bhzdcz/inkrail) · code owner `@bhzdcz`.

## Branch protection note (v1)

GitHub branch protection / rulesets on **private** repos require GitHub Pro (or a public repo). Until then, treat `CODEOWNERS` + PR review as process gates: do not push straight to `main` without a PR and human approval.
