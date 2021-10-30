#!/bin/sh

(return 0 2>/dev/null) && SOURCED=1 || SOURCED=0

[ $SOURCED -eq 0 ] && echo Please source $0 && exit 1

mkdir -p $XDG_CACHE_HOME/tmux &> /dev/null
[ -z "$TMUX" ] && echo $DISPLAY > $XDG_CACHE_HOME/tmux/display_var
[ ! -z "$TMUX" ] && export DISPLAY=$(cat $XDG_CACHE_HOME/tmux/display_var)
