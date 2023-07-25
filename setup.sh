#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
shopt -s inherit_errexit 2> /dev/null || true
shopt -s lastpipe

script_dir="$( dirname -- "${BASH_SOURCE[0]}" )"
script_dir="$( cd -- "$script_dir" && pwd )"
readonly script_dir

repo_dir=''

cleanup_repo() {
    if [ -n "$repo_dir" ]; then
        echo "Cleaning up directory: $repo_dir"
        rm -rf -- "$repo_dir"
    fi
}

config_links_in_path() {
    # Make sure the links-* utils are available.

    if command -v links-update &> /dev/null; then
        return 0
    fi

    # This is a common directory to clone config-links for me.
    if [ -d "$script_dir/../config-links" ]; then
        export PATH="$script_dir/../config-links:$PATH"
        return 0
    fi

    # If config-links is unavailable, clone it.
    readonly repo_url=https://github.com/egor-tensin/config-links.git
    trap cleanup_repo EXIT
    repo_dir="$( mktemp -d )"

    git clone -q -- "$repo_url" "$repo_dir"
    export PATH="$repo_dir:$PATH"
}

links_update() {
    cd -- "$script_dir"
    links-update

    # Some utilities (for example, ssh) fix too relaxed file permissions
    # automatically. Others (GHCi is the reason this exists) just spit out a
    # warning and ignore such files. This script simply removes the write
    # permission for everybody except myself for every file in this repository.
    links-chmod go-w
}

main() {
    config_links_in_path
    links_update
}

main
