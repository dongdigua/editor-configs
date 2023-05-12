# zsh acts as a wrapper around swaywm
# it should load nessesary env variables

. "$HOME/.cargo/env"

if [ -e /home/digua/.nix-profile/etc/profile.d/nix.sh ]; then . /home/digua/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

