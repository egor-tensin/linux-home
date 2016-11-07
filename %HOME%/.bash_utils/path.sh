#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

source "$HOME/.bash_utils/text.sh"

add_missing_path() (
    set -o errexit -o nounset -o pipefail

    [ "$#" -eq 0 ] && return 0

    local -a new_list
    local path

    while IFS= read -d '' -r path; do
        new_list+=("$path")
    done < <( readlink -z --canonicalize-missing -- "$@" )

    for path; do
        if str_contains "$path" ':'; then
            echo "${FUNCNAME[0]}: mustn't contain colon (':') characters: $path" >&2
            return 1
        fi
    done

    local -A old_dict
    local -a old_list

    if [ -n "${PATH-}" ]; then
        while IFS= read -d '' -r path; do
            old_dict[$path]=1
            old_list+=("$path")
        done < <( str_split -z -- "${PATH-}" ':' | xargs -0 -- readlink -z --canonicalize-missing -- )
    fi

    for path in ${new_list[@]+"${new_list[@]}"}; do
        [ -n "${old_dict[$path]+x}" ] && continue
        old_dict[$path]=1
        old_list+=("$path")
    done

    str_join ':' ${old_list[@]+"${old_list[@]}"}
)

add_path() {
    local new_path

    new_path="$( add_missing_path "$@" )" \
        && export PATH="$new_path"
}
