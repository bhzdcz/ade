import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
import zipfile

SOURCE = Path(__file__).resolve().parents[1]


class CliTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='ade project ')
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        subprocess.run(['git', 'init', '-q', str(self.root)], check=True)

    def cli(self, *args, ok=True, executable=None):
        proc = subprocess.run([sys.executable, str(executable or SOURCE / 'ade'), *args], cwd=self.root, text=True, capture_output=True)
        self.assertEqual(proc.returncode == 0, ok, proc.stdout + proc.stderr)
        return proc

    def snapshot(self):
        return {str(p.relative_to(self.root)): p.read_bytes() for p in self.root.rglob('*') if p.is_file() and '.git' not in p.parts}

    def test_preview_is_read_only_and_install_repeatable(self):
        self.cli('init', '--dry-run')
        self.assertEqual(self.snapshot(), {})
        self.cli('init')
        first = self.snapshot()
        self.cli('init')
        self.assertEqual(first, self.snapshot())
        self.cli('doctor')
        self.assertNotIn('.claude/active-intent', first)
        self.assertNotIn(b'Behzad', first['releases/release-managers.txt'])

    def test_preserves_settings_permissions_hooks_and_context(self):
        (self.root / '.claude').mkdir()
        data = {'permissions': {'deny': ['Bash(rm *)']}, 'hooks': {'PreToolUse': [{'matcher': 'Read', 'hooks': [{'type': 'command', 'command': 'echo custom'}]}]}}
        settings = self.root / '.claude/settings.json'
        settings.write_text(json.dumps(data))
        (self.root / 'CLAUDE.md').write_text('Existing instructions.\n')
        self.cli('init')
        updated = json.loads(settings.read_text())
        self.assertEqual(updated['permissions'], data['permissions'])
        self.assertEqual(updated['hooks']['PreToolUse'][0], data['hooks']['PreToolUse'][0])
        self.assertEqual((self.root / 'CLAUDE.md.ade-backup').read_text(), 'Existing instructions.\n')
        self.assertEqual(json.loads((self.root / '.claude/settings.json.ade-backup').read_text()), data)
        first = self.snapshot()
        self.cli('init')
        self.assertEqual(first, self.snapshot())

    def test_invalid_settings_no_partial_install(self):
        (self.root / '.claude').mkdir()
        for contents in ['{', '[]', '{"hooks": []}', '{"hooks":{"PreToolUse":{}}}']:
            (self.root / '.claude/settings.json').write_text(contents)
            first = self.snapshot()
            self.cli('init', ok=False)
            self.assertEqual(first, self.snapshot())

    def test_conflicting_runtime_no_partial_install(self):
        path = self.root / '.claude/hooks/plan-before-edit.sh'
        path.parent.mkdir(parents=True)
        path.write_text('custom existing hook')
        first = self.snapshot()
        self.cli('init', ok=False)
        self.assertEqual(first, self.snapshot())

    def test_symlinks_and_non_repo_rejected(self):
        with tempfile.TemporaryDirectory() as outside:
            (self.root / '.claude').symlink_to(outside)
            self.cli('init', ok=False)
            self.assertEqual(list(Path(outside).iterdir()), [])
            self.cli('init', '--project', outside, ok=False)

    def test_new_starts_draft_does_not_overwrite(self):
        self.cli('init')
        self.cli('new', 'password-reset', '--title', 'Reset "password"')
        active = (self.root / '.claude/active-intent').read_text().strip()
        for name in [f'intent/{active}.md', f'specs/{active}/spec.md', f'plans/{active}/plan.md']:
            self.assertIn('status: draft', (self.root / name).read_text())
        before = self.snapshot()
        self.cli('new', 'password-reset', '--title', 'Reset', ok=False)
        self.assertEqual(before, self.snapshot())
        self.assertIn('draft', self.cli('status').stdout)
        for slug in ['../../outside', 'invalid/slug', 'UPPERCASE', 'a--b']:
            self.cli('new', slug, '--title', 'x', ok=False)
        self.assertEqual(before, self.snapshot())

    def test_doctor_detects_missing_registration_and_tampering(self):
        self.cli('init')
        (self.root / '.claude/settings.json').write_text('{}')
        self.cli('doctor', ok=False)
        (self.root / '.claude/hooks/plan-before-edit.sh').write_text('exit 0')
        self.cli('doctor', ok=False)

    def test_pack_is_reproducible_clean_and_installable(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            first, second = root / 'one.zip', root / 'two.zip'
            self.cli('pack', '--output', str(first))
            self.cli('pack', '--output', str(second))
            self.assertEqual(first.read_bytes(), second.read_bytes())
            self.cli('pack', '--output', str(first), ok=False)
            with zipfile.ZipFile(first) as archive:
                names = archive.namelist()
                for forbidden in ['active-intent', 'commercial-strategy', '.git/', 'code-owner-acceptances', '2026-09-04']:
                    self.assertFalse(any(forbidden in name for name in names), forbidden)
                archive.extractall(root / 'unpacked')
            kit = next((root / 'unpacked').iterdir())
            manifest = json.loads((kit / 'manifest.json').read_text())
            for name, digest in manifest['files'].items():
                self.assertEqual(hashlib.sha256((kit / name).read_bytes()).hexdigest(), digest)
            self.cli('init', executable=kit / 'ade')
            self.cli('doctor', executable=kit / 'ade')


class FindingTests(unittest.TestCase):
    def test_finding_slug_cannot_escape_or_overwrite(self):
        import shutil
        with tempfile.TemporaryDirectory(prefix='ade finding ') as directory:
            root = Path(directory)
            (root / 'scripts').mkdir()
            script = root / 'scripts/finding-to-intent.sh'
            shutil.copy2(SOURCE / 'scripts/finding-to-intent.sh', script)
            finding = root / 'finding.md'
            finding.write_text('# A "quoted" finding\n\n## Problem\n\nBroken workflow.\n')
            for slug in ['../outside', 'bad/slug', 'UPPER']:
                proc = subprocess.run(['bash', str(script), str(finding), slug], capture_output=True, text=True)
                self.assertNotEqual(proc.returncode, 0)
            self.assertFalse((root / 'intent').exists())
            for _ in range(2):
                proc = subprocess.run(['bash', str(script), str(finding), 'workflow'], capture_output=True, text=True)
                self.assertEqual(proc.returncode, 0, proc.stderr)
            intents = list((root / 'intent').glob('*.md'))
            self.assertEqual(len(intents), 2)
            self.assertTrue(all('status: draft' in p.read_text() for p in intents))

    def test_symlinked_finding_output_is_rejected(self):
        import shutil
        with tempfile.TemporaryDirectory() as directory, tempfile.TemporaryDirectory() as outside:
            root = Path(directory)
            (root / 'scripts').mkdir()
            script = root / 'scripts/finding-to-intent.sh'
            shutil.copy2(SOURCE / 'scripts/finding-to-intent.sh', script)
            (root / 'intent').symlink_to(outside)
            finding = root / 'finding.md'; finding.write_text('# Finding\n')
            proc = subprocess.run(['bash', str(script), str(finding), 'workflow'], capture_output=True)
            self.assertNotEqual(proc.returncode, 0)
            self.assertEqual(list(Path(outside).iterdir()), [])


if __name__ == '__main__':
    unittest.main()
