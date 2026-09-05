# Spec: ADE marketing site (`ade.ir`) via public `bhzdcz/ade-site`

Author: Designito (Stage 2). Status: accepted. Signed off by Behzad (PO) on 2026-09-05. Event: spec_signed_off — Develito plan mode.
Date: 2026-09-05.
Intent-id: `2026-09-05-ade-site`
Source intent: accepted by Behzad (PO) on 2026-09-05 (host decision locked).
Product repo: `https://github.com/bhzdcz/ade` (private) — platform SoT.
Site repo: `https://github.com/bhzdcz/ade-site` (public, new) — GitHub Pages only.
Canonical URL: `https://ade.ir`
Event chain: `spec_signed_off` → Develito plan mode. **Leadito does not Build.**

## 1. Summary

Ship a **public marketing landing** for ADE at `https://ade.ir`: single dark-first scroll page, **pixel-art (“pixelar”)** aesthetic with **high-end but meaningful** animation. Hosting is **GitHub Pages from a new public repo `bhzdcz/ade-site`**, not from private `bhzdcz/ade`. Behzad configures DNS for the custom domain.

The site **explains** ADE and links to the product; it does **not** run the SDLC, show dashboards, or replace git artifacts.

## 2. Goals and non-goals

### Goals

1. Create public repo `bhzdcz/ade-site` and deploy a static landing via GitHub Pages + Actions.
2. Pixel-art visual system + restrained, story-driven motion (not decoration spam).
3. Dark-first single-page scroll (default experience).
4. CTAs: GitHub product `bhzdcz/ade`, `docs/how-to-run` (on product repo), canonical `ade.ir`.
5. Explain the artifact chain simply (intent → spec → plan → diff → review → gates → maintain).
6. Document DNS/CNAME records for Behzad; a11y including `prefers-reduced-motion`.
7. Clarify marketing repo ↔ product repo relationship: **link only**.

### Non-goals

- Runner, dashboard, auth, or in-browser Claude
- Publishing Pages from private `bhzdcz/ade`
- Building Braiins adoption tooling or AI-DD UI
- Behzad’s DNS panel automation (document records only; he sets DNS)
- Light-mode-first experience (optional later toggle out of v1 unless trivial)
- Multi-page docs portal (link out to product `docs/how-to-run.md` instead)
- Leadito Build authorship

## 3. Artifact home recommendation

| Artifact | Recommended home | Why |
| --- | --- | --- |
| `intent/2026-09-05-ade-site.md` | **`bhzdcz/ade`** | Platform remains SoT for the chain |
| `specs/2026-09-05-ade-site/spec.md` | **`bhzdcz/ade`** | Same |
| `plans/2026-09-05-ade-site/plan.md` | **`bhzdcz/ade`** | Same |
| Site source (`index.html`, assets, Actions) | **`bhzdcz/ade-site`** | Public Pages cannot ship from private product repo without awkward mirrors |

Build may mirror a short `README` pointer in `ade-site` back to the intent-id on `ade`. Do **not** duplicate full specs into the marketing repo as SoT.

## 4. Stage ownership (binding)

| Stage | Owner | Action |
| --- | --- | --- |
| Plan | Planito | Accepted intent (done) |
| Design | Designito | This spec (+ optional Figma/pixel mock if Build wants; not blocking if HTML prototype is the mock) |
| Build | **Develito** | plan.md; create `ade-site`; implement landing; Pages/Actions |
| Test | Testito | §12 checklist |
| Review / gates | Reviwito → Leadito | Findings never approve |
| PO / DNS / Pages approve | Behzad | Merge; DNS; enable Pages |

**Hard rule:** Leadito does not Build.

## 5. Information architecture (single scroll)

One route: `/` (and GitHub Pages project/user site root). Sections in order:

1. **Hero** — ADE name lockup (pixel wordmark), one-line value (“AI-native SDLC — artifacts on rails, humans at the gates”), primary CTA **View on GitHub** → `https://github.com/bhzdcz/ade`, secondary **How to run** → raw/blob link to `docs/how-to-run.md` on `bhzdcz/ade` (and/or `https://github.com/bhzdcz/ade/blob/main/docs/how-to-run.md`).
2. **Problem** — Chat isn’t a handoff; code isn’t the bottleneck; controls assume a human did every step.
3. **Artifact chain** — Simple horizontal or stepped pixel “rail”: `intent` → `spec` → `plan` → `diff+tests` → `REVIEW` → `gates` → `Maintain` → new `intent`. Plain-language captions; no stage-bot roster as the product.
4. **How it runs** — Git + Claude Code + PRs; hooks as must-holds; humans at judgment gates. CTA repeat: How to run.
5. **What’s in v1 / not** — Honest scope (contracts, hooks, dogfood; not live watcher / multi-harness / this site as a console).
6. **Footer** — `ade.ir` canonical, GitHub links (`ade`, `ade-site`), © / Apache-or-site-license note TBD in Build (default: site MIT or match product if declared), tiny pixel colophon.

