# Copyright (c) 2018 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

if command -v vim > /dev/null 2>&1; then
    export EDITOR=vim
elif command -v nano > /dev/null 2>&1; then
    export EDITOR=nano
fi

path_export() {
    local path
    for path; do
        # Don't add paths with colons in them:
        case "$path" in
            *:*) continue ;;
        esac
        case "${PATH-}" in
            "$path")     continue ;;
            *":$path")   continue ;;
            "$path:"*)   continue ;;
            *":$path:"*) continue ;;
        esac
        export PATH="$path:${PATH-}"
    done
}

path_export "$HOME/.local/bin"

# -----------------------------------------------------------------------------
# Homebrew
# -----------------------------------------------------------------------------

brew_setup() {
    [ -x /opt/homebrew/bin/brew ] && \
        eval "$( /opt/homebrew/bin/brew shellenv )" && \
        prefix="$( brew --prefix )" && \
        path_export \
            "$prefix/opt/coreutils/libexec/gnubin" \
            "$prefix/opt/findutils/libexec/gnubin" \
            "$prefix/opt/gnu-sed/libexec/gnubin" \
            "$prefix/opt/grep/libexec/gnubin" \
            "$prefix/opt/python/libexec/bin"
}

brew_setup

# -----------------------------------------------------------------------------
# Ruby
# -----------------------------------------------------------------------------

# This is a half-assed way to automatically add your user's gem binary
# directory to $PATH (also setting GEM_HOME).

ruby_setup() {
    local user_dir
    local bin_dir

    command -v ruby > /dev/null 2>&1                   \
        && command -v gem > /dev/null 2>&1             \
        && user_dir="$( ruby -e 'puts Gem.user_dir' )" \
        && export GEM_HOME="$user_dir"                 \
        && bin_dir="$( ruby -e 'puts Gem.bindir' )"    \
        && path_export "$bin_dir"
}

# Deprecated in favour of using chruby/RVM/etc. for Ruby management.
#ruby_setup

chruby_setup() {
    local install_prefix="$HOME/.local"
    local share_dir="$install_prefix/share/chruby"
    [ -r "$share_dir/chruby.sh" ] && . "$share_dir/chruby.sh"
    [ -r "$share_dir/auto.sh"   ] && . "$share_dir/auto.sh"
}

chruby_setup

rbenv_setup() {
    local rbenv_init

    command -v rbenv > /dev/null && \
        rbenv_init="$( rbenv init - )" && \
        eval "$rbenv_init"
}

rbenv_setup

# -----------------------------------------------------------------------------
# Python
# -----------------------------------------------------------------------------

# This is a half-assed way to automatically add your user's pip binary
# directory to $PATH.

python_setup() {
    local python
    local user_base
    for python; do
        command -v "$python" > /dev/null 2>&1                 \
            && user_base="$( "$python" -m site --user-base )" \
            && path_export "$user_base/bin"
    done
}

python_setup python3 python

[ -r "$HOME/.pythonrc" ] && export PYTHONSTARTUP="$HOME/.pythonrc"

pyenv_setup() {
    local pyenv_init

    command -v pyenv > /dev/null && \
        pyenv_init="$( pyenv init - )" && \
        eval "$pyenv_init"
}

pyenv_setup

# -----------------------------------------------------------------------------
# Rust
# -----------------------------------------------------------------------------

path_export "$HOME/.cargo/bin"

# -----------------------------------------------------------------------------
# fzf
# -----------------------------------------------------------------------------

# Search directories and hidden files by default.
export FZF_DEFAULT_COMMAND='find -L . -\( -fstype dev -o -fstype proc -\) -prune -o -print 2> /dev/null'

command -v fd > /dev/null 2>&1 \
    && export FZF_DEFAULT_COMMAND='fd --follow --show-errors --hidden --no-ignore-vcs 2> /dev/null'

# -----------------------------------------------------------------------------
# nnn
# -----------------------------------------------------------------------------

# -A    Don't auto-enter directories.
# -e    Open text files in $EDITOR.
# -o    Only open on Enter, not on l.
export NNN_OPTS=Aeo
export NNN_PLUG='f:myfzcd'
export NNN_BMS="d:$HOME/Downloads;w:$HOME/workspace/personal"
