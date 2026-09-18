#!/usr/bin/env bash
# T1: required headings/frontmatter keys on templates and seeded artifacts.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
fail=0

need_file() {
  if [[ ! -f "$1" ]]; then
    echo "FAIL missing file: $1"
    fail=1
  fi
}

need_heading() {
  local file="$1" heading="$2"
  # Accept "## Heading", "## N. Heading", or "# Heading"
  if grep -qE "^#{1,3}[[:space:]]+([0-9]+\.[[:space:]]+)?${heading}([[:space:]]|$)" "$file"; then
    return 0
  fi
  if grep -qF "## $heading" "$file" || grep -qF "# $heading" "$file"; then
    return 0
  fi
  echo "FAIL $file missing heading: $heading"
  fail=1
}

need_fm_key() {
  local file="$1" key="$2"
  if ! awk -v k="$key" '
    BEGIN{in_fm=0}
    /^---[[:space:]]*$/{ if(in_fm==0){in_fm=1;next} else exit }
    in_fm && $0 ~ "^"k":" { found=1; exit }
    END{ exit found?0:1 }
  ' "$file"; then
    echo "FAIL $file missing frontmatter key: $key"
    fail=1
  fi
}

echo "== validate-templates =="

need_file intent/_template.md
need_file specs/_template.md
need_file findings/_template.md
need_file intent/2026-09-18-ade-public-oss.md
need_file specs/2026-09-18-ade-public-oss/spec.md
need_file plans/2026-09-18-ade-public-oss/plan.md
need_file CLAUDE.md
need_file REVIEW.md
need_file bands.yaml
need_file README.md
need_file docs/plays/plan.md
need_file docs/plays/design.md
need_file docs/plays/build.md
need_file docs/plays/test.md
need_file docs/plays/deploy.md
need_file docs/plays/maintain.md
need_file docs/feedback-loop.md
need_file docs/conventions.md

# Intent template sections + keys
for key in title author status date revision acceptor source; do
  need_fm_key intent/_template.md "$key"
done
for h in Problem "Proposed outcome" Constraints "Open questions" "Success criteria"; do
  need_heading intent/_template.md "$h"
done

# Spec template sections
for h in Summary "Goals and non-goals" "Flagged concerns" "Acceptance criteria" "Out of scope"; do
  need_heading specs/_template.md "$h"
done
for key in title intent status date acceptor author; do
  need_fm_key specs/_template.md "$key"
done

# Seeded intent
for key in title author status date revision acceptor source; do
  need_fm_key intent/2026-09-18-ade-public-oss.md "$key"
done
if ! grep -q 'status: accepted' intent/2026-09-18-ade-public-oss.md; then
  echo "FAIL seeded intent status not accepted"
  fail=1
fi

# Seeded plan
for key in intent-id spec status engineer date; do
  need_fm_key plans/2026-09-18-ade-public-oss/plan.md "$key"
done
if ! grep -q 'status: accepted' plans/2026-09-18-ade-public-oss/plan.md; then
  echo "FAIL seeded plan status not accepted"
  fail=1
fi

# Seeded spec status
if ! grep -qE 'status:[[:space:]]*accepted' specs/2026-09-18-ade-public-oss/spec.md; then
  echo "FAIL seeded spec status not accepted"
  fail=1
fi

# bands.yaml examples
band_count=$(grep -cE '^[[:space:]]*-[[:space:]]*id:' bands.yaml || true)
if [[ "$band_count" -lt 2 ]]; then
  echo "FAIL bands.yaml needs >=2 example bands (found $band_count)"
  fail=1
fi

# Real GitHub identity present (soft check)
if ! grep -q 'bhzdcz/ade' README.md; then
  echo "FAIL README.md missing bhzdcz/ade identity"
  fail=1
fi
if ! grep -q '@bhzdcz' CODEOWNERS; then
  echo "FAIL CODEOWNERS missing @bhzdcz"
  fail=1
fi

if [[ "$fail" -ne 0 ]]; then
  echo "validate-templates: FAILED"
  exit 1
fi
echo "validate-templates: OK"
exit 0