No nav drawer required; optional sticky mini-rail of section anchors if it stays ≤1 row and pixel-styled.

## 6. Visual system (pixelar)

### 6.1 Grid and scale

- **Base pixel unit:** 4 CSS px = 1 “texel” (design in 4px multiples).
- **Layout max width:** 960–1040px content column; generous side margin on large screens.
- **Corners:** hard (0–2px); no soft Material blobs.
- **Imagery:** CSS shapes, inline SVG pixel grids, or PNG sprites at integer scale (`image-rendering: pixelated`). No stock 3D glassmorphism.

### 6.2 Palette (dark-first)

| Token | Hex | Use |
| --- | --- | --- |
| `--bg` | `#0B0D12` | Page background |
| `--bg-elev` | `#12161F` | Section panels |
| `--ink` | `#E6EAF2` | Primary text |
| `--muted` | `#8B93A7` | Secondary text |
| `--line` | `#2A3142` | Borders / rail tracks |
| `--accent` | `#5CFF9A` | ADE “signal” / CTAs / active rail node |
| `--accent-2` | `#6BCBFF` | Secondary highlight (chain arrows) |
| `--warn` | `#FFC857` | Optional “gate” marker |
| `--danger` | `#FF5C7A` | Rare; errors only |

Accent usage ≤ ~10% of viewport — high-end feel comes from restraint + motion timing, not neon soup.

### 6.3 Typography

- **Display / wordmark:** pixel font (e.g. “Press Start 2P” or similar OFL pixel face) — **ADE** lockup + section labels only. Load via self-hosted files in `ade-site` (preferred) or Google Fonts with font-display swap.
- **Body:** readable humanist or neo-grotesk for long copy (e.g. IBM Plex Sans / Source Sans 3) — **not** pixel for paragraphs (a11y + legibility).
- **Mono snippets** (artifact names): system mono or IBM Plex Mono, small caps optional via CSS.

Minimum body size 16px; line-length ~60–75ch.

### 6.4 UI chrome

- Primary button: solid `--accent` on `--bg`, 4px outer square border, hover = 1 texel translate or inset shadow (pixel “press”).
- Secondary button: outline `--line` / `--ink`.
- Focus: 2-texel `--accent-2` outline; never remove focus rings.

## 7. Motion storyboard (meaningful only)

Default stack: **CSS** (+ minimal JS for intersection / reduced-motion). Canvas or a motion library **only if** CSS cannot deliver the rail sequence cleanly — justify in `plan.md`.

| Beat | Trigger | Motion | Why it exists |
| --- | --- | --- | --- |
| Hero enter | Load | Wordmark texels fade/step in L→R (≤600ms); CTA delay 200ms | Brand presence without splash bloat |
| Scroll hint | Hero in view | Soft bob on chevron (pause if reduced-motion) | Affordance for single-page |
| Chain rail | Section ≥40% visible | Nodes light `--accent` in order along the rail; connector dashes draw | Teaches the product metaphor |
| Gate pulse | Node “gates” | Brief `--warn` flash then settle | Humans-at-gates message |
| CTA hover | Pointer | 1-texel press + accent border | Tactile pixel affordance |
| Parallax | **Avoid** heavy parallax | — | Fights pixel grid; skip in v1 |

**`prefers-reduced-motion: reduce`:** disable sequential draws, bobbing, and step-ins; show final static states immediately; keep color/contrast.

No autoplay video, no audio, no infinite spinners as content.

## 8. Content requirements (copy constraints)

- Lead with **ADE**, not Inkrail (historical name may appear once as “formerly” only if helpful — default omit).
- Product = playbook loop / contracts — **not** a roster of chat personas.
- Private product repo CTA is fine; copy must not claim the landing hosts the platform runtime.
- Link `https://ade.ir` as canonical (og:url, footer).
- How-to-run points at **product** repo file, not a duplicate essay on the marketing site.

## 9. Technical shape (`ade-site`)

### 9.1 Stack (v1 default)

- Static: `index.html`, `styles.css`, `main.js` (or equivalent small set), `assets/`
- No React/SPA framework required for one page; Build may use a tiny static generator only if it keeps Pages simple
- No backend

### 9.2 GitHub Pages + Actions

1. Create public `bhzdcz/ade-site`.
2. Workflow on `main`: checkout → (optional lint) → upload Pages artifact → deploy with `actions/deploy-pages` (or classic `peaceiris/actions-gh-pages` if simpler — pick one in plan.md).
3. Repo Settings → Pages: deploy from GitHub Actions; custom domain `ade.ir`.
4. Commit `CNAME` file containing `ade.ir` at site root (Pages custom domain).
5. Enforce HTTPS once DNS propagates (Behzad ticks in Settings).

