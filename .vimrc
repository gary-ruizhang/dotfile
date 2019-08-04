" minimal-vimrc

"" basic settings
set nocompatible

filetype plugin indent on
" syntax on
set autoread
set autoindent
set smartindent
set expandtab
set smarttab
set softtabstop=4
set shiftwidth=4
set shiftround
set backspace=indent,eol,start
set hidden
set number
set relativenumber
set ignorecase
set smartcase
set showcmd
set showmatch
set timeoutlen=500
set ttimeoutlen=50
set updatetime=100
set history=10000
set undofile
set incsearch
set hlsearch
set wrap
set wrapscan

let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

"" key mappings
let mapleader = " "

nnoremap <silent> <leader>/ :nohl<cr><c-l>
nnoremap <silent> g; g;zz
nnoremap <silent> g, g,zz
nnoremap ' `
nnoremap ` '
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
