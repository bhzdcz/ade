# Optional Jev / System One Noul gate (spike)

Thin, **opt-in** PreToolUse Noul beside `production-gate.sh`. Default **OFF**. Does **not** replace attestation, `release-managers.txt`, or human PR gates. Not required for the README quickstart.

## What it does

When `ADE_JEV_GATE` is ON, Edit|Write|MultiEdit tools build a short path + diff summary and call `scripts/jev-noul-check.sh`. That script asks Typesafe System One (`jev-latest`) for a probability `p`. Allow if `p >= threshold` (default **0.8**); otherwise deny with a human-readable message.

## Env

| Var | Default | Purpose |
| --- | --- | --- |
| `ADE_JEV_GATE` | off (unset/`0`) | Set `1`/`true` to enable. Unset/empty/`0` = OFF. |
| `ADE_JEV_API_KEY` | — | Bearer key for live calls. **Never commit.** Required when gate ON and not stubbing. |
| `ADE_JEV_THRESHOLD` | `0.8` | Allow when `p >=` this float. |
| `ADE_JEV_MODEL` | `jev-latest` | Model id sent to System One. |
| `ADE_JEV_URL` | `https://api.typesafe.ai/v1/systemone` | POST endpoint. |
| `ADE_JEV_STUB` | off | `1`/`true` → no network; deterministic stub `p`. |
| `ADE_JEV_STUB_P` | `0.9` (when stub on and unset) | Stub probability. Or put `jev-stub-p=0.3` in the summary. |
| `ADE_JEV_TIMEOUT` | `8` | curl connect/max time seconds (5–10s window). |

## Response field (assumed until live probe)

Spike assumes JSON field **`p`** (fallback: `probability`, or under `data`). Documented here so operators know what to expect; adjust after one local live probe.

## Deny rehearsal (offline)

```bash
# Allow path (p >= 0.8)
ADE_JEV_GATE=1 ADE_JEV_STUB=1 ADE_JEV_STUB_P=0.9 \
  bash scripts/jev-noul-check.sh docs/optional-jev-gate.md "safe doc tweak"

# Deny path (p < 0.8)
ADE_JEV_GATE=1 ADE_JEV_STUB=1 ADE_JEV_STUB_P=0.3 \
  bash scripts/jev-noul-check.sh scripts/promote.sh "risky summary jev-stub-p=0.3"

# Misconfig when ON without key (not stub)
ADE_JEV_GATE=1 bash scripts/jev-noul-check.sh README.md "x"; echo exit:$?
# → exit 2, message to set ADE_JEV_API_KEY or ADE_JEV_STUB=1
```

Hook dry-run (gate OFF → fast allow):

```bash
printf '%s' '{"tool_name":"Write","tool_input":{"file_path":"README.md","content":"x"}}' \
  | ADE_JEV_GATE=0 CLAUDE_PROJECT_DIR="$PWD" bash .claude/hooks/jev-noul-gate.sh
```

## Failure modes (gate ON)

| Case | Behavior |
| --- | --- |
| No key and not stub | Exit **2** / hook deny — clear misconfig message |
| Network error / timeout | Deny (fail-closed) |
| Gate OFF | Allow; zero network |

## Non-goals

- Dual-call from `production-gate.sh` / `promote.sh` (deferred)
- Secrets in git or CI for this spike
- README quickstart dependency on Jev
