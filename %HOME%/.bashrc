# Copyright (c) 2018 Egor Tensin <egor@tensin.name>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

case "$-" in
    *i*) ;;
      *) return ;;
esac

# Tango:
#PS1="\[\e[1;32m\]\h\[\e[m\] \[\e[1;34m\]\W\[\e[m\] # \[$(tput sgr0)\]"
# Solarized (light):
PS1="\[\e[1;35m\]\h\[\e[m\] \[\e[1;36m\]\W\[\e[m\] # \[$(tput sgr0)\]"

# -----------------------------------------------------------------------------
# Command history
# -----------------------------------------------------------------------------
# `echo "!)"` doesn't work otherwise (namely, in third-party scripts):
set +o histexpand

export HISTCONTROL=ignoredups
export HISTFILESIZE=20000
export HISTSIZE=20000

# -----------------------------------------------------------------------------
# Includes
# -----------------------------------------------------------------------------

[ -r "$HOME/.bash_utils/file.sh" ] && source "$HOME/.bash_utils/file.sh"
[ -r "$HOME/.bash_utils/text.sh" ] && source "$HOME/.bash_utils/text.sh"

[ -r "$HOME/.bash_utils/alternatives.sh" ] && source "$HOME/.bash_utils/alternatives.sh"
[ -r "$HOME/.bash_utils/cxx.sh"          ] && source "$HOME/.bash_utils/cxx.sh"
[ -r "$HOME/.bash_utils/distr.sh"        ] && source "$HOME/.bash_utils/distr.sh"
[ -r "$HOME/.bash_utils/git.sh"          ] && source "$HOME/.bash_utils/git.sh"
[ -r "$HOME/.bash_utils/os.sh"           ] && source "$HOME/.bash_utils/os.sh"
[ -r "$HOME/.bash_utils/path.sh"         ] && source "$HOME/.bash_utils/path.sh"

[ -r "$HOME/.bashrc_local" ] && source "$HOME/.bashrc_local"

# -----------------------------------------------------------------------------
# Shell options
# -----------------------------------------------------------------------------

# Too many third-party scripts stop working w/ nounset enabled :-(
#set -o nounset

set -o pipefail

shopt -s autocd
shopt -s checkwinsize
shopt -s dotglob
shopt -s histappend
shopt -s nullglob
shopt -s nocaseglob

os_is_cygwin && set -o igncr
os_is_cygwin || complete -r

# I'm sick and tired of third-party scripts breaking b/c of a random shell
# option I use (configure scripts in particular), so I'm commenting this out.
#export SHELLOPTS
#export BASHOPTS

# I've bumped into this on Linux Mint: Ctrl+S causes my terminal to freeze
# completely (Ctrl+Q is a temporary escape, stty is the cure).
os_is_cygwin \
    || command -v stty > /dev/null 2>&1 \
    && stty -ixon

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

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

alias sed='sed --follow-symlinks'

# Use in a pipeline:
#     command | copy
if os_is_linux; then
    alias copy='xclip -sel clip'
elif os_is_cygwin; then
    alias copy='cat > /dev/clipboard'
elif os_is_macos; then
    alias copy='pbcopy'
fi

# Make sure ssh-copy-id copies public keys along with their comments.
alias ssh-copy-id='ssh-copy-id -i'

# Shut GDB up:
alias gdb='gdb -q'
alias coredumpctl='coredumpctl --debugger-arguments="-q"'

# Group by 1 byte only with xxd:
alias xxd='xxd -groupsize 1'

# -----------------------------------------------------------------------------
# GnuPG
# -----------------------------------------------------------------------------

# This doc says that "you should always add the following lines to your
# .bashrc":
#
#     https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
#
# Otherwise, GPG signing in git often doesn't work (for example, ever a SSH
# connection): https://stackoverflow.com/a/54809060/514684
GPG_TTY="$( tty )"
export GPG_TTY

# -----------------------------------------------------------------------------
# nnn
# -----------------------------------------------------------------------------

inside_nnn() {
    [ -n "$NNNLVL" ] && [ "${NNNLVL:-0}" -ge 1 ]
}

# nnn: print selected paths.
alias ncp="cat ${NNN_SEL:-${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.selection} | tr '\0' '\n'"

# nnn: like quitcd.bash_zsh, but better.
n() {
    inside_nnn && exit

    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    /usr/bin/nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        rm -f -- "$NNN_TMPFILE" > /dev/null
    fi
}

nnn() {
    n "$@"
}

# -----------------------------------------------------------------------------
# tmux
# -----------------------------------------------------------------------------

remote_terminal() {
    test -n "$SSH_CONNECTION"
}

local_terminal() {
    ! remote_terminal
}

multiplexed() {
    test -n "$STY" -o -n "$TMUX"
}

if multiplexed && ! inside_nnn && local_terminal; then
    # Launch nnn automatically in tmux, except when I'm inside a ssh session.
    # `which` instead of the normal `command -v` here because we need the
    # actual external executable, not the function defined above.
    which nnn &> /dev/null && exec nnn
fi

# tmux: start automatically.
# https://unix.stackexchange.com/a/113768
if os_is_cygwin && local_terminal; then
    # Skip, as it's too slow for some reason.
    true
elif multiplexed; then
    # Skip, we're already running a multiplexer.
    true
elif command -v tmux &> /dev/null; then
    exec tmux new -A -s main
fi

# Disable Alt+N shortcuts, which I use in tmux:
# https://superuser.com/a/770902
for i in "-" {0..9}; do bind -r "\e$i"; done
