#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
shopt -s inherit_errexit lastpipe

plugins_dir="$HOME/.vim/pack/plugins/start"
readonly plugins_dir

plugins=(
    alteraction/vim-colors-solarized
    editorconfig/editorconfig-vim
)

pull() {
    local plugin
    for plugin in ${plugins[@]+"${plugins[@]}"}; do
        echo "Plugin: $plugin"

        local name
        name="${plugin#*/}"

        if [ -d "$name" ]; then
            git -C "$name" pull
        else
            git clone "https://github.com/$plugin.git"
        fi
    done
}

main() {
    mkdir -p -- "$plugins_dir"
    cd -- "$plugins_dir"
    pull
}

main
