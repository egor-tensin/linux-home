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
