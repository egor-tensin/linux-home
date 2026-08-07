# Copyright (c) 2026 Egor Tensin <egor@tensin.name>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

_curl() {
    curl -sS --connect-timeout 5 "$@"
}

whatsmyip() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true
    shopt -s lastpipe

    _curl "https://ifconfig.co/"
)

whatsmycountry() (
    set -o errexit -o nounset -o pipefail
    shopt -s inherit_errexit 2> /dev/null || true
    shopt -s lastpipe

    _curl "https://ifconfig.co/country"
)
