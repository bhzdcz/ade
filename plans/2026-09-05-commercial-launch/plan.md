---
intent-id: 2026-09-05-commercial-launch
spec: specs/2026-09-05-commercial-launch/spec.md
status: accepted
engineer: Codex
date: 2026-09-05
authorization: "Behzad's explicit request to plan, rebuild, add and modify on branches"
---

# Plan: Commercial launch

## Approach

1. Audit repository, public access, competitors, hook contracts and deployment policy.
2. Add Python standard-library CLI (no registry dependency) with init, new, status, doctor and pack. Keep shell hook entry points compatible. Add MIT licensing for proposed toolkit release on this branch; no public release until owner review.
3. Harden hook canonical paths, malformed input, success permission behavior and active-intent validation. Keep the release check explicitly a stub. Replace destructive shell fixtures with isolated Python test harnesses; preserve existing cases and extend regression coverage.
4. Provide example, quickstart, architecture/security boundaries, commercial strategy, paid setup scope and launch runbook. Keep private history out of distribution.
5. Rebuild ade-site with native CSS and progressive JavaScript: dark graphite, restrained green from the original brand, pixel wordmark, readable sans body, 2px radii. Visual variance 5, motion 2, density 4. Product example is a working artifact explorer, not a fictional dashboard.
6. Add public docs, example downloads, inquiry brief generator, configured contact/checkout/Bitcoin support, privacy explanation and SEO. No unpublished product-code mirroring.
7. Verify CLI, hooks and bundle end to end; browser-test responsive/accessibility/interactions; run CI and open reviewable PRs on feat/commercial-launch. Do not merge or deploy.

## Validation

Run template checks, isolated hook regression tests, CLI integration tests, deterministic package checks, site link/config validation, browser tests at desktop/mobile sizes, keyboard and reduced-motion checks. Record actual results and unresolved owner setup in docs/launch-readiness.md.
