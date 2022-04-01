#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

# These are a couple of routines that allow you to add to your $PATH correctly
# and safely. Originally added as a dependency for other routines, currently
# are unused. TODO: remove?

path_add() (
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

    for path in ${src_list[@]+"${src_list[@]}"}; do
        [ -n "${dest_dict[$path]+x}" ] && continue
        dest_dict[$path]=1
        dest_list+=("$path")
    done

    if [ -n "${PATH-}" ]; then
        while IFS= read -d '' -r path; do
            [ -n "${dest_dict[$path]+x}" ] && continue
            dest_dict[$path]=1
            dest_list+=("$path")
        done < <( str_split -z -- "${PATH-}" ':' | xargs -0 -- readlink -z --canonicalize-missing -- )
    fi

    str_join ':' ${dest_list[@]+"${dest_list[@]}"}
)

path_export() {
    local new_path

    new_path="$( path_add "$@" )" \
        && export PATH="$new_path"
}
