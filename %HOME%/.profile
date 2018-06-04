# Copyright (c) 2018 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Linux/Cygwin environment" project.
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

# Ruby-specific stuff

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

ruby_setup

# Python-specific stuff

# This is a half-assed way to automatically add your user's pip binary
# directory to $PATH.

python_setup() {
    local python
    local user_base
    for python; do
        command -v "$python" > /dev/null 2>&1                 \
            && user_base="$( "$python" -m site --user-base )" \
            && [ -d "$user_base/bin" ]                        \
            && path_export "$user_base/bin"                   \
            && continue
        break
    done
}

python_setup python3 python

[ -r "$HOME/.pythonrc" ] && export PYTHONSTARTUP="$HOME/.pythonrc"

# ssh-agent

kill_ssh_agent() {
    [ -n "${SSH_AGENT_PID:+x}" ] && kill "$SSH_AGENT_PID"
}

spawn_ssh_agent() {
    local output
    [ -z "${SSH_AGENT_PID:+x}" ] \
        && command -v ssh-agent > /dev/null 2>&1 \
        && output="$( ssh-agent -s )" \
        && eval "$output" > /dev/null \
        && [ -n "${SSH_AGENT_PID:+x}" ] \
        && trap kill_ssh_agent EXIT
}

# This is a deprecated way to start ssh-agent; now it's managed by systemd (see
# .config/systemd/user/ssh-agent.service for details).
# Before starting ssh-agent like this, make sure to disable system ssh-agent's
# (like those started by Gnome or X11).
# Also, this file needs to be sourced by both your login shell and your display
# manager.
command -v systemctl > /dev/null 2>&1 || spawn_ssh_agent
