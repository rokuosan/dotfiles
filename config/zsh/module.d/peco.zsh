if (( $+commands[peco] )); then
    function peco-history-selection() {
        BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco`
        CURSOR=$#BUFFER
        zle reset-prompt
    }

    zle -N peco-history-selection
    bindkey '^R' peco-history-selection

    function peco-ssh () {
        local selected_host=$(awk '
        tolower($1)=="host" {
            for (i=2; i<=NF; i++) {
                if ($i !~ "[*?]") {
                    print $i
                }
            }
        }
        ' ~/.ssh/config | sort | peco --query "$LBUFFER")
        if [ -n "$selected_host" ]; then
            BUFFER="ssh ${selected_host}"
            zle accept-line
        fi
        zle clear-screen
    }
    zle -N peco-ssh
    bindkey '^\' peco-ssh

    if (( $+commands[ghq] )); then
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
    fi
fi
