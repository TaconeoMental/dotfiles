set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tomasr/molokai'

Plugin 'hynek/vim-python-pep8-indent'

Plugin 'vim-python/python-syntax'

Plugin 'vim-airline/vim-airline'

Plugin 'davidhalter/jedi-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


syntax on
colorscheme darkblue

let g:python_highlight_all = 1

set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

set relativenumber

set ruler

set visualbell

set encoding=utf-8

" Whitespace
set textwidth=79
set tabstop=4
set expandtab

nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

inoremap jj <esc>
vnoremap jj <esc><esc>
