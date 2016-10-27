[[ "$-" != *i* ]] && return

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options
#
# Don't put duplicate lines in the history.
# export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
#
# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

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

[ -f "$HOME/.bash_utils/cxx.sh"   ] && source "$HOME/.bash_utils/cxx.sh"
[ -f "$HOME/.bash_utils/distr.sh" ] && source "$HOME/.bash_utils/distr.sh"
[ -f "$HOME/.bash_utils/file.sh"  ] && source "$HOME/.bash_utils/file.sh"
[ -f "$HOME/.bash_utils/git.sh"   ] && source "$HOME/.bash_utils/git.sh"
[ -f "$HOME/.bash_utils/path.sh"  ] && source "$HOME/.bash_utils/path.sh"
[ -f "$HOME/.bash_utils/text.sh"  ] && source "$HOME/.bash_utils/text.sh"

export PYTHONSTARTUP="$HOME/.pythonrc"

update_ruby_settings() {
    local user_dir

    command -v ruby &> /dev/null \
        && command -v gem &> /dev/null \
        && user_dir="$( ruby -e 'print Gem.user_dir' )"  \
        && add_path "$user_dir" \
        && export GEM_HOME="$user_dir"
}

update_ruby_settings
