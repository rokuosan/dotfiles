autoload -Uz compinit

zstyle ':completion:*' use-cache on
typeset -g zsh_cache_base="${XDG_CACHE_HOME:-$HOME/.cache}"
if [[ ! -d $zsh_cache_base && ! -w ${zsh_cache_base:h} ]]; then
    zsh_cache_base="${TMPDIR:-/tmp}"
fi

typeset -g zsh_cache_dir="$zsh_cache_base/zsh"
typeset -g zcompdump_path="$zsh_cache_dir/.zcompdump"

[[ -d $zsh_cache_dir ]] || mkdir -p "$zsh_cache_dir" 2>/dev/null
if [[ ! -d $zsh_cache_dir ]]; then
    zsh_cache_dir="${TMPDIR:-/tmp}/zsh-$UID"
    zcompdump_path="$zsh_cache_dir/.zcompdump"
    [[ -d $zsh_cache_dir ]] || mkdir -p "$zsh_cache_dir" 2>/dev/null
fi

zstyle ':completion:*' cache-path "$zsh_cache_dir/completion"

if [[ -s $zcompdump_path(#qN.mh+24) ]]; then
    compinit -i -d "$zcompdump_path"
else
    compinit -C -i -d "$zcompdump_path"
fi

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
if [[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
