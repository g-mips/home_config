" Plugin management
execute pathogen#infect()

syntax on
filetype plugin indent on

" Relative number
function! SetRelNum()
  if &ft != "man"
    set relativenumber
  endif
endfunc

set nu rnu
augroup numbertoogle
  au!
  au BufEnter,FocusGained,InsertLeave * call SetRelNum()
  au BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END

" Theme
set background=dark
let g:everforeset_background = 'soft'
colorscheme everforest
let g:airline_theme = 'everforest'

" Man
runtime! ftplugin/man.vim

set cursorline
set showcmd
set belloff=all
set ttyfast
set incsearch

set sessionoptions+=tabpages,globals

" Web, Vim
au FileType html,javascript,vim setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab smarttab
au BufNewFile,BufRead *.vue setfiletype html

" C, C++, Shell
au FileType c,cpp,sh setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab smarttab

" Golang
au FileType go setlocal tabstop=8 shiftwidth=8 softtabstop=8 noexpandtab smarttab

inoremap jj <ESC>

" Remove GUI things
if has('gui_running')
  set guioptions -=m
  set guioptions -=T
  set guioptions -=r
endif
