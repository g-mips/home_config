#!/bin/sh

# Configuration dirs
printf "\tMaking .config directories\n"
mkdir -p ~/.config
mkdir -p ~/.config/java
mkdir -p ~/.config/esound
mkdir -p ~/.config/vim/pack/
mkdir -p ~/.config/vim/pack/themes/start

# Cache dirs
printf "\tMaking .cache directories\n"
mkdir -p ~/.cache
mkdir -p ~/.cache/sqlite
mkdir -p ~/.cache/npm

# .local dirs
printf "\tMaking .local directories\n"
mkdir -p ~/.local
mkdir -p ~/.local/share
mkdir -p ~/.local/state
mkdir -p ~/.local
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/python
mkdir -p ~/.local/share/icons
mkdir -p ~/.local/share/gnupg
mkdir -p ~/.local/share/go
mkdir -p ~/.local/share/w3m
mkdir -p ~/.local/share/openssl
