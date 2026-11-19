#!/usr/bin/env zsh

if (( $+commands[git-wt] )); then
    eval "$(git wt --init zsh)"
fi
wt() {
    local target=$(git wt | tail -n +2 | peco | awk '{print $(NF-1)}')
    [[ $target ]] && git wt "$target"
}
