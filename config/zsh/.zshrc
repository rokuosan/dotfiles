bindkey -e

bindkey -r '^T'

ZSH_CONFIG_PATH="$HOME/.config/zsh/"
ZSH_MODULE_PATH="$ZSH_CONFIG_PATH/module.d"

# Load modules
module_names=(
    "mise"
    "completion"
    "history"
    "starship"
    "syntax-highlight"
    "peco"
    "git-wt"
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
alias todaydir='mkdir -p $(date "+%Y-%m-%d")'
alias ls='ls -G --color=auto'
alias ll='ls -G --color=auto -la'
alias path='echo $PATH | tr ":" "\n"'
alias q='exit'
alias qq='exit'
alias "/exit"="exit"
alias k='kubectl'
alias g='git'
alias gsp='git switch `git branch | peco | sed -e "s/*//g"`'
alias nl='nl -b a -s ": " '

if (( ${+commands[nvim]} )); then
    alias v='nvim'
fi

if (( ${+commands[codex]} )); then
    alias codexauto="codex --sandbox workspace-write --ask-for-approval untrusted -c approvals_reviewer=auto_review"
    alias codexx="codex --sandbox workspace-write --ask-for-approval untrusted"
    alias codexro="codex --sandbox read-only --ask-for-approval never"
    alias codexroi="codex --sandbox read-only --ask-for-approval on-request"
fi

if (( ${+commands[zoxide]} )); then
    [[ $- == *i* ]] && eval "$(zoxide init zsh --cmd cd)"
fi

if (( ${+commands[bat]} )); then
    alias cat="bat"
fi

if (( ${+commands[op]} )); then
    export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
fi
