#! /bin/sh

setxkbmap -option "caps:escape" &
xset r rate 300 30 &
doas wsconsctl mouse.tp.tapping=1,0,0 mouse.tp.scaling=1 &
feh --bg-scale ~/default.jpg &
xbacklight -set 10 &
picom --backend glx --vsync &
~/.local/share/dwm/bar.sh &
~/bin/v2ray run -c ~/v2ray/config.json
