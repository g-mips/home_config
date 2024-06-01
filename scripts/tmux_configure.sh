#!/bin/sh

SETUP_PACKAGES='y'
read -N 1 -p "$(printf "\t")Setup tmux package manager and packages (requires internet)? (y|n) " SETUP_PACKAGES

printf "\n"

if printf "%s" $SETUP_PACKAGES | grep -iqF y
then
    mkdir -p ~/.config/tmux/plugins/

    rm -rf ~/.config/tmux/plugins/tpm

    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
fi
