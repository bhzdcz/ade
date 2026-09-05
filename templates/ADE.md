# ADE workflow

Keep intent, decisions, implementation plans and review evidence in Git. Use Claude Code as the worker; humans own acceptance and releases.

For a new change, use the ADE CLI to create a draft intent, spec and plan. Read `.claude/active-intent`, then the matching files under `intent/`, `specs/`, and `plans/`. Refine all three in plan mode. Ask the owner to review and accept the plan in Git before editing product files. The human can edit drafts directly in their editor; do not use shell writes to bypass the hook.

Follow `REVIEW.md` for correctness, security and scope checks. Follow `docs/plays/` for the six lifecycle plays. Findings never count as approval. Never mark a plan accepted or create release attestations on behalf of a human without explicit authorization.

Hooks apply to supported Claude tools only. They are editable workflow checks, not a security sandbox or proof of reviewer identity. `scripts/promote.sh` is a demonstration with no deployment side effects. Enforce real review and deployment permissions in the Git host and deployment platform. Keep credentials out of artifacts.
