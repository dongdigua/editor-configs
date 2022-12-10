#! /bin/sh

START=$(grep -n ';; theme-start' .emacs | gawk '{print $1}' FS=":")
END=$(grep -n ';; theme-end' .emacs | gawk '{print $1}' FS=":")
sed -i "$START,$END d" .emacs
sed -i "\$a (load-theme 'tango-dark t)" .emacs
