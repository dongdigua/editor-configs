# ksh init file
# also login shell

export PATH=$PATH:$HOME/bin
export HISTFILE=$HOME/.ksh_hist
export HISTCONTROL=ignoredup
export PS1='\u@\h \w \$ '
export LC_ALL=en_US.UTF-8

alias vim=nvim
alias tree='colortree -aC'
alias gs='git status'
