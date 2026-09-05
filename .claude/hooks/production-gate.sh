#!/usr/bin/env bash
# PreToolUse hook for Bash — block promote-like commands without attestation.
# Deny via hook JSON; unexpected failures exit 2 to block the operation.

set -euo pipefail

HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$HOOK_DIR/lib/common.sh"

# Nonzero hook failures otherwise fail open in Claude; exit 2 blocks the tool.
trap 'echo "ADE production check failed." >&2; exit 2' ERR
json="$(read_stdin_json)"
if ! printf '%s' "$json" | python3 -c 'import json,sys; d=json.load(sys.stdin); assert isinstance(d,dict); ti=d.get("tool_input"); assert isinstance(ti,dict); c=ti.get("command",ti.get("cmd")); assert isinstance(c,str) and c.strip()' 2>/dev/null; then
  hook_deny "invalid Bash tool input"
  exit 0
fi
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

hook_deny "prod_gate_blocked: promote-like command requires releases/attestations/*.yaml (or .yml) whose release_manager exactly matches releases/release-managers.txt"
exit 0