### 9.3 Marketing ↔ product relationship

```
ade.ir  (ade-site, public Pages)
   │  links only
   ▼
github.com/bhzdcz/ade  (private product SoT: intents, specs, hooks, docs)
```

No submodule requirement in v1. Optional: badge or commit SHA of product “docs tip” — not required.

## 10. DNS / CNAME (Behzad executes)

Document in `ade-site` README and in product `docs/` pointer if useful:

| Record | Host / name | Type | Value | Notes |
| --- | --- | --- | --- | --- |
| Apex `ade.ir` | `@` or zone apex | **A** | GitHub Pages IPs (current GitHub docs: `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`) | Verify against live GitHub Pages docs at implement time |
| Apex IPv6 (optional) | `@` | **AAAA** | GitHub Pages AAAA set per current docs | Optional |
| `www.ade.ir` | `www` | **CNAME** | `bhzdcz.github.io` | Or redirect www → apex via DNS/provider |
| Pages custom domain | — | — | Enable in repo Settings; add `CNAME` file `ade.ir` | |

Build must **re-check** GitHub’s published Pages IP/CNAME instructions at implementation time (IPs can change). Spec locks *intent* of records, not eternal IP literals — plan.md cites the URL of GitHub’s current doc.

Behzad owns registrar DNS UI. Agents do not change DNS.

## 11. SEO / social (lightweight)

- `<title>ADE — AI-native SDLC</title>`
- Meta description ≤160 chars
- `link rel=canonical` → `https://ade.ir/`
- Open Graph: title, description, dark pixel OG image (1200×630, pixel style) in `assets/`
- `robots.txt` allow all

## 12. Acceptance criteria / Testito

1. Public repo `bhzdcz/ade-site` exists; Pages serves the landing (github.io and/or `ade.ir` once DNS set).
2. Dark-first single scroll; sections §5 present.
3. Pixel visual system matches §6 (grid, palette tokens, pixel display + readable body).
4. Motion matches storyboard or is disabled under reduced-motion; no library unless plan justified.
5. CTAs resolve: GitHub `bhzdcz/ade`, how-to-run on product repo, canonical ade.ir references.
6. Artifact chain explained without presenting stage bots as the product.
7. `CNAME` + README DNS table present; HTTPS note for Behzad.
8. Lighthouse-ish sanity: usable contrast, keyboard focus visible, no critical a11y blockers on the one page.
9. Develito authors site commits; Leadito does not.
10. Product repo receives intent/spec/plan artifacts for this intent-id; site repo is not the SoT for the chain.

## 13. Flagged concerns

1. **Private product CTA** — visitors without access hit a login wall on `bhzdcz/ade`. Acceptable for now; copy should not promise public code. Future intent may add a public docs mirror.
2. **DNS / IP drift** — hardcoding Pages A records can rot; Build must verify GitHub docs at ship time.
3. **ade.ir already stamped** on product README from rename — site must actually resolve or expectation gap remains (Behzad DNS is critical path).
4. **Pixel font licensing** — self-host OFL/SIL fonts; attribute in README.
5. **Over-animation risk** — “high-end” ≠ busy; Testito should fail gratuitous particles/parallax.
6. **Spec/mock** — no Figma required if HTML in `ade-site` is the first visual; optional mock before Build if Behzad wants pixel lockup approval first.
7. **www vs apex** — pick apex canonical; redirect www to avoid duplicate content.

## 14. Open questions (defaults)

| # | Question | Default |
| --- | --- | --- |
| 1 | www policy | CNAME www → github.io; canonical apex `ade.ir` |
| 2 | Site license | MIT in `ade-site` unless PO prefers matching product |
| 3 | Light mode toggle | Out of v1 |
| 4 | Figma before code | Optional; HTML prototype acceptable as mock |
| 5 | Jira | Only if ticket exists |

## 15. Out of scope

DNS clicking for Behzad; runner/dashboard; Pages from private `ade`; Braiins/AI-DD; multi-page docs site; Leadito Build; playbook v2 platform features.

## 16. Sign-off

PO accepts this spec → `spec_signed_off` → Develito writes `plan.md` then implements in `ade-site` (+ seeds artifacts on `ade`).

Checklist:

- [ ] Visual system + IA + motion storyboard specified
- [ ] Pages/Actions + CNAME/DNS documented
- [ ] Marketing↔product = link only; artifact home recommended on `ade`
- [ ] a11y reduced-motion called out
- [ ] Concerns flagged; no implementation in Design
