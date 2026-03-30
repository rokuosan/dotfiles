#!/usr/bin/env zsh

eval "$(git wt --init zsh)"
wt() {
    local target=$(git wt | tail -n +2 | peco | awk '{print $(NF-1)}')
    [[ $target ]] && git wt "$target"
}
