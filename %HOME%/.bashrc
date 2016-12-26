case "$-" in
    *i*) ;;
      *) return ;;
esac

export PS1="\[\e[33m\]\h\[\e[m\] \[\e[31m\]\W\[\e[m\] # \[$(tput sgr0)\]"

#set -o nounset
set -o pipefail

shopt -s checkwinsize
shopt -s dotglob
shopt -s histappend
shopt -s nullglob
shopt -s nocaseglob

alias sudo='sudo '

alias df='df --human-readable'
alias du='du --human-readable'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

alias ls='LC_COLLATE=C ls --almost-all -l --human-readable --color=auto'
alias dir='ls --format=vertical'

alias less='less --ignore-case --RAW-CONTROL-CHARS'
alias tree='tree -a'

alias ssh-copy-id='ssh-copy-id -i'

alias cls='echo -en "\ec"'

[ -r "$HOME/.bash_utils/cxx.sh"   ] && source "$HOME/.bash_utils/cxx.sh"
[ -r "$HOME/.bash_utils/distr.sh" ] && source "$HOME/.bash_utils/distr.sh"
[ -r "$HOME/.bash_utils/file.sh"  ] && source "$HOME/.bash_utils/file.sh"
[ -r "$HOME/.bash_utils/git.sh"   ] && source "$HOME/.bash_utils/git.sh"
[ -r "$HOME/.bash_utils/os.sh"    ] && source "$HOME/.bash_utils/os.sh"
[ -r "$HOME/.bash_utils/path.sh"  ] && source "$HOME/.bash_utils/path.sh"
[ -r "$HOME/.bash_utils/ruby.sh"  ] && source "$HOME/.bash_utils/ruby.sh"
[ -r "$HOME/.bash_utils/text.sh"  ] && source "$HOME/.bash_utils/text.sh"

export PYTHONSTARTUP="$HOME/.pythonrc"

is_cygwin && set -o igncr
is_cygwin || complete -r

export SHELLOPTS

if is_cygwin; then
    alias mingcc32='i686-w64-mingw32-gcc'
    alias ming++32='i686-w64-mingw32-g++'
    alias mingcc='x86_64-w64-mingw32-gcc'
    alias ming++='x86_64-w64-mingw32-g++'
fi
