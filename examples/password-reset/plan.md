---
title: "Implement password recovery"
status: draft
source: example
---

# Plan: Implement password recovery

## Changes

Use the existing authentication provider's reset API. Add request and confirmation views to the application. Connect the existing transactional email template. Keep provider credentials server-side.

## Validation

Test request response parity, token expiry, one-time use, rate limiting and session invalidation. Exercise success and invalid-link paths in the browser. Inspect logs for accidental token disclosure.

## Human review

Review the provider's actual capabilities and the application's session model before accepting this plan. Confirm the test results in a pull request. Deploy only through the application's protected environment.
