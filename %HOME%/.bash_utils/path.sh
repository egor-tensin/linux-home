#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/text.sh"

add_missing_path() (
    set -o errexit -o nounset -o pipefail

    [ "$#" -eq 0 ] && return 0

    local -a new_paths
    local path

    while IFS= read -d '' -r path; do
        new_paths+=("$path")
    done < <( readlink --zero --canonicalize-missing "$@" )

    for path; do
        if str_contains "$path" ':'; then
            echo "${FUNCNAME[0]}: mustn't contain colons: $path" >&2
            return 1
        fi
    done

    local -A old_paths

    while IFS= read -d '' -r path; do
        old_paths[$path]=1
    done < <( str_split -z -- "${PATH-}" ':' | xargs --null readlink --zero --canonicalize-missing )

    for path in ${new_paths[@]+"${new_paths[@]}"}; do
        old_paths[$path]=1
    done

    str_join ':' "${!old_paths[@]}"
)

add_path() {
    PATH="$( add_missing_path "$@" )" || return $?
    export PATH
}
