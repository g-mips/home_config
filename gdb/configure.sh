#!/bin/sh
ROOT=$(pwd)
CONFIG_FILE=${ROOT}/Makefile_config
DEFAULT_FILE=${ROOT}/.gdbinit.default

echo "******** GDB CONFIGURATION ********"

echo "source ${ROOT}/.gdbinit" > $DEFAULT_FILE

read -p "Do you want tui enabled by default (y|n)? " TUI

if [ "$TUI" = "y" ] || [ "$TUI" = "Y" ]
then
	echo OTHER_FILES=\$\(ROOT\)/.gdb_tui > $CONFIG_FILE
    echo "source ${ROOT}/.gdb_tui" >> $DEFAULT_FILE
fi

echo "refresh" >> $DEFAULT_FILE
