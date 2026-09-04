# Feedback loop — findings → intent / evals

## Principles

- Every production incident and every **Important** review finding should become either permanent regression coverage (when feasible) or a new `intent.md`.
- Chat is not the handoff; commit the artifact.

## Paths

| Trigger | Action |
| --- | --- |
| Band breach / manual finding | `scripts/finding-to-intent.sh` → draft intent → Plan play |
| Important PR finding | Fix in-branch if small; else open finding → intent |
| Hook/CI failure on main | Finding under `findings/`; high severity per `bands.yaml` |

## v1 vs v2

- v1: manual Maintain path exercised once; instructions here; fixtures in CI.
- v2: eval suite; incidents become permanent evals automatically.
