#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

source "$HOME/.bash_utils/text.sh"

add_missing_path() (
    set -o errexit -o nounset -o pipefail

    [ "$#" -eq 0 ] && return 0

    local -a src_list
    local path

    while IFS= read -d '' -r path; do
        src_list+=("$path")
    done < <( readlink -z --canonicalize-missing -- "$@" )

    for path; do
        if str_contains "$path" ':'; then
            echo "${FUNCNAME[0]}: mustn't contain colon (':') characters: $path" >&2
            return 1
        fi
    done

    local -A dest_dict
    local -a dest_list

    if [ -n "${PATH-}" ]; then
        while IFS= read -d '' -r path; do
            dest_dict[$path]=1
            dest_list+=("$path")
        done < <( str_split -z -- "${PATH-}" ':' | xargs -0 -- readlink -z --canonicalize-missing -- )
    fi

    for path in ${src_list[@]+"${src_list[@]}"}; do
        [ -n "${dest_dict[$path]+x}" ] && continue
        dest_dict[$path]=1
        dest_list+=("$path")
    done

    str_join ':' ${dest_list[@]+"${dest_list[@]}"}
)

add_path() {
    local new_path

    new_path="$( add_missing_path "$@" )" \
        && export PATH="$new_path"
}
