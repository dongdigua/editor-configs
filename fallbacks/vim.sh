#! /bin/sh

NUM=$(grep -n '" Plug {' .vimrc | gawk '{print $1}' FS=":")
sed -i "$NUM,\$d" .vimrc
sed -i '$a colorscheme habamax' .vimrc
