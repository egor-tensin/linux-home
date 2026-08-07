# Copyright (c) 2026 Egor Tensin <egor@tensin.name>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

_curl() {
    curl -sS --connect-timeout 5 "$@"
}

whatsmyip() (
    _bash_func_prelude
    _curl "https://ifconfig.co/"
)

whatsmycountry() (
    _bash_func_prelude
    _curl "https://ifconfig.co/country"
)
