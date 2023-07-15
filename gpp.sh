#! /bin/sh

# from:
# https://lantian.pub/article/modify-website/gpp-preprocess-dockerfile-include-if.lantian/

gpp --nostdinc -U "" "" "(" "," ")" "(" ")" "#" "" -M "#" "\n" " " " " "\n" "(" ")" +c "\\\n" "" $@
