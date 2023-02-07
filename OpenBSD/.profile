# ksh init file
# also login shell

export PATH=$PATH:$HOME/bin
export HISTFILE=$HOME/.ksh_hist
export HISTCONTROL=ignoredup
#export VISUAL=vi
export AUTOCONF_VERSION=2.71
export CLICOLOR=1
# https://gitweb.gentoo.org/repo/gentoo.git/tree/app-shells/bash/files/bashrc
export PS1='\[\033]0;\u@\h:\w\007\]\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '

alias vim=nvim
alias e='emacs -nw'
alias tree='colortree -aC'
alias gs='git status'
alias cls=clear
