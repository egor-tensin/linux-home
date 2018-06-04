#!/usr/bin/env bash

# Copyright (c) 2018 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Linux/Cygwin environment" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

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
        && echo "Spawned ssh-agent with PID: $SSH_AGENT_PID." \
        && trap kill_ssh_agent EXIT
}

alias ssh-copy-id='ssh-copy-id -i'
