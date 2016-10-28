LANG="$( locale --no-unicode --utf )"
export LANG

[ -n "${BASH_VERSION+x}" ] \
    && [ -f "$HOME/.bashrc" ] \
    && source "$HOME/.bashrc"
