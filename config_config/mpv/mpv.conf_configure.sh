#!/bin/sh
set -e

[ -z "$XDG_CACHE_DIR" ] && CACHE_DIR=$HOME/.cache || CACHE_DIR=$XDG_CACHE_HOME
[ -z "$XDG_CONFIG_DIR" ] && CONFIG_DIR=$HOME/.config || CONFIG_DIR=$XDG_CONFIG_HOME

mkdir -p $CACHE_DIR/config_config/mpv > /dev/null 2>&1
mkdir -p $CONFIG_DIR/mpv > /dev/null 2>&1

cp -R $(dirname $0)/../../extras/mpv/* $CONFIG_DIR/mpv/.

touch $CACHE_DIR/config_config/mpv/mpv.conf_extra
