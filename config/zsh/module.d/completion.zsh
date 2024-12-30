autoload -Uz compinit
compinit -i

# Shell Options
setopt ALWAYS_TO_END
setopt AUTO_CD
setopt AUTO_LIST
setopt AUTO_MENU
setopt AUTO_PARAM_KEYS
setopt AUTO_PARAM_SLASH
setopt COMPLETE_IN_WORD
setopt CORRECT
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
setopt MAGIC_EQUAL_SUBST

unsetopt MENU_COMPLETE
unsetopt FLOW_CONTROL

# Color
autoload -Uz colors
colors

# Completions
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Suggest
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
