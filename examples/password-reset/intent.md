---
title: "Let users recover access"
status: draft
source: example
---

# Intent: Let users recover access

## Problem

A user who forgets their password currently needs support to regain access.

## Proposed outcome

Users can request a reset email and choose a new password without revealing whether an email address has an account.

## Constraints

Keep the existing authentication provider. No account migration or changes to social sign-in. Never log reset tokens.

## Success criteria

A valid request completes the recovery flow. Expired and reused links cannot change a password.
