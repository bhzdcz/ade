---
title: "Password recovery behavior"
status: draft
source: example
---

# Spec: Password recovery behavior

## Acceptance criteria

- A reset request returns the same public response for known and unknown email addresses.
- A token expires after 30 minutes and can be used only once.
- A successful reset invalidates existing sessions according to the authentication provider's supported mechanism.
- Expired, malformed and reused tokens return an actionable error without changing credentials.
- Rate limiting applies to reset requests; tokens never appear in application logs.

## Out of scope

Social sign-in changes, new authentication providers and a new email delivery service.
