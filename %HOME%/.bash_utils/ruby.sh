#!/usr/bin/env bash

update_ruby_settings() {
    local user_dir
    local bin_dir

    command -v ruby &> /dev/null                       \
        && command -v gem &> /dev/null                 \
        && user_dir="$( ruby -e 'puts Gem.user_dir' )" \
        && export GEM_HOME="$user_dir"                 \
        && bin_dir="$( ruby -e 'puts Gem.bindir' )"    \
        && add_path "$bin_dir"
}

update_ruby_settings
