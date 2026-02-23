# eval "$(starship init bash)"

HISTSIZE=500000
SAVEHIST=500000

color_prompt=yes
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[00m\]\$ '

alias today='date "+%Y-%m-%d"'
alias ls='ls -G --color=auto'
alias ll='ls -G --color=auto -l'
alias la='ls -laO'
alias q='exit'

alias edit='code'
alias h='history'
alias h2='history 20'
alias nl='nl -b a -s ": " '
alias auth='sh ~/bin/auth.sh'
alias b2a='sh ~/bin/b2a.sh'
alias java_home-v='sh ~/bin/java_home-v.sh'
alias path='echo $PATH | tr ":" "\n"'
