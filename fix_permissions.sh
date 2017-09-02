#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

script_dir="$( dirname -- "${BASH_SOURCE[0]}" )"
script_dir="$( cd -- "$script_dir" && pwd )"
find "$script_dir" -mindepth 1 -path "$script_dir/.git" -prune -o -exec chmod g-w {} +
