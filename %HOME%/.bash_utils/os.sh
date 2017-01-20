#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

_os=''

os_detect() {
    command -v uname > /dev/null           \
        && [ "$( uname -o )" == 'Cygwin' ] \
        && _os='Cygwin'                    \
        && return 0

    [ -r /etc/os-release ]                              \
        && _os="$( . /etc/os-release && echo "$NAME" )" \
        && return 0

    return 1
}

os_detect

os_detected() {
    test -n "$_os"
}

os_is_cygwin() {
    test "$_os" == 'Cygwin'
}

os_is_ubuntu() {
    test "$_os" == 'Ubuntu'
}

os_is_arch() {
    test "$_os" == 'Arch Linux'
}

packages_list_cygwin() (
    set -o errexit -o nounset -o pipefail

    cygcheck --check-setup --dump-only \
        | tail -n +3                   \
        | cut -d ' ' -f 1
)

setup_packages_list_ubuntu() (
    set -o errexit -o nounset -o pipefail

    local -r initial_status='/var/log/installer/initial-status.gz'

    gzip --decompress --stdout -- "$initial_status" \
        | sed --quiet -- 's/^Package: //p' \
        | sort \
        | uniq
)

user_packages_list_ubuntu() (
    set -o errexit -o nounset -o pipefail

    comm -23 <( apt-mark showmanual | sort | uniq ) \
             <( setup_packages_list_ubuntu )
)

packages_list_ubuntu() (
    set -o errexit -o nounset -o pipefail

    dpkg --get-selections                     \
        | grep --invert-match -- 'deinstall$' \
        | cut -f 1                            \
        | cut -d ':' -f 1
)

setup_packages_list_arch() (
    set -o errexit -o nounset -o pipefail

    local -ra groups=(base base-devel)

    pacman -Q --groups -q -- ${groups[@]+"${groups[@]}"} | sort
)

user_packages_list_arch() (
    set -o errexit -o nounset -o pipefail

    comm -23 <( pacman -Q --explicit -q | sort ) \
             <( setup_packages_list_arch )
)

packages_list_arch() {
    pacman -Qq
}

packages_list() (
    set -o errexit -o nounset -o pipefail

    if os_is_cygwin; then
        packages_list_cygwin
    elif os_is_ubuntu; then
        packages_list_ubuntu
    elif os_is_arch; then
        packages_list_arch
    else
        return 1
    fi
)
