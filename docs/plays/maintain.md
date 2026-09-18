# Play: Maintain — close the loop

## v1 path

1. Detection stays deterministic (`bands.yaml` schema; watcher thin/manual).
2. Open a finding from `findings/_template.md` (copy to `findings/<slug>.md`).
3. Draft intent: `bash scripts/finding-to-intent.sh <finding.md>`.
4. PO accepts intent → normal Plan → Design → Build chain. Do not bypass Deploy for code changes.
5. Prefer PR for fixes; pre-approved runbooks only where explicitly listed.

## bands.yaml usage

Each band: `metric`, `threshold`, `window`, `severity`, `owner`, `intent_template`. Breach → finding → intent.

## v2 (deferred)

Live watcher, scheduled scans, on-call routing, automated band → intent.
