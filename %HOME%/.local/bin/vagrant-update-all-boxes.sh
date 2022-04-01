#!/usr/bin/env bash

# Copyright (c) 2022 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

set -o errexit -o nounset -o pipefail

dump() {
    local msg
    for msg; do
        local prefix="${FUNCNAME[0]}"
        [ "${#FUNCNAME[@]}" -gt 1 ] && prefix="${FUNCNAME[1]}"
        echo "$prefix: $msg"
    done
}

update_box_from_line() {
    local orig_line
    for orig_line; do
        local line="$orig_line"
        line="${line//'*'/}"
        line="${line//"'"/}"

        local box
        box="$( echo "$line" | cut -d ' ' -f 2 )"
        local provider
        provider="$( echo "$line" | cut -d ' ' -f 4 )"

        local sanity_check
        sanity_check="$( echo "$line" | cut -d ' ' -f 3 )"

        if [ "$sanity_check" != 'for' ]; then
            dump "this line is malformed:" "$orig_line" >&2
            return 1
        fi

        dump "updating box '$box' for provider '$provider'..."
        vagrant box update --box "$box" --provider "$provider"
    done
}

update_all_boxes() {
    local line
    while IFS= read -r line; do
        update_box_from_line "$line"
    done < <( vagrant box outdated --global | grep -F outdated )
}

clean_old_boxes() {
    vagrant box prune --force --keep-active-boxes
}

main() {
    update_all_boxes
    clean_old_boxes
}

main
