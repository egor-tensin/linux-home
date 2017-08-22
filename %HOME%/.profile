# This $LANG stuff I inherited from Cygwin, so I'm preserving it for now.
# Although it's broken on Ubuntu and such.
[ -z "${LANG+x}" ] \
    && LANG="$( locale --no-unicode --utf )" \
    && export LANG

[ -n "${BASH_VERSION+x}" ]    \
    && [ -r "$HOME/.bashrc" ] \
    && source "$HOME/.bashrc"
