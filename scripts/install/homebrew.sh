#!/usr/bin/env bash

set -euo pipefail

DOTFILES_HOME="$(cd "$(dirname "$0")/../.." && pwd)"

find_brew() {
    if command -v brew > /dev/null 2>&1; then
        command -v brew
        return
    fi

    local candidate
    for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
        if [ -x "$candidate" ]; then
            echo "$candidate"
            return
        fi
    done

    return 1
}

if ! BREW_BIN="$(find_brew)"; then
    installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    /bin/bash -c "$installer"
    BREW_BIN="$(find_brew)"
fi

eval "$("$BREW_BIN" shellenv)"
"$BREW_BIN" bundle --file="${DOTFILES_HOME}/Brewfile" --no-upgrade
