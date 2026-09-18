# ADE

**ADE** is an AI-native SDLC kit: markdown artifacts on rails, humans at the gates.

You clone it, follow the plays, and keep intent → spec → plan → review → deploy → maintain in git. Chat is never the system of record.

Product site: [https://ade.ir](https://ade.ir) · GitHub: [`bhzdcz/ade`](https://github.com/bhzdcz/ade) · License: [Apache-2.0](LICENSE)

## What it is

- A public open-source playbook and template kit for AI-assisted software delivery
- Six stage plays (Plan → Design → Build → Test → Deploy → Maintain)
- Claude Code hooks that gate edits behind an accepted `plan.md`
- One fictional worked example so strangers can walk the rail end-to-end

## What it is not

- Not an agent IDE or in-browser console
- Not a hosted SaaS, paid install, or checkout product
- Not a roster of chat personas as the source of truth — optional conductors may draft artifacts; humans accept in git/PRs

## Quickstart

```bash
git clone https://github.com/bhzdcz/ade.git
cd ade
bash tests/validate-templates.sh
bash tests/validate-hooks.sh
```

Then read **[docs/how-to-run.md](docs/how-to-run.md)** for the happy path.

Kit map (templates, skills, hooks, plays): **[docs/kit-map.md](docs/kit-map.md)**

Worked example: **[examples/widgetco-status-digest/](examples/widgetco-status-digest/)**

## Artifact chain

```
intent.md → spec.md → plan.md → diff + tests → REVIEW.md / PR findings → deploy gates → Maintain → new intent.md
```

## v1 scope (honest)

| In v1 | Not in v1 |
| --- | --- |
| Templates, plays, `CLAUDE.md` / `REVIEW.md` | Live control-band watcher |
| Hooks: `plan-before-edit`, `production-gate` | Cloud deploy automation / SaaS |
| Validators + minimal CI | Multi-harness runtime |
| Fictional WidgetCo worked example | Paid packs, Sponsors CTAs, checkout |

**Code owner / release manager (v1):** Behzad (`@bhzdcz`).

## Local checks

```bash
bash tests/validate-templates.sh
bash tests/validate-hooks.sh
```

## Identity

GitHub: [`bhzdcz/ade`](https://github.com/bhzdcz/ade) · site [ade.ir](https://ade.ir) · historically renamed from `bhzdcz/inkrail`.

## Branch protection

Once the repo is **public**, GitHub free accounts can enable branch protection / required reviews on `main` (Settings → Branches). Until then (or if protection is off), treat `CODEOWNERS` + PR review as process gates: do not push straight to `main` without a PR and human approval.

## License

Licensed under the [Apache License 2.0](LICENSE).
