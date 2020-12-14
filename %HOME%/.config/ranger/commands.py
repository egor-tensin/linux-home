# This I borrowed from the default Manjaro setup, which in turn borrowed it
# from somewhere else.

from ranger.api.commands import Command

class paste_as_root(Command):
	def execute(self):
		if self.fm.do_cut:
			self.fm.execute_console('shell sudo mv %c .')
		else:
			self.fm.execute_console('shell sudo cp -r %c .')

class fzf_select(Command):
    def execute(self):
        import subprocess
        import os.path
        if self.quantifier:
            # Trigger this by prefixing the command hotkey with e.g. a number.
            command = "find -L . \
    \( -fstype 'dev' -o -fstype 'proc' \) -prune \
    -o -type d -print 2> /dev/null \
| sed 1d \
| cut -b3- \
| fzf +m --reverse"
        else:
            # Match files and directories.
            command = "find -L . \
    \( -fstype 'dev' -o -fstype 'proc' \) -prune \
    -o -print 2> /dev/null \
| sed 1d \
| cut -b3- \
| fzf +m --reverse"
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)
