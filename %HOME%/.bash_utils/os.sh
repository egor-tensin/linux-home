#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Linux/Cygwin environment" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

_os=''

_CYGWIN='Cygwin'
_UBUNTU='Ubuntu'
_MINT='Linux Mint'
_ARCH='Arch Linux'
_ARCH_ARM='Arch Linux ARM'
_FEDORA='Fedora'

os_detect() {
    command -v uname > /dev/null             \
        && [ "$( uname -o )" == "$_CYGWIN" ] \
        && _os="$_CYGWIN"                    \
        && return 0

    [ -r /etc/os-release ]                              \
        && _os="$( . /etc/os-release && echo "$NAME" )" \
        && test "$_os" == "$_UBUNTU"   \
             -o "$_os" == "$_MINT"     \
             -o "$_os" == "$_ARCH"     \
             -o "$_os" == "$_ARCH_ARM" \
             -o "$_os" == "$_FEDORA"   \
        && return 0

    _os=''
    return 1
}

os_detect

os_detected() { test -n "$_os" ; }

os_is_cygwin() { test "$_os" == "$_CYGWIN" ; }
os_is_ubuntu() { test "$_os" == "$_UBUNTU" ; }
os_is_mint()   { test "$_os" == "$_MINT"   ; }
os_is_arch()   { test "$_os" == "$_ARCH" -o "$_os" == "$_ARCH_ARM" ; }
os_is_fedora() { test "$_os" == "$_FEDORA" ; }

# Cygwin

pkg_list_cygwin() (
    set -o errexit -o nounset -o pipefail

    cygcheck --check-setup --dump-only \
        | tail -n +3                   \
        | cut -d ' ' -f 1
)

# Ubuntu/Linux Mint

setup_pkg_list_ubuntu() (
    set -o errexit -o nounset -o pipefail

    local -r initial_status='/var/log/installer/initial-status.gz'

    gzip --decompress --stdout -- "$initial_status" \
        | sed --quiet -- 's/^Package: //p'          \
        | sort                                      \
        | uniq
)

user_pkg_list_ubuntu() (
    set -o errexit -o nounset -o pipefail

    comm -23 <( apt-mark showmanual | sort | uniq ) \
             <( setup_pkg_list_ubuntu )
)

pkg_list_ubuntu() (
    set -o errexit -o nounset -o pipefail

    dpkg --get-selections                     \
        | grep --invert-match -- 'deinstall$' \
        | cut -f 1                            \
        | cut -d ':' -f 1
)

# Arch Linux

setup_pkg_list_arch() (
    set -o errexit -o nounset -o pipefail

    # Assuming you only selected groups 'base and 'base-devel' during
    # installation.
    local -ra groups=(base base-devel)

    pacman -Q --groups -q -- ${groups[@]+"${groups[@]}"} | sort
)

user_pkg_list_arch() (
    set -o errexit -o nounset -o pipefail

    comm -23 <( pacman -Q --explicit -q | sort ) \
             <( setup_pkg_list_arch )
)

pkg_list_arch() {
    pacman -Qq
}

# Fedora

pkg_list_fedora() (
    set -o errexit -o nounset -o pipefail

    rpm --queryformat="%{NAME}\n" -qa | sort
)

# Generic routines

pkg_list() (
    set -o errexit -o nounset -o pipefail

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
