if [ `uname -s` = "Darwin" ]; then
    alias ls="ls -G"
else
    alias ls="ls --color=auto"
fi

alias grep="grep --color=auto"
alias gk="gitk --all &"

export PS1="\n\[\033[32m\]\u@\h \[\033[33m\w\033[0m\]\n$ "
export EDITOR=vim

