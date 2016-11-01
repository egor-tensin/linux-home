#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

runc_flags=('-Wall' '-Wextra')

runc() (
    set -o errexit -o nounset -o pipefail

    local -a c_flags=(${runc_flags[@]+"${runc_flags[@]}"})
    local -a src_files
    local -a prog_args

    while [ "$#" -gt 0 ]; do
        case "$1" in
            -c|--comp-arg)
                if [ "$#" -le 1 ]; then
                    echo "${FUNCNAME[0]}: missing argument for parameter: $1" >&2
                    return 1
                fi
                shift
                c_flags+=("$1")
                shift
                ;;

            -h|--help)
                echo "usage: ${FUNCNAME[0]} [-h|--help] [-c|--comp-arg ARG]... C_PATH... [-- [PROG_ARG]...]"
                return 0
                ;;

            --)
                shift
                break
                ;;

            *)
                src_files+=("$( realpath "$1" )")
                shift
                ;;
        esac
    done

    prog_args=("$@")

    local build_dir
    build_dir="$( mktemp --directory )"

    trap "$( printf 'popd > /dev/null && rm -rf %q' "$build_dir" )" 0
    pushd "$build_dir" > /dev/null

    local output_name
    output_name="$( mktemp --tmpdir=. "${FUNCNAME[0]}XXX.exe" )"

    gcc -o "$output_name" \
        ${c_flags[@]+"${c_flags[@]}"} \
        ${src_files[@]+"${src_files[@]}"}

    "$output_name" ${prog_args[@]+"${prog_args[@]}"}
)

runcxx_flags=('-Wall' '-Wextra' '-std=c++14')

runcxx() (
    set -o errexit -o nounset -o pipefail

    local -a cxx_flags=(${runcxx_flags[@]+"${runcxx_flags[@]}"})
    local -a src_files
    local -a prog_args

    while [ "$#" -gt 0 ]; do
        case "$1" in
            -c|--comp-arg)
                if [ "$#" -le 1 ]; then
                    echo "${FUNCNAME[0]}: missing argument for parameter: $1" >&2
                    return 1
                fi
                shift
                cxx_flags+=("$1")
                shift
                ;;

            -h|--help)
                echo "usage: ${FUNCNAME[0]} [-h|--help] [-c|--comp-arg ARG]... CPP_PATH... [-- [PROG_ARG]...]"
                return 0
                ;;

            --)
                shift
                break
                ;;

            *)
                src_files+=("$( realpath "$1" )")
                shift
                ;;
        esac
    done

    prog_args=("$@")

    local build_dir
    build_dir="$( mktemp --directory )"

    trap "$( printf 'popd > /dev/null && rm -rf %q' "$build_dir" )" 0
    pushd "$build_dir" > /dev/null

    local output_name
    output_name="$( mktemp --tmpdir=. "${FUNCNAME[0]}XXX.exe" )"

    g++ -o "$output_name" \
        ${cxx_flags[@]+"${cxx_flags[@]}"} \
        ${src_files[@]+"${src_files[@]}"}

    "$output_name" ${prog_args[@]+"${prog_args[@]}"}
)
