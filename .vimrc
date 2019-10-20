" minimal-vimrc
" don't put anything in here that you don't understand

"" basic settings
set nocompatible

filetype plugin indent on
set autoread
set autoindent
set smartindent
set expandtab
set smarttab
set tabstop=8
set softtabstop=0
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
set incsearch
set hlsearch
set wrap
set wrapscan
set wildmode=longest:list,full

set viminfo='100,<1000,s100,h

" set Pmenu color to be gray
highlight Pmenu ctermbg=gray guibg=gray
" set line number color to be gray
highlight LineNr ctermfg=gray
highlight CursorLineNr  ctermfg=gray

let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" strip trailing whitespace and not jump the cursor on save
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" open file at last position when you close
" remap g' to g`, cause I switch this two keys
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif

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
nnoremap <C-o> <C-o>zz
cnoremap f<enter> echo expand('%:p')<enter>

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align'

Plug 'tpope/vim-surround'

Plug 'tpope/vim-commentary'

Plug 'zxqfl/tabnine-vim'

Plug 'easymotion/vim-easymotion'

call plug#end()

nmap s <Plug>(easymotion-overwin-f2)
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" Plug will override this config to turn syntax on, so put this line under
syntax off
