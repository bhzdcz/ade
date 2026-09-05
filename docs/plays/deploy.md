# Play: Deploy — review, gates, release

## Review

Run the three passes in REVIEW.md: correctness, security and scope. Findings inform; human code owners approve. Require successful CI and human review in the Git host.

## Real authorization

Production credentials belong in protected deployment environments with required reviewers. Bind approvals to the intended change and environment using your deployment platform. Never treat a writable plan status or maintainer name as authenticated approval.

## Demonstration gate

The bundled Bash hook recognizes a limited set of promote patterns. The `scripts/promote.sh` entry point checks whether a local attestation contains an allowlisted release-manager name, then prints a simulation message. It does not deploy anything. A forged allowlisted name or stale attestation can satisfy that local check; it must never be used as production authorization.

Installed projects start with no release-manager names configured. A human can adapt the simulation after reviewing its limits. ADE hooks cover supported tools only; shell writes and disabled hooks can bypass local conventions.

## Rollback

Use the application's actual rollback procedure and protected environment. Reverting an ADE configuration change affects workflow files only. Removing a demonstration attestation re-blocks the simulation, not a real deployment.
