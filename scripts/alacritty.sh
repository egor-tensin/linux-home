#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
shopt -s inherit_errexit 2> /dev/null || true
shopt -s lastpipe

config_dir="$HOME/.config/alacritty"
readonly config_dir

pull() {
    local themes_dir
    themes_dir="$config_dir/themes"
    local themes_url='https://github.com/alacritty/alacritty-theme.git'

    if [ -d "$themes_dir" ]; then
        echo "Updating themes for alacritty"
        git -C "$themes_dir" pull
    else
        echo "Installing themes for alacritty"
        git clone -q "$themes_url" "$themes_dir"
    fi
}

main() {
    mkdir -p -- "$config_dir"
    pull
}

main
