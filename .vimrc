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

Plugin 'SirVer/ultisnips'

Plugin 'garbas/vim-snipmate'

Plugin 'MarcWeber/vim-addon-mw-utils'

Plugin 'tomtom/tlib_vim'

Plugin 'yuttie/comfortable-motion.vim'

Plugin 'metakirby5/codi.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


syntax on
colorscheme SerialExperimentsLain

let g:python_highlight_all = 1
let g:rubycomplete_buffer_loading = 1
let g:snipMate = {}
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['ruby'] = 'ruby,ruby-rails,ruby-1.9'

" Trigger configuration. You need to change this to something else than <tab> if you use https://github.com/Valloric/YouCompleteMe.
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
