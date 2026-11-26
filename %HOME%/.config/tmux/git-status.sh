#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
shopt -s inherit_errexit lastpipe

script_name="$( basename -- "${BASH_SOURCE[0]}" )"
readonly script_name

export GIT_CONFIG_NOSYSTEM=1
export GIT_CONFIG_GLOBAL=/dev/null

main() {
    if [ "$#" -ne 1 ]; then
        echo "usage: $script_name DIR"
        exit 1
    fi

    local dir="$1"

    if ! git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        exit 0
    fi

    local branch
    branch="$( git -C "$dir" symbolic-ref --quiet --short HEAD )"
    if [ -z "$branch" ]; then
        branch="$( git -C "$dir" rev-parse --short HEAD )"
    fi

    if [ "$branch" != "master" ] && [ "$branch" != "main" ]; then
        branch="#[fg=brightblack]$branch#[default]"
    fi

    local state
    if [ -n "$( git -C "$dir" status --porcelain )" ]; then
        state="*"
    else
        state="✓"
    fi

    if [ -n "$( git -C "$dir" status --porcelain )" ]; then
        state="#[fg=brightblack]$state#[default]"
    fi

    printf 'git: %s %s | ' "$branch" "$state"
}

main "$@"
