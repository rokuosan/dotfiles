# Set locale
export LANG='ja_JP.UTF-8'
export LC_ALL='ja_JP.UTF-8'

# Set XDG config home
export XDG_CONFIG_HOME=~/.config

# Suppress bash deprecation warning on macOS
export BASH_SILENCE_DEPRECATION_WARNING=1

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

path_components=(
    "$HOME/.bin"
    "$HOME/local/bin"
    "$HOME/.local/bin"
    "$HOME/.npm-global/bin"
    "/opt/homebrew/sbin"
    "/opt/homebrew/bin"
    "/usr/local/sbin"
    "/usr/local/bin"
    "/usr/sbin"
    "/usr/bin"
    "/sbin"
    "/bin"
)

for (( idx=${#path_components[@]}-1; idx>=0; idx-- )); do
    p=${path_components[idx]}
    PATH="$p:$PATH"
done

export PATH

if [ -d "/opt/homebrew/opt/mysql-client@8.0/bin" ]; then
    export PATH="/opt/homebrew/opt/mysql-client@8.0/bin:$PATH"
fi

# plenv
if [ -d "$HOME/.plenv/bin" ]; then
    export PATH="$HOME/.plenv/bin:$PATH"
    if command -v plenv >/dev/null 2>&1; then
        eval "$(plenv init -)"
    fi
fi

# rbenv
if [ -d "$HOME/.rbenv/bin" ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    if command -v rbenv >/dev/null 2>&1; then
        eval "$(rbenv init -)"
    fi
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT/bin" ]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
fi
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# Go
export GOPATH="$HOME/go"
if [ -d "$GOPATH/bin" ]; then
    export PATH="$GOPATH/bin:$PATH"
fi

# Bun
export BUN_INSTALL="$HOME/.bun"
if [ -d "$BUN_INSTALL/bin" ]; then
    export PATH="$BUN_INSTALL/bin:$PATH"
fi

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
if [ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Vault autocomplete
if [ -x "/opt/homebrew/bin/vault" ]; then
    complete -C /opt/homebrew/bin/vault vault
fi

if [ -f "$HOME/.bashrc" ]; then
    case "$-" in
        *i*) . "$HOME/.bashrc" ;;
    esac
fi
