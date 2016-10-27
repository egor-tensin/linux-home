#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

alias dos2eol='sed --binary --in-place '"'"'s/\(\r\?\)$//'"'"
alias eol2dos='sed --binary --in-place '"'"'s/\r\?$/\r/'"'"

alias trim='sed --binary --in-place '"'"'s/[[:blank:]]*\(\r\?\)$/\1/'"'"

alias trimeol='sed --binary --in-place -e :a -e '"'"'/^\n*$/{$d;N;ba}'"'"
alias trimdoseol='sed --binary --in-place -e :a -e '"'"'/^\(\r\n\)*\r$/{$d;N;ba}'"'"

alias eol='sed --binary --in-place '"'"'$a\'"'"
alias doseol='sed --binary --in-place '"'"'$s/\r\?$/\r/;a\'"'"

alias trimbom='sed --binary --in-place '"'"'1 s/^\xef\xbb\xbf//'"'"

lint() {
    trim "$@" && trimeol "$@" && eol "$@"
}

doslint() {
    trim "$@" && trimdoseol "$@" && doseol "$@"
}

replace_word() (
    set -o errexit -o nounset -o pipefail

    if [ "$#" -lt 3 ]; then
        echo "usage: ${FUNCNAME[0]} OLD NEW PATH..." >&2
        return 1
    fi

    local old="$1"
    shift
    local new="$1"
    shift

    sed --binary --in-place "s/\\b$old\\b/$new/g" "$@"
)

str_tolower() (
    set -o errexit -o nounset -o pipefail

    local s
    for s; do
        echo "${s,,}" # | tr '[:upper:]' '[:lower:]'
    done
)

str_toupper() (
    set -o errexit -o nounset -o pipefail

    local s
    for s; do
        echo "${s^^}" # | tr '[:lower:]' '[:upper:]'
    done
)

str_contains() (
    set -o errexit -o nounset -o pipefail

    if [ "$#" -ne 2 ]; then
        echo "usage: ${FUNCNAME[0]} STR SUB"
        return 1
    fi

    local str="$1"
    local sub
    sub="$( printf '%q' "$2" )"

    test "$str" != "${str#*$sub}"
)

str_starts_with() (
    set -o errexit -o nounset -o pipefail

    if [ "$#" -ne 2 ]; then
        echo "usage: ${FUNCNAME[0]} STR SUB"
        return 1
     fi

     local str="$1"
     local sub
     sub="$( printf '%q' "$2" )"

     test "$str" != "${str#$sub}"
)

str_split() (
    set -o errexit -o nounset -o pipefail

    local zero=
    local -a args

    while [ "$#" -ne 0 ]; do
        case "$1" in
            -z|-0)
                zero=1
                shift
                ;;

            -h|--help)
                echo "usage: ${FUNCNAME[0]} [-z|-0] [-h|--help] [--] STR DELIM"
                return 0
                ;;

            --)
                shift
                break
                ;;

            -*)
                echo "${FUNCNAME[0]}: unrecognized parameter: $1" >&2
                return 1
                ;;

            *)
                args+=("$1")
                shift
                ;;
        esac
    done

    args+=("$@")

    if [ "${#args[@]}" -ne 2 ]; then
        echo "usage: ${FUNCNAME[0]} [-z|-0] [-h|--help] [--] STR DELIM"
        return 1
    fi

    local str="${args[0]}"
    local old_delim="${args[1]}"

    local -a xs
    local x

    IFS="$old_delim" read -ra xs <<< "$str"

    for x in ${xs[@]+"${xs[@]}"}; do
        if [ -z "$zero" ]; then
            printf '%s\n' "$x"
        else
            printf '%s\0' "$x"
        fi
    done
)

str_join() (
    set -o errexit -o nounset -o pipefail

    if [ "$#" -lt 1 ]; then
        echo "usage: ${FUNCNAME[0]} DELIM [STR]..."
        return 1
    fi

    local delim="$1"
    shift

    case "$#" in
        0)
            ;;
        1)
            echo "$@"
            ;;
        *)
            local s="$1"
            shift
            printf '%s' "$s"

            for s; do
                printf '%s%s' "$delim" "$s"
            done
            ;;
    esac
)
