#! /bin/sh

setxkbmap -option "caps:escape" &
xset r rate 300 30 &
doas wsconsctl mouse.tp.tapping=1,0,0 mouse.tp.scaling=1 &
feh --bg-scale ~/default-bg &  # symlink
xbacklight -set 12 &
picom --backend glx --vsync --blur-background --blur-method dual_kawase \
    --blur-strength 2 --no-fading-openclose &
~/.local/share/dwm/bar.sh &
~/bin/v2ray run -c ~/v2ray/config.json
