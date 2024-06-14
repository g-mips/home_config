#!/bin/sh
set -e

# make the proper directories
mkdir -p ~/.config/vim/bundle
mkdir -p ~/.config/vim/autoload
mkdir -p ~/.config/vim/doc
mkdir -p ~/.config/vim/colors
mkdir -p ~/.cache/vim/swap
mkdir -p ~/.local/state/vim/backup
mkdir -p ~/.local/state/vim/undo

SETUP_PACKAGES='y'
read -N 1 -p "$(printf "\t")Setup vim package manager and packages (requires internet)? (y|n) " SETUP_PACKAGES

printf "\n"

if printf "%s" $SETUP_PACKAGES | grep -iqF y
then
    # Setup the package manager
    curl -LSso ~/.config/vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

    # clone in the bundles
    rm -rf ~/.config/vim/bundle/base16-vim
    rm -rf ~/.config/vim/bundle/vim-airline

    git clone https://github.com/chriskempson/base16-vim.git ~/.config/vim/bundle/base16-vim
    git clone https://github.com/vim-airline/vim-airline.git ~/.config/vim/bundle/vim-airline
    git clone https://github.com/tpope/vim-markdown.git ~/.config/vim/bundle/vim-markdown

    mkdir -p ~/.config/vim/pack/themes/start
    cd ~/.config/vim/pack/themes/start
    git clone https://github.com/srcery-colors/srcery-vim.git
fi
