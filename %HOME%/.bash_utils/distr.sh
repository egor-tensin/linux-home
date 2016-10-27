#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

checksums_path='sha1sums.txt'

list_checksums_paths() (
    set -o errexit -o nounset -o pipefail

    if [ -f "$checksums_path" ]; then
        local path
        while IFS= read -r path; do
            printf '%s\0' "$path"
        done < <( sed --binary 's/^\\\?[[:alnum:]]\+ [ *]//' "$checksums_path" )
    fi
)

update_checksums() (
    set -o errexit -o nounset -o pipefail

    local path

    local -A existing
    while IFS= read -d '' -r path; do
        existing[$path]=1
    done < <( list_checksums_paths )

    local -a missing
    for path in "$@"; do
        if [ -z "${existing[$path]+x}" ]; then
            missing+=("$path")
        fi
    done

    sha1sum -- ${missing[@]+"${missing[@]}"} >> "$checksums_path"
)

update_checksums_distr() (
    set -o errexit -o nounset -o pipefail

    local -a paths
    local path

    while IFS= read -d '' -r path; do
        paths+=("$path")
    done < <( find . -type f -\( -iname '*.exe' -o -iname '*.iso' -\) -printf '%P\0' )

    update_checksums ${paths[@]+"${paths[@]}"}
)

verify_checksums() {
    sha1sum --check "$checksums_path"
}
