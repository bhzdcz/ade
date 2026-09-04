---
id: dogfood-sample-001
date: 2026-09-04
severity: medium
band_id: hook-deny-false-positive
owner: Behzad
status: open
---

# Finding: Dogfood sample — unexpected plan-before-edit friction

## Problem

During v1 dogfood scaffold validation, operators noted that without a clear allowlist, documentation edits could be blocked by plan-before-edit. The accepted plan defines an explicit allowlist; this sample finding exercises the Maintain path (finding to draft intent) once.

## Evidence

- Plan section on allowlist (docs/**, templates, findings/**, etc.)
- Hook fixtures under tests/fixtures/hooks/

## Suspected cause

Bootstrap chicken-and-egg / incomplete operator docs — not a live production incident.

## Suggested next step

- [x] Draft intent via scripts/finding-to-intent.sh (Maintain dry-run)
- [ ] Close after dry-run evidence is committed

## Status

open
