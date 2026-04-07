typeset -gU path fpath cdpath

export LANG='ja_JP.UTF-8'
export LC_ALL='ja_JP.UTF-8'

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export GOPATH="$HOME/go"

# Editor
export PAGER='less'
export LESS='--quit-if-one-screen --hilite-search --ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS --chop-long-lines --hilite-unread --no-init --window=-5'
case "$OSTYPE" in
    darwin*)
        export EDITOR='nvim'
        ;;
    *)
        export EDITOR='vim'
        ;;
esac

path=(
    $GOPATH/bin
    $HOME/bin
    $HOME/.local/bin
    /opt/homebrew/{sbin,bin}
    /usr/local/{sbin,bin}
    /usr/{sbin,bin}
    /{sbin,bin}
    $path
)
fpath=(
    $HOME/.config/zsh/completion.d
    $fpath
)

# Homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
    brew_prefix="$(/opt/homebrew/bin/brew --prefix)"
elif [[ -x /usr/local/bin/brew ]]; then
    brew_prefix="$(/usr/local/bin/brew --prefix)"
else
    brew_prefix=""
fi

if [[ -n $brew_prefix ]]; then
    path=(
        "$brew_prefix"/{sbin,bin}
        "$brew_prefix"/opt/{gnu-sed,gnu-tar,grep}/libexec/gnubin
        $path
    )
    fpath=(
        "$brew_prefix"/share/zsh-completions
        "$brew_prefix"/share/zsh/{functions,site-functions}
        $fpath
    )
    unset brew_prefix
fi
