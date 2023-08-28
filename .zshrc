# init
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
autoload -Uz compinit promptinit
compinit -d .cache/zcompdump

# zsh
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep extendedglob
bindkey -e
autoload -U select-word-style
select-word-style bash
WORDCHARS='.-'

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
alias irc='TERM=tmux proxychains -q irssi'
alias potato='echo notify-send -u critical stop! | at now+25 minutes'

# env
export LANG=en_US.UTF-8
export EDITOR=vim
export FZF_DEFAULT_COMMAND='rg --hidden --files'
export SDCV_PAGER='less' # not using -F
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

# ~ cleanup
export SQLITE_HISTORY=
export W3M_DIR="$XDG_DATA_HOME"/w3m

# post-init
. /etc/profile.d/autojump.sh
eval $(starship init zsh)
