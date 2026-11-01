"""Installation regression tests. System changes and downloads are mocked."""

import errno
import fcntl
import json
import os
from pathlib import Path
import pty
import select
import shutil
import subprocess
import tempfile
import termios
import time
import unittest
import zipfile


REPO = Path(__file__).resolve().parents[1]
GIT = shutil.which("git")
JQ = shutil.which("jq")


class InstallationTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="omakos-test-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.home = self.root / "home with spaces"
        self.home.mkdir()
        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.project = self.root / "project"
        self.project.mkdir()
        for filename in ("install.sh", "setup.sh"):
            shutil.copy2(REPO / filename, self.project / filename)
        for directory in ("scripts", "configs"):
            shutil.copytree(REPO / directory, self.project / directory,
                            ignore=shutil.ignore_patterns("images"))
        self.env = {
            "HOME": str(self.home),
            "PATH": f"{self.bin}:/usr/bin:/bin:/usr/sbin:/sbin",
            "TERM": "xterm-256color",
            "LANG": "en_US.UTF-8",
            "XDG_CONFIG_HOME": str(self.home / ".config"),
            "XDG_DATA_HOME": str(self.home / ".local/share"),
            "XDG_STATE_HOME": str(self.home / ".local/state"),
            "XDG_CACHE_HOME": str(self.home / ".cache"),
            "TEST_BIN": str(self.bin),
        }
        self.stub("tput", "exit 0")
        for command in ("curl", "sudo", "brew", "softwareupdate", "chsh"):
            self.stub(command, f'echo "Unexpected {command}" >&2; exit 97')

    def stub(self, name, body):
        path = self.bin / name
        path.write_text("#!/bin/bash\nset -e\n" + body + "\n")
        path.chmod(0o755)
        return path

    def run_script(self, script, data=""):
        return subprocess.run(
            ["/bin/bash", script], cwd=self.project, env=self.env,
            input=data, text=True, capture_output=True, timeout=15,
            start_new_session=True,
        )

    def run_tty(self, args, answers, stdin=""):
        """Keep stdin piped while giving the process a controlling terminal."""
        master, slave = pty.openpty()

        def controlling_terminal():
            os.setsid()
            fcntl.ioctl(slave, termios.TIOCSCTTY, 0)

        process = None
        try:
            process = subprocess.Popen(
                args, cwd=self.project, env=self.env, stdin=subprocess.PIPE,
                stdout=slave, stderr=slave, preexec_fn=controlling_terminal,
            )
            os.close(slave)
            slave = None
            process.stdin.write(stdin.encode())
            process.stdin.close()
            os.write(master, answers.encode())
            output = bytearray()
            deadline = time.monotonic() + 15
            while time.monotonic() < deadline:
                ready, _, _ = select.select([master], [], [], 0.1)
                if ready:
                    try:
                        chunk = os.read(master, 65536)
                    except OSError as error:
                        if error.errno != errno.EIO:
                            raise
                        break
                    if not chunk:
                        break
                    output.extend(chunk)
                elif process.poll() is not None:
                    break
            status = process.wait(timeout=1)
            return status, output.decode(errors="replace")
        finally:
            if process is not None and process.poll() is None:
                process.kill()
                process.wait()
            os.close(master)
            if slave is not None:
                os.close(slave)

    def test_shell_syntax(self):
        for script in [self.project / "install.sh", self.project / "setup.sh",
                       *sorted((self.project / "scripts").glob("*.sh"))]:
            with self.subTest(script=script.name):
                result = subprocess.run(["/bin/bash", "-n", str(script)],
                                        capture_output=True, text=True)
                self.assertEqual(result.returncode, 0, result.stderr)

    def test_offline_check_really_calls_curl_and_fails(self):
        self.stub("curl", 'echo checked > "$HOME/network-check"; exit 7')
        script = self.project / "check.sh"
        script.write_text("source ./scripts/utils.sh\ncheck_internet_connection\n")
        result = self.run_script(str(script))
        self.assertNotEqual(result.returncode, 0)
        self.assertTrue((self.home / "network-check").exists())
        self.assertIn("Cannot reach GitHub", result.stdout)

    def test_online_check_succeeds(self):
        self.stub("curl", "exit 0")
        script = self.project / "check.sh"
        script.write_text("source ./scripts/utils.sh\ncheck_internet_connection\n")
        result = self.run_script(str(script))
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_setup_preserves_failure_status(self):
        with (self.project / "scripts/utils.sh").open("a") as stream:
            stream.write("\ncheck_internet_connection() { return 37; }\n")
        result = self.run_script("setup.sh")
        self.assertEqual(result.returncode, 37)
        self.assertIn("Omakos setup failed", result.stderr)

    def prepare_homebrew(self):
        (self.bin / "brew").unlink()
        self.stub("uname", "echo x86_64")
        with (self.project / "scripts/utils.sh").open("a") as stream:
            stream.write("\nask_for_sudo() { :; }\n")
        # Stop at the boundary of the next installation phase.
        (self.project / "scripts/brew.sh").write_text("exit 42\n")

    def test_homebrew_handles_clt_without_local_version_parser(self):
        self.prepare_homebrew()
        self.stub("curl", '''case "$*" in
*https://github.com) exit 0 ;;
*Homebrew/install*) echo 'echo HOMEBREW_INSTALLER_REACHED' ;;
*) exit 97 ;;
esac''')
        result = self.run_script("setup.sh")
        self.assertEqual(result.returncode, 42, result.stderr)
        self.assertIn("HOMEBREW_INSTALLER_REACHED", result.stdout)
        self.assertNotIn("Unexpected softwareupdate", result.stderr)

    def test_homebrew_download_failure_is_not_executed_as_empty_script(self):
        self.prepare_homebrew()
        self.stub("curl", 'case "$*" in *https://github.com) exit 0 ;; *) exit 22 ;; esac')
        result = self.run_script("setup.sh")
        self.assertEqual(result.returncode, 22)
        self.assertNotIn("Homebrew installed!", result.stdout)

    def existing_checkout(self):
        checkout = self.home / "omakos"
        (checkout / ".git").mkdir(parents=True)
        (checkout / ".git/HEAD").write_text("ref: refs/heads/local\n")
        (checkout / "local-change.txt").write_text("uncommitted work\n")
        return checkout

    def prepare_archive(self, valid=True):
        archive = self.root / "archive.zip"
        with zipfile.ZipFile(archive, "w") as output:
            output.writestr("omakos-main/setup.sh", '''#!/bin/bash
read -r answer
printf '%s' "$answer" > "$HOME/setup-answer"
exit "${TEST_SETUP_EXIT:-0}"
''')
            if valid:
                output.writestr("omakos-main/scripts/utils.sh", "")
                output.writestr("omakos-main/configs/Brewfile", "")
        self.env["TEST_ARCHIVE"] = str(archive)
        self.stub("curl", 'cp "$TEST_ARCHIVE" "${@: -1}"')
        return archive

    def assert_no_staging(self):
        self.assertEqual(list(self.home.glob(".omakos-install.*")), [])

    def test_download_failure_preserves_checkout(self):
        checkout = self.existing_checkout()
        self.stub("curl", "exit 22")
        result = self.run_script("install.sh")
        self.assertEqual(result.returncode, 22)
        self.assertEqual((checkout / "local-change.txt").read_text(), "uncommitted work\n")
        self.assertEqual(list(self.home.glob("omakos.backup.*")), [])
        self.assert_no_staging()

    def test_corrupt_archive_preserves_checkout(self):
        checkout = self.existing_checkout()
        archive = self.prepare_archive()
        archive.write_bytes(b"not a zip archive")
        result = self.run_script("install.sh")
        self.assertNotEqual(result.returncode, 0)
        self.assertTrue((checkout / "local-change.txt").exists())
        self.assert_no_staging()

    def test_incomplete_archive_preserves_checkout(self):
        checkout = self.existing_checkout()
        self.prepare_archive(valid=False)
        result = self.run_script("install.sh")
        self.assertEqual(result.returncode, 1)
        self.assertTrue((checkout / "local-change.txt").exists())
        self.assert_no_staging()

    def test_failed_replacement_restores_existing_checkout(self):
        checkout = self.existing_checkout()
        self.prepare_archive()
        self.stub("mv", '''case "$1" in
*/.omakos-install.*/omakos-main) exit 1 ;;
*) exec /bin/mv "$@" ;;
esac''')
        result = self.run_script("install.sh")
        self.assertEqual(result.returncode, 1)
        self.assertEqual((checkout / "local-change.txt").read_text(), "uncommitted work\n")
        self.assertTrue((checkout / ".git/HEAD").exists())
        self.assertEqual(list(self.home.glob("omakos.backup.*")), [])
        self.assert_no_staging()

    def test_piped_bootstrap_preserves_checkout_and_connects_setup_to_tty(self):
        self.existing_checkout()
        self.prepare_archive()
        status, output = self.run_tty(
            ["/bin/bash"], "terminal answer\n",
            stdin=(self.project / "install.sh").read_text(),
        )
        self.assertEqual(status, 0, output)
        backups = list(self.home.glob("omakos.backup.*/omakos"))
        self.assertEqual(len(backups), 1)
        self.assertEqual((backups[0] / "local-change.txt").read_text(), "uncommitted work\n")
        self.assertTrue((backups[0] / ".git/HEAD").exists())
        self.assertEqual((self.home / "setup-answer").read_text(), "terminal answer")
        self.assert_no_staging()

    def test_bootstrap_preserves_setup_failure_status(self):
        self.prepare_archive()
        self.env["TEST_SETUP_EXIT"] = "31"
        status, output = self.run_tty(["/bin/bash", "install.sh"], "answer\n")
        self.assertEqual(status, 31, output)
        self.assert_no_staging()

    @unittest.skipUnless(GIT, "git is needed for Git config validation")
    def test_git_reads_tty_when_stdin_is_exhausted(self):
        status, output = self.run_tty(
            ["/bin/bash", "scripts/git.sh"], "Test Person\ntest@example.invalid\n",
        )
        self.assertEqual(status, 0, output)
        for key, expected in (("user.name", "Test Person"),
                              ("user.email", "test@example.invalid")):
            result = subprocess.run([GIT, "config", "--file", str(self.home / ".gitconfig"), key],
                                    env=self.env, capture_output=True, text=True)
            self.assertEqual(result.stdout.strip(), expected)

    def test_git_without_tty_does_not_install_template_identity(self):
        result = self.run_script("scripts/git.sh")
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse((self.home / ".gitconfig").exists())

    def test_empty_git_identity_preserves_existing_config(self):
        config = self.home / ".gitconfig"
        original = "[user]\nname = Existing User\nemail = old@example.invalid\n"
        config.write_text(original)
        status, output = self.run_tty(["/bin/bash", "scripts/git.sh"], "y\n\n\n")
        self.assertNotEqual(status, 0, output)
        self.assertEqual(config.read_text(), original)

    def prepare_sol(self):
        if JQ:
            (self.bin / "jq").symlink_to(JQ)
        self.stub("open", 'echo "$*" >> "$HOME/sol-launches"; exit "${TEST_OPEN_EXIT:-0}"')
        self.stub("pgrep", "exit 1")
        self.stub("osascript", "echo Unexpected AppleScript >&2; exit 97")
        self.stub("activateSettings", "exit 0")
        self.stub("defaults", 'echo "$*" >> "$HOME/preference-writes"')
        return self.home / ".config/sol/config.json"

    @unittest.skipUnless(JQ, "jq is needed for Sol configuration merging")
    def test_sol_preserves_unrelated_settings_and_is_safe_to_rerun(self):
        target = self.prepare_sol()
        target.parent.mkdir(parents=True)
        original = {
            "globalShortcut": "option", "launchAtLogin": False,
            "searchFolders": ["/a folder"],
            "shortcuts": {"custom": "command+shift+k"},
            "customItems": [{"name": "My item", "url": "https://example.invalid"}],
        }
        target.write_text(json.dumps(original))
        for attempt in range(2):
            result = self.run_script("scripts/sol.sh")
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(json.loads(target.read_text()), {
                **original, "globalShortcut": "command", "launchAtLogin": True,
            })
            backups = list(target.parent.glob("config.json.backup.*"))
            self.assertEqual(len(backups), 1)
            self.assertEqual(json.loads(backups[0].read_text()), original)
            self.assertEqual(list(target.parent.glob(".config.*")), [])

    @unittest.skipUnless(JQ, "jq is needed for Sol configuration merging")
    def test_invalid_sol_config_does_not_clobber_settings_or_disable_spotlight(self):
        target = self.prepare_sol()
        target.parent.mkdir(parents=True)
        for original in ("{broken", "", "[]", "null", "{} {}"):
            with self.subTest(original=original):
                target.write_text(original)
                result = self.run_script("scripts/sol.sh")
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(target.read_text(), original)
                self.assertFalse((self.home / "preference-writes").exists())
                self.assertEqual(list(target.parent.glob(".config.*")), [])

    def test_missing_sol_does_not_disable_spotlight(self):
        target = self.prepare_sol()
        self.env["TEST_OPEN_EXIT"] = "1"
        result = self.run_script("scripts/sol.sh")
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(target.exists())
        self.assertFalse((self.home / "preference-writes").exists())

if __name__ == "__main__":
    unittest.main()
