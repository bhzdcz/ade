# ADE

**Reviewable AI work, in your repository.**

ADE is a local workflow toolkit for small teams using Claude Code. Turn a request into an intent, spec and plan; keep the implementation and review connected in Git. Humans own acceptance and releases.

[Product site](https://ade.ir) · [Quickstart](docs/how-to-run.md) · [Worked example](examples/password-reset/README.md) · [Trust boundaries](SECURITY.md)

## Why use it?

AI makes generating code fast. It also makes it easy to lose the decision behind a change. ADE gives the next engineer a readable trail: what was requested, what “done” means, what changed, and what still needs human review.

- **Install into an existing repository.** Preview the files first; preserve your existing Claude instructions, hooks and permission settings.
- **Start with a small artifact chain.** One command creates draft intent, spec and plan files.
- **Check before supported edits.** Claude Code hooks require a locally accepted plan for product edits.
- **Keep the last word.** Agents propose; humans review and merge. ADE never deploys your app.

## Try it

Requires Python 3.10+, Bash, Git, and Claude Code for hook execution. macOS and Linux are tested; use WSL on Windows.

The product repository is currently private. These clone commands require access. Public visitors can read the [walkthrough](https://ade.ir/docs/) and download the example there; request toolkit access at **behzad@airoweb.com**. No public package or public release is claimed yet.

```bash
git clone https://github.com/bhzdcz/ade.git
cd ade
python3 ade init --project /path/to/your/repo --dry-run
python3 ade init --project /path/to/your/repo
python3 ade doctor --project /path/to/your/repo
python3 ade new password-reset --title "Add password reset" --project /path/to/your/repo
python3 ade status --project /path/to/your/repo
```

Review the generated files and installation diff. Restart Claude Code to load the project hooks. The human refines and accepts the plan in their editor before product changes begin. The CLI never accepts a plan for you.

## The workflow

```text
Intent → Spec → Plan → Code + tests → Human review → Release → Findings
   ↑                                                           │
   └──────────────────── next change ───────────────────────────┘
```

The six [plays](docs/plays/) cover Plan, Design, Build, Test, Deploy and Maintain. Use [REVIEW.md](REVIEW.md) for correctness, security and scope. [bands.yaml](bands.yaml) contains example signals to adapt to your project.

**Honest limits:** local files are editable, hooks cover selected Claude tools, and `promote.sh` is a simulation. Use your Git host's review rules and protected environments for real authorization. Read [SECURITY.md](SECURITY.md) before adoption. ADE is independent and is not affiliated with Anthropic or GitHub.

## Work with the maintainer

The proposed first paid offer is **€490 for setup in one repository**: workflow review, installation, one tailored example and a handover session. Scope and availability are confirmed in writing before payment; no checkout is live. Contact **behzad@airoweb.com**. See the [service scope](docs/services.md).

The proposed model is an MIT core, paid implementation help and optional sponsorship. The MIT license in this branch is part of the release proposal; the repository remains private until owner approval. Sponsor and Bitcoin destinations will be linked only after the maintainer configures them.

## Contribute and verify

Run these checks from a development checkout. The distribution excludes development tests and internal historical artifacts; installed projects use `ade doctor`.

```bash
bash tests/validate-templates.sh
bash tests/validate-hooks.sh
python3 -m unittest discover -s tests -p 'test_cli.py' -v
python3 ade pack --output dist/ade-0.2.0.zip
```

Tests use temporary repositories. The reproducible package has a per-file checksum manifest and excludes internal history, active intents and release attestations. Packaging creates a local archive; it does not publish it.

See [CONTRIBUTING.md](CONTRIBUTING.md), [CHANGELOG.md](CHANGELOG.md), and [LICENSE](LICENSE). Maintained by [@bhzdcz](https://github.com/bhzdcz).
