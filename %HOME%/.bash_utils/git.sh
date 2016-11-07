#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

source "$HOME/.bash_utils/text.sh"

list_repo_files() (
    set -o errexit -o nounset -o pipefail

    local -a cmd=(git ls-tree -r)

    while [ "$#" -gt 0 ]; do
        local key="$1"
        shift
        case "$key" in
            -h|--help)
                echo "usage: ${FUNCNAME[0]} [-h|--help] [-0|-z]"
                return 0
                ;;
            -0|-z)
                cmd+=(-z)
                ;;
            *)
                echo "${FUNCNAME[0]}: unrecognized parameter: $key" >&2
                return 1
                ;;
        esac
    done

    cmd+=(--name-only HEAD)

    eval ${cmd[@]+"${cmd[@]}"}
)

list_repo_dirs() (
    set -o errexit -o nounset -o pipefail

    local -a cmd=(git ls-tree -r -d)

    while [ "$#" -gt 0 ]; do
        local key="$1"
        shift
        case "$key" in
            -h|--help)
                echo "usage: ${FUNCNAME[0]} [-h|--help] [-z|-0]"
                return 0
                ;;
            -z|-0)
                cmd+=(-z)
                ;;
            *)
                echo "${FUNCNAME[0]}: unrecognized parameter: $key" >&2
                return 1
                ;;
        esac
    done

    cmd+=(--name-only HEAD)

    eval ${cmd[@]+"${cmd[@]}"}
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
    zip_name="${repo_name}_$( date -u +'%Y%m%dT%H%M%S' ).zip"

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
