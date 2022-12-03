#! /bin/sh

sed -i '$d' rofi/config.rasi
sed -i 's/wallpaper:~\/.config\/waybar\/scripts\/wallpaper.pl,//g' rofi/config.rasi
