# zsh login file
export PATH=$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$PATH
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
# https://wiki.archlinux.org/title/Wayland#Java
export _JAVA_AWT_WM_NONREPARENTING=1

export INPUT_METHOD=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
