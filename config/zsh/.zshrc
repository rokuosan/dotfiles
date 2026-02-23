bindkey -e

ZSH_CONFIG_PATH="$HOME/.config/zsh/"
ZSH_MODULE_PATH="$ZSH_CONFIG_PATH/module.d"

# Load modules
module_names=(
    "completion"
    "history"
    "starship"
    "syntax-highlight"
    "peco"
)
for module_name in $module_names; do
    source $HOME/.config/zsh/module.d/$module_name.zsh
done
unset module_name{s,}

if [[ -f "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

# Aliases
alias today='date "+%Y-%m-%d"'
alias ls='ls -G --color=auto'
alias ll='ls -G --color=auto -l'
alias q='exit'
alias v='nvim'
alias k='kubectl'
alias t='task'
disable r
alias r='bin/rails'
alias p='pnpm'

eval "$(zoxide init zsh)"

eval "$(git wt --init zsh)"
wt() {
    git wt "$(git wt | tail -n +2 | peco | awk '{print $(NF-1)}')"
}

export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# bun completions
[ -s "/Users/km3/.bun/_bun" ] && source "/Users/km3/.bun/_bun"
