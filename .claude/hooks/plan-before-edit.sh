#!/usr/bin/env bash
# PreToolUse hook for Edit|Write — require accepted plan unless allowlisted.
# Always exit 0. Deny via hookSpecificOutput.permissionDecision=deny.

set -euo pipefail

HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$HOOK_DIR/lib/common.sh"

json="$(read_stdin_json || true)"
path="$(extract_file_path "$json")"

# If no path, allow (avoid false denies on unexpected shapes)
if [[ -z "$path" ]]; then
  hook_allow "no file path in tool input"
  exit 0
fi

root="$(repo_root)"

# Make path relative to repo root when absolute under root
if [[ "$path" == /* ]]; then
  if [[ "$path" == "$root"/* ]]; then
    path="${path#"$root"/}"
  fi
fi
path="${path#./}"

if is_allowlisted_path "$path"; then
  hook_allow "allowlisted path: $path"
  exit 0
fi

intent_id="$(read_active_intent "$root")"
if [[ -z "$intent_id" ]]; then
  hook_deny "plan-before-edit: missing .claude/active-intent; engineer must set active intent and accept plans/${intent_id:-<id>}/plan.md (status: accepted) before editing $path"
  exit 0
fi

status="$(plan_status "$root" "$intent_id")"
if [[ "$status" != "accepted" ]]; then
  hook_deny "plan-before-edit: plans/$intent_id/plan.md must have frontmatter status: accepted (found: '${status:-missing}') before editing $path — engineer gate"
  exit 0
fi

hook_allow "accepted plan for $intent_id"
exit 0
