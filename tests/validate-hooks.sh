#!/usr/bin/env bash
# Isolated portable tests. Never rewrite active intent, plans or attestations.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 "$ROOT/tests/test_hooks.py"
