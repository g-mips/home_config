#!/bin/sh
set -e

[ -z "$XDG_DATA_HOME" ] && DATA_DIR=$HOME/.local/share || DATA_DIR=$XDG_DATA_HOME
mkdir -p $DATA_DIR/feh > /dev/null 2>&1

printf "Copying all feh extra files from $(dirname $0)/../extras/feh/ to $DATA_DIR/feh/\n"

cp -R $(dirname $0)/../extras/feh/* $DATA_DIR/feh/.
