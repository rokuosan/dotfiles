export LANG='ja_JP.UTF-8'
export LC_ALL='ja_JP.UTF-8'

export XDG_CONFIG_HOME=~/.config

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

# Ensure path arrays do not contain duplicates
typeset -gU path fpath cdpath

# Set the list of directories that Zsh searches for programs
path=(
    $HOME/.bin
    $HOME/local/bin
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
if (( $+commands[brew] )); then
    eval "$(brew shellenv)"
    path=(
        $(brew --prefix)/{sbin,bin}
        $(brew --prefix)/opt/{gnu-sed,gnu-tar,grep}/libexec/gnubin
        $path
    )
    fpath=(
        $(brew --prefix)/share/zsh-completions
        $(brew --prefix)/share/zsh/{functions,site-functions}
        $fpath
    )
fi

# Added by Toolbox App
export PATH="$PATH:/Users/km3/Library/Application Support/JetBrains/Toolbox/scripts"

# pipx
if (( $+commands[pipx] )); then
    path=(
        $HOME/.local/pipx
        $path
    )
fi

# Flutter
if (( $+commands[flutter] )); then
    path=(
        $HOME/flutter/bin
        $path
    )
fi

# plenv
if (( $+commands[plenv] )); then
    path=(
        $HOME/.plenv/bin
        $path
    )
    eval "$(plenv init zsh -)"
fi

# rbenv
if (( $+commands[rbenv] )); then
    path=(
        $HOME/.rbenv/bin
        $path
    )
    eval "$(rbenv init zsh -)"
fi

# sdkman
if (( $+commands[sdk] )); then
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# bun
if (( $+commands[bun] )); then
    export BUN_INSTALL="$HOME/.bun"
    path=(
        $BUN_INSTALL/bin
        $path
    )
fi

# go
if (( $+commands[go] )); then
    export GOPATH="$HOME/go"
    path=(
        $GOPATH/bin
        $path
    )
fi

# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true
