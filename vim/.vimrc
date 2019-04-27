" Plugin management
execute pathogen#infect()

syntax on
filetype plugin indent on

set nu rnu
augroup numbertoogle
    au!
    au BufEnter,FocusGained,InsertLeave * set relativenumber
    au BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END

colorscheme base16-gruvbox-dark-medium

runtime! ftplugin/man.vim

set cursorline
set showcmd
set belloff=all
set ttyfast
set incsearch

" Web
au FileType html,javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab smarttab
au BufNewFile,BufRead *.vue setfiletype html

" C, C++
au FileType c,cpp setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab smarttab

" Golang
au FileType go setlocal tabstop=8 shiftwidth=8 softtabstop=8 noexpandtab smarttab

inoremap jj <ESC>

" set guioptions -=m
" set guioptions -=T
" set guioptions -=r
