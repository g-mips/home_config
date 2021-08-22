#!/bin/sh

# make the proper directories
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/doc
mkdir -p ~/.vim/colors

# clone in the bundles
git clone https://github.com/chriskempson/base16-vim.git ~/.vim/bundle/base16-vim
git clone https://github.com/vim-airline/vim-airline.git ~/.vim/bundle/vim-airline
git clone https://github.com/sainnhe/everforest.git ~/.vim/bundle/everforest

# Manually install certain things
cp -R ~/.vim/bundle/everforest/autoload/* ~/.vim/autoload/.
cp -R ~/.vim/bundle/everforest/colors/* ~/.vim/colors/.
cp -R ~/.vim/bundle/everforest/doc/* ~/.vim/doc/.
