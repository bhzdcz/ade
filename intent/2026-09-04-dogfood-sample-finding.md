---
title: "Finding: Dogfood sample — unexpected plan-before-edit friction"
author: finding-to-intent.sh
status: draft
date: 2026-09-04
revision: 1
acceptor: ""
jira_key: ""
figma_url: ""
source: maintain
---

# Intent: Finding: Dogfood sample — unexpected plan-before-edit friction

## Problem

During v1 dogfood scaffold validation, operators noted that without a clear allowlist, documentation edits could be blocked by plan-before-edit. The accepted plan defines an explicit allowlist; this sample finding exercises the Maintain path (finding to draft intent) once.

Source finding: `findings/examples/dogfood-sample.md`

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
