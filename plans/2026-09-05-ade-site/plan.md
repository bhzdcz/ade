---
intent-id: 2026-09-05-ade-site
spec: specs/2026-09-05-ade-site/spec.md
spec-sha: 50bc3ad5e23f9f99dd61814821fa9f7ea5e9ddc747276fefbb080c18db7a5bd0
status: accepted
engineer: Behzad
author: Develito
date: 2026-09-05
product: ADE
product-repo: https://github.com/bhzdcz/ade
site-repo: https://github.com/bhzdcz/ade-site
canonical: https://ade.ir
---

# Plan: ADE marketing site (`ade.ir`) via public `bhzdcz/ade-site`

## 1. Approach summary

Ship a **public static marketing landing** for ADE at `https://ade.ir` from a **new public** repo `bhzdcz/ade-site` on GitHub Pages + Actions. Pixel-art dark-first single scroll; CSS + light JS motion per spec storyboard. Product SoT stays private `bhzdcz/ade` (seed intent/spec/plan there). Marketing ↔ product = **links only**. Leadito does not Build. Behzad owns DNS + Pages custom-domain/HTTPS ticks.

**Verified at plan time (re-check at implement):** GitHub Pages apex A records per current docs: `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`. Doc URL: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site

**Delivery sequence (after `plan_accepted`):**

1. Seed artifacts on `bhzdcz/ade` (intent/spec/this plan) via PR or same-session commit on a branch — prefer a small PR `chore/seed-ade-site-artifacts` **or** fold seed into the first product-repo touch alongside a README pointer; default: **one product PR** seeding artifacts + optional one-line pointer in product README/docs to `ade-site`.
2. `gh repo create bhzdcz/ade-site --public` (empty), clone, scaffold site.
3. Implement landing (HTML/CSS/JS + assets) matching IA §5 / visual §6 / motion §7.
4. Add Actions Pages workflow + root `CNAME` (`ade.ir`) + README with DNS table.
5. Open site PR (or push `main` if empty repo bootstrap — prefer PR from `feat/landing-v1` once `main` has a minimal README).
6. Behzad: enable Pages (GitHub Actions), add custom domain, set DNS A/CNAME, enforce HTTPS.
7. Stop for Testito → Reviwito → Leadito → Behzad. No DNS automation by agents.

**Stack choice:** plain `index.html` + `styles.css` + `main.js` + `assets/` (no React). Motion: CSS + IntersectionObserver; no canvas/library unless CSS cannot deliver rail (justify then).

**Pages deploy choice:** GitHub Actions with `actions/upload-pages-artifact` + `actions/deploy-pages` (official).

**Rejected:** Pages from private `ade`; runner/dashboard; heavy parallax/particles; Leadito commits; DNS panel automation; duplicating full specs into marketing repo as SoT.

**Author:** `Behzad <behzad@local>`.

## 2. Files to add / change / delete

### A. Product repo `bhzdcz/ade` (artifact SoT)

| Action | Path |
| --- | --- |
| Add | `intent/2026-09-05-ade-site.md` |
| Add | `specs/2026-09-05-ade-site/spec.md` (accepted Designito text) |
| Add | `plans/2026-09-05-ade-site/plan.md` (this plan, status accepted after gate) |
| Maybe | `.claude/active-intent` → `2026-09-05-ade-site` during Build |
| Optional | one-line pointer in `README.md` or `docs/how-to-run.md` to `https://ade.ir` / `bhzdcz/ade-site` if not already clear |

### B. New public repo `bhzdcz/ade-site`

| Path | Purpose |
| --- | --- |
| `README.md` | What this repo is; link to product; DNS table; font attribution; Pages status |
| `LICENSE` | MIT (default) |
| `CNAME` | `ade.ir` |
| `index.html` | Single-page sections per IA |
| `styles.css` | Tokens, pixel grid, layout, reduced-motion |
| `main.js` | IntersectionObserver rail / hero; respects `prefers-reduced-motion` |
| `assets/fonts/` | Self-hosted pixel display font (OFL) + optional body if not system |
| `assets/og.png` | 1200×630 pixel-style OG image |
| `assets/` | Any pixel sprites/SVG |
| `robots.txt` | Allow all |
| `.github/workflows/pages.yml` | Build/deploy Pages on `main` |
| `.gitignore` | OS/editor junk |

