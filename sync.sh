#! /bin/bash
cp ~/.vimrc                            .
cp ~/.emacs                            .
cp ~/.tmux.conf                        .
cp ~/.nethackrc                        .
cp ~/.config/starship.toml             .
cp ~/.config/fish/config.fish          .
cp -r ~/.config/sway/*                 sway/
cp -r ~/.config/waybar/*               waybar/
cp ~/.config/rofi/*                    rofi/
cp ~/.config/qutebrowser/config.py     qutebrowser/
cp ~/.config/qutebrowser/home.html     qutebrowser/
cp ~/.config/qutebrowser/home.html     ~/Documents/
sed -i "s/duckduckgo/bing/g"           ~/Documents/home.html
# cp ~/.config/wayfire.ini .
