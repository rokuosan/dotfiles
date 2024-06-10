export LC_ALL=ja_JP.UTF-8

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by Toolbox App
export PATH="$PATH:/Users/km3/Library/Application Support/JetBrains/Toolbox/scripts"

# pipx
export PATH="$PATH:/Users/km3/.local/pipx"

export PATH=$HOME/flutter/bin:$PATH

export PATH="$HOME/.plenv/bin:$PATH"
eval "$(plenv init zsh -)"
