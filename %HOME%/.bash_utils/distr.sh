#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

sums_path='sha1sums.txt'
sums_name="$( basename -- "$sums_path" )"

_sums_unescape_path() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    if [ "$#" -ne 1 ]; then
        echo "usage: ${FUNCNAME[0]} PATH" >&2
        return 1
    fi

    local path="$1"
    path="${path//'\\'/$'\\'}"
    path="${path//'\n'/$'\n'}"
    echo "$path"
)

sums_list_paths() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    local print_lines=
    local print_sums=
    local zero_terminated=

    while [ "$#" -gt 0 ]; do
        local key="$1"
        shift
        case "$key" in
            -h|--help)
                echo "usage: ${FUNCNAME[0]} [-h|--help] [-0|--null|-z|--zero] [-l|--lines] [-s|--sums]"
                return 0
                ;;
            -0|-null|-z|--zero)
                zero_terminated=1
                ;;
            -l|--lines)
                print_lines=1
                ;;
            -s|--sums)
                print_sums=1
                ;;
            *)
                echo "${FUNCNAME[0]}: unrecognized parameter: $key" >&2
                return 1
                ;;
        esac
    done

    local fmt_line='%s\n'
    [ -n "$zero_terminated" ] && fmt_line='%s\0'

    local fmt_output="$fmt_line"

    [ -n "$print_lines" ] && fmt_output="$fmt_line$fmt_output"
    [ -n "$print_sums"  ] && fmt_output="$fmt_output$fmt_line"

    [ -e "$sums_path" ] || return 0

    local -a output=()
    local line

    while IFS= read -r line; do
        {
            local path sum

            IFS= read -d ' ' -r sum
            local escaped=
            if [ "${sum#'\'}" != "$sum" ]; then
                escaped=1
                sum="${sum:1}"
            fi

            IFS= read -r path
            path="${path#'*'}"
            [ -n "$escaped" ] && path="$( _sums_unescape_path "$path" )"

            [ -n "$print_lines" ] && output+=("$line")
            output+=("$path")
            [ -n "$print_sums"  ] && output+=("$sum")
        } <<< "$line"
    done < "$sums_path"

    if [ "${#output[@]}" -gt 0 ]; then
        printf -- "$fmt_output" ${output[@]+"${output[@]}"}
    fi
)

sums_add() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit lastpipe

    local -A existing
    local -a missing=()

    local path
    sums_list_paths -z | while IFS= read -d '' -r path; do
        existing[$path]=1
    done

    for path; do
        [ -z "${existing[$path]+x}" ] && missing+=("$path")
    done

    [ "${#missing[@]}" -eq 0 ] && return 0

    sha1sum -- ${missing[@]+"${missing[@]}"} >> "$sums_path"
)

sums_add_all() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit lastpipe

    local -a paths

    local path
    find . -type f -\! -iname "$sums_name" -printf '%P\0' | while IFS= read -d '' -r path; do
        paths+=("$path")
    done

    sums_add ${paths[@]+"${paths[@]}"}
)

sums_add_distr() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit lastpipe

    local -a paths
    local path

    find . -type f -\(        \
        -iname '*.7z'         \
        -o -iname '*.exe'     \
        -o -iname '*.img'     \
        -o -iname '*.iso'     \
        -o -iname '*.tar'     \
        -o -iname '*.tar.bz2' \
        -o -iname '*.tar.gz'  \
        -o -iname '*.zip'     \
        -\) -printf '%P\0' |
    while IFS= read -d '' -r path; do
        paths+=("$path")
    done

    sums_add ${paths[@]+"${paths[@]}"}
)

sums_verify() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    sha1sum --check --strict --quiet -- "$sums_path"
)

sums_remove_missing() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit lastpipe

    local dry_run=

    while [ "$#" -gt 0 ]; do
        local key="$1"
        shift
        case "$key" in
            -h|--help)
                echo "usage: ${FUNCNAME[0]} [-h|--help] [-n|--dry-run]"
                return 0
                ;;
            -n|--dry-run)
                dry_run=1
                ;;
            *)
                echo "${FUNCNAME[0]}: unrecognized parameter: $key" >&2
                return 1
                ;;
        esac
    done

    local -a input=()
    local -a paths=()

    local line path
    sums_list_paths -z --lines | while IFS= read -d '' -r line; do
        IFS= read -d '' -r path
        input+=("$line")
        paths+=("$path")
    done

    local -a output=()

    local i
    for i in "${!paths[@]}"; do
        if [ ! -e "${paths[$i]}" ]; then
            echo "${FUNCNAME[0]}: doesn't exist: ${paths[$i]}"
        else
            output+=("${input[$i]}")
        fi
    done

    [ -n "$dry_run" ] && return 0

    for line in ${output[@]+"${output[@]}"}; do
        echo "$line"
    done > "$sums_path"
)
