# History Settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=100000
setopt inc_append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt extended_history


# Color
autoload -Uz colors
colors

# Completions
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Misc
setopt auto_cd
setopt correct
setopt extended_glob
setopt auto_param_slash
setopt auto_param_keys
setopt auto_menu
setopt auto_list
setopt magic_equal_subst
setopt interactive_comments
setopt complete_in_word

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# kubectl
source <(kubectl completion zsh)
source <(kind completion zsh)
alias k=kubectl
complete -o default -F __start_kubectl k

# zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

# pipx
export PATH="$PATH:/Users/km3/.local/pipx"
export PIPX_HOME="$HOME/.local/pipx"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/Users/km3/.bun/_bun" ] && source "/Users/km3/.bun/_bun"

# Golang
export PATH=$PATH:$HOME/go/bin

# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# zsh-completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  autoload -Uz compinit
  compinit
fi

# Aliases
alias ls='ls -G --color=auto'
alias q='exit'
alias today='date "+%Y-%m-%d"'
alias e='emacs'

# starship
eval "$(starship init zsh)"

# pipx
# eval "$(register-python-argcomplete pipx)"

# zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
eval "$(rbenv init - zsh)"

export PATH=$PATH:$HOME/local/bin
source <(home completion zsh)
export NATURE_TOKEN=L6cSAicqlcLAR-pSDx4aJ2iPFneeKz_JRQRTOK99ThE.S4TE0fJJMmmquiKyVn6YEZYM0MtLnDYhpyIUAZBlDnA

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/vault vault
export PATH="/opt/homebrew/opt/mysql-client@8.0/bin:$PATH"

# Taskfile
eval "$(task --completion zsh)"

# Created by `pipx` on 2024-09-26 15:51:01
export PATH="$PATH:/Users/km3/.local/bin"
