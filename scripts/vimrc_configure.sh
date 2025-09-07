#!/bin/sh
set -e

# make the proper directories
#mkdir -p ~/.config/vim/bundle
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
    #curl -LSso ~/.config/vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

    # Plugins
    PLUGIN_BASE=~/.config/vim/pack/plugins/start

    # clone in the bundles
    rm -rf ~/.config/vim/bundle
    rm -rf $PLUGIN_BASE/base16-vim
    rm -rf $PLUGIN_BASE/vim-airline
    rm -rf $PLUGIN_BASE/vim-markdown
    rm -rf $PLUGIN_BASE/vimwiki

    git clone https://github.com/chriskempson/base16-vim.git $PLUGIN_BASE/base16-vim
    git clone https://github.com/vim-airline/vim-airline.git $PLUGIN_BASE/vim-airline
    git clone https://github.com/tpope/vim-markdown.git $PLUGIN_BASE/vim-markdown
    git clone https://github.com/vimwiki/vimwiki.git $PLUGIN_BASE/vimwiki

    # To generate documentation i.e. ':h vimwiki'
    vim -c "helptags $PLUGIN_BASE/vimwiki/doc" -c quit

    # Themes
    THEME_BASE=~/.config/vim/pack/themes/start
    rm -rf $THEME_BASE
    mkdir -p $THEME_BASE
    cd $THEME_BASE

    git clone https://github.com/srcery-colors/srcery-vim.git
    git clone https://github.com/NLKNguyen/papercolor-theme.git
    git clone https://github.com/dracula/vim.git
    git clone https://github.com/vim-airline/vim-airline-themes.git
fi
