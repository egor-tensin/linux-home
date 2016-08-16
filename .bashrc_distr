#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

readonly checksums_path='sha1sums.txt'

update_checksums() {
    sha1sum -- "$@" > "$checksums_path"
}

update_checksums_distr() (
    set -o errexit -o nounset -o pipefail

    local -a paths
    local path

    while IFS= read -d '' -r path; do
        paths+=("$path")
    done < <( find . -type f -\( -iname '*.exe' -o -iname '*.iso' -\) -print0 )

    update_checksums "${paths[@]+"${paths[@]}"}"
)

verify_checksums() {
    sha1sum --check "$checksums_path"
}
