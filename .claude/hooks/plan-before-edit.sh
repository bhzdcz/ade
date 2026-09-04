#!/usr/bin/env bash
# PreToolUse hook for Edit|Write|MultiEdit — require accepted plan unless allowlisted.
# Always exit 0. Deny via hookSpecificOutput.permissionDecision=deny.

set -euo pipefail

HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$HOOK_DIR/lib/common.sh"

json="$(read_stdin_json || true)"

paths=()
while IFS= read -r p || [[ -n "${p:-}" ]]; do
  [[ -n "${p:-}" ]] && paths+=("$p")
done < <(extract_file_paths "$json")

# Pathless / unresolvable tool input → DENY (fail-closed)
if [[ ${#paths[@]} -eq 0 ]]; then
  hook_deny "plan-before-edit: pathless/unresolvable tool input — no file path could be resolved from tool_input (Edit/Write/MultiEdit)"
  exit 0
fi

root="$(repo_root)"

normalize_path() {
  local path="$1"
  if [[ "$path" == /* ]]; then
    if [[ "$path" == "$root"/* ]]; then
      path="${path#"$root"/}"
    fi
  fi
  path="${path#./}"
  printf '%s' "$path"
}

need_plan=0
declare -a gated_paths=()
for raw in "${paths[@]}"; do
  path="$(normalize_path "$raw")"
  if is_allowlisted_path "$path"; then
    continue
  fi
  need_plan=1
  gated_paths+=("$path")
done

if [[ "$need_plan" -eq 0 ]]; then
  hook_allow "allowlisted path(s)"
  exit 0
fi

# Summarize first gated path for deny messages
path_summary="${gated_paths[0]}"
if [[ ${#gated_paths[@]} -gt 1 ]]; then
  path_summary="${gated_paths[0]} (+$(( ${#gated_paths[@]} - 1 )) more)"
fi

intent_id="$(read_active_intent "$root")"
if [[ -z "$intent_id" ]]; then
  hook_deny "plan-before-edit: missing .claude/active-intent; engineer must set active intent and accept plans/${intent_id:-<id>}/plan.md (status: accepted) before editing $path_summary"
  exit 0
fi

status="$(plan_status "$root" "$intent_id")"
if [[ "$status" != "accepted" ]]; then
  hook_deny "plan-before-edit: plans/$intent_id/plan.md must have frontmatter status: accepted (found: '${status:-missing}') before editing $path_summary — engineer gate"
  exit 0
fi

hook_allow "accepted plan for $intent_id"
exit 0
