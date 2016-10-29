LANG="$( locale --no-unicode --utf )" && export LANG

[ -n "${BASH_VERSION+x}" ] \
    && [ -r "$HOME/.bashrc" ] \
    && source "$HOME/.bashrc"
