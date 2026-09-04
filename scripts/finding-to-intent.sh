#!/usr/bin/env bash
# Thin Maintain helper: finding markdown -> draft intent file.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <finding.md> [optional-slug]" >&2
  exit 2
fi

FINDING="$1"
if [[ ! -f "$FINDING" ]]; then
  echo "finding-to-intent: file not found: $FINDING" >&2
  exit 1
fi

SLUG="${2:-}"
if [[ -z "$SLUG" ]]; then
  base="$(basename "$FINDING" .md)"
  SLUG="$(echo "$base" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g;s/-\+/-/g;s/^-//;s/-$//')"
  SLUG="${SLUG}-finding"
fi

DATE="$(date -u +%Y-%m-%d)"
INTENT_ID="${DATE}-${SLUG}"
OUT="intent/${INTENT_ID}.md"

# Avoid overwrite
if [[ -f "$OUT" ]]; then
  i=2
  while [[ -f "intent/${INTENT_ID}-${i}.md" ]]; do
    i=$((i + 1))
  done
  INTENT_ID="${INTENT_ID}-${i}"
  OUT="intent/${INTENT_ID}.md"
fi

TITLE="$(grep -E '^# ' "$FINDING" | head -n1 | sed 's/^# //' || true)"
[[ -z "$TITLE" ]] && TITLE="Finding: $SLUG"

PROBLEM="$(awk '
  /^## Problem/{flag=1; next}
  /^## /{if(flag) exit}
  flag{print}
' "$FINDING" | sed '/^$/d' | head -n 40)"
[[ -z "$PROBLEM" ]] && PROBLEM="See source finding: $FINDING"

cat > "$OUT" <<EOFINTENT
---
title: "$TITLE"
author: finding-to-intent.sh
status: draft
date: $DATE
revision: 1
acceptor: ""
jira_key: ""
figma_url: ""
source: maintain
---

# Intent: $TITLE

## Problem

$PROBLEM

Source finding: \`$FINDING\`

## Proposed outcome

Draft intent created by Maintain dry-run. Product owner should refine, then accept to open Design.

## Affected users and systems

- Platform operators on OWNER/REPO
- Engineers using Claude Code against this dogfood repo

## Constraints

- Chat is not SoT; this file is the record once committed
- Humans stay at judgment gates
- Do not bypass Deploy for code changes

## Open questions

1. Is this finding Important enough for a full Design/Build chain, or a small fix PR? (default: full chain if it touches hooks/gates)

## Success criteria

### Leading

- Intent accepted or closed with reason in git
- Linked finding remains readable

### Lagging

- Recurrence of the underlying band/signal declines after fix

## Status

draft — awaiting Plan play / PO accept.
EOFINTENT

echo "wrote $OUT"
echo "$OUT"
