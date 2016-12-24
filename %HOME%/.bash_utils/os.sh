#!/usr/bin/env bash

_os=''

detect_os() {
    command -v uname > /dev/null           \
        && [ "$( uname -o )" == 'Cygwin' ] \
        && _os='Cygwin'                    \
        && return 0

    [ -r /etc/os-release ]                              \
        && _os="$( . /etc/os-release && echo "$NAME" )" \
        && return 0

    return 1
}

detect_os

os_detected() {
    test -n "$_os"
}

is_cygwin() {
    test "$_os" == 'Cygwin'
}

is_ubuntu() {
    test "$_os" == 'Ubuntu'
}

list_manually_installed_packages_ubuntu() (
    set -o errexit -o nounset -o pipefail

    comm -23 <( apt-mark showmanual | sort | uniq ) \
        <( gzip --decompress --stdout -- /var/log/installer/initial-status.gz | sed --quiet 's/^Package: //p' | sort | uniq )
)

list_packages_cygwin() (
    set -o errexit -o nounset -o pipefail

    cygcheck --check-setup --dump-only \
        | tail -n +3                   \
        | cut -d ' ' -f 1
)

list_packages_ubuntu() (
    set -o errexit -o nounset -o pipefail

    dpkg --get-selections                     \
        | grep --invert-match -- 'deinstall$' \
        | cut -f 1                            \
        | cut -d ':' -f 1
)

list_packages() (
    set -o errexit -o nounset -o pipefail

    if is_cygwin; then
        list_packages_cygwin
    elif is_ubuntu; then
        list_packages_ubuntu
    fi
    return 1
)
