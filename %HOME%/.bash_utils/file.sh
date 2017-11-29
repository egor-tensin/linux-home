#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Linux/Cygwin environment" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

swap_files() (
    set -o errexit -o nounset -o pipefail

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
