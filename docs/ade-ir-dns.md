# ade.ir DNS / GitHub Pages (private ops)

Operator notes for the marketing site in public `bhzdcz/ade-site`. Keep this file **private** — do not copy into the public marketing README.

Canonical: https://ade.ir  
Site repo: https://github.com/bhzdcz/ade-site  
GitHub Pages custom domain docs: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site

## Records (verify IPs against live GitHub docs before changing DNS)

| Record | Host | Type | Value |
| --- | --- | --- | --- |
| Apex `ade.ir` | `@` | A | `185.199.108.153` |
| Apex `ade.ir` | `@` | A | `185.199.109.153` |
| Apex `ade.ir` | `@` | A | `185.199.110.153` |
| Apex `ade.ir` | `@` | A | `185.199.111.153` |
| `www.ade.ir` | `www` | CNAME | `bhzdcz.github.io` |

Root `CNAME` in `ade-site` contains `ade.ir`.

## Checklist

1. `ade-site` Settings → Pages: source = GitHub Actions.
2. Custom domain `ade.ir` (after first green deploy).
3. Registrar: A records (+ optional www CNAME).
4. Enforce HTTPS once DNS propagates.

Re-check GitHub’s published Pages IPs if docs change.
