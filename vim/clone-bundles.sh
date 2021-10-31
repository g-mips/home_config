#!/bin/sh

# make the proper directories
mkdir -p ~/.config/vim/bundle
mkdir -p ~/.config/vim/autoload
mkdir -p ~/.config/vim/doc
mkdir -p ~/.config/vim/colors

# clone in the bundles
git clone https://github.com/chriskempson/base16-vim.git ~/.config/vim/bundle/base16-vim
git clone https://github.com/vim-airline/vim-airline.git ~/.config/vim/bundle/vim-airline
git clone https://github.com/sainnhe/everforest.git ~/.config/vim/bundle/everforest

# Manually install certain things
cp -R ~/.config/vim/bundle/everforest/autoload/* ~/.config/vim/autoload/.
cp -R ~/.config/vim/bundle/everforest/colors/* ~/.config/vim/colors/.
cp -R ~/.config/vim/bundle/everforest/doc/* ~/.config/vim/doc/.
