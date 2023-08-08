# init
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
autoload -Uz compinit
compinit


# zsh
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep extendedglob
bindkey -e

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
export PATH=$HOME/bin:$HOME/.local/bin:$PATH
export EDITOR=vim
export LANG=en_US.UTF-8 # translated documents are not good
export LC_ALL=en_US.UTF-8
export FZF_DEFAULT_COMMAND='rg --hidden --files'
export SDCV_PAGER='less' # not using -F
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

# ~ cleanup
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export SQLITE_HISTORY=
export W3M_DIR="$XDG_DATA_HOME"/w3m


# post-init
. $HOME/.cargo/env
. $HOME/.nix-profile/etc/profile.d/nix.sh
. /etc/profile.d/autojump.sh
eval $(starship init zsh)
ps -p $SSH_AGENT_PID > /dev/null || eval $(ssh-agent -s)
