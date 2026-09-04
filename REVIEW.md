# REVIEW.md — three-pass review policy

Findings **inform**; they **never approve**. Merge requires a human code owner (`CODEOWNERS`; Behzad sole for v1).

## Pass 1 — Bugs / logic

- Correctness vs acceptance criteria and `plan.md`
- Edge cases, error handling, regressions
- Tests: present, meaningful; bugfixes had a failing test first

## Pass 2 — Security / vulnerabilities

- Authz, secrets in artifacts, unsafe tool use, supply chain
- No secrets in markdown; Important security findings **block merge** until human resolution
- Production promote still behind release-manager attestation

## Pass 3 — Compliance vs artifacts

- Diff matches `spec.md` + `plan.md` + stated design principles
- Gate events and status vocabulary respected
- Explicit won’t-change boundaries not violated

## Severity

| Label | Meaning |
| --- | --- |
| **Important** | Must resolve or explicitly waive before merge |
| **Nit** | Optional polish; must not block merge alone |

## Skip rules

- Pure doc/template allowlist edits may skip Pass 3 depth if no behavior change
- Do not re-litigate accepted plan approach unless the diff departs from it
- v1 production-gate guards a **stub** promote (`scripts/promote.sh`), not cloud prod — note false-safety risk; call out in Deploy play until v2 deploy tools exist

## Code-owner rule

AI/reviewer findings never count as approval. Branch protection / `CODEOWNERS` human approval is required for merge.
