#!/usr/bin/env bash

# Copyright (c) 2022 Egor Tensin <egor@tensin.name>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

# This script destroys all libvirt resources.

set -o errexit -o nounset -o pipefail
shopt -s inherit_errexit lastpipe

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
    virsh -q -c "$CONNECT" "$@"
}

list_domains() {
    run_virsh list --all --name
}

list_networks() {
    local name
    run_virsh net-list --all --name | while IFS= read -r name; do
        [ "$name" = default ] && continue
        echo "$name"
    done
}

list_volumes() {
    local name
    run_virsh vol-list "$POOL" | tr -s ' ' | while IFS=' ' read -r name _; do
        echo "$name"
    done
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
    local item

    list_domains  | while IFS= read -r item; do remove_domain  "$item"; done
    list_volumes  | while IFS= read -r item; do remove_volume  "$item"; done
    list_networks | while IFS= read -r item; do remove_network "$item"; done
}

main
