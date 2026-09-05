# Launch readiness: September 5, 2026

## Delivered for review

Both repositories are on `feat/commercial-launch`. No changes are pushed to main, merged, deployed, or used to change repository visibility. The old live website remains untouched.

The product now has an offline CLI with safe initialization, draft artifact scaffolding, status, diagnostics and reproducible packaging. Hooks canonicalize paths, deny malformed input and leave normal Claude permissions in control. Existing tests were replaced with isolated regressions, and the finding helper rejects unsafe output slugs. Public onboarding, a worked example, proposed licensing, contribution guidance, service scope and a commercial strategy are included.

The site has a redesigned responsive interface, interactive artifact explorer, public docs and example download, a setup inquiry builder using behzad@airoweb.com, privacy information and configurable funding paths. The site has no tracking or form-submission backend. Its CI produces a review artifact; the former automatic Pages deployment is removed from this proposed branch because the new offer needs an appropriate commercial host.

## Verification evidence

Local environment: macOS, Python 3.13, Node 24, Chromium via Playwright.

- Existing template contracts: pass.
- 11 isolated hook regression test methods: pass, including existing fixture scenarios, malformed input, traversal, symlinks, tool working directories, draft plans and production simulation behavior.
- 10 CLI/finding integration test methods: pass, including preview, settings preservation, repeatability, conflict failures, symlinks, no overwrite, status, doctor and reproducible package installation.
- 4 website build/config/link tests: pass, including address checksum validation and build output confinement.
- 14 browser tests across desktop and mobile: pass. Covers keyboard interaction, local inquiry preview and encoded email draft, clipboard fallback, downloads, no-JavaScript fallback, reduced motion, hidden/unconfigured funding and configured funding links.
- Axe WCAG 2 A/AA and 2.1 AA automated checks on home, docs, support and privacy: no violations in the tested desktop/mobile states. This is not a formal accessibility certification.
- Desktop and mobile screenshots visually inspected. The new social image is a capture of the actual page.

CI is configured for Python 3.10 and 3.13 on macOS and Ubuntu for the product, and Chromium website checks on Ubuntu. Remote CI outcomes are reported in the PR checks; local tests alone do not establish results on every platform.

## What is not proven

No fresh live Claude Code session was run as part of verification. Hook behavior was exercised through real hook processes using representative payloads and checked against the official hook contract. Restart and verify hook registration in the intended Claude installation before relying on it.

No external customer outcome, conversion rate, revenue or market demand is claimed. No live payment has been tested; no payment or sponsorship destination was supplied. Bitcoin support accepts owner-verified native SegWit mainnet addresses only. Local checks cannot authenticate human approval; real deployments require protected environments.

## Owner actions before commercial launch

1. Review and merge the branches when satisfied. The price (€490) and MIT core license are proposals for owner approval.
2. Choose a host whose terms support the commercial site, deploy the tested `dist/`, configure ade.ir and update the privacy page with the actual host. Do not enable the storefront on GitHub Pages.
3. Confirm seller/invoice identity, service availability, taxes, cancellation/refund terms and payment method. For scoped setup work, a hosted invoice is a practical starting point. Add a checkout URL only after this is ready.
4. Decide the public core release: review the clean package and source contents before publishing. The private repository includes historical internal artifacts, so changing its visibility is not part of this work.
5. Optionally supply a verified Bitcoin receiving address or complete GitHub Sponsors onboarding. No private keys are needed or accepted by the site.
6. Run one real customer-style onboarding session and record friction before broad promotion.

## Reading order

- [Commercial strategy](commercial-strategy.md): positioning, alternatives, revenue experiment and first-month plan.
- [Service scope](services.md): the proposed €490 deliverable and boundaries.
- [Quickstart](how-to-run.md): actual commands and workflow.
- [Security boundaries](../SECURITY.md): what the local checks cannot enforce.
