bindkey -e

bindkey -r '^T'

ZSH_CONFIG_PATH="$HOME/.config/zsh"
ZSH_MODULE_PATH="$ZSH_CONFIG_PATH/module.d"

fpath=("$ZSH_CONFIG_PATH/completion.d" $fpath)

# Load modules
module_names=(
    "mise"
    "completion"
    "history"
    "starship"
    "peco"
    "git-wt"
    "syntax-highlight"
)
for module_name in $module_names; do
    source "$ZSH_MODULE_PATH/$module_name.zsh"
done
unset module_name{s,}

if [[ -f "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

# Aliases
if [[ $OSTYPE == darwin* ]]; then
    alias ls='ls -G --color=auto'
else
    alias ls='ls --color=auto'
fi
alias ll='ls -la'
alias path='echo $PATH | tr ":" "\n" | less'
alias q='exit'
alias qq='exit'
alias "/exit"="exit"
alias k='kubectl'
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

if [[ $OSTYPE == darwin* && -z $SSH_CONNECTION ]]; then
    agent_socket="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    [[ -S $agent_socket ]] && export SSH_AUTH_SOCK="$agent_socket"
    unset agent_socket
fi
