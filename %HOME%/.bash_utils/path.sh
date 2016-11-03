#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

source "$HOME/.bash_utils/text.sh"

add_missing_path() (
    set -o errexit -o nounset -o pipefail

    [ "$#" -eq 0 ] && return 0

    local -a new_paths
    local path

    while IFS= read -d '' -r path; do
        new_paths+=("$path")
    done < <( readlink --zero --canonicalize-missing -- "$@" )

    for path; do
        if str_contains "$path" ':'; then
            echo "${FUNCNAME[0]}: mustn't contain colons: $path" >&2
            return 1
        fi
    done

    local -A old_paths_dict
    local -a old_paths_list

    while IFS= read -d '' -r path; do
        old_paths_dict[$path]=1
        old_paths_list+=("$path")
    done < <( str_split -z -- "${PATH-}" ':' | xargs -0 readlink --zero --canonicalize-missing -- )

    for path in ${new_paths[@]+"${new_paths[@]}"}; do
        [ -n "${old_paths_dict[$path]+x}" ] && continue
        old_paths_dict[$path]=1
        old_paths_list+=("$path")
    done

    str_join ':' ${old_paths_list[@]+"${old_paths_list[@]}"}
)

add_path() {
    local new_path

    new_path="$( add_missing_path "$@" )" \
        && export PATH="$new_path"
}
