case "$-" in
    *i*) ;;
      *) return ;;
esac

export PS1="\[\e[1;32m\]\h\[\e[m\] \[\e[1;34m\]\W\[\e[m\] # \[$(tput sgr0)\]"

set +o histexpand
# `echo "!)"` doesn't work otherwise (namely, in third-party scripts).
#set -o nounset
# Too many third-party scripts stop working w/ nounset enabled :-(
set -o pipefail

shopt -s checkwinsize
shopt -s dotglob
shopt -s histappend
shopt -s nullglob
shopt -s nocaseglob

alias sudo='sudo '

alias df='df --human-readable'
alias du='du --human-readable'
alias free='free --human'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

alias ls='LC_COLLATE=C ls --almost-all -l --human-readable --color=auto'
alias dir='ls --format=vertical'

alias less='less --ignore-case --RAW-CONTROL-CHARS'
alias tree='tree -a'

#alias sed='sed --follow-symlinks'
# The alias above doesn't actually work with stdin in sed 4.2.2, it's a bug
# fixed in sed 4.3.
# Don't forget to uncomment once sed 4.3 becomes common.

alias ssh-copy-id='ssh-copy-id -i'

alias cls='echo -en "\ec"'
alias copy='xclip -sel clip'

[ -r "$HOME/.bash_utils/cxx.sh"    ] && source "$HOME/.bash_utils/cxx.sh"
[ -r "$HOME/.bash_utils/distr.sh"  ] && source "$HOME/.bash_utils/distr.sh"
[ -r "$HOME/.bash_utils/file.sh"   ] && source "$HOME/.bash_utils/file.sh"
[ -r "$HOME/.bash_utils/git.sh"    ] && source "$HOME/.bash_utils/git.sh"
[ -r "$HOME/.bash_utils/os.sh"     ] && source "$HOME/.bash_utils/os.sh"
[ -r "$HOME/.bash_utils/path.sh"   ] && source "$HOME/.bash_utils/path.sh"
[ -r "$HOME/.bash_utils/python.sh" ] && source "$HOME/.bash_utils/python.sh"
[ -r "$HOME/.bash_utils/ruby.sh"   ] && source "$HOME/.bash_utils/ruby.sh"
[ -r "$HOME/.bash_utils/text.sh"   ] && source "$HOME/.bash_utils/text.sh"

[ -r "$HOME/.bash_aliases" ] && source "$HOME/.bash_aliases"

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

if command -v vim > /dev/null 2>&1; then
    export EDITOR=vim
elif command -v nano > /dev/null 2>&1; then
    export EDITOR=nano
fi

# I've bumped into this on Linux Mint: Ctrl+S causes my terminal to freeze
# completely (Ctrl+Q is a temporary escape, stty is the cure).
os_is_cygwin \
    || command -v stty > /dev/null 2>&1 \
    && stty -ixon
