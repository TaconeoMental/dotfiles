set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'tomasr/molokai'

Plugin 'hynek/vim-python-pep8-indent'

Plugin 'vim-python/python-syntax'

Plugin 'vim-airline/vim-airline'

Plugin 'davidhalter/jedi-vim'

Plugin 'SirVer/ultisnips'

Plugin 'garbas/vim-snipmate'

Plugin 'MarcWeber/vim-addon-mw-utils'

Plugin 'tomtom/tlib_vim'

Plugin 'yuttie/comfortable-motion.vim'

Plugin 'metakirby5/codi.vim'

Plugin 'Yggdroot/indentLine'

Plugin 'lu-ren/SerialExperimentsLain'
call vundle#end()            " required
filetype plugin indent on    " required

syntax on
colorscheme SerialExperimentsLain

let g:python_highlight_all = 1
let g:rubycomplete_buffer_loading = 1
let g:snipMate = {}
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['ruby'] = 'ruby,ruby-rails,ruby-1.9'

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Configuración para Codi
let g:codi#interpreters = {
   \ 'python': {
       \ 'bin': 'python3',
       \ 'prompt': '^\(>>>\|\.\.\.\) ',
       \ },
   \ }
let g:codi#width = 70

" Conf de indentLine
let g:indentLine_char = '¦'

" Configuración general

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

" Bloqueo el uso de las flechas para moverse >:(
" No me gusta usar <esc> para salir de los modos, así que lo mapeo jj.

nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

inoremap jj <esc>
vnoremap jj <esc><esc>
