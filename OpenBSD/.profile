# ksh init file
# also login shell

export PATH=$PATH:$HOME/bin
export HISTFILE=$HOME/.ksh_hist
export HISTCONTROL=ignoredup
export PS1='\u@\h \w \$ '
export AUTOCONF_VERSION=2.71

alias vim=nvim
alias e='emacs -nw'
alias tree='colortree -aC'
alias gs='git status'
