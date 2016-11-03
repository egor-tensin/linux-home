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

alias df='df --human-readable'
alias du='du --human-readable'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

alias ls='ls --almost-all -l --human-readable --color=auto'
alias dir='ls --format=vertical'

alias less='less --RAW-CONTROL-CHARS'
alias tree='tree -a'

[ "$( uname -o )" == 'Cygwin' ] && alias list_packages='cygcheck -cd'

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

    command -v ruby &> /dev/null \
        && command -v gem &> /dev/null \
        && user_dir="$( ruby -e 'print Gem.user_dir' )"  \
        && bin_dir="$( ruby -e 'puts Gem.bindir' )" \
        && add_path "$bin_dir" \
        && export GEM_HOME="$user_dir"
}

update_ruby_settings

[ "$( uname -o )" != 'Cygwin' ] && complete -r
