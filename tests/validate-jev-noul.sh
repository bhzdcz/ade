#!/usr/bin/env bash
# Stub rehearsals for optional Jev Noul CLI + hook (offline, no key/network).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
CLI="$ROOT/scripts/jev-noul-check.sh"
HOOK="$ROOT/.claude/hooks/jev-noul-gate.sh"
FIX="$ROOT/tests/fixtures/hooks"
fail=0

chmod +x "$CLI" "$HOOK"

expect_cli() {
  local label="$1" want_rc="$2"
  shift 2
  local out rc=0
  set +e
  out="$("$@" 2>&1)"
  rc=$?
  set -e
  if [[ "$rc" -ne "$want_rc" ]]; then
    echo "FAIL $label: expected exit $want_rc got $rc"
    echo "  out: $out"
    fail=1
  else
    echo "PASS $label (exit $want_rc)"
  fi
}

decision_of() {
  echo "$1" | jq -r '.hookSpecificOutput.permissionDecision // empty'
}

expect_hook() {
  local label="$1" fixture="$2" want="$3"
  shift 3
  local out rc=0
  set +e
  out="$(env CLAUDE_PROJECT_DIR="$ROOT" "$@" bash "$HOOK" < "$fixture" 2>/dev/null)"
  rc=$?
  set -e
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL $label: hook exited $rc (must always exit 0)"
    fail=1
    return
  fi
  local got
  got="$(decision_of "$out")"
  if [[ "$got" != "$want" ]]; then
    echo "FAIL $label: expected $want got '$got'"
    echo "  stdout: $out"
    fail=1
  else
    echo "PASS $label ($want)"
  fi
}

echo "== validate-jev-noul =="

# T2 stub allow (p>=0.8)
expect_cli "stub allow ADE_JEV_STUB_P=0.9" 0 \
  env ADE_JEV_GATE=1 ADE_JEV_STUB=1 ADE_JEV_STUB_P=0.9 \
  bash "$CLI" "docs/optional-jev-gate.md" "safe doc tweak"

# T2 stub deny (p<0.8)
expect_cli "stub deny ADE_JEV_STUB_P=0.3" 1 \
  env ADE_JEV_GATE=1 ADE_JEV_STUB=1 ADE_JEV_STUB_P=0.3 \
  bash "$CLI" "scripts/promote.sh" "risky"

# Summary marker deny
expect_cli "stub deny summary marker" 1 \
  env ADE_JEV_GATE=1 ADE_JEV_STUB=1 \
  bash "$CLI" "bands.yaml" "change jev-stub-p=0.1"

# T3 ON + no key + no stub → exit 2
expect_cli "misconfig ON no key" 2 \
  env ADE_JEV_GATE=1 ADE_JEV_STUB=0 ADE_JEV_API_KEY= \
  bash "$CLI" "README.md" "x"

# Gate OFF → allow without key
expect_cli "gate OFF allow" 0 \
  env ADE_JEV_GATE=0 \
  bash "$CLI" "README.md" "x"

# Redaction: KEY= must not appear in output
set +e
red_out="$(ADE_JEV_GATE=1 ADE_JEV_STUB=1 ADE_JEV_STUB_P=0.9 bash "$CLI" "x.md" "export API_KEY=supersecretvalue123 and KEY=abc" 2>&1)"
red_rc=$?
set -e
if [[ "$red_rc" -ne 0 ]]; then
  echo "FAIL redaction run exited $red_rc"
  fail=1
elif echo "$red_out" | grep -qE 'supersecretvalue123|KEY=abc|API_KEY=super'; then
  echo "FAIL redaction leaked secret material: $red_out"
  fail=1
else
  echo "PASS redaction (no secret in output)"
fi

# Hook: gate OFF → fast allow
expect_hook "hook gate OFF allow" "$FIX/jev-edit-allow.json" allow ADE_JEV_GATE=0

# Hook: stub allow
expect_hook "hook stub allow" "$FIX/jev-edit-allow.json" allow \
  ADE_JEV_GATE=1 ADE_JEV_STUB=1 ADE_JEV_STUB_P=0.95

# Hook: stub deny via STUB_P
expect_hook "hook stub deny" "$FIX/jev-edit-deny.json" deny \
  ADE_JEV_GATE=1 ADE_JEV_STUB=1 ADE_JEV_STUB_P=0.2

if [[ "$fail" -ne 0 ]]; then
  echo "validate-jev-noul: FAILED"
  exit 1
fi
echo "validate-jev-noul: OK"
exit 0
