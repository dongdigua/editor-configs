#! /bin/sh

START=$(grep -n ';; theme-start' .emacs | gawk '{print $1}' FS=":")
END=$(grep -n ';; theme-end' .emacs | gawk '{print $1}' FS=":")
sed -i "$START,$END d" .emacs
BUTT=$(grep -n ';; end of init ;;' .emacs | gawk '{print $1}' FS=":")
sed -i "$BUTT,\$d" .emacs

sed -i "\$a (load-theme 'tango-dark t)"   .emacs
sed -i "1a  (load-file \"./min-pkg.el\")" .emacs
