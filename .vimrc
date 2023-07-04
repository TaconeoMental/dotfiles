" Duh
set encoding=utf-8

" Me parece más cómodo que \
let mapleader=","

""" Inicio de configuración Vundle
" Requeridos para Vundle
set nocompatible

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle bootstrap
Plugin 'VundleVim/Vundle.vim'

" General
Plugin 'preservim/nerdtree'
Plugin 'itchyny/lightline.vim'
Plugin 'yuttie/comfortable-motion.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'matze/vim-move'
Plugin 'airblade/vim-gitgutter'
Plugin 'mg979/vim-visual-multi'
Plugin 'vimsence/vimsence'

" Programación general
Plugin 'metakirby5/codi.vim'
Plugin 'Chiel92/vim-autoformat'

" Python
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'vim-python/python-syntax'

" Ruby
Plugin 'vim-ruby/vim-ruby'

" Arduino
Plugin 'sudar/vim-arduino-syntax'

" Todo
Plugin 'sheerun/vim-polyglot'

" Go
" Plugin 'fatih/vim-go'

" Misc
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'

call vundle#end()            " required
filetype plugin indent on    " required

syntax on
set termguicolors
"set t_Co=256
"set term=screen-256color
colorscheme pseudopink

""" Configuración de vimsence
let g:vimsence_file_explorer_text = 'En el explorador'
let g:vimsence_file_explorer_details = 'Buscando archivos'
let g:vimsence_editing_details = 'Editando: {}'
let g:vimsence_editing_state = 'Proyecto: {}'
let g:vimsence_editing_large_text = "Editando un archivo {}"

""" Configuración de python-syntax
let g:python_highlight_all = 1

" Esta no es específica de jedi, sino de completeopt, pero jedi-vim la
" inicializa en su ftplugin y hace que con cada completación me muestre la
" documentación arriba. Suena interesante, pero la verdad no lo uso.
autocmd FileType python setlocal completeopt-=preview

""" Configuración para Codi
let g:codi#interpreters = {
   \ 'python': {
       \ 'bin': 'python3',
       \ 'prompt': '^\(>>>\|\.\.\.\) ',
       \ },
   \ }
let g:codi#width = 70

""" Configuración de indentLine
let g:indentLine_char = '¦'

""" Configuración de lightline
let g:lightline = {
      \ 'colorscheme': 'pseudopink',
      \ }

""" Configuración de NERDTree
" Se abre siempre con vim y lleva el focus al archivo
" También actualiza lightline porque hay un bug cuando se usan estos dos juntos
"autocmd VimEnter * NERDTree | wincmd p | call lightline#update()

" Si NERDTree es la última ventana abierta, la cerramos
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

nnoremap <leader>n :NERDTreeFocus<CR>

""" Configuración de vim-autoformat
noremap <F5> :Autoformat<CR>

""" Configuración de vim-move
let g:move_key_modifier = 'S'
let g:move_key_modifier_visualmode = 'S'

" FZF
nnoremap <leader>f :Files<CR>
nnoremap <leader>l :Lines<CR>
nnoremap <leader>w :Windows<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>s :Rg<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-i': 'split',
  \ 'ctrl-s': 'vsplit' }

""" Configuración general
" Tabs
noremap <leader>t :tabnew<CR>
" Tab x número
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<CR>
" <- ->
nnoremap > gt
nnoremap < gT

" No mostrar el modo de edición actual
set noshowmode

" En pantallas pequeñas se ven mal las líneas wrappeadas, pero a veces me gusta
"function ToggleWrap()
"   set wrap!
"endfunction
"nnoremap <leader>w :call ToggleWrap()<CR>

" Shortcuts para navegar entre splits
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Splits más naturales: hacia la derecha y hacia abajo
set splitbelow
set splitright

" PEP8 es para ñoños
autocmd FileType python setlocal cc=80

" Para no usar el scroll del mouse
set guioptions-=r " chao scrollbar
set guioptions-=R " chao scrollbar en vsplits
set guioptions-=l " chao scrollbar izquierdo
set guioptions-=L " chao scrollbar izquierdo en vsplits

" Sé que se ve feo, pero creo que la única forma decente de ajustar el tamaño
" de los splits es con el mouse
function! ToggleMouse()
    if &mouse == 'n'
        set mouse=
    else
        set mouse=n
    endif
endfunc
nnoremap <F3> :call ToggleMouse()<CR>

" Una de mis cosas favoritas para moverme eficientemente
" Numeros relativos solo en el buffer actual
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set number relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Eliminar trailing whitespace al guardar el archivo
"autocmd BufWritePre * %s/\s\+$//e
"autocmd BufWritePre * %s/\n\+\%$//e
"autocmd BufWritePre *.[ch] %s/\%$/\r/e

" Mostrar posición del cursor
set ruler

" Debería ser default
set visualbell

" Whitespace
set textwidth=79
set tabstop=4
set shiftwidth=4
set expandtab

" TODO: Explicar esto
set laststatus=2

" Bloqueo el uso de las flechas para moverse >:(
nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" No me gusta usar <esc> para salir de los modos, así que lo mapeo a jj.
inoremap jj <esc>
vnoremap jj <esc><esc>
