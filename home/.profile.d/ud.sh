#!/bin/sh

(return 0 2>/dev/null) && SOURCED=1 || SOURCED=0

[ $SOURCED -eq 0 ] && echo Please source $0 && exit 1

mkdir -p $XDG_RUNTIME_DIR/tmux > /dev/null 2>&1
if [ -d $XDG_RUNTIME_DIR/tmux ]
then
    if [ -z "$TMUX" ]
    then
        echo $DISPLAY > $XDG_RUNTIME_DIR/tmux/display_var
    else
        export DISPLAY=$(cat $XDG_RUNTIME_DIR/tmux/display_var)
        REAL_SSH_CONNECTION=$(tmux show-environment 2> /dev/null | grep -E "^SSH_CONNECTION=" | cut -d'=' -f2)
        if [ "$SSH_CONNECTION" != "$REAL_SSH_CONNECTION" ]
        then
            if [ -z "$REAL_SSH_CONNECTION" ]
            then
                unset SSH_CONNECTION
                [ -f "${SSH_ENV}_$(hostname)" ] && source "${SSH_ENV}_$(hostname)" > /dev/null
                start_agent 0
            else
                export SSH_CONNECTION=$REAL_SSH_CONNECTION
            fi
        fi
    fi
fi
