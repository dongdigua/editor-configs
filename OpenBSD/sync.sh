#! /bin/sh

CURDIR=$(pwd)

Each () {
    echo $1
    cd ~/suckless/$1-flexipatch
    diff patches.def.h patches.h > $CURDIR/$1/patches.diff
    diff config.def.h config.h   > $CURDIR/$1/config.diff
}

Each dwm
Each st

# restore current dir
cd $CURDIR

cp ~/.local/share/dwm/* dwm/
cp ~/.profile .
cp ~/.xsession .
