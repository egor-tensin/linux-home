#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
shopt -s inherit_errexit 2> /dev/null || true
shopt -s lastpipe

plugins_dir="$HOME/.vim/pack/plugins/start"
readonly plugins_dir

plugins=(
    altercation/vim-colors-solarized
    editorconfig/editorconfig-vim
)

pull() {
    local plugin
    for plugin in ${plugins[@]+"${plugins[@]}"}; do
        local name
        name="${plugin#*/}"

        if [ -d "$name" ]; then
            echo "Updating plugin: $plugin"
            git -C "$name" pull
        else
            echo "Installing plugin: $plugin"
            git clone -q "https://github.com/$plugin.git"
        fi
    done
}

main() {
    mkdir -p -- "$plugins_dir"
    cd -- "$plugins_dir"
    pull
}

main
