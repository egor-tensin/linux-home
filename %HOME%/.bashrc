# Copyright (c) 2018 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Linux/Cygwin environment" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

case "$-" in
    *i*) ;;
      *) return ;;
esac

PS1="\[\e[1;32m\]\h\[\e[m\] \[\e[1;34m\]\W\[\e[m\] # \[$(tput sgr0)\]"

# `echo "!)"` doesn't work otherwise (namely, in third-party scripts):
set +o histexpand

# Don't store duplicate commands.
export HISTCONTROL=ignoredups

# Too many third-party scripts stop working w/ nounset enabled :-(
#set -o nounset

set -o pipefail

shopt -s checkwinsize
shopt -s dotglob
shopt -s histappend
shopt -s nullglob
shopt -s nocaseglob

# Make aliases work with sudo:
alias sudo='sudo '

alias df='df --human-readable'
alias du='du --human-readable'
alias free='free --human'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

alias ls='LC_COLLATE=C ls --almost-all -l --human-readable --color=auto'
alias dir='ls --format=vertical'

alias less='less --ignore-case --line-numbers --RAW-CONTROL-CHARS'
alias tree='tree -a'

alias utc_file_name='date --utc +"%Y%m%d%H%M%S"'
alias utc_iso='date --utc +"%Y-%m-%dT%H:%M:%SZ"'

#alias sed='sed --follow-symlinks'
# The alias above doesn't actually work with stdin in sed 4.2.2, it's a bug
# fixed in sed 4.3.
# Don't forget to uncomment once sed 4.3 becomes common.

alias detached='screen -d -m'

# Clear the screen (https://stackoverflow.com/a/5367075/514684):
alias cls='echo -en "\ec"'

alias copy='xclip -sel clip'

# Make ssh work properly when connecting to some CentOS servers from inside a
# screen session:
alias ssh='TERM=xterm ssh'

# Make sure ssh-copy-id copies public keys along with their comments.
alias ssh-copy-id='ssh-copy-id -i'

[ -r "$HOME/.bash_utils/file.sh" ] && source "$HOME/.bash_utils/file.sh"
[ -r "$HOME/.bash_utils/text.sh" ] && source "$HOME/.bash_utils/text.sh"

[ -r "$HOME/.bash_utils/alternatives.sh" ] && source "$HOME/.bash_utils/alternatives.sh"
[ -r "$HOME/.bash_utils/cxx.sh"          ] && source "$HOME/.bash_utils/cxx.sh"
[ -r "$HOME/.bash_utils/distr.sh"        ] && source "$HOME/.bash_utils/distr.sh"
[ -r "$HOME/.bash_utils/git.sh"          ] && source "$HOME/.bash_utils/git.sh"
[ -r "$HOME/.bash_utils/mysql.sh"        ] && source "$HOME/.bash_utils/mysql.sh"
[ -r "$HOME/.bash_utils/os.sh"           ] && source "$HOME/.bash_utils/os.sh"
[ -r "$HOME/.bash_utils/path.sh"         ] && source "$HOME/.bash_utils/path.sh"

[ -r "$HOME/.bashrc_local" ] && source "$HOME/.bashrc_local"

os_is_cygwin && set -o igncr
os_is_cygwin || complete -r

# I'm sick and tired of third-party scripts breaking b/c of a random shell
# option I use (configure scripts in particular), so I'm commenting this out.
#export SHELLOPTS
#export BASHOPTS

if os_is_cygwin; then
    alias mingcc32='i686-w64-mingw32-gcc'
    alias ming++32='i686-w64-mingw32-g++'
    alias mingcc='x86_64-w64-mingw32-gcc'
    alias ming++='x86_64-w64-mingw32-g++'
fi

# I've bumped into this on Linux Mint: Ctrl+S causes my terminal to freeze
# completely (Ctrl+Q is a temporary escape, stty is the cure).
os_is_cygwin \
    || command -v stty > /dev/null 2>&1 \
    && stty -ixon
