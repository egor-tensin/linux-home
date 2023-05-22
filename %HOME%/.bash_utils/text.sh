#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

alias dos2eol='sed --binary --in-place -- '"'"'s/\(\r\?\)$//'"'"
alias eol2dos='sed --binary --in-place -- '"'"'s/\r\?$/\r/'"'"

alias trim='sed --binary --in-place -- '"'"'s/[[:blank:]]*\(\r\?\)$/\1/'"'"

alias trimeol='sed --binary --in-place -e :a -e '"'"'/^\n*$/{$d;N;ba}'"'"' --'
alias trimdoseol='sed --binary --in-place -e :a -e '"'"'/^\(\r\n\)*\r$/{$d;N;ba}'"'"' --'

alias eol='sed --binary --in-place -- '"'"'$a\'"'"
alias doseol='sed --binary --in-place -- '"'"'$s/\r\?$/\r/;a\'"'"

alias trimbom='sed --binary --in-place -- '"'"'1 s/^\xef\xbb\xbf//'"'"

lint() {
    trim "$@" && trimeol "$@" && eol "$@"
}

doslint() {
    trim "$@" && trimdoseol "$@" && doseol "$@"
}

_sed_escape_pattern() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true

    if [ "$#" -ne 1 ]; then
        echo "usage: ${FUNCNAME[0]} STR" >&2
        return 1
    fi

    # Only $^*./\[] need to be escaped according to this:
    # https://unix.stackexchange.com/a/33005/60124
    local s="$1"
    s="${s//'\'/'\\'}"
    s="${s//'/'/'\/'}"
    s="${s//'$'/'\$'}"
    s="${s//'^'/'\^'}"
    s="${s//'*'/'\*'}"
    s="${s//'.'/'\.'}"
    s="${s//'['/'\['}"
    s="${s//']'/'\]'}"
    s="${s//$'\n'/'\n'}"
    echo "$s"
)

_sed_escape_substitution() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true

    if [ "$#" -ne 1 ]; then
        echo "usage: ${FUNCNAME[0]} STR" >&2
        return 1
    fi

    local s="$1"
    s="${s//'\'/'\\'}"
    s="${s//'/'/'\/'}"
    s="${s//'&'/'\&'}"
    s="${s//$'\n'/'\n'}"
    echo "$s"
)

file_replace() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true

    if [ "$#" -lt 3 ]; then
        echo "usage: ${FUNCNAME[0]} OLD NEW PATH..." >&2
        return 1
    fi

    local old="$1"
    old="$( _sed_escape_pattern "$old" )"
    shift
    local new="$1"
    new="$( _sed_escape_substitution "$new" )"
    shift

    sed --binary --in-place -- "s/$old/$new/g" "$@"
)

file_replace_word() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true

    if [ "$#" -lt 3 ]; then
        echo "usage: ${FUNCNAME[0]} OLD NEW PATH..." >&2
        return 1
    fi

    local old="$1"
    old="$( _sed_escape_pattern "$old" )"
    shift
    local new="$1"
    new="$( _sed_escape_substitution "$new" )"
    shift

    sed --binary --in-place -- "s/\\b$old\\b/$new/g" "$@"
)

str_replace() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true

    if [ "$#" -ne 3 ]; then
        echo "usage: ${FUNCNAME[0]} STR SUB REP" >&2
        return 1
    fi

    local str="$1"
    local sub="$2"
    local rep="$3"

    sub="$( _bash_escape_pattern "$sub" )"

    echo "${str//$sub/$rep}"
)

_bash_escape_pattern() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true

    if [ "$#" -ne 1 ]; then
        echo "usage: ${FUNCNAME[0]} STR" >&2
        return 1
    fi

    # Only *?\[] need to be escaped according to:
    # http://wiki.bash-hackers.org/syntax/pattern#normal_pattern_language
    local s="$1"
    s="${s//'\'/'\\'}"
    s="${s//'*'/'\*'}"
    s="${s//'?'/'\?'}"
    s="${s//'['/'\['}"
    s="${s//']'/'\]'}"
    echo "$s"
)

str_contains() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true

    if [ "$#" -ne 2 ]; then
        echo "usage: ${FUNCNAME[0]} STR SUB" >&2
        return 1
    fi

    local str="$1"
    local sub="$2"

    [ -z "$sub" ] && return 0
    sub="$( _bash_escape_pattern "$sub" )"

    test "$str" != "${str#*$sub}"
)

str_starts_with() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true

    if [ "$#" -ne 2 ]; then
        echo "usage: ${FUNCNAME[0]} STR SUB" >&2
        return 1
    fi

    local str="$1"
    local sub="$2"

    [ -z "$sub" ] && return 0
    sub="$( _bash_escape_pattern "$sub" )"

    test "$str" != "${str#$sub}"
)

str_ends_with() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true

    if [ "$#" -ne 2 ]; then
        echo "usage: ${FUNCNAME[0]} STR SUB" >&2
        return 1
    fi

    local str="$1"
    local sub="$2"

    [ -z "$sub" ] && return 0
    sub="$( _bash_escape_pattern "$sub" )"

    test "$str" != "${str%$sub}"
)

str_split() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true
    shopt -s lastpipe

    local fmt='%s\n'
    local -a args

    while [ "$#" -ne 0 ]; do
        local key="$1"
        shift
        case "$key" in
            -h|--help)
                echo "usage: ${FUNCNAME[0]} [-h|--help] [-0|--null|-z|--zero] [--] STR DELIM"
                return 0
                ;;
            -0|--null|-z|--zero)
                fmt='%s\0'
                ;;
            --)
                break
                ;;
            -*)
                echo "${FUNCNAME[0]}: unrecognized parameter: $key" >&2
                return 1
                ;;
            *)
                args+=("$key")
                ;;
        esac
    done

    args+=("$@")

    if [ "${#args[@]}" -ne 2 ]; then
        echo "usage: ${FUNCNAME[0]} [-h|--help] [-0|--null|-z|--zero] [--] STR DELIM" >&2
        return 1
    fi

    local str="${args[0]}"
    local delim="${args[1]}"

    if [ "${#delim}" -ne 1 ]; then
        echo "${FUNCNAME[0]}: delimiter must be exactly 1 character long" >&2
        return 1
    fi

    local -a xs=()

    # Thanks to this guy for this trick:
    # http://stackoverflow.com/a/24426608/514684
    printf -- "%s$delim\\0" "$str" | IFS="$delim" read -a xs -d '' -r

    [ "${#xs[@]}" -gt 0 ] && printf -- "$fmt" ${xs[@]+"${xs[@]}"}
)

str_join() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true

    if [ "$#" -lt 1 ]; then
        echo "usage: ${FUNCNAME[0]} DELIM [STR]..." >&2
        return 1
    fi

    local delim="$1"
    shift

    [ "$#" -eq 0 ] && return 0

    local str="$1"
    shift

    echo -n "$str"
    for str; do
        echo -n "$delim$str"
    done
    echo
)
