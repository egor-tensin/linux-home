[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"

echo "Welcome to $( hostname )"

spawn_ssh_agent() {
    [ -n "${SSH_AGENT_PID:+x}" ] && return 0

    eval "$( ssh-agent -s )" > /dev/null \
        && trap "$( printf 'kill %q' "$SSH_AGENT_PID" )" 0 \
        && ssh-add &> /dev/null
}

[ "$( uname -o )" == 'Cygwin' ] && spawn_ssh_agent
