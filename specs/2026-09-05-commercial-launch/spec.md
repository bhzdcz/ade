---
title: "Commercial launch"
author: Codex
status: accepted
date: 2026-09-05
intent: intent/2026-09-05-commercial-launch.md
acceptor: Behzad
---

# Spec: Commercial launch

## Summary

Deliver ADE as a local, Git-based workflow toolkit for small teams using Claude Code. Preserve the artifact chain and human review. Broad implementation authorization is recorded in the source intent; no claim of separate line-by-line user sign-off.

## Goals and non-goals

Add dependency-light CLI installation, draft artifact scaffolding, status, diagnostics, package creation, and a complete example. Fix hook path handling and permission escalation. Add onboarding, contribution and commercial documentation. Redesign the static public site with working interactions, public explanations, paid setup brief generation, optional configured payments/donations, and automated checks. Do not create a hosted agent runtime or subscription backend.

## Acceptance criteria

- Installation previews changes, never overwrites user files, merges only ADE hooks, is repeatable, and rejects symlink escapes.
- New work starts in draft; agent commands never mark human acceptance.
- Hooks deny invalid input and escaped paths, and abstain on successful checks so normal permissions apply.
- Tests run in temporary repositories on macOS and Linux.
- Marketing is usable on narrow screens and keyboards, contains no fabricated customers/results, and never advertises unavailable public source or a working checkout without configuration.
- Donation links validate destinations. Pricing is a proposal until the owner enables a sales contact or checkout.
- Product packaging includes a manifest and checksums, excludes historical private artifacts, and remains private pending release approval.
- CI validates product and website; Pages uploads only built public assets and does not deploy branches.

## Flagged concerns

Local writable artifacts do not authenticate reviewers. Hooks are workflow checks, not security boundaries. The promote command remains a simulation; real deployments require protected environments. GitHub Pages commercial-use policy requires a hosting decision before activating a sales storefront. No revenue can be guaranteed.

## Out of scope

Main pushes, merges, live deployment, changing repository visibility, opening financial accounts, DNS changes, or publishing private sources.
