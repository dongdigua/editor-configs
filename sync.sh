#! /bin/sh
cp ~/.emacs                            .
cp ~/.tmux.conf                        .
cp ~/.nethackrc                        .
cp ~/.zshenv                           .
cp ~/.config/starship.toml             .
cp ~/.config/libinput-gestures.conf    .
cp ~/.config/nvim/init.vim             .
cp ~/.config/fish/config.fish          .
cp ~/.config/mutt/muttrc               .
cp -r ~/.config/sway/*                 sway/
cp -r ~/.config/waybar/*               waybar/
cp ~/.config/rofi/*                    rofi/
cp ~/.config/qutebrowser/config.py     qutebrowser/
cp ~/.config/qutebrowser/home.html     qutebrowser/
#cp ~/.config/qutebrowser/home.html     ~/Documents/
#sed -i "s/duckduckgo/bing/g"           ~/Documents/home.html
elixir epp.ex .emacs dump >            ~/.emacs.d/emacs/lisp/site-init.el
