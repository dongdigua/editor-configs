function fish_greeting
    # https://github.com/qlkzy/elisp/blob/master/fortunes
    # dos2unix it otherwise it won't work
    # fortune probably makes me aware of opening up too many terminal
    fortune -s ~/.emacs.d/fortunes
end

# alias
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

# env
export EDITOR=vim
export LANG=en_US.UTF-8 # translated documents are not good
export LC_ALL=en_US.UTF-8
export FZF_DEFAULT_COMMAND='rg --hidden --files'
export SDCV_PAGER='less' # not using -F

# ~ cleanup
export SQLITE_HISTORY=
export W3M_DIR="$XDG_DATA_HOME"/w3m

# function
function kp --description "Kill processes"
    # https://github.com/SidOfc/dotfiles/blob/master/config.fish
    set -l __kp__pid ''
    set __kp__pid (ps -ef | sed 1d | eval "fzf -m --header='[kill:process]'" | awk '{print $2}')

    if test "x$__kp__pid" != "x"
        if test "x$argv[1]" != "x"
            echo $__kp__pid | xargs kill $argv[1]
        else
            echo $__kp__pid | xargs kill -9
        end
    end
end

# startup
echo "all" | history delete --prefix "git commit" > /dev/null
starship init fish | source
zoxide   init fish | source
