typeset -gU path fpath cdpath

export GOPATH="${GOPATH:-$HOME/go}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

path=(
    "$GOPATH/bin"
    "$HOME/bin"
    "$HOME/.local/bin"
    "${MISE_DATA_DIR:-$XDG_DATA_HOME/mise}/shims"
    $path
)
