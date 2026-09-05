# Security and trust boundaries

Report vulnerabilities privately to **behzad@airoweb.com**. Include a minimal reproduction and affected version; do not post credentials or customer data. No response-time SLA is currently offered.

## What the checks do

The plan hook canonicalizes tool paths, rejects paths outside the project, validates the active intent, and requires an accepted plan for gated edits. On success it leaves Claude Code's ordinary permission system in control. Malformed requests are denied. Python 3.10+ is required; missing Python blocks hooked operations.

## What they cannot prove

Anyone with write access can change a plan, a hook, or the settings file. A name in a release attestation does not authenticate its author. An old attestation is not approval for a new deployment. Shell writes, unsupported tools, other agent harnesses, disabled hooks and direct editor edits are outside the plan hook. These are workflow checks, not a sandbox, compliance certification, or tamper-proof audit system.

The Bash hook recognizes only patterns in `.claude/hooks/lib/promote-patterns.txt`. It does not parse every possible shell program. `scripts/promote.sh` is a simulation that never deploys. Never connect this attestation check directly to production credentials.

## Real enforcement

Require human PR review and protected deployment environments in your Git host. Restrict production credentials to those environments. Review CI changes and pin the toolkit revision you install. Keep provider keys in environment variables or a secret manager, never in intent/spec/plan files. ADE makes no network requests; Claude Code and your Git host have their own data policies.

## Installation and removal

Inspect `ade init --dry-run` and the source before installation. Installation preserves existing content, backs up changed Claude settings/context, and refuses runtime conflicts or symlink paths. Run without concurrent editors modifying the same files. For removal, review the installation diff: remove ADE's two hook entries and `@ADE.md` import, then delete only unmodified ADE files. Preserve project artifacts and other hooks. Restore a backup only if it still represents the settings you want.
