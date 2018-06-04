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
