#!/usr/bin/env bash

# Copyright (c) 2018 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

alias update-my-alternatives='update-alternatives --quiet --altdir ~/.local/etc/alternatives --admindir ~/.local/var/lib/alternatives'

setup_alternatives_cc() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true

    gcc_cc="$(  command -v gcc 2> /dev/null )" || return 0
    gcc_cxx="$( command -v g++ 2> /dev/null )" || return 0
    clang_cc="$(  command -v clang   2> /dev/null )" || return 0
    clang_cxx="$( command -v clang++ 2> /dev/null )" || return 0

    mkdir -p -- ~/.local/bin

    update-my-alternatives --remove-all cc || true
    update-my-alternatives --install ~/.local/bin/cc cc "$clang_cc" 256 --slave ~/.local/bin/c++ c++ "$clang_cxx"
    update-my-alternatives --install ~/.local/bin/cc cc "$gcc_cc"   512 --slave ~/.local/bin/c++ c++ "$gcc_cxx"
)

setup_alternatives() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true

    command -v update-alternatives > /dev/null 2>&1 || return 0
    mkdir -p -- ~/.local/etc/alternatives ~/.local/var/lib/alternatives

    setup_alternatives_cc
)

setup_alternatives

alt_gcc() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true

    gcc_cc="$( command -v gcc 2> /dev/null )"
    update-my-alternatives --set cc "$gcc_cc"
)

alt_clang() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true

    clang_cc="$( command -v clang 2> /dev/null )"
    update-my-alternatives --set cc "$clang_cc"
)
