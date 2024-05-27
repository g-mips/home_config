#!/bin/sh
set -e

[ -z "$XDG_CONFIG_HOME" ] && CONFIG_DIR=$HOME/.config || CONFIG_DIR=$XDG_CONFIG_HOME
mkdir -p $CONFIG_DIR/mpv > /dev/null 2>&1

printf "Copying all MPV extra files from $(dirname $0)/../extras/mpv/ to $CONFIG_DIR/mpv/\n"
cp -R $(dirname $0)/../extras/mpv/* $CONFIG_DIR/mpv/.
