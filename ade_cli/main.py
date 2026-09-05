"""Offline, standard-library CLI. Never accepts a plan or deploys a project."""
import argparse
from datetime import date
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import zipfile
from . import __version__

SOURCE = Path(__file__).resolve().parents[1]
SLUG = re.compile(r'[a-z0-9]+(?:-[a-z0-9]+)*\Z')
ID = re.compile(r'\d{4}-\d{2}-\d{2}-' + SLUG.pattern)


def safe(root, relative):
    path = root / relative
    # Reject all symlink ancestors, including links pointing inside the repo.
    for parent in (path, *path.parents):
        if parent == root:
            break
        if parent.is_symlink():
            raise ValueError(f'Refusing symlink: {parent}')
    if not path.resolve().is_relative_to(root):
        raise ValueError(f'Path escapes project: {relative}')
    return path


def project(raw):
    root = Path(raw).expanduser().resolve()
    if not root.is_dir():
        raise ValueError(f'Project directory does not exist: {root}')
    result = subprocess.run(['git', '-C', str(root), 'rev-parse', '--show-toplevel'], capture_output=True, text=True)
    if result.returncode or Path(result.stdout.strip()).resolve() != root:
        raise ValueError('Choose the root of a Git repository (run git init first).')
    return root


def template_files():
    names = ['REVIEW.md', 'bands.yaml', 'intent/_template.md', 'specs/_template.md', 'plans/_template.md',
             'findings/_template.md', 'scripts/promote.sh', 'scripts/finding-to-intent.sh']
    for directory in ['.claude/hooks', '.claude/skills', 'docs/plays']:
        names.extend(p.relative_to(SOURCE).as_posix() for p in (SOURCE / directory).rglob('*') if p.is_file() and '__pycache__' not in p.parts)
    return {name: (SOURCE / name).read_bytes() for name in sorted(names)}


def settings_for(existing):
    if not isinstance(existing, dict):
        raise ValueError('Claude settings must be a JSON object')
    hooks = existing.setdefault('hooks', {})
    if not isinstance(hooks, dict):
        raise ValueError('Claude hooks must be a JSON object')
    pre = hooks.setdefault('PreToolUse', [])
    if not isinstance(pre, list):
        raise ValueError('PreToolUse hooks must be a list')
    expected = json.loads((SOURCE / '.claude/settings.json').read_text())['hooks']['PreToolUse']
    for item in expected:
        if item not in pre:
            pre.append(item)
    return existing


