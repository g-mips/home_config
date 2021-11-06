#!/bin/sh
set -e

[ -z "$XDG_CACHE_HOME" ] && CACHE_DIR=$HOME/.cache || CACHE_DIR=$XDG_CACHE_HOME
[ -z "$XDG_DATA_HOME" ] && DATA_DIR=$HOME/.local/share || DATA_DIR=$XDG_DATA_HOME

mkdir -p $CACHE_DIR/config_config/feh > /dev/null 2>&1
mkdir -p $DATA_DIR/feh > /dev/null 2>&1

cp -R $(dirname $0)/../../extras/feh/* $DATA_DIR/feh/.

touch $CACHE_DIR/config_config/feh/fehbg_extra
