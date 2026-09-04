#!/usr/bin/env bash
# T2-T6: dry-run hooks with fixture stdin JSON.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
FIX="$ROOT/tests/fixtures/hooks"
fail=0

decision_of() {
  # Extract permissionDecision from hook JSON stdout
  echo "$1" | jq -r '.hookSpecificOutput.permissionDecision // empty'
}

run_hook() {
  local hook="$1" fixture="$2"
  CLAUDE_PROJECT_DIR="$ROOT" bash "$hook" < "$fixture"
}

expect_decision() {
  local label="$1" hook="$2" fixture="$3" want="$4"
  local out rc=0
  set +e
  out="$(run_hook "$hook" "$fixture" 2>/dev/null)"
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

echo "== validate-hooks =="

PLAN_HOOK="$ROOT/.claude/hooks/plan-before-edit.sh"
PROD_HOOK="$ROOT/.claude/hooks/production-gate.sh"

# Ensure executable
chmod +x "$PLAN_HOOK" "$PROD_HOOK" "$ROOT/.claude/hooks/lib/common.sh"

# T4 allowlist
expect_decision "T4 allowlist docs" "$PLAN_HOOK" "$FIX/allowlist-docs-write.json" allow
expect_decision "T4 allowlist readme" "$PLAN_HOOK" "$FIX/allowlist-readme-write.json" allow

# T3 accepted plan allow — ensure active-intent + accepted plan
printf '%s\n' '2026-09-04-ai-native-sdlc-platform' > "$ROOT/.claude/active-intent"
expect_decision "T3 accepted plan CLAUDE.md" "$PLAN_HOOK" "$FIX/accepted-plan-claude-write.json" allow

# T2 deny without accepted plan: stash active-intent
ACTIVE_BAK="$(mktemp)"
cp "$ROOT/.claude/active-intent" "$ACTIVE_BAK"
rm -f "$ROOT/.claude/active-intent"
expect_decision "T2 deny missing active-intent" "$PLAN_HOOK" "$FIX/missing-plan-bands-write.json" deny
cp "$ACTIVE_BAK" "$ROOT/.claude/active-intent"
rm -f "$ACTIVE_BAK"

# Also deny when plan status is not accepted (temp rewrite)
PLAN="$ROOT/plans/2026-09-04-ai-native-sdlc-platform/plan.md"
PLAN_BAK="$(mktemp)"
cp "$PLAN" "$PLAN_BAK"
# flip status to draft temporarily
sed -i 's/^status: accepted/status: draft/' "$PLAN"
expect_decision "T2 deny plan not accepted" "$PLAN_HOOK" "$FIX/missing-plan-bands-write.json" deny
cp "$PLAN_BAK" "$PLAN"
rm -f "$PLAN_BAK"

# Restore active intent + accepted status sanity
printf '%s\n' '2026-09-04-ai-native-sdlc-platform' > "$ROOT/.claude/active-intent"
if ! grep -q '^status: accepted' "$PLAN"; then
  echo "FAIL plan status not restored to accepted"
  fail=1
fi

# Production gate: non-promote allow
expect_decision "prod non-promote allow" "$PROD_HOOK" "$FIX/bash-non-promote.json" allow

# T5 deny promote without attestation — ensure no attestations yaml present
ATT_DIR="$ROOT/releases/attestations"
mkdir -p "$ATT_DIR"
# Move any existing yaml/yml aside
ATT_STASH="$(mktemp -d)"
shopt -s nullglob
for f in "$ATT_DIR"/*.yaml "$ATT_DIR"/*.yml; do
  [[ -f "$f" ]] && mv "$f" "$ATT_STASH/"
done
shopt -u nullglob
expect_decision "T5 promote deny no attestation" "$PROD_HOOK" "$FIX/promote-command.json" deny
expect_decision "T5 promote deny env flag" "$PROD_HOOK" "$FIX/promote-env-flag.json" deny

# T6 allow with attestation
cp "$FIX/prod-allow-attestation.yaml" "$ATT_DIR/test-attestation.yaml"
expect_decision "T6 promote allow with attestation" "$PROD_HOOK" "$FIX/promote-command.json" allow
expect_decision "T6 promote allow env flag" "$PROD_HOOK" "$FIX/promote-env-flag.json" allow

# Cleanup test attestation; restore stashed
rm -f "$ATT_DIR/test-attestation.yaml"
shopt -s nullglob
for f in "$ATT_STASH"/*; do
  [[ -f "$f" ]] && mv "$f" "$ATT_DIR/"
done
shopt -u nullglob
rmdir "$ATT_STASH" 2>/dev/null || true

if [[ "$fail" -ne 0 ]]; then
  echo "validate-hooks: FAILED"
  exit 1
fi
echo "validate-hooks: OK"
exit 0
