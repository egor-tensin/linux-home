# To the extent possible under law, the author(s) have dedicated all 
# copyright and related and neighboring rights to this software to the 
# public domain worldwide. This software is distributed without any warranty. 
# You should have received a copy of the CC0 Public Domain Dedication along 
# with this software. 
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>. 

# base-files version 4.2-3

# ~/.bashrc: executed by bash(1) for interactive shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

set -o pipefail
set -o nounset
shopt -s nullglob

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
# shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

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

# Aliases
#
# Some people use a different file for aliases
# if [ -f "${HOME}/.bash_aliases" ]; then
#   source "${HOME}/.bash_aliases"
# fi
#
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
# Default to human readable figures
alias df='df -h'
alias du='du -h'
#
# Misc :)
alias less='less -R'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different directory listings
alias ls='ls -h --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
# alias ll='ls -l'                              # long list
# alias la='ls -A'                              # all but . and ..
# alias l='ls -CF'                              #

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# Functions
#
# Some people use a different file for functions
# if [ -f "${HOME}/.bash_functions" ]; then
#   source "${HOME}/.bash_functions"
# fi
#
# Some example functions:
#
# a) function settitle
# settitle () 
# { 
#   echo -ne "\e]2;$@\a\e]1;$@\a"; 
# }
# 
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping, 
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
# cd_func ()
# {
#   local x2 the_new_dir adir index
#   local -i cnt
# 
#   if [[ $1 ==  "--" ]]; then
#     dirs -v
#     return 0
#   fi
# 
#   the_new_dir=$1
#   [[ -z $1 ]] && the_new_dir=$HOME
# 
#   if [[ ${the_new_dir:0:1} == '-' ]]; then
#     #
#     # Extract dir N from dirs
#     index=${the_new_dir:1}
#     [[ -z $index ]] && index=1
#     adir=$(dirs +$index)
#     [[ -z $adir ]] && return 1
#     the_new_dir=$adir
#   fi
# 
#   #
#   # '~' has to be substituted by ${HOME}
#   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
# 
#   #
#   # Now change to the new dir and add to the top of the stack
#   pushd "${the_new_dir}" > /dev/null
#   [[ $? -ne 0 ]] && return 1
#   the_new_dir=$(pwd)
# 
#   #
#   # Trim down everything beyond 11th entry
#   popd -n +11 2>/dev/null 1>/dev/null
# 
#   #
#   # Remove any other occurence of this dir, skipping the top of the stack
#   for ((cnt=1; cnt <= 10; cnt++)); do
#     x2=$(dirs +${cnt} 2>/dev/null)
#     [[ $? -ne 0 ]] && return 0
#     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
#     if [[ "${x2}" == "${the_new_dir}" ]]; then
#       popd -n +$cnt 2>/dev/null 1>/dev/null
#       cnt=cnt-1
#     fi
#   done
# 
#   return 0
# }
# 
# alias cd=cd_func

alias list_packages='cygcheck -cd'

PS1='\[\e[33m\]\W\[\e[0m\]: '

nwx_host=172.28.10.2
nwx_dev2=172.28.19.60
nwx_dev3=172.28.19.61

symlink_sublime_preferences() (
  set -o errexit

  local src_dir="$HOME/.Sublime Text 3"
  local dest_dir="$APPDATA/Sublime Text 3/Packages/User"

  if [ ! -d "$dest_dir" ]; then
    mkdir -p "$dest_dir"
  fi

  find "$src_dir" -maxdepth 1 -type f -exec ln --force -s {} "$dest_dir" \;
)

alias list_repo_files='git ls-files -z'

list_repo_dirs() (
  set -o errexit

  { printf '.\0' ; list_repo_files ; } \
    | xargs -0 dirname -z \
    | sort -z \
    | uniq -z \
    | tail -z -n +2
)

tighten_repo_security() (
  set -o errexit

  list_repo_files | xargs -0 chmod 0600
  list_repo_dirs | xargs -0 chmod 0700
  chmod 0700 .git
)

alias dos2eol='sed --binary --in-place '"'"'s/\(\r\?\)$//'"'"
alias eol2dos='sed --binary --in-place '"'"'s/\r\?$/\r/'"'"

alias trim='sed --binary --in-place '"'"'s/[[:blank:]]*\(\r\?\)$/\1/'"'"

alias trimeol='sed --binary --in-place -e :a -e '"'"'/^\n*$/{$d;N;ba}'"'"
alias trimdoseol='sed --binary --in-place -e :a -e '"'"'/^\(\r\n\)*\r$/{$d;N;ba}'"'"

alias eol='sed --binary --in-place '"'"'$a\'"'"
alias doseol='sed --binary --in-place '"'"'$s/\r\?$/\r/;a\'"'"

alias trimbom='sed --binary --in-place '"'"'1 s/^\xef\xbb\xbf//'"'"

lint() {
  trim "$@" && trimeol "$@" && eol "$@"
}

doslint() {
  trim "$@" && trimdoseol "$@" && doseol "$@"
}

lint_webapi() (
  set -o errexit

  local root_dir='/cygdrive/c/Netwrix Auditor/CurrentVersion-AuditCore-Dev/AuditCore/Sources'

  cd "$root_dir/Configuration"
  doslint WebAPI*.acinc WebAPI*.acconf

  cd "$root_dir/Subsystems/PublicAPI"
  local path
  find . -type f -\( -iname '*.cpp' -o -iname '*.h' -\) | while read -r path ; do
    doslint "$path"
  done
)

backup_repo() (
  set -o errexit

  local repo_dir="$( realpath . )"
  local repo_name="$( basename "$repo_dir" )"
  local backup_dir="$repo_dir"

  if [ $# -eq 1 ]; then
    backup_dir="$1"
  elif [ $# -gt 1 ]; then
    echo "Usage: $FUNCNAME [BACKUP_DIR]" >&2
    exit 1
  fi

  local zip_name="${repo_name}_$( date -u +'%Y%m%dT%H%M%S' ).zip"

  git archive \
    --format=zip -9 \
    --output="$backup_dir/$zip_name" \
    --remote="$repo_dir" \
    HEAD
)

backup_repo_dropbox() {
  backup_repo "$USERPROFILE/Dropbox/backups"
}

backup_repo_nwx() {
  backup_repo '//spbfs02/P/Personal/Egor Tensin'
}

checksums_path='sha1sums.txt'

update_checksums() {
  sha1sum "$@" > "$checksums_path"
}

update_checksums_distr() {
  update_checksums *.exe *.iso
}

verify_checksums() {
  sha1sum --check "$checksums_path"
}

runc() (
  set -o errexit

  local -a src_files
  local src_file

  for src_file in "$@"; do
    src_files+=("$( realpath "$src_file" )")
  done

  local build_dir="$( mktemp -d )"
  pushd "$build_dir" > /dev/null

  set +o errexit

  gcc -Wall -Wextra "${src_files[@]}" && ./a.exe
  popd > /dev/null && rm -rf "$build_dir"
)

runcpp() (
  set -o errexit

  local -a src_files
  local src_file

  for src_file in "$@"; do
    src_files+=("$( realpath "$src_file" )")
  done

  local build_dir="$( mktemp -d )"
  pushd "$build_dir" > /dev/null

  set +o errexit

  g++ -std=c++14 -Wall -Wextra "${src_files[@]}" && ./a.exe
  popd > /dev/null && rm -rf "$build_dir"
)

export PYTHONSTARTUP=~/.pythonrc
