#!/usr/bin/env bash
# PreToolUse hook for Bash — block promote-like commands without attestation.
# Always exit 0. Deny via hookSpecificOutput.permissionDecision=deny.

set -euo pipefail

HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$HOOK_DIR/lib/common.sh"

json="$(read_stdin_json || true)"
cmd="$(extract_command "$json")"

# Non-promote commands: allow
if ! is_promote_command "$cmd"; then
  hook_allow "non-promote command"
  exit 0
fi

root="$(repo_root)"

if has_valid_attestation "$root"; then
  hook_allow "valid release_manager attestation present"
  exit 0
fi

hook_deny "prod_gate_blocked: promote-like command requires releases/attestations/*.yaml (or .yml) with non-empty release_manager"
exit 0
