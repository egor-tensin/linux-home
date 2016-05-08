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
# shopt -s nocaseglob
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
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CF'                              #

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

PS1='\[\e[33m\]\W\[\e[0m\]: '

netwrix_host=172.28.10.2
netwrix_dev=172.28.12.149
netwrix_dev2=172.28.19.60
netwrix_dev3=172.28.19.61

list_files() {
  local cmd='find . -type f'
  if [ $# -gt 0 ]; then
    cmd+="$( printf ' %q' '-(' )"
    local fmask="$1"
    cmd+="$( printf ' -iname %q' "$fmask" )"
    shift
    for fmask; do
      cmd+="$( printf ' -o -iname %q' "$fmask" )"
    done
    cmd+="$( printf ' %q' '-)' )"
  fi
  eval "$cmd"
}

list_dirs() {
  find . -type d
}

list_git_files() {
  git ls-files
}

list_git_dirs() {
  {
    list_git_files | xargs realpath | xargs dirname && realpath .
  } | sort | uniq | tail -n +2
}

adjust_dotfiles_permissions() {
  pushd ~ > /dev/null \
    && list_git_files | xargs chmod 0600 \
    && list_git_dirs | xargs chmod 0700 \
    && chmod 0700 .git \
    && pushd .git > /dev/null \
    && list_files | xargs chmod 0600 \
    && list_dirs | xargs chmod 0700 \
    && popd > /dev/null \
    && popd > /dev/null
}

alias rtrim_line_whitespace='sed --binary --in-place '"'"'s/[[:blank:]]*\(\r\?\)$/\1/'"'"
alias rtrim_file_newlines_dos='sed --binary --in-place -e :a -e '"'"'/^\(\r\n\)*\r$/{$d;N;ba}'"'"
alias rtrim_file_newlines_unix='sed --binary --in-place -e :a -e '"'"'/^\n*$/{$d;N;ba}'"'"
alias ensure_eol_dos='sed --binary --in-place -e '"'"'$s/\r\?$/\r/;a\'"'"
alias ensure_eol_unix='sed --binary --in-place -e '"'"'$a\'"'"

lint() {
  rtrim_line_whitespace "$@" \
    && rtrim_file_newlines_unix "$@" \
    && ensure_eol_unix "$@"
}

lint_all() {
  local path
  list_files "$@" | while read -r path ; do lint "$path" ; done
}

doslint() {
  rtrim_line_whitespace "$@" \
    && rtrim_file_newlines_dos "$@" \
    && ensure_eol_dos "$@"
}

doslint_all() {
  local path
  list_files "$@" | while read -r path ; do doslint "$path" ; done
}

doslint_netwrix() {
  local root_dir='/cygdrive/c/Netwrix Auditor/CurrentVersion-AuditCore-Dev/AuditCore/Sources'
  pushd "$root_dir/Configuration" > /dev/null \
    && doslint_all 'WebAPI*.acinc' 'WebAPI*.acconf' \
    && popd > /dev/null \
    && pushd "$root_dir/Subsystems/PublicAPI" > /dev/null \
    && doslint_all '*.cpp' '*.h' \
    && popd > /dev/null
}

backup_repo() {
  if [ $# -eq 1 ]; then
    local repo_dir_path="$1"
    local backup_dir_path="$( realpath . )" || return $?
  elif [ $# -eq 2 ]; then
    local repo_dir_path="$1"
    local backup_dir_path="$2"
  else
    echo "Usage: $FUNCNAME REPO_DIR_PATH [BACKUP_DIR_PATH]" >&2
    return 1
  fi
  local zip_name="$( basename "$( realpath "$repo_dir_path" )" )_$( date -u +'%Y%m%dT%H%M%S' ).zip" || return $?
  git archive \
    --format=zip -9 \
    --output="$backup_dir_path/$zip_name" \
    --remote="$repo_dir_path" \
    HEAD
}

backup_repo_dropbox() {
  backup_repo "$@" "/cygdrive/c/Users/$( whoami )/Dropbox/backups"
}

backup_repo_netwrix() {
  backup_repo "$@" '//spbfs02/P/Personal/Egor Tensin'
}

checksums_path='sha1sums.txt'

update_checksums() {
  list_files "$@" | xargs sha1sum > "$checksums_path"
}

update_distr_checksums() {
  update_checksums '*.exe' '*.iso'
}

verify_checksums() {
  sha1sum --check "$checksums_path"
}
