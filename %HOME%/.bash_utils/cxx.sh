#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

_runc_os_is_cygwin() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    local os
    os="$( uname -o )"
    test 'Cygwin' = "$os"
)

if _runc_os_is_cygwin; then
    _runc_exe_ext='.exe'
fi

runc_use_gcc() {
    runc_compiler=gcc
    runcxx_compiler=g++
    declare -ag runc_flags=('-Wall' '-Wextra')
    declare -ag runcxx_flags=('-Wall' '-Wextra' '-std=c++14')
}

runc_use_clang() {
    runc_compiler=clang
    runcxx_compiler=clang++
    declare -ag runc_flags=('-Wall' '-Wextra')
    declare -ag runcxx_flags=('-Wall' '-Wextra')
}

runc_use_gcc

_runc_get_absolute_path() {
    readlink -z --canonicalize-missing -- "$@"
}

_runc_usage() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    local prefix="${FUNCNAME[0]}"
    [ "${#FUNCNAME[@]}" -gt 1 ] && prefix="${FUNCNAME[1]}"

    local msg
    for msg; do
        echo "$prefix: $msg"
    done

    echo "usage: $prefix [-h|--help] [-c|--comp-arg ARG]... [-I DIR]... [-L DIR]... [-l LIB]... PATH... [-- [PROG_ARG]...]"
)

runc() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit lastpipe

    local -a c_flags=(${runc_flags[@]+"${runc_flags[@]}"})
    local -a src_files=()
    local -a include_dirs=()
    local -a lib_dirs=()
    local -a libs=()
    local -a prog_args

    while [ "$#" -gt 0 ]; do
        local key="$1"
        shift

        case "$key" in
            -h|--help)
                _runc_usage
                return 0
                ;;
            -c|--comp-arg|-I|-L|-l)
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
            -l)
                libs+=("$1")
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
    _runc_get_absolute_path ${_src_files[@]+"${_src_files[@]}"} | while IFS= read -d '' -r src_file; do
        src_files+=("$src_file")
    done

    if [ "${#include_dirs[@]}" -gt 0 ]; then
        local include_dir
        _runc_get_absolute_path ${include_dirs[@]+"${include_dirs[@]}"} | while IFS= read -d '' -r include_dir; do
            c_flags+=("-I$include_dir")
        done
    fi

    if [ "${#lib_dirs[@]}" -gt 0 ]; then
        local lib_dir
        _runc_get_absolute_path ${lib_dirs[@]+"${lib_dirs[@]}"} | while IFS= read -d '' -r lib_dir; do
            c_flags+=("-L$lib_dir")
        done
    fi

    if [ "${#libs[@]}" -gt 0 ]; then
        local lib
        for lib in ${libs[@]+"${libs[@]}"}; do
            c_flags+=("-l$lib")
        done
    fi

    local build_dir
    build_dir="$( mktemp --directory )"

    local rm_build_dir
    rm_build_dir="$( printf -- 'popd > /dev/null && rm -rf -- %q' "$build_dir" )"

    trap "$rm_build_dir" EXIT
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
    shopt -s inherit_errexit

    local -a runc_flags=(${runcxx_flags[@]+"${runcxx_flags[@]}"})
    BASH_ENV=<( declare -p runc_flags ) \
        runc_compiler="${runcxx_compiler:-g++}" \
        runc "$@"
)

_runc_gdb() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    if [ "$#" -ne 2 ]; then
        echo "usage: ${FUNCNAME[0]} BINARY CORE_DUMP" >&2
        return 1
    fi

    local binary_path="$1"
    local core_dump_path="$2"

    gdb "$binary_path" "$core_dump_path"
)

_runc_lldb() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    if [ "$#" -ne 2 ]; then
        echo "usage: ${FUNCNAME[0]} BINARY CORE_DUMP" >&2
        return 1
    fi

    local binary_path="$1"
    local core_dump_path="$2"

    lldb -f "$binary_path" -c "$core_dump_path"
)

runc_debug() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    if [ "$#" -ne 1 ]; then
        echo "usage: ${FUNCNAME[0]} BINARY" >&2
        return 1
    fi

    local binary_path="$1"
    binary_path="$( readlink --canonicalize-missing -- "$binary_path" )"

    local crash_path
    crash_path="$( str_replace "$binary_path" '/' '_' )"
    crash_path="$crash_path.$UID.crash"
    crash_path="/var/crash/$crash_path"

    if [ ! -r "$crash_path" ]; then
        echo "${FUNCNAME[0]}: $crash_path doesn't exist or isn't readable" >&2
        return 1
    fi

    local crash_dir
    crash_dir="$( mktemp --directory )"

    local rm_crash_dir
    rm_crash_dir="$( printf -- 'rm -rf -- %q' "$crash_dir" )"
    trap "$rm_crash_dir" EXIT

    apport-unpack "$crash_path" "$crash_dir"
    local core_dump_path="$crash_dir/CoreDump"

    if [ ! -r "$core_dump_path" ]; then
        echo "${FUNCNAME[0]}: $core_dump_path doesn't exist or isn't readable" >&2
        return 1
    fi

    "${DEBUG_FUNCTION:-_runc_gdb}" "$binary_path" "$core_dump_path"
)

runc_gdb() {
    DEBUG_FUNCTION=_runc_gdb runc_debug "$@"
}

runc_lldb() {
    DEBUG_FUNCTION=_runc_lldb runc_debug "$@"
}
