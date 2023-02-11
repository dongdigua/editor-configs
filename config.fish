function fish_greeting
    echo '( .-.)'
    # cat ~/TODO.md
end

alias gdbtool="emacs --eval (gdb \"gdb -i=mi $argv\")&"
alias lla="exa -alh --git --icons"
alias trexa="exa --tree --git-ignore"
alias t="trans -x 127.0.0.1:20171"  # I tried bing, but not asgoodas google
alias neofetch='neofetch | sed "s/4.2/42./g"'
alias gs="git status -sb"
alias cls=clear
alias vifzf='vim $(fzf)'
alias ra=ranger
alias bat='bat -p'
alias e="emacs -nw"
alias vim=nvim

echo "all" | history delete --prefix "git commit" > /dev/null

export EDITOR=vim
export LANG=en_US.UTF-8 # translated documents are not good
export FZF_DEFAULT_COMMAND='rg --hidden --files'

starship init fish | source
zoxide   init fish | source
