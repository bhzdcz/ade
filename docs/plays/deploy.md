# Play: Deploy — review, gates, release

## Review

- Run three passes per `REVIEW.md` (bugs, security, compliance vs artifacts).
- Findings never approve; human code owner required.

## Gates

- CI: `.github/workflows/ci.yml` runs template + hook validation.
- Production-gate hook blocks promote patterns without `releases/attestations/<id>.yaml` and non-empty `release_manager`.
- v1 promote is **`scripts/promote.sh` stub only** — no cloud deploy. Document this to avoid false sense of prod safety (spec concern #3).

## Release manager

Behzad for v1. Agents act up to the production gate, not past it.

## Rollback (documented only in v1)

1. Revert the bootstrap/merge commit or close the promote attestation file.
2. Delete attestation YAML under `releases/attestations/` to re-block promote.
3. No prod traffic in v1 dogfood — rollback is git revert.
