#!/bin/sh
set -e

[ -z "$XDG_CACHE_HOME" ] && CACHE_DIR=$HOME/.cache || CACHE_DIR=$XDG_CACHE_HOME
INIT_CONFIG_FILE="${CACHE_DIR}/config_config/gdb/gdbinit_extra"

mkdir -p $(dirname $INIT_CONFIG_FILE) > /dev/null 2>&1

printf "******** GDB CONFIGURATION ********\n"

read -N 1 -p "Do you want tui enabled by default (y|n)? " TUI

if printf "%s" "$TUI" | grep -iqF y
then
    cat > $INIT_CONFIG_FILE <<- EOF

# TUI settings
tui enable
set tui border-kind acs
set tui border-mode bold-standout
layout regs

winheight regs 10
winheight src 35

EOF
fi

printf "refresh\n" >> $INIT_CONFIG_FILE
