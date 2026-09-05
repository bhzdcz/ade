# Run ADE in your project

ADE lives beside your code. You need Python 3.10+, Bash and Git; Claude Code is required to run the hooks. The public introduction is at [ade.ir](https://ade.ir). Source access is currently by request to behzad@airoweb.com.

## Install

Obtain a reviewed ADE checkout or distribution archive. The `ade` script runs from that directory and targets your project explicitly:

```bash
python3 /path/to/ade/ade init --project /path/to/project --dry-run
python3 /path/to/ade/ade init --project /path/to/project
python3 /path/to/ade/ade doctor --project /path/to/project
```

The target must already be a Git repository. Run `git init` there if needed. Paths with spaces work when quoted. The toolkit makes no network requests and installs no Python packages.

Installation adds templates, six plays, review policy, example control bands and hooks. It appends `@ADE.md` to existing `CLAUDE.md` and merges ADE hook entries into `.claude/settings.json`, preserving other hooks and permissions. Original settings and context get `.ade-backup` copies. Existing customized content stays in place; conflicting runtime scripts stop installation before changes. Repeated installation is a no-op when nothing changed.

Review `git diff` and `git status`. Read the [trust boundaries](../SECURITY.md). Restart Claude Code and confirm the two hooks appear in its hooks settings. If `doctor` cannot find Claude on PATH, install it using [Anthropic's instructions](https://code.claude.com/docs/en/setup); ADE does not bundle a model subscription.

## Start a change

```bash
python3 /path/to/ade/ade new password-reset --title "Add password reset" --project /path/to/project
python3 /path/to/ade/ade status --project /path/to/project
```

This creates `intent/<date>-password-reset.md`, `specs/<id>/spec.md`, `plans/<id>/plan.md` and sets `.claude/active-intent`. All three begin as drafts. Starting another change switches the active intent and preserves previous files.

## Refine and accept

Ask Claude in plan mode to propose the problem, observable acceptance criteria, affected files and verification steps. The owner edits the draft artifacts directly in their editor, resolves open questions, then changes the plan frontmatter to `status: accepted` after review. Record acceptance in the PR. The CLI never performs this decision. The hook blocks draft product edits, including draft artifact edits outside the allowlist; do not use shell commands to bypass it.

A successful check does not grant tool permission. Claude's normal permissions still apply. README, docs, findings and designated templates are allowlisted after canonical path checks; other in-project paths require the accepted plan. Paths outside the project are denied even with an accepted plan.

## Build, review, release

Keep changes on a branch. Attach test evidence and a three-pass review to the PR. Humans decide whether to merge. For production, configure required reviewers and protected environments in the Git/deployment host. `scripts/promote.sh` is an illustrative stub, not a deploy command. A maintainer name in a YAML file is not authenticated approval.

## Maintain

Capture problems in `findings/`, then use `bash scripts/finding-to-intent.sh findings/example.md optional-slug` to create a draft follow-up. Review before acceptance. Keep secrets and customer data out of the artifacts.

## Troubleshoot and upgrade

- **Missing plan:** check `.claude/active-intent` and run `ade status`.
- **Conflicting runtime:** compare the existing hook with the new version. Back up and manually reconcile it; the installer never forces overwrites.
- **Existing backup:** preserve/move the old `.ade-backup` before another settings update.
- **Symlink refused:** install into a real project directory with real `.claude` and artifact subdirectories.
- **Missing Python:** install Python 3.10+; hooked operations block until it is available.
- **Remove ADE:** review the install diff, remove only ADE's hook entries and import, and preserve custom files and other settings. See SECURITY.md.
