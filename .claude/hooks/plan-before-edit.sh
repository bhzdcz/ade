#!/usr/bin/env bash
# Deny failures, otherwise leave normal Claude permissions unchanged.
set -euo pipefail
HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! command -v python3 >/dev/null 2>&1; then
  echo 'ADE requires Python 3.10+ to check the plan.' >&2
  exit 2
fi
if ! python3 "$HOOK_DIR/lib/plan_check.py"; then
  echo 'ADE could not check the plan.' >&2
  exit 2
fi
