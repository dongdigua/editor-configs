#! /bin/sh

NUM=$(grep -n '" Plug {' init.vim | gawk '{print $1}' FS=":")
sed -i "$NUM,\$d" init.vim
sed -i '$a colorscheme habamax' init.vim
