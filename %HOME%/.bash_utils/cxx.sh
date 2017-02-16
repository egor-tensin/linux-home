#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

runc_flags=('-Wall' '-Wextra')
runcxx_flags=('-Wall' '-Wextra' '-std=c++14')

runc_compiler=gcc
runcxx_compiler=g++

_runc_usage() (
    set -o errexit -o nounset -o pipefail

    local msg
    for msg; do
        echo "${FUNCNAME[1]}: $msg"
    done

    echo "usage: ${FUNCNAME[1]} [-h|--help] [-c|--comp-arg ARG]... C_PATH... [-- [PROG_ARG]...]"
)

runc() (
    set -o errexit -o nounset -o pipefail

    local -a c_flags=(${runc_flags[@]+"${runc_flags[@]}"})
    local -a src_files=()
    local -a prog_args

    while [ "$#" -gt 0 ]; do
        local key="$1"
        shift

        case "$key" in
            -h|--help)
                _runc_usage
                return 0
                ;;

            -c|--comp-arg)
                if [ "$#" -eq 0 ]; then
                    _runc_usage "missing argument for parameter: $key" >&2
                    return 1
                fi
                c_flags+=("$1")
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
    done < <( readlink -z --canonicalize-missing -- ${_src_files[@]+"${_src_files[@]}"} )

    local build_dir
    build_dir="$( mktemp --directory )"

    trap "$( printf -- 'popd > /dev/null && rm -rf -- %q' "$build_dir" )" 0
    pushd "$build_dir" > /dev/null

    local output_name
    output_name="$( mktemp --tmpdir=. -- "${FUNCNAME[0]}XXX" )"

    "${runc_compiler:-gcc}" -o "$output_name" \
        ${c_flags[@]+"${c_flags[@]}"} \
        ${src_files[@]+"${src_files[@]}"}

    "$output_name" ${prog_args[@]+"${prog_args[@]}"}
)

_runcxx_usage() (
    set -o errexit -o nounset -o pipefail

    local msg
    for msg; do
        echo "${FUNCNAME[1]}: $msg"
    done

    echo "usage: ${FUNCNAME[1]} [-h|--help] [-c|--comp-arg ARG]... CPP_PATH... [-- [PROG_ARG]...]"
)

runcxx() (
    set -o errexit -o nounset -o pipefail

    local -a cxx_flags=(${runcxx_flags[@]+"${runcxx_flags[@]}"})
    local -a src_files=()
    local -a prog_args

    while [ "$#" -gt 0 ]; do
        local key="$1"
        shift

        case "$key" in
            -h|--help)
                _runcxx_usage
                return 0
                ;;

            -c|--comp-arg)
                if [ "$#" -le 1 ]; then
                    _runcxx_usage "missing argument for parameter: $key" >&2
                    return 1
                fi
                cxx_flags+=("$1")
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
        _runcxx_usage 'at least one source file is required' >&2
        return 1
    fi

    local -a _src_files=(${src_files[@]+"${src_files[@]}"})
    src_files=()

    local src_file
    while IFS= read -d '' -r src_file; do
        src_files+=("$src_file")
    done < <( readlink -z --canonicalize-missing -- ${_src_files[@]+"${_src_files[@]}"} )

    local build_dir
    build_dir="$( mktemp --directory )"

    trap "$( printf -- 'popd > /dev/null && rm -rf -- %q' "$build_dir" )" 0
    pushd "$build_dir" > /dev/null

    local output_name
    output_name="$( mktemp --tmpdir=. -- "${FUNCNAME[0]}XXX" )"

    "${runcxx_compiler:-g++}" -o "$output_name" \
        ${cxx_flags[@]+"${cxx_flags[@]}"} \
        ${src_files[@]+"${src_files[@]}"}

    "$output_name" ${prog_args[@]+"${prog_args[@]}"}
)