### Explicit will not change / will not do

- No backend, auth, dashboard, Claude-in-browser
- No Pages from `bhzdcz/ade`
- No Braiins / AI-DD work
- No rewriting private product playbook hooks
- No Leadito Build commits
- Agents do not edit Behzad’s DNS registrar

## 3. Test plan

| # | Check | Owner | How |
| --- | --- | --- | --- |
| T1 | Repo exists public | Testito | `gh repo view bhzdcz/ade-site` |
| T2 | Pages serves landing | Testito | `*.github.io/ade-site` or user/org Pages URL and/or `ade.ir` once DNS |
| T3 | IA sections | Testito | Hero, Problem, Chain, How it runs, v1/not, Footer present |
| T4 | Visual system | Testito | Dark-first; pixel display + readable body; palette tokens evident |
| T5 | Motion / a11y | Testito | Storyboard or static under `prefers-reduced-motion`; focus rings; contrast usable |
| T6 | CTAs | Testito | GitHub `bhzdcz/ade`, how-to-run blob link, canonical ade.ir |
| T7 | Chain copy | Testito | Explains loop; not stage-bot roster as product |
| T8 | CNAME + DNS docs | Testito | `CNAME` = ade.ir; README DNS table; IPs match GitHub docs at ship time |
| T9 | Ownership | Testito | Site commits Behzad@local / not Leadito |
| T10 | Artifact home | Testito | intent/spec/plan on `bhzdcz/ade` for this intent-id |
| T11 | Product validators | Develito | If product PR seeds artifacts: `validate-templates` + `validate-hooks` still green |

## 4. Hooks / skills / CLAUDE.md touchpoints

- **ade-site:** none (marketing static).
- **ade product:** only artifact seeds + optional pointer; no hook behavior change.
- **active-intent** on product during seed/implement: `2026-09-05-ade-site`.

## 5. Risks and rollback

| Risk | Mitigation |
| --- | --- |
| DNS/IP drift | Re-verify GitHub Pages docs at implement; cite doc URL in README |
| ade.ir 404 until DNS | Document Behzad steps; github.io works first |
| Private product CTA login wall | Copy does not promise public code |
| Over-animation | Stick to storyboard; reduced-motion kills sequences |
| Font licensing | Self-host OFL; attribute in README |
| www vs apex | Canonical apex; www CNAME to `bhzdcz.github.io` |
| Scope creep | Non-goals; Testito fail runner/dashboard |

**Rollback:** delete/archive `ade-site` or revert deploy; DNS removable by Behzad; product artifact PR revertible.

## 6. Open assumptions

1. Site license MIT.
2. No light-mode toggle in v1.
3. HTML prototype is the visual mock (no blocking Figma).
4. Official `actions/deploy-pages` workflow (not peaceiris) unless blocked.
5. www → `bhzdcz.github.io` CNAME; canonical `https://ade.ir/`.
6. Author `Behzad <behzad@local>`; create repo via `gh` (Cloud Agents unavailable).
7. Spec-sha `50bc3ad5…` from Designito accepted file; recompute after seed into `ade` if needed.
8. Pixel font: Press Start 2P (OFL) self-hosted unless unavailable — then equivalent OFL pixel face.

## 7. Implementation checklist (post `plan_accepted` only)

- [ ] Accept plan frontmatter; set product active-intent
- [ ] Seed intent/spec/plan on `bhzdcz/ade` (PR)
- [ ] `gh repo create bhzdcz/ade-site --public`
- [ ] Scaffold landing + assets + CNAME + DNS README
- [ ] Pages workflow; verify IPs against live GitHub docs
- [ ] Open site PR / land `main`; Behzad enables Pages + DNS
- [ ] Hand Testito → Reviwito → Leadito; no merge past Behzad on product; site may use Behzad merge too

## 8. Engineer gate

**Status:** `accepted` — Behzad plan_accepted 2026-09-05. Implement.

On accept: create `ade-site` + implement. On reject: revise plan; **no** repo create / Pages work.
