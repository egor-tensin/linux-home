#!/usr/bin/env bash

# Copyright (c) 2017 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

# This is a half-assed way to automatically add your user's pip binary
# directory to $PATH.

source "$HOME/.bash_utils/path.sh"

python_setup_() (
    set -o errexit -o nounset -o pipefail

    if [ "$#" -ne 1 ]; then
        echo "usage: ${FUNCNAME[0]} PYTHON_EXE"
        return 1
    fi

    local python="$1"

    local user_base
    user_base="$( "$python" -m site --user-base )"

    local user_bin="$user_base/bin"
    [ -d "$user_bin" ] || return 1
    echo "$user_bin"
)

python_setup() {
    local user_bin

    if command -v python3 &> /dev/null; then
        user_bin="$( python_setup_ python3 )" \
            && path_export "$user_bin"
    elif command -v python &> /dev/null; then
        user_bin="$( python_setup_ python )" \
            && path_export "$user_bin"
    fi
}

python_setup

[ -r "$HOME/.pythonrc" ] && export PYTHONSTARTUP="$HOME/.pythonrc"
