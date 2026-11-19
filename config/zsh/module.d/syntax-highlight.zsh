for highlighting in /opt/homebrew/share/zsh-syntax-highlighting /usr/local/share/zsh-syntax-highlighting /usr/share/zsh-syntax-highlighting; do
    if [[ -r $highlighting/zsh-syntax-highlighting.zsh ]]; then
        source "$highlighting/zsh-syntax-highlighting.zsh"
        break
    fi
done
unset highlighting
