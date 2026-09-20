#!/usr/bin/env bash
# Optional Jev / System One Noul check (spike).
# Usage: jev-noul-check.sh <path> <summary>
# Exit: 0 allow · 1 deny · 2 misconfig (gate ON, no key, not stub)
# Never logs or echoes ADE_JEV_API_KEY.

set -euo pipefail

PATH_ARG="${1:-}"
SUMMARY_ARG="${2:-}"

ADE_JEV_GATE="${ADE_JEV_GATE:-}"
ADE_JEV_API_KEY="${ADE_JEV_API_KEY:-}"
ADE_JEV_THRESHOLD="${ADE_JEV_THRESHOLD:-0.8}"
ADE_JEV_MODEL="${ADE_JEV_MODEL:-jev-latest}"
ADE_JEV_URL="${ADE_JEV_URL:-https://api.typesafe.ai/v1/systemone}"
ADE_JEV_STUB="${ADE_JEV_STUB:-}"
ADE_JEV_STUB_P="${ADE_JEV_STUB_P:-}"
# curl timeout seconds (5–10s window)
ADE_JEV_TIMEOUT="${ADE_JEV_TIMEOUT:-8}"

gate_on() {
  case "${ADE_JEV_GATE,,}" in
    1|true|yes|on) return 0 ;;
    *) return 1 ;;
  esac
}

stub_on() {
  case "${ADE_JEV_STUB,,}" in
    1|true|yes|on) return 0 ;;
    *) return 1 ;;
  esac
}

usage() {
  echo "usage: jev-noul-check.sh <path> <summary>" >&2
  echo "  Env: ADE_JEV_GATE ADE_JEV_API_KEY ADE_JEV_THRESHOLD ADE_JEV_MODEL ADE_JEV_URL ADE_JEV_STUB [ADE_JEV_STUB_P]" >&2
}

if [[ -z "$PATH_ARG" ]]; then
  usage
  exit 2
fi

# Gate OFF → allow, zero network
if ! gate_on; then
  echo "jev-noul: allow (gate OFF)"
  exit 0
fi

# Redact KEY=... and high-entropy-looking tokens from summary before any use/print
redact_summary() {
  local s="$1"
  # KEY=value / API_KEY=value / *_KEY=value (non-greedy-ish line fragments)
  s="$(printf '%s' "$s" | sed -E \
    -e 's/([A-Za-z0-9_]*KEY)=[^[:space:]]+/\1=[REDACTED]/g' \
    -e 's/(Bearer[[:space:]]+)[A-Za-z0-9._~+\/=-]{12,}/\1[REDACTED]/g' \
    -e 's/\bsk-[A-Za-z0-9]{8,}/[REDACTED]/g' \
    -e 's/\b[A-Za-z0-9+\/=]{40,}/[REDACTED-HIGH-ENTROPY]/g')"
  # Cap length ~700 chars
  if [[ ${#s} -gt 700 ]]; then
    s="${s:0:700}…"
  fi
  printf '%s' "$s"
}

SUMMARY="$(redact_summary "$SUMMARY_ARG")"

parse_p_from_stub() {
  # Prefer ADE_JEV_STUB_P; else summary marker jev-stub-p=N or jev-stub-p:N
  local p=""
  if [[ -n "$ADE_JEV_STUB_P" ]]; then
    p="$ADE_JEV_STUB_P"
  elif [[ "$SUMMARY_ARG" =~ [Jj][Ee][Vv]-[Ss][Tt][Uu][Bb]-[Pp][=:]([0-9]*\.?[0-9]+) ]]; then
    p="${BASH_REMATCH[1]}"
  else
    # Deterministic default allow path for stub rehearsals
    p="0.9"
  fi
  printf '%s' "$p"
}

decide() {
  local p="$1"
  local thr="$ADE_JEV_THRESHOLD"
  # awk float compare
  if awk -v p="$p" -v t="$thr" 'BEGIN { exit (p+0 >= t+0) ? 0 : 1 }'; then
    echo "jev-noul: allow path=$PATH_ARG p=$p threshold=$thr"
    exit 0
  else
    echo "jev-noul: deny path=$PATH_ARG p=$p threshold=$thr — human can retry / adjust summary / set ADE_JEV_GATE=0" >&2
    echo "jev-noul: deny path=$PATH_ARG p=$p threshold=$thr"
    exit 1
  fi
}

if stub_on; then
  p="$(parse_p_from_stub)"
  decide "$p"
fi

# Live path: require key
if [[ -z "$ADE_JEV_API_KEY" ]]; then
  echo "jev-noul: misconfig — ADE_JEV_GATE is ON but ADE_JEV_API_KEY is unset; set ADE_JEV_API_KEY or ADE_JEV_STUB=1" >&2
  exit 2
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "jev-noul: deny — curl not available (fail-closed while gate ON)" >&2
  exit 1
fi

# Assumed System One request body (spike). Response field documented in docs/optional-jev-gate.md: top-level "p".
payload="$(PATH_JSON="$PATH_ARG" SUMMARY_JSON="$SUMMARY" MODEL_JSON="$ADE_JEV_MODEL" python3 -c '
import json, os
print(json.dumps({
  "model": os.environ["MODEL_JSON"],
  "path": os.environ["PATH_JSON"],
  "summary": os.environ["SUMMARY_JSON"],
}))
')"

tmp_body="$(mktemp)"
tmp_err="$(mktemp)"
cleanup() { rm -f "$tmp_body" "$tmp_err"; }
trap cleanup EXIT

http_code=0
set +e
http_code="$(curl -sS -o "$tmp_body" -w '%{http_code}' \
  --connect-timeout "$ADE_JEV_TIMEOUT" \
  --max-time "$ADE_JEV_TIMEOUT" \
  -X POST "$ADE_JEV_URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${ADE_JEV_API_KEY}" \
  -d "$payload" 2>"$tmp_err")"
curl_rc=$?
set -e

if [[ "$curl_rc" -ne 0 ]]; then
  echo "jev-noul: deny — network/timeout calling System One (fail-closed; curl_rc=$curl_rc)" >&2
  exit 1
fi

if [[ "$http_code" -lt 200 || "$http_code" -ge 300 ]]; then
  echo "jev-noul: deny — System One HTTP $http_code (fail-closed)" >&2
  exit 1
fi

# Parse p from response: prefer .p, then .probability, then .data.p
p="$(python3 -c '
import json,sys
try:
  d=json.load(open(sys.argv[1]))
except Exception:
  print(""); sys.exit(0)
def dig(obj,*keys):
  for k in keys:
    if isinstance(obj,dict) and k in obj: return obj[k]
  return None
v = dig(d,"p","probability")
if v is None and isinstance(d.get("data"),dict):
  v = dig(d["data"],"p","probability")
if v is None:
  print("")
else:
  print(v)
' "$tmp_body")"

if [[ -z "$p" ]]; then
  echo "jev-noul: deny — could not parse probability p from response (fail-closed)" >&2
  exit 1
fi

decide "$p"
