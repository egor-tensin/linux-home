#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

_os=''

_CYGWIN='Cygwin'
_MACOS='macOS'
_UBUNTU='Ubuntu'
_MINT='Linux Mint'
_ARCH='Arch Linux'
_ARCH_ARM='Arch Linux ARM'
_FEDORA='Fedora'

os_detect() {
    case "$OSTYPE" in
        cygwin)
            _os="$_CYGWIN"
            return 0
            ;;
        darwin*)
            _os="$_MACOS"
            return 0
            ;;
        linux-gnu*)
            if [ -r /etc/os-release ] && _os="$( . /etc/os-release && echo "$NAME" )"; then
                case "$_os" in
                    "$_UBUNTU"|"$_MINT"|"$_ARCH"|"$_ARCH_ARM"|"$_FEDORA")
                        return 0
                        ;;
                    *)
                        _os=''
                        return 1
                        ;;
                esac
            fi
            ;;
        *)
            return 1
            ;;
    esac
}

os_detect

os_detected() { test -n "$_os" ; }

os_is_cygwin() { test "$_os" == "$_CYGWIN" ; }
os_is_macos()  { test "$_os" == "$_MACOS"  ; }

os_is_ubuntu() { test "$_os" == "$_UBUNTU" ; }
os_is_mint()   { test "$_os" == "$_MINT"   ; }
os_is_arch()   { test "$_os" == "$_ARCH" -o "$_os" == "$_ARCH_ARM" ; }
os_is_fedora() { test "$_os" == "$_FEDORA" ; }

os_is_linux() { os_is_ubuntu || os_is_mint || os_is_arch || os_is_fedora ; }

# Cygwin

pkg_list_cygwin() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    cygcheck --check-setup --dump-only \
        | tail -n +3                   \
        | cut -d ' ' -f 1
)

# Ubuntu/Linux Mint

setup_pkg_list_ubuntu() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    local -r initial_status='/var/log/installer/initial-status.gz'

    gzip --decompress --stdout -- "$initial_status" \
        | sed --quiet -- 's/^Package: //p'          \
        | sort                                      \
        | uniq
)

user_pkg_list_ubuntu() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    local manual
    manual="$( apt-mark showmanual | sort | uniq )"

    local setup
    setup="$( setup_pkg_list_ubuntu )"

    comm -23 <( echo "$manual" ) <( echo "$setup" )
)

pkg_list_ubuntu() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    dpkg --get-selections                     \
        | grep --invert-match -- 'deinstall$' \
        | cut -f 1                            \
        | cut -d ':' -f 1
)

# Arch Linux

setup_pkg_list_arch() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    # Assuming you only selected groups 'base and 'base-devel' during
    # installation.
    local -ra groups=(base base-devel)

    pacman -Q --groups -q -- ${groups[@]+"${groups[@]}"} | sort
)

user_pkg_list_arch() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    local manual
    manual="$( pacman -Q --explicit -q | sort )"

    local setup
    setup="$( setup_pkg_list_arch )"

    comm -23 <( echo "$manual" ) <( echo "$setup" )
)

manual_pkg_list_arch() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    expac '%n %p' | grep 'Unknown Packager'
)

pkg_list_arch() {
    pacman -Qq
}

# Fedora

pkg_list_fedora() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    rpm --queryformat="%{NAME}\n" -qa | sort
)

# Generic routines

pkg_list() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    if os_is_cygwin; then
        pkg_list_cygwin
    elif os_is_ubuntu || os_is_mint; then
        pkg_list_ubuntu
    elif os_is_arch; then
        pkg_list_arch
    elif os_is_fedora; then
        pkg_list_fedora
    else
        echo "${FUNCNAME[0]}: unsupported OS" >&2
        return 1
    fi
)

user_pkg_list() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit

    if os_is_ubuntu || os_is_mint; then
        user_pkg_list_ubuntu
    elif os_is_arch; then
        user_pkg_list_arch
    else
        echo "${FUNCNAME[0]}: unsupported OS" >&2
        return 1
    fi
)
