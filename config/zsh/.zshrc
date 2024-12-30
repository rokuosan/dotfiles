bindkey -e

ZSH_CONFIG_PATH="$HOME/.config/zsh/"
ZSH_MODULE_PATH="$ZSH_CONFIG_PATH/module.d"

# Load modules
module_names=(
    "completion"
    "history"
    "starship"
    "syntax-highlight"
)
for module_name in $module_names; do
    source $HOME/.config/zsh/module.d/$module_name.zsh
done
unset module_name{s,}

# Aliases
alias today='date "+%Y-%m-%d"'
alias ls='ls -G --color=auto'
alias ll='ls -G --color=auto -l'
alias q='exit'
alias v='nvim'
alias k='kubectl'

# Path(temporary)
export PATH="/opt/homebrew/opt/mysql-client@8.0/bin:$PATH"

