#!/usr/bin/env python3
"""Local workflow check. Successful checks preserve Claude's normal permissions."""
import json
import os
from pathlib import Path
import re
import sys


def deny(reason):
    print(json.dumps({'hookSpecificOutput': {'hookEventName': 'PreToolUse',
          'permissionDecision': 'deny', 'permissionDecisionReason': 'ADE: ' + reason}}))


def check(data, root):
    if not isinstance(data, dict) or not isinstance(data.get('tool_input'), dict):
        return 'invalid tool input'
    ti = data['tool_input']
    paths = []
    for source in (ti, data):
        for key in ('file_path', 'path', 'filePath'):
            if key in source:
                paths.append(source[key])
    if 'edits' in ti:
        if not isinstance(ti['edits'], list) or not ti['edits']:
            return 'edits must be a nonempty list'
        for edit in ti['edits']:
            if not isinstance(edit, dict):
                return 'invalid edit entry'
            candidates = [edit[k] for k in ('file_path', 'path', 'filePath') if k in edit]
            if not candidates:
                return 'every edit must have a file path'
            paths.extend(candidates)
    if not paths or any(not isinstance(p, str) or not p.strip() or any(c in p for c in '\n\r\x00') for p in paths):
        return 'every edit must have a valid file path'
    # Claude reports the tool working directory; relative paths must use it.
    cwd = Path(data.get('cwd') or root).resolve()
    gated = False
    for raw in paths:
        candidate = Path(raw)
        candidate = (cwd / candidate).resolve() if not candidate.is_absolute() else candidate.resolve()
        try:
            relative = candidate.relative_to(root).as_posix()
        except ValueError:
            return 'file path resolves outside the project'
        allowed = relative in ('intent/_template.md', 'specs/_template.md', '.markdownlint.json', '.gitignore', 'README.md') or relative.startswith(('docs/', 'findings/'))
        gated = gated or not allowed
    if not gated:
        return None
    active = root / '.claude/active-intent'
    if not active.is_file():
        return 'missing .claude/active-intent; create and review a plan before editing'
    if not active.resolve().is_relative_to(root):
        return 'active intent resolves outside the project'
    intent = active.read_text().strip()
    if not re.fullmatch(r'\d{4}-\d{2}-\d{2}-[a-z0-9]+(?:-[a-z0-9]+)*', intent):
        return 'invalid active intent ID'
    plan = root / 'plans' / intent / 'plan.md'
    if not plan.resolve().is_relative_to(root) or not plan.is_file():
        return 'missing in-project plan for ' + intent
    lines = plan.read_text().splitlines()
    if not lines or lines[0] != '---' or '---' not in lines[1:]:
        return 'plan needs frontmatter with status: accepted'
    fm = lines[1:lines[1:].index('---') + 1]
    statuses = [line.split(':', 1)[1].strip().strip('\"\'') for line in fm if line.startswith('status:')]
    if statuses != ['accepted']:
        return 'plan must have exactly one status: accepted in frontmatter'
    return None


if __name__ == '__main__':
    try:
        root = Path(os.environ.get('CLAUDE_PROJECT_DIR') or Path(__file__).resolve().parents[3]).resolve()
        reason = check(json.load(sys.stdin), root)
        if reason:
            deny(reason)
        else:
            print('{}')
    except (ValueError, TypeError, OSError, RuntimeError, KeyError) as exc:
        deny('cannot validate workflow input (' + type(exc).__name__ + ')')