def write_new(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open('xb') as stream:
        stream.write(data)


def init(args):
    root = project(args.project)
    files = template_files()
    files['ADE.md'] = (SOURCE / 'templates/ADE.md').read_bytes()
    files['releases/release-managers.txt'] = b'# Add your real release manager identity after review. No defaults.\n'
    files['releases/attestations/.gitkeep'] = b''
    settings = safe(root, '.claude/settings.json')
    original = settings.read_bytes() if settings.exists() else None
    merged = settings_for(json.loads(original) if original else {})
    changes = {}
    for name, data in files.items():
        target = safe(root, name)
        if target.exists():
            if not target.is_file() or target.read_bytes() != data:
                # User-owned review/bands/template content stays in place. Runtime
                # conflicts must stop installation before adding any new hooks.
                if name.startswith(('.claude/hooks/', 'scripts/')):
                    raise ValueError(f'Existing runtime differs: {name}. Back it up and reconcile manually; no files changed.')
                print(f'KEEP   {name} (existing customization)')
        else:
            changes[name] = data
    context = safe(root, 'CLAUDE.md')
    context_old = context.read_bytes() if context.exists() else None
    marker = b'@ADE.md'
    if context_old is None or marker not in context_old.splitlines():
        changes['CLAUDE.md'] = (context_old or b'') + b'\n# ADE workflow\n@ADE.md\n'
    settings_data = (json.dumps(merged, indent=2) + '\n').encode()
    if original is None or merged != json.loads(original):
        changes['.claude/settings.json'] = settings_data
    for name in changes:
        safe(root, name)
        if name in ('CLAUDE.md', '.claude/settings.json') and (root / name).exists():
            backup = safe(root, name + '.ade-backup')
            if backup.exists():
                raise ValueError(f'Backup already exists: {backup}. Move it before changing settings.')
        print(f'{"MERGE " if (root / name).exists() else "CREATE"} {name}')
    if args.dry_run:
        print(f'Preview: {len(changes)} files would change. Nothing written.')
        return
    created, replaced = [], []
    try:
        for name, data in changes.items():
            target = root / name
            if target.exists():
                old = target.read_bytes()
                backup = root / (name + '.ade-backup')
                write_new(backup, old)
                created.append(backup)
                replaced.append((target, old))
                target.write_bytes(data)
            else:
                write_new(target, data)
                created.append(target)
    except OSError:
        for target, old in reversed(replaced):
            target.write_bytes(old)
        for target in reversed(created):
            target.unlink(missing_ok=True)
        raise
    print(f'ADE installed: {len(changes)} files changed. Review git diff, then run ade doctor.')
    print('Restart Claude Code to load hooks. New work starts as draft; no approvals were granted.')


def new(args):
    root = project(args.project)
    if not SLUG.fullmatch(args.slug) or len(args.slug) > 80:
        raise ValueError('Use a lowercase slug with letters, numbers and single hyphens (max 80 characters).')
    if not args.title.strip() or any(c in args.title for c in '\r\n\x00'):
        raise ValueError('Title must be a nonempty single line.')
    if not safe(root, 'ADE.md').is_file() and root != SOURCE:
        raise ValueError('Run ade init before starting work.')
    ident = date.today().isoformat() + '-' + args.slug
    title = json.dumps(args.title)
    content = {
        f'intent/{ident}.md': f'---\ntitle: {title}\nauthor: ""\nstatus: draft\ndate: {date.today()}\nrevision: 1\nacceptor: ""\nsource: human\n---\n\n# Intent: {args.title}\n\n## Problem\n\nDescribe the user problem.\n\n## Proposed outcome\n\nState the observable result.\n\n## Constraints\n\nName the boundaries.\n\n## Open questions\n\nResolve before accepting.\n\n## Success criteria\n\n- Define a verifiable outcome.\n',
        f'specs/{ident}/spec.md': f'---\ntitle: {title}\nintent: intent/{ident}.md\nstatus: draft\nacceptor: ""\n---\n\n# Spec: {args.title}\n\n## Acceptance criteria\n\n- Describe observable behavior and failure cases.\n\n## Out of scope\n\nList exclusions.\n',
        f'plans/{ident}/plan.md': f'---\nintent-id: {ident}\nspec: specs/{ident}/spec.md\nstatus: draft\nengineer: ""\ndate: {date.today()}\n---\n\n# Plan: {args.title}\n\n## Changes\n\nList the files and approach.\n\n## Validation\n\nList meaningful checks.\n\n## Review\n\nA human reviews the intent, spec and plan before accepting.\n'
    }
    for name in content:
        if safe(root, name).exists():
            raise ValueError(f'Work already exists: {ident}; choose another slug.')
    active = safe(root, '.claude/active-intent')
    old_active = active.read_bytes() if active.exists() else None
    made = []
    try:
        for name, text in content.items():
            p = root / name
            write_new(p, text.encode())
            made.append(p)
        active.parent.mkdir(parents=True, exist_ok=True)
        active.write_text(ident + '\n')
    except OSError:
        for p in made:
            p.unlink(missing_ok=True)
        if old_active is not None:
            active.write_bytes(old_active)
        else:
            active.unlink(missing_ok=True)
        raise
    print(f'Created {ident}\nIntent, spec and plan are drafts. Active intent set; product edits remain gated.')


def status(args):
    root = project(args.project)
    active = safe(root, '.claude/active-intent')
    ident = active.read_text().strip() if active.exists() else ''
    if not ident:
        print('No active work. Run ade new <slug> --title "Your change".')
        return
    if not ID.fullmatch(ident):
        raise ValueError('Invalid active intent ID')
    print('Active: ' + ident)
    for label, name in [('intent', f'intent/{ident}.md'), ('spec', f'specs/{ident}/spec.md'), ('plan', f'plans/{ident}/plan.md')]:
        path = safe(root, name)
        text = path.read_text() if path.is_file() else ''
        fm = text.split('---', 2)[1] if text.startswith('---\n') and len(text.split('---', 2)) == 3 else ''
        found = re.findall(r'^status:\s*(.*?)\s*$', fm, re.M)
        print(f'{label:7} {found[0] if len(found) == 1 else "missing or invalid"}')
    print('Local status records are editable; Git review is the acceptance record.')


def doctor(args):
    root = project(args.project)
    issues = []
    def report(ok, label):
        print(('OK    ' if ok else 'FAIL  ') + label)
        if not ok:
            issues.append(label)
    report(sys.version_info >= (3, 10), 'Python 3.10+')
    for name in ['bash', 'git']:
        report(shutil.which(name) is not None, name + ' available')
    print(('OK    ' if shutil.which('claude') else 'NOTE  ') + 'Claude Code ' + ('available' if shutil.which('claude') else 'not on PATH; needed to use the hooks in Claude'))
    for name, data in template_files().items():
        if name.startswith(('.claude/hooks/', 'scripts/')):
            p = safe(root, name)
            report(p.is_file() and p.read_bytes() == data, name + ' matches this toolkit')
    settings = safe(root, '.claude/settings.json')
    try:
        loaded = json.loads(settings.read_text())
        pre = loaded['hooks']['PreToolUse']
        expected = json.loads((SOURCE / '.claude/settings.json').read_text())['hooks']['PreToolUse']
        report(all(h in pre for h in expected), 'both ADE hook registrations present')
    except (OSError, ValueError, KeyError, TypeError):
        report(False, 'valid Claude hook settings')
    context = safe(root, 'CLAUDE.md')
    report(context.is_file() and '@ADE.md' in context.read_text().splitlines() and safe(root, 'ADE.md').is_file(), 'Claude imports ADE.md')
    print('NOTE  Hooks are local workflow checks. Enforce review and deploy permissions in your Git host.')
    if issues:
        raise ValueError(f'{len(issues)} check(s) failed. Reconcile files with this version before using ADE.')


def pack(args):
    output = Path(args.output).expanduser().resolve()
    if output.exists():
        raise ValueError('Output already exists; choose a new archive path.')
    names = set(template_files()) | {'ade', 'ade_cli/__init__.py', 'ade_cli/main.py', '.claude/settings.json',
        'templates/ADE.md', 'LICENSE', 'README.md', 'CONTRIBUTING.md', 'docs/how-to-run.md', 'docs/services.md', 'docs/conventions.md', 'docs/feedback-loop.md', 'SECURITY.md', 'CHANGELOG.md'}
    names.update(p.relative_to(SOURCE).as_posix() for p in (SOURCE / 'examples').rglob('*') if p.is_file())
    payload = {name: (SOURCE / name).read_bytes() for name in sorted(names)}
    manifest = {'version': __version__, 'files': {name: hashlib.sha256(data).hexdigest() for name, data in payload.items()}}
    payload['manifest.json'] = (json.dumps(manifest, indent=2) + '\n').encode()
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(dir=output.parent) as temp:
        archive = Path(temp) / 'toolkit.zip'
        with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED) as z:
            for name, data in sorted(payload.items()):
                info = zipfile.ZipInfo(f'ade-{__version__}/{name}', (2026, 1, 1, 0, 0, 0))
                info.compress_type = zipfile.ZIP_DEFLATED
                info.external_attr = (0o100755 if name == 'ade' or name.endswith('.sh') else 0o100644) << 16
                z.writestr(info, data)
        # Exclusive creation prevents replacing an archive created concurrently.
        with output.open('xb') as dest, archive.open('rb') as src:
            shutil.copyfileobj(src, dest)
    print(f'{output}\nSHA256 {hashlib.sha256(output.read_bytes()).hexdigest()}')
    print('Private build only. Review licensing and contents before distribution.')


def main():
    parser = argparse.ArgumentParser(prog='ade', description='Reviewable AI work, in your repository.')
    parser.add_argument('--version', action='version', version=__version__)
    sub = parser.add_subparsers(dest='command', required=True)
    for command, help_text, func in [('init', 'Install into an existing Git repository', init), ('new', 'Create draft intent, spec and plan', new), ('status', 'Inspect active artifacts', status), ('doctor', 'Verify installation', doctor), ('pack', 'Build a private distribution archive', pack)]:
        p = sub.add_parser(command, help=help_text)
        p.set_defaults(func=func)
        if command != 'pack':
            p.add_argument('--project', default='.', help='Target Git repository root')
        if command == 'init':
            p.add_argument('--dry-run', action='store_true')
        if command == 'new':
            p.add_argument('slug')
            p.add_argument('--title', required=True)
        if command == 'pack':
            p.add_argument('--output', required=True)
    args = parser.parse_args()
    try:
        args.func(args)
    except (ValueError, OSError, subprocess.SubprocessError) as exc:
        print('ADE: ' + str(exc), file=sys.stderr)
        sys.exit(1)
