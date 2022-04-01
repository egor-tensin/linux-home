#!/usr/bin/env bash

# Copyright (c) 2022 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

set -o errexit -o nounset -o pipefail
shopt -s inherit_errexit

CONNECT="${CONNECT:=qemu:///system}"
POOL="${POOL:=default}"

dump() {
    local prefix="${FUNCNAME[0]}"
    [ "${#FUNCNAME[@]}" -gt 1 ] && prefix="${FUNCNAME[1]}"

    local msg
    for msg; do
        echo "$prefix: $msg"
    done
}

run_virsh() {
    virsh -c "$CONNECT" "$@"
}

list_domains() {
    run_virsh list --all --name
}

list_networks() {
    local output
    output="$( run_virsh net-list --all --name )"

    local name
    while IFS= read -r name; do
        [ "$name" = default ] && continue
        echo "$name"
    done <<< "$output"
}

list_volumes() {
    local output
    output="$( run_virsh vol-list "$POOL" | tail -n +3 | tr -s ' ' )"

    local name
    while IFS=' ' read -r name _; do
        echo "$name"
    done <<< "$output"
}

remove_domain() {
    local domain
    for domain; do
        dump "$domain"
        run_virsh destroy "$domain"
        run_virsh undefine "$domain"
    done
}

remove_network() {
    local network
    for network; do
        dump "$network"
        run_virsh net-destroy "$network"
        run_virsh net-undefine "$network"
    done
}

remove_volume() {
    local volume
    for volume; do
        dump "$volume"
        run_virsh vol-delete --pool "$POOL" "$volume"
    done
}

main() {
    local output item

    output="$( list_domains )"
    if [ -n "$output" ]; then
        while IFS= read -r item; do remove_domain "$item"; done <<< "$output"
    fi

    output="$( list_volumes )"
    if [ -n "$output" ]; then
        while IFS= read -r item; do remove_volume "$item"; done <<< "$output"
    fi

    output="$( list_networks )"
    if [ -n "$output" ]; then
        while IFS= read -r item; do remove_network "$item"; done <<< "$output"
    fi
}

main
