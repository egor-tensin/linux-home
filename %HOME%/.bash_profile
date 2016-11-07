[ -r "$HOME/.bashrc" ] && source "$HOME/.bashrc"

echo "Welcome to $( hostname )"

spawn_ssh_agent() {
    [ -n "${SSH_AGENT_PID:+x}" ] && return 0

    command -v ssh-agent &> /dev/null           \
        && eval "$( ssh-agent -s )" > /dev/null \
        && [ -n "${SSH_AGENT_PID:+x}" ]         \
        && trap "$( printf -- 'kill %q' "$SSH_AGENT_PID" )" 0
}

spawn_ssh_agent
