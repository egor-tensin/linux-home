#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

swap_files() (
    set -o errexit -o nounset -o pipefail

    if [ "$#" -ne 2 ]; then
        echo "usage: ${FUNCNAME[0]} PATH1 PATH2" >&2
        return 1
    fi

    local path1="$1"
    local path2="$2"

    if [ ! -f "$path1" ]; then
        echo "${FUNCNAME[0]}: must be a regular file: $path1" >&2
        return 1
    fi

    if [ ! -f "$path2" ]; then
        echo "${FUNCNAME[0]}: must be a regular file: $path2" >&2
        return 1
    fi

    local tmp_path
    tmp_path="$( mktemp "$( dirname "$path1" )/XXX" )"

    mv "$path1" "$tmp_path"
    mv "$path2" "$path1"
    mv "$tmp_path" "$path2"
)
