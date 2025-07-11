if (( $+commands[peco] )); then
    # History
    function peco-history-selection() {
        BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco`
        CURSOR=$#BUFFER
        zle reset-prompt
    }
    zle -N peco-history-selection
    bindkey '^R' peco-history-selection

    # SSH
    function peco-ssh () {
        local selected_host=$(grep -E "^Host " ~/.ssh/config | awk '{print $2}' | grep -v '*' | peco --query "$LBUFFER")
        if [ -n "$selected_host" ]; then
            BUFFER="ssh ${selected_host}"
            zle accept-line
        fi
        zle clear-screen
    }
    zle -N peco-ssh
    bindkey '^_' peco-ssh

    # ghq
    function peco-ghq-look () {
        local ghq_roots="$(git config --path --get-all ghq.root)"
        local selected_dir=$(ghq list --full-path | \
            xargs -I{} gls -dl --time-style=+%s {}/.git | sed 's/.*\([0-9]\{10\}\)/\1/' | sort -nr | \
            sed "s,.*\(${ghq_roots/$'\n'/\|}\)/,," | \
            sed 's/\/.git//' | \
            peco --prompt="cd-ghq >" --query "$LBUFFER")
        if [ -n "$selected_dir" ]; then
            BUFFER="cd $(ghq list --full-path | grep --color=never -E "/$selected_dir$")"
            zle accept-line
        fi
    }
    zle -N peco-ghq-look
    bindkey '^G' peco-ghq-look

    function peco-action-menu() {
        local -A actions=(
            ["Go to Repository(^G)"]="peco-ghq-look"
            ["SSH Connect(^_)"]="peco-ssh"
            ["History Search(^R)"]="peco-history-selection"
        )

        local selected=$(printf '%s\n' "${(@k)actions}" | peco --prompt="Action: ") || return
        eval "${actions[$selected]}"
    }
    zle -N peco-action-menu
    bindkey '^\' peco-action-menu
fi
