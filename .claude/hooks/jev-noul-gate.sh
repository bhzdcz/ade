#!/usr/bin/env bash
# PreToolUse hook for Edit|Write|MultiEdit — optional Jev / System One Noul gate.
# Always exit 0. Deny via hookSpecificOutput.permissionDecision=deny.
# When ADE_JEV_GATE is OFF → immediate allow (no network).

set -euo pipefail

HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$HOOK_DIR/lib/common.sh"

gate_on() {
  case "${ADE_JEV_GATE:-}" in
    1|true|TRUE|yes|YES|on|ON) return 0 ;;
    *) return 1 ;;
  esac
}

# OFF → fast allow, zero network / no CLI
if ! gate_on; then
  hook_allow "jev-noul-gate OFF"
  exit 0
fi

json="$(read_stdin_json || true)"

paths=()
while IFS= read -r p || [[ -n "${p:-}" ]]; do
  [[ -n "${p:-}" ]] && paths+=("$p")
done < <(extract_file_paths "$json")

if [[ ${#paths[@]} -eq 0 ]]; then
  hook_deny "jev-noul-gate: pathless/unresolvable tool input while ADE_JEV_GATE is ON"
  exit 0
fi

root="$(repo_root)"
CLI="$root/scripts/jev-noul-check.sh"
if [[ ! -x "$CLI" ]]; then
  hook_deny "jev-noul-gate: missing executable scripts/jev-noul-check.sh (fail-closed while gate ON)"
  exit 0
fi

# Prefer first path; build short summary from tool_input (truncated, redacted in CLI)
path="${paths[0]}"
# Strip absolute root prefix if present
if [[ "$path" == /* && "$path" == "$root"/* ]]; then
  path="${path#"$root"/}"
fi
path="${path#./}"

# Extract a short content/new_string snippet for summary (best-effort)
snippet=""
if command -v jq >/dev/null 2>&1; then
  snippet="$(printf '%s' "$json" | jq -r '
    .tool_input.content // .tool_input.new_string // .tool_input.newString //
    ((.tool_input.edits // [])[0].new_string // (.tool_input.edits // [])[0].content // empty)
    // empty
  ' 2>/dev/null || true)"
else
  snippet="$(printf '%s' "$json" | python3 -c '
import json,sys
try:
 d=json.load(sys.stdin)
except Exception:
 sys.exit(0)
ti=d.get("tool_input") or {}
v=ti.get("content") or ti.get("new_string") or ti.get("newString") or ""
if not v:
 eds=ti.get("edits") or []
 if eds and isinstance(eds[0],dict):
  v=eds[0].get("new_string") or eds[0].get("content") or ""
print(v if isinstance(v,str) else "")
' 2>/dev/null || true)"
fi

# Truncate snippet for summary budget
if [[ ${#snippet} -gt 400 ]]; then
  snippet="${snippet:0:400}…"
fi

if [[ -n "$snippet" ]]; then
  summary="edit $path :: $snippet"
else
  summary="edit $path :: (no content snippet; new/empty or binary)"
fi

# Cap overall summary
if [[ ${#summary} -gt 700 ]]; then
  summary="${summary:0:700}…"
fi

set +e
out="$("$CLI" "$path" "$summary" 2>&1)"
rc=$?
set -e

case "$rc" in
  0)
    hook_allow "jev-noul allow: ${out:-ok}"
    ;;
  2)
    hook_deny "jev-noul misconfig: ${out:-set ADE_JEV_API_KEY or ADE_JEV_STUB=1}"
    ;;
  *)
    hook_deny "jev-noul deny: ${out:-p below threshold or fail-closed}"
    ;;
esac
exit 0
