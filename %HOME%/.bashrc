case "$-" in
    *i*) ;;
      *) return ;;
esac

PS1='\[\e[33m\]\W\[\e[0m\]: '

set -o nounset
set -o pipefail

shopt -s checkwinsize
shopt -s dotglob
shopt -s histappend
shopt -s nullglob
shopt -s nocaseglob

_os="$( uname -o )"

is_cygwin() {
    test "$_os" == 'Cygwin'
}

alias df='df --human-readable'
alias du='du --human-readable'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

alias ls='ls --almost-all -l --human-readable --color=auto'
alias dir='ls --format=vertical'

alias less='less --RAW-CONTROL-CHARS'
alias tree='tree -a'

is_cygwin && alias list_packages='cygcheck -cd'

[ -r "$HOME/.bash_utils/cxx.sh"   ] && source "$HOME/.bash_utils/cxx.sh"
[ -r "$HOME/.bash_utils/distr.sh" ] && source "$HOME/.bash_utils/distr.sh"
[ -r "$HOME/.bash_utils/file.sh"  ] && source "$HOME/.bash_utils/file.sh"
[ -r "$HOME/.bash_utils/git.sh"   ] && source "$HOME/.bash_utils/git.sh"
[ -r "$HOME/.bash_utils/path.sh"  ] && source "$HOME/.bash_utils/path.sh"
[ -r "$HOME/.bash_utils/text.sh"  ] && source "$HOME/.bash_utils/text.sh"

export PYTHONSTARTUP="$HOME/.pythonrc"

update_ruby_settings() {
    local user_dir
    local bin_dir

    command -v ruby &> /dev/null                       \
        && command -v gem &> /dev/null                 \
        && user_dir="$( ruby -e 'puts Gem.user_dir' )" \
        && export GEM_HOME="$user_dir"                 \
        && bin_dir="$( ruby -e 'puts Gem.bindir' )"    \
        && add_path "$bin_dir"
}

update_ruby_settings

is_cygwin || complete -r

if is_cygwin; then
    alias mingcc32='i686-w64-mingw32-gcc'
    alias ming++32='i686-w64-mingw32-g++'
    alias mingcc='x86_64-w64-mingw32-gcc'
    alias ming++='x86_64-w64-mingw32-g++'
fi
