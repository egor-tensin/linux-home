#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <egor@tensin.name>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

swap_files() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true

    if [ "$#" -ne 2 ]; then
        echo "usage: ${FUNCNAME[0]} PATH1 PATH2" >&2
        return 1
    fi

    local path1="$1"
    local path2="$2"

    if [ ! -r "$path1" ] || [ ! -w "$path1" ]; then
        echo "${FUNCNAME[0]}: must be readable and writable: $path1" >&2
        return 1
    fi

    if [ ! -r "$path2" ] || [ ! -w "$path2" ]; then
        echo "${FUNCNAME[0]}: must be readable and writable: $path2" >&2
        return 1
    fi

    local path1_dir
    path1_dir="$( dirname -- "$path1" )"

    local tmp_path
    tmp_path="$( mktemp -- "$path1_dir/XXX" )"

    mv -- "$path1" "$tmp_path"
    mv -- "$path2" "$path1"
    mv -- "$tmp_path" "$path2"
)

pastebin() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true

    if [ "$#" -ne 1 ]; then
        echo "usage: ${FUNCNAME[0]} PATH" >&2
        return 1
    fi

    local path="$1"

    # Use the .txt file extension so that when you open a link, it displays
    # the contents instead of downloading.
    curl -sS --connect-timeout 5 -F "file=@$path;filename=.txt" https://x0.at/
)
