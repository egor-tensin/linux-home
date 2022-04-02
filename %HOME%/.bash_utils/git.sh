#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

alias branch_files='git ls-tree -r --name-only HEAD'
alias branch_dirs='git ls-tree -r --name-only HEAD -d'

alias repo_branches='git for-each-ref '"'"'--format=%(refname:short)'"'"' refs/heads/'

workdir_is_clean() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    local status
    status="$( git status --porcelain )"

    if [ -n "$status" ]; then
        echo "${FUNCNAME[0]}: repository isn't clean" >&2
        return 1
    fi
)

alias workdir_clean_all='git clean -fdx'
alias workdir_clean_ignored='git clean -fdX'

branch_eol_normalized() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit lastpipe

    workdir_is_clean

    local normalized=0

    local line
    git ls-files -z --eol | while IFS= read -d '' -r line; do
        local eolinfo
        if ! eolinfo="$( expr "$line" : 'i/\([^ ]*\)' )"; then
            echo "${FUNCNAME[0]}: couldn't extract eolinfo from: $line" >&2
            return 1
        fi

        local path
        if ! path="$( expr "$line" : $'[^\t]*\t\\(.*\\)' )"; then
            echo "${FUNCNAME[0]}: couldn't extract file path from: $line" >&2
            return 1
        fi

        if [ "$eolinfo" == crlf ]; then
            echo "${FUNCNAME[0]}: CRLF line endings in file: $path" >&2
        elif [ "$eolinfo" == mixed ]; then
            echo "${FUNCNAME[0]}: mixed line endings in file: $path" >&2
        else
            continue
        fi

        normalized=1
    done

    return "$normalized"
)

repo_eol_normalized() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit lastpipe

    workdir_is_clean

    local branch
    repo_branches | while IFS= read -r branch; do
        git checkout --quiet "$branch"
        branch_eol_normalized "$branch"
    done
)

workdir_tighten_permissions() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    branch_files -z | xargs -0 -- chmod 0600 --
    branch_dirs  -z | xargs -0 -- chmod 0700 --
    chmod 0700 .git
)

branch_doslint() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit lastpipe

    local -a paths

    local path
    branch_files -z | while IFS= read -d '' -r path; do
        paths+=("$path")
    done

    doslint ${paths[@]+"${paths[@]}"}
)

branch_lint() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit lastpipe

    local -a paths

    local path
    branch_files -z | while IFS= read -d '' -r path; do
        paths+=("$path")
    done

    lint ${paths[@]+"${paths[@]}"}
)

branch_backup() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

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

branch_backup_dropbox() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    branch_backup "$USERPROFILE/Dropbox/backups"
)

alias branch_fixup_committer_dates='git filter-branch --force --env-filter '"'"'export GIT_COMMITTER_DATE="$GIT_AUTHOR_DATE"'"'"
