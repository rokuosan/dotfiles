# Editor
export PAGER='less'
export LESS='--quit-if-one-screen --hilite-search --ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS --chop-long-lines --hilite-unread --no-init --window=-5'
export EDITOR='nvim'

if [[ $OSTYPE == darwin* ]]; then
    export LANG='ja_JP.UTF-8'
    export LC_ALL='ja_JP.UTF-8'
    path+=("$HOME/.docker/bin")
fi

# Homebrew
if [[ $OSTYPE == darwin* && -d /opt/homebrew ]]; then
    brew_prefix="/opt/homebrew"
elif [[ $OSTYPE == darwin* && -x /usr/local/bin/brew ]]; then
    brew_prefix="/usr/local"
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
