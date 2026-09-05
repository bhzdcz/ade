#!/usr/bin/env bash
# Shared helpers for Claude Code PreToolUse hooks.
# Denials use hook JSON. Successful checks abstain and preserve normal permissions.

hook_allow() {
  # Abstain: a workflow check must never auto-approve tool permissions.
  printf '%s\n' '{}'
}

hook_deny() {
  local reason="${1:-denied}"
  if command -v jq >/dev/null 2>&1; then
    jq -n --arg reason "$reason" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: $reason
      }
    }'
  else
    local escaped
    escaped=$(printf '%s' "$reason" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read())[1:-1])')
    printf '%s\n' "{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"deny\",\"permissionDecisionReason\":\"${escaped}\"}}"
  fi
}

read_stdin_json() {
  cat
}

extract_file_path() {
  local json="$1"
  # Prefer first path from multi-path extractor (covers MultiEdit edits[])
  local first
  first="$(extract_file_paths "$json" | head -n1 || true)"
  printf '%s\n' "$first"
}

extract_file_paths() {
  local json="$1"
  if command -v jq >/dev/null 2>&1; then
    echo "$json" | jq -r '
      [
        (.tool_input.file_path // empty),
        (.tool_input.path // empty),
        (.tool_input.filePath // empty),
        (.file_path // empty),
        ((.tool_input.edits // [])[] | (.file_path // .path // empty))
      ]
      | map(select(type == "string" and . != ""))
      | unique
      | .[]
    '
  else
    printf '%s' "$json" | python3 -c 'import json,sys
try:
 d=json.load(sys.stdin)
except Exception:
 sys.exit(0)
ti=d.get("tool_input") or {}
paths=[]
for k in ("file_path","path","filePath"):
 v=ti.get(k)
 if isinstance(v,str) and v:
  paths.append(v)
fp=d.get("file_path")
if isinstance(fp,str) and fp:
 paths.append(fp)
for ed in (ti.get("edits") or []):
 if not isinstance(ed,dict):
  continue
 for k in ("file_path","path"):
  v=ed.get(k)
  if isinstance(v,str) and v:
   paths.append(v)
   break
seen=set()
for p in paths:
 if p not in seen:
  seen.add(p)
  print(p)
'
  fi
}

extract_command() {
  local json="$1"
  if command -v jq >/dev/null 2>&1; then
    echo "$json" | jq -r '.tool_input.command // .tool_input.cmd // .command // empty'
  else
    printf '%s' "$json" | python3 -c 'import json,sys
try:
 d=json.load(sys.stdin)
except Exception:
 sys.exit(0)
ti=d.get("tool_input") or {}
print(ti.get("command") or ti.get("cmd") or d.get("command") or "")'
  fi
}

repo_root() {
  if [[ -n "${CLAUDE_PROJECT_DIR:-}" ]]; then
    echo "$CLAUDE_PROJECT_DIR"
  else
    # Walk up looking for .claude/active-intent or plans/
    local d
    d=$(pwd)
    while [[ "$d" != "/" ]]; do
      if [[ -d "$d/.claude" ]] || [[ -d "$d/plans" ]]; then
        echo "$d"
        return 0
      fi
      d=$(dirname "$d")
    done
    pwd
  fi
}

read_active_intent() {
  local root="$1"
  local f="$root/.claude/active-intent"
  if [[ ! -f "$f" ]]; then
    echo ""
    return 0
  fi
  head -n 1 "$f" | tr -d "\r" | sed "s/^[[:space:]]*//;s/[[:space:]]*$//"
}

plan_status() {
  local root="$1"
  local id="$2"
  local plan="$root/plans/$id/plan.md"
  if [[ ! -f "$plan" ]]; then
    echo ""
    return 0
  fi
  awk '
    BEGIN { in_fm=0 }
    /^---[[:space:]]*$/ {
      if (in_fm==0) { in_fm=1; next }
      else { exit }
    }
    in_fm && /^status:[[:space:]]*/ {
      sub(/^status:[[:space:]]*/, "")
      gsub(/[[:space:]]+$/, "")
      gsub(/^["'\'']|["'\'']$/, "")
      print
      exit
    }
  ' "$plan"
}

is_allowlisted_path() {
  local path="$1"
  path="${path#./}"
  case "$path" in
    intent/_template.md) return 0 ;;
    specs/_template.md) return 0 ;;
    docs|docs/*) return 0 ;;
    findings|findings/*) return 0 ;;
    .markdownlint.json) return 0 ;;
    .gitignore) return 0 ;;
    README.md) return 0 ;;
  esac
  return 1
}

is_promote_command() {
  local cmd="$1"
  if [[ -z "$cmd" ]]; then
    return 1
  fi
  local patfile
  patfile="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/promote-patterns.txt"
  if [[ ! -f "$patfile" ]]; then
    return 1
  fi
  local pat
  while IFS= read -r pat || [[ -n "$pat" ]]; do
    [[ -z "$pat" ]] && continue
    if echo "$cmd" | grep -Eq "$pat"; then
      return 0
    fi
  done < "$patfile"
  return 1
}

# Trim leading/trailing whitespace
_trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

is_allowed_release_manager() {
  local root="$1"
  local name="$2"
  local managers="$root/releases/release-managers.txt"
  if [[ ! -f "$managers" ]] || [[ -z "$name" ]]; then
    return 1
  fi
  local line trimmed
  while IFS= read -r line || [[ -n "$line" ]]; do
    trimmed="$(_trim "$line")"
    [[ -z "$trimmed" ]] && continue
    [[ "$trimmed" == \#* ]] && continue
    if [[ "$name" == "$trimmed" ]]; then
      return 0
    fi
  done < "$managers"
  return 1
}

has_valid_attestation() {
  local root="$1"
  local dir="$root/releases/attestations"
  if [[ ! -d "$dir" ]]; then
    return 1
  fi
  local f val
  shopt -s nullglob
  for f in "$dir"/*.yaml "$dir"/*.yml; do
    [[ -f "$f" ]] || continue
    val=$(grep -E "^[[:space:]]*release_manager:" "$f" | head -n1 | sed "s/^[[:space:]]*release_manager:[[:space:]]*//;s/[[:space:]]*$//;s/^[\"']//;s/[\"']$//")
    val="$(_trim "$val")"
    if is_allowed_release_manager "$root" "$val"; then
      shopt -u nullglob
      return 0
    fi
  done
  shopt -u nullglob
  return 1
}
