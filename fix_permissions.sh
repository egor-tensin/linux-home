#!/usr/bin/env bash

# Some utilities (for example, ssh) fix too relaxed file permissions
# automatically.
# Others (GHCi is the reason this script exists) just spit out a warning and
# ignore such files.
# This script simply removes the write permission for everybody except myself
# for every file in this repository.

set -o errexit -o nounset -o pipefail

script_dir="$( dirname -- "${BASH_SOURCE[0]}" )"
script_dir="$( cd -- "$script_dir" && pwd )"
readonly script_dir

find "$script_dir" -mindepth 1 -path "$script_dir/.git" -prune -o -exec chmod go-w {} +
