[ -r "$HOME/.profile" ] && source "$HOME/.profile"
[ -r "$HOME/.bashrc"  ] && source "$HOME/.bashrc"

echo "Welcome to $( hostname )"

command -v spawn_ssh_agent > /dev/null 2>&1 \
    && spawn_ssh_agent
