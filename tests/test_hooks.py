"""Integration regressions run against isolated repositories, never the checkout."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

SOURCE = Path(__file__).resolve().parents[1]


class HookTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='ade hooks ')
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        shutil.copytree(SOURCE / '.claude/hooks', self.root / '.claude/hooks')
        (self.root / 'plans/2026-09-05-test').mkdir(parents=True)
        (self.root / 'plans/2026-09-05-test/plan.md').write_text('---\nstatus: accepted\n---\n')
        (self.root / '.claude/active-intent').write_text('2026-09-05-test\n')
        (self.root / 'releases/attestations').mkdir(parents=True)
        (self.root / 'releases/release-managers.txt').write_text('# owners\nBehzad\n@bhzdcz\n')

    def run_hook(self, payload, hook='plan-before-edit.sh'):
        proc = subprocess.run(['bash', str(self.root / '.claude/hooks' / hook)], input=json.dumps(payload) if not isinstance(payload, str) else payload,
            text=True, capture_output=True, cwd=self.root, env={**os.environ, 'CLAUDE_PROJECT_DIR': str(self.root)})
        self.assertEqual(proc.returncode, 0, proc.stderr)
        return json.loads(proc.stdout).get('hookSpecificOutput', {}).get('permissionDecision', 'abstain')

    def edit(self, path):
        return {'tool_input': {'file_path': path}}

    def test_existing_fixtures(self):
        # Keep original scenarios; point accepted fixtures at this isolated plan.
        fixtures = SOURCE / 'tests/fixtures/hooks'
        for name in ['allowlist-docs-write', 'allowlist-readme-write', 'accepted-plan-claude-write', 'multiedit-claude', 'attestations-write']:
            with self.subTest(name=name):
                self.assertEqual(self.run_hook((fixtures / (name + '.json')).read_text()), 'abstain')
        self.assertEqual(self.run_hook((fixtures / 'pathless-write.json').read_text()), 'deny')
        (self.root / '.claude/active-intent').unlink()
        for name in ['missing-plan-bands-write', 'multiedit-deny', 'attestations-write']:
            with self.subTest(name=name):
                self.assertEqual(self.run_hook((fixtures / (name + '.json')).read_text()), 'deny')

    def test_draft_denied(self):
        (self.root / 'plans/2026-09-05-test/plan.md').write_text('---\nstatus: draft\n---\n')
        self.assertEqual(self.run_hook(self.edit('src/app.py')), 'deny')

    def test_traversal_does_not_inherit_docs_allowlist(self):
        (self.root / '.claude/active-intent').unlink()
        self.assertEqual(self.run_hook(self.edit('docs/../src/app.py')), 'deny')
        self.assertEqual(self.run_hook(self.edit('docs/../README.md')), 'abstain')

    def test_outside_denied_even_with_accepted_plan(self):
        self.assertEqual(self.run_hook(self.edit('../outside.py')), 'deny')
        self.assertEqual(self.run_hook(self.edit('/tmp/outside.py')), 'deny')
        (self.root / 'docs').symlink_to(self.root.parent, target_is_directory=True)
        self.assertEqual(self.run_hook(self.edit('docs/outside.py')), 'deny')

    def test_symlink_to_product_is_gated(self):
        (self.root / 'docs').symlink_to(self.root / 'src', target_is_directory=True)
        (self.root / '.claude/active-intent').unlink()
        self.assertEqual(self.run_hook(self.edit('docs/app.py')), 'deny')

    def test_relative_paths_use_tool_cwd(self):
        (self.root / 'src').mkdir()
        (self.root / '.claude/active-intent').unlink()
        self.assertEqual(self.run_hook({'cwd': str(self.root / 'src'), 'tool_input': {'file_path': 'README.md'}}), 'deny')

    def test_malformed_payloads_fail_closed(self):
        for data in ['{', 'null', '[]', {}, {'tool_input': []}, self.edit(4), self.edit('bad\npath'),
                     {'tool_input': {'edits': [{'file_path': 'README.md'}, {}]}},
                     {'tool_input': {'edits': 'README.md'}}, {'tool_input': {'edits': []}},
                     {'tool_input': {'file_path': 'README.md', 'edits': [{'file_path': None}]}}]:
            with self.subTest(data=data):
                self.assertEqual(self.run_hook(data), 'deny')

    def test_invalid_ids_and_frontmatter(self):
        active = self.root / '.claude/active-intent'
        for ident in ['../../../tmp/bypass', '2026-09-05-test\nother']:
            active.write_text(ident)
            self.assertEqual(self.run_hook(self.edit('app.py')), 'deny')
        active.write_text('2026-09-05-test')
        plan = self.root / 'plans/2026-09-05-test/plan.md'
        for text in ['# prose\n---\nstatus: accepted\n---', '---\nstatus: accepted\nstatus: draft\n---', '---\nstatus: accepted']:
            plan.write_text(text)
            self.assertEqual(self.run_hook(self.edit('app.py')), 'deny')

    def test_normal_command_never_grants_permissions(self):
        self.assertEqual(self.run_hook({'tool_input': {'command': 'git status'}}, 'production-gate.sh'), 'abstain')

    def test_production_fixture_contract(self):
        for name in ['promote-command', 'promote-env-flag']:
            data = (SOURCE / 'tests/fixtures/hooks' / (name + '.json')).read_text()
            self.assertEqual(self.run_hook(data, 'production-gate.sh'), 'deny')
        att = self.root / 'releases/attestations/test.yaml'
        att.write_text('release_manager: Eve\n')
        cmd = {'tool_input': {'command': 'bash scripts/promote.sh'}}
        self.assertEqual(self.run_hook(cmd, 'production-gate.sh'), 'deny')
        att.write_text('release_manager: Behzad\n')
        self.assertEqual(self.run_hook(cmd, 'production-gate.sh'), 'abstain')

    def test_malformed_bash_denied(self):
        for data in ['{', 'null', {}, {'tool_input': {'command': 5}}]:
            self.assertEqual(self.run_hook(data, 'production-gate.sh'), 'deny')


if __name__ == '__main__':
    unittest.main()
