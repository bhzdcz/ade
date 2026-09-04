# Skill: security-policy

**Strength:** advisory (policy). Must-holds are hooks/CI, not this skill alone.

## Rules

1. **No secrets in markdown artifacts** — use env / secret store; never commit tokens, keys, or credentials.
2. **Important security findings block merge** until human resolution (`REVIEW.md` Pass 2).
3. Agents must not cross the production gate; release manager attestation required for promote.
4. Compliance claims in a spec must map to a checkable artifact, hook, or CI item — else flag as concern.
5. Audit trail = git history + PR approvals + hook/CI logs.

## When reviewing drafts

Call out secrets, unsafe tool use, missing authz, and supply-chain risks before accept.
