#!/usr/bin/env bash
# Stub promote entrypoint for ADE v1.
# Does not deploy to cloud. Requires a valid attestation (enforced by production-gate hook
# when invoked via Claude Code Bash; this script also self-checks).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# shellcheck source=../.claude/hooks/lib/common.sh
source "$ROOT/.claude/hooks/lib/common.sh"

if ! has_valid_attestation "$ROOT"; then
  echo "promote.sh: denied — need releases/attestations/*.y{a,}ml whose release_manager exactly matches releases/release-managers.txt" >&2
  exit 1
fi

echo "promote.sh: attestation OK (stub promote — no cloud side effects)"
echo "promote.sh: bhzdcz/ade — stub promote only (no cloud deploy in v1)"
exit 0
