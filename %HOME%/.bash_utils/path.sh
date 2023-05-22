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
    shopt -s inherit_errexit 2> /dev/null || true
    shopt -s lastpipe

    local prepend=

    if [ "$#" -gt 0 ] && [ "$1" == --prepend ]; then
        shift
        prepend=y
    fi

    [ "$#" -eq 0 ] && return 0

    local -a src_list

    local path
    readlink -z --canonicalize-missing -- "$@" | while IFS= read -d '' -r path; do
        src_list+=("$path")
    done

    for path; do
        if str_contains "$path" ':'; then
            echo "${FUNCNAME[0]}: mustn't contain colon (':') characters: $path" >&2
            return 1
        fi
    done

    local -A uniq_paths
    local -a new_paths current_paths

    for path in ${src_list[@]+"${src_list[@]}"}; do
        [ -n "${uniq_paths[$path]+x}" ] && continue
        uniq_paths[$path]=1
        new_paths+=("$path")
    done

    if [ -n "${PATH-}" ]; then
        str_split -z -- "${PATH-}" ':' | xargs -0 -- readlink -z --canonicalize-missing -- | while IFS= read -d '' -r path; do
            [ -n "${uniq_paths[$path]+x}" ] && continue
            uniq_paths[$path]=1
            current_paths+=("$path")
        done
    fi

    local -a result
    [ -n "$prepend" ] && result+=(${new_paths[@]+"${new_paths[@]}"})
    result+=(${current_paths[@]+"${current_paths[@]}"})
    [ -z "$prepend" ] && result+=(${new_paths[@]+"${new_paths[@]}"})

    str_join ':' ${result[@]+"${result[@]}"}
)

path_export() {
    local new_path
    local ret

    new_path="$( path_add "$@" )"
    ret="$?"

    [ "$ret" -ne 0 ] && return "$ret"

    export PATH="$new_path"
}
