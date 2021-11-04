#!/bin/sh
set -e

# make the proper directories
mkdir -p ~/.config/vim/bundle
mkdir -p ~/.config/vim/autoload
mkdir -p ~/.config/vim/doc
mkdir -p ~/.config/vim/colors

# Setup the package manager
curl -LSso ~/.config/vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# clone in the bundles
rm -rf ~/.config/vim/bundle/base16-vim
rm -rf ~/.config/vim/bundle/vim-airline
rm -rf ~/.config/vim/bundle/everforest

git clone https://github.com/chriskempson/base16-vim.git ~/.config/vim/bundle/base16-vim
git clone https://github.com/vim-airline/vim-airline.git ~/.config/vim/bundle/vim-airline
git clone https://github.com/sainnhe/everforest.git ~/.config/vim/bundle/everforest

# Manually install certain things
cp -f -R ~/.config/vim/bundle/everforest/autoload/* ~/.config/vim/autoload/.
cp -f -R ~/.config/vim/bundle/everforest/colors/* ~/.config/vim/colors/.
cp -f -R ~/.config/vim/bundle/everforest/doc/* ~/.config/vim/doc/.

mkdir -p ~/.cache/config_config/vim
touch ~/.cache/config_config/vim/vimrc_extra
