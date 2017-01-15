#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

source "$HOME/.bash_utils/text.sh"

alias list_repo_files='git ls-tree -r --name-only HEAD'
alias list_repo_dirs='git ls-tree -r --name-only HEAD -d'

list_repo_branches() {
    git for-each-ref --format='%(refname:short)' refs/heads/
}

is_repo_clean() (
    set -o errexit -o nounset -o pipefail
    test -z "$( git status --porcelain )"
)

alias repo_clean_all='git clean -fdx'
alias repo_clean_ignored='git clean -fdX'

branch_eol_normalized() (
    set -o errexit -o nounset -o pipefail

    if is_repo_clean; then
        repo_clean_ignored
    else
        echo "${FUNCNAME[0]}: repository isn't clean" >&2
        return 1
    fi

    local line
    while IFS= read -d '' -r line; do
        local eolinfo
        if ! eolinfo="$( expr "$line" : 'i/\([^ ]*\)' )"; then
            echo "${FUNCNAME[0]}: couldn't extract eolinfo from: $line" >&2
            return 1
        fi

        local path
        if ! path="$( expr "$line" : $'.*\t\\(.*\\)' )"; then
            echo "${FUNCNAME[0]}: couldn't extract file path from: $line" >&2
            return 1
        fi

        if [ "$eolinfo" == crlf ] || [ "$eolinfo" == mixed ]; then
            echo "${FUNCNAME[0]}: detected inconsistent line endings in file: $path" >&2
        fi
    done < <( git ls-files -z --eol )
)

repo_eol_normalized() (
    set -o errexit -o nounset -o pipefail

    if is_repo_clean; then
        repo_clean_ignored
    else
        echo "${FUNCNAME[0]}: repository isn't clean" >&2
        return 1
    fi

    local branch
    while IFS= read -r branch; do
        git checkout --quiet "$branch"
        branch_eol_normalized "$branch"
    done < <( list_repo_branches )
)

tighten_repo_security() (
    set -o errexit -o nounset -o pipefail

    list_repo_files -z | xargs -0 -- chmod 0600 --
    list_repo_dirs  -z | xargs -0 -- chmod 0700 --
    chmod 0700 .git
)

doslint_repo() (
    set -o errexit -o nounset -o pipefail

    local -a paths
    local path

    while IFS= read -d '' -r path; do
        paths+=("$path")
    done < <( list_repo_files -z )

    doslint ${paths[@]+"${paths[@]}"}
)

lint_repo() (
    set -o errexit -o nounset -o pipefail

    local -a paths
    local path

    while IFS= read -d '' -r path; do
        paths+=("$path")
    done < <( list_repo_files -z )

    lint ${paths[@]+"${paths[@]}"}
)

backup_repo() (
    set -o errexit -o nounset -o pipefail

    local repo_dir
    repo_dir="$( pwd )"
    local repo_name
    repo_name="$( basename -- "$repo_dir" )"
    local backup_dir="$repo_dir"

    if [ $# -eq 1 ]; then
        backup_dir="$1"
    elif [ $# -gt 1 ]; then
        echo "usage: ${FUNCNAME[0]} [BACKUP_DIR]" >&2
        exit 1
    fi

    local zip_name
    zip_name="${repo_name}_$( date --utc -- '+%Y%m%dT%H%M%S' ).zip"

    git archive \
        --format=zip -9 \
        --output="$backup_dir/$zip_name" \
        --remote="$repo_dir" \
        HEAD
)

backup_repo_dropbox() (
    set -o errexit -o nounset -o pipefail

    backup_repo "$USERPROFILE/Dropbox/backups"
)
