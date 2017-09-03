#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

_runc_is_cygwin() (
    set -o errexit -o nounset -o pipefail
    local os
    os="$( uname -o )"
    test 'Cygwin' = "$os"
)

if _runc_is_cygwin; then
    _runc_exe_ext='.exe'
fi

runc_flags=('-Wall' '-Wextra')
runcxx_flags=('-Wall' '-Wextra' '-std=c++14')

runc_compiler=gcc
runcxx_compiler=g++

_get_absolute_path() {
    readlink -z --canonicalize-missing -- "$@"
}

_runc_usage() (
    set -o errexit -o nounset -o pipefail

    local prefix="${FUNCNAME[0]}"
    [ "${#FUNCNAME[@]}" -gt 1 ] && prefix="${FUNCNAME[1]}"

    local msg
    for msg; do
        echo "$prefix: $msg"
    done

    echo "usage: $prefix [-h|--help] [-c|--comp-arg ARG]... [-I DIR]... [-L DIR]... PATH... [-- [PROG_ARG]...]"
)

runc() (
    set -o errexit -o nounset -o pipefail

    local -a c_flags=(${runc_flags[@]+"${runc_flags[@]}"})
    local -a src_files=()
    local -a include_dirs=()
    local -a lib_dirs=()
    local -a prog_args

    while [ "$#" -gt 0 ]; do
        local key="$1"
        shift

        case "$key" in
            -h|--help)
                _runc_usage
                return 0
                ;;
            -c|--comp-arg|-I|-L)
                if [ "$#" -eq 0 ]; then
                    _runc_usage "missing argument for parameter: $key" >&2
                    return 1
                fi
                ;;&
            -c|--comp-arg)
                c_flags+=("$1")
                shift
                ;;
            -I)
                include_dirs+=("$1")
                shift
                ;;
            -L)
                lib_dirs+=("$1")
                shift
                ;;
            --)
                break
                ;;
            *)
                src_files+=("$key")
                ;;
        esac
    done

    prog_args=("$@")

    if [ "${#src_files[@]}" -eq 0 ]; then
        _runc_usage 'at least one source file is required' >&2
        return 1
    fi

    local -a _src_files=(${src_files[@]+"${src_files[@]}"})
    src_files=()

    local src_file
    while IFS= read -d '' -r src_file; do
        src_files+=("$src_file")
    done < <( _get_absolute_path ${_src_files[@]+"${_src_files[@]}"} )

    if [ "${#include_dirs[@]}" -gt 0 ]; then
        local include_dir
        while IFS= read -d '' -r include_dir; do
            c_flags+=("-I$include_dir")
        done < <( _get_absolute_path ${include_dirs[@]+"${include_dirs[@]}"} )
    fi

    if [ "${#lib_dirs[@]}" -gt 0 ]; then
        local lib_dir
        while IFS= read -d '' -r lib_dir; do
            c_flags+=("-L$lib_dir")
        done < <( _get_absolute_path ${lib_dirs[@]+"${lib_dirs[@]}"} )
    fi

    local build_dir
    build_dir="$( mktemp --directory )"

    trap "$( printf -- 'popd > /dev/null && rm -rf -- %q' "$build_dir" )" 0
    pushd "$build_dir" > /dev/null

    local output_name
    output_name="$( mktemp --tmpdir=. -- "${FUNCNAME[0]}XXX${_runc_exe_ext-}" )"

    "${runc_compiler:-gcc}" -o "$output_name" \
        ${src_files[@]+"${src_files[@]}"} \
        ${c_flags[@]+"${c_flags[@]}"}

    "$output_name" ${prog_args[@]+"${prog_args[@]}"}
)

runcxx() (
    set -o errexit -o nounset -o pipefail
    local -a runc_flags=(${runcxx_flags[@]+"${runcxx_flags[@]}"})
    BASH_ENV=<( declare -p runc_flags ) \
        runc_compiler="${runcxx_compiler:-g++}" \
        runc "$@"
)
