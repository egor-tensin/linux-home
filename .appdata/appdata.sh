#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

# This relies on the availability of native symlinks.
# Those are indeed available on NTFS, but require Administrator privileges for
# creation.
# It likely won't bother you as long as you don't use the functions defined in
# this file.
# In any case, you will see `ln` complaining about some access being denied in
# case something goes wrong.
#
# Remember that in order to force `ln` to use native NTFS symlinks, your
# `CYGWIN` Windows environment variable value **must** include either
# `winsymlinks:native` or `winsymlinks:nativestrict`!
 
ensure_symlinks_enabled() {
    case "${CYGWIN:-}" in
        *winsymlinks:native*)       ;;
        *winsymlinks:nativestrict*) ;;

        *)
            echo "${FUNCNAME[0]}: native Windows symlinks aren't enabled in Cygwin" >&2
            return 1
            ;;
    esac
}

symlink_preferences() (
    set -o errexit -o nounset -o pipefail

    if [ "$#" -ne 2 ]; then
        echo "usage: ${FUNCNAME[0]} SRC_DIR DEST_DIR" >&2
        return 1
    fi

    ensure_symlinks_enabled

    local src_dir="$1"
    local dest_dir="$2"

    mkdir -p "$dest_dir"

    find "$src_dir" -maxdepth 1 -type f -exec ln --force -s {} "$dest_dir" \;
)

symlink_sublime_preferences() (
    set -o errexit -o nounset -o pipefail

    symlink_preferences \
        "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/Sublime Text 3" \
        "$APPDATA/Sublime Text 3/Packages/User"
)

symlink_ghc_preferences() (
    set -o errexit -o nounset -o pipefail

    symlink_preferences \
        "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/ghc" \
        "$APPDATA/ghc"
)
