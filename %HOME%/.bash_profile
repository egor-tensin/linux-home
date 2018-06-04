[ -r "$HOME/.bashrc" ] && source "$HOME/.bashrc"

echo "Welcome to $( hostname )"

spawn_ssh_agent() {
    # This spawns ssh-agent and exports its variables to ~/.ssh_agent.sh,
    # to be used in cron jobs and such.
    local rm_ssh_agent
    local output_path="$HOME/.ssh_agent.sh"
    [ -z "${SSH_AGENT_PID:+x}" ] \
        && command -v ssh-agent > /dev/null 2>&1 \
        && touch -- "$output_path" \
        && chmod 0600 -- "$output_path" \
        && ssh-agent -s > "$output_path" \
        && source "$output_path" > /dev/null \
        && [ -n "${SSH_AGENT_PID:+x}" ] \
        && echo "Spawned ssh-agent with PID: $SSH_AGENT_PID." \
        && command -v printf > /dev/null 2>&1 \
        && rm_ssh_agent="$( printf -- 'kill %q' "$SSH_AGENT_PID" )" \
        && trap "$rm_ssh_agent" EXIT
}

spawn_ssh_agent
