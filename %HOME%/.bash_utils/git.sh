#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <egor@tensin.name>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

branch_eol_normalized() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true
    shopt -s lastpipe

    local status
    status="$( git status --porcelain )"

    if [ -n "$status" ]; then
        echo "${FUNCNAME[0]}: repository isn't clean" >&2
        return 1
    fi

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

branch_doslint() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true
    shopt -s lastpipe

    local -a paths

    local path
    git ls-tree -r --name-only -z HEAD | while IFS= read -d '' -r path; do
        paths+=("$path")
    done

    doslint ${paths[@]+"${paths[@]}"}
)

branch_lint() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true
    shopt -s lastpipe

    local -a paths

    local path
    git ls-tree -r --name-only -z HEAD | while IFS= read -d '' -r path; do
        paths+=("$path")
    done

    lint ${paths[@]+"${paths[@]}"}
)

git_replace() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true
    shopt -s lastpipe

    if [ "$#" -ne 2 ]; then
        echo "usage: ${FUNCNAME[0]} STR SUB" 1>&2
        exit 1
    fi

    readonly str="$1"
    readonly sub="$2"

    git grep --files-with-matches -- "$str" | xargs sed -i "s/$str/$sub/g"
)

git_replace_word() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true
    shopt -s lastpipe

    if [ "$#" -ne 2 ]; then
        echo "usage: ${FUNCNAME[0]} STR SUB" 1>&2
        exit 1
    fi

    readonly str="$1"
    readonly sub="$2"

    git grep --files-with-matches --word-regexp -- "$str" | xargs sed -i "s/\b$str\b/$sub/g"
)
