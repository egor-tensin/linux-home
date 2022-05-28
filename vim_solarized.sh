#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

plugins_dir="$HOME/.vim/pack/plugins/start"
name='vim-colors-solarized'

mkdir -p -- "$plugins_dir"
cd -- "$plugins_dir"

if [ -d "$name" ]; then
    cd -- "$name"
    git pull
else
    git clone "https://github.com/altercation/$name.git"
fi
