#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

sums_path='sha1sums.txt'

sums_list_paths() (
    set -o errexit -o nounset -o pipefail

    local fmt='%s\n'

    while [ "$#" -gt 0 ]; do
        local key="$1"
        shift
        case "$key" in
            -h|--help)
                echo "usage: ${FUNCNAME[0]} [-h|--help] [-0|--null|-z|--zero]"
                return 0
                ;;
            -0|-null|-z|--zero)
                fmt='%s\0'
                ;;
            *)
                echo "${FUNCNAME[0]}: unrecognized parameter: $key" >&2
                return 1
                ;;
        esac
    done

    [ -e "$sums_path" ] || return 0

    local -a paths=()
    local sum path

    while IFS= read -d ' ' -r sum; do
        local escaped=
        if [ "${sum#'\'}" != "$sum" ]; then
            escaped=1
            sum="${sum:1}"
        fi
        IFS= read -r path
        path="${path#'*'}"
        if [ -n "$escaped" ]; then
            path="${path//'\\'/$'\\'}"
            path="${path//'\n'/$'\n'}"
        fi
        paths+=("$path")
    done < "$sums_path"

    [ "${#paths[@]}" -gt 0 ] && printf -- "$fmt" ${paths[@]+"${paths[@]}"}
)

sums_add() (
    set -o errexit -o nounset -o pipefail

    local -A existing
    local -a missing=()

    local path

    while IFS= read -d '' -r path; do
        existing[$path]=1
    done < <( sums_list_paths -z )

    for path; do
        [ -z "${existing[$path]+x}" ] && missing+=("$path")
    done

    [ "${#missing[@]}" -eq 0 ] && return 0

    sha1sum -- ${missing[@]+"${missing[@]}"} >> "$sums_path"
)

sums_add_all() (
    set -o errexit -o nounset -o pipefail

    local -a paths
    local path

    while IFS= read -d '' -r path; do
        paths+=("$path")
    done < <( find . -type f -\! -name "$( basename -- "$sums_path" )" -printf '%P\0' )

    sums_add ${paths[@]+"${paths[@]}"}
)

sums_add_distr() (
    set -o errexit -o nounset -o pipefail

    local -a paths
    local path

    while IFS= read -d '' -r path; do
        paths+=("$path")
    done < <( find . -type f -\( -iname '*.exe' -o -iname '*.iso' -o -iname '*.tar.gz' -o -iname '*.tar.bz2' -o -iname '*.zip' -\) -printf '%P\0' )

    sums_add ${paths[@]+"${paths[@]}"}
)

sums_verify() {
    sha1sum --check --quiet -- "$sums_path"
}
