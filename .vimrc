""""""""""""""""""""
"  Basic Settings  "
""""""""""""""""""""

set nocompatible

filetype plugin indent on  " Load plugins according to detected filetype.
syntax on                  " Enable syntax highlighting.

set autoread               " set auto read when file changed outside
set autoindent             " Indent according to previous line.
set smartindent            " smart indent
set expandtab              " Use spaces instead of tabs.
set smarttab
set softtabstop =4         " Tab key indents by 4 spaces.
set shiftwidth  =4         " >> indents by 4 spaces.
set shiftround             " >> indents to next multiple of 'shiftwidth'.

set backspace   =indent,eol,start  " Make backspace work as you would expect.
set hidden                 " Switch between buffers without having to save first.
set laststatus  =2         " Always show statusline.
set display     =lastline  " Show as much as possible of the last line.
set number                 " Show line numbers.
set ignorecase
set smartcase              " ignorecase affects substitutions
set noshowmode             " disable show mode
set showcmd                " Show already typed keys when more are expected.
set showmatch              " Jump to matches

set timeoutlen=500
set ttimeoutlen=50
set history=10000          " default by neovim
set undofile               " keep undo history cross multi files

" cursor on iterm2 and tmux
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

set incsearch              " Highlight while searching with / or ?.
set hlsearch               " Keep matches highlighted.

set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.

set splitbelow             " Open new windows below the current window.
set splitright             " Open new windows right of the current window.

set cursorline             " Find the current line quickly.
set wrap
set wrapscan               " Searches wrap around end-of-file.
set report      =0         " Always report changed lines.
set synmaxcol   =200       " Only highlight the first 200 columns.

set wildmenu
set wildmode=longest,list
" set wildmode=full

" remove trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e

" Vim ONLY

if !has('nvim')
endif

" NeoVim ONLY

if has('nvim')
    " terminal
    tnoremap <Esc> <C-\><C-n>
    tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
endif

""""""""""""""""""""
"     Plugins      "
""""""""""""""""""""
" Plugins

" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" solarized theme
Plug 'altercation/vim-colors-solarized'

" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" nerdtree
Plug 'scrooloose/nerdtree'

" vim surround
Plug 'tpope/vim-surround'

" vim commentary
Plug 'tpope/vim-commentary'

" ale
Plug 'w0rp/ale'

" which key
Plug 'liuchengxu/vim-which-key'

" easymotion
Plug 'easymotion/vim-easymotion'

" nord theme
Plug 'arcticicestudio/nord-vim'

" coc
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}

" auto pairs
Plug 'jiangmiao/auto-pairs'

" Initialize plugin system
call plug#end()

""""""""""""""""""""
"        UI        "
""""""""""""""""""""

" nord settings need put before colorscheme
let g:nord_italic = 1
let g:nord_italic_comments = 1
set background=dark
colorscheme nord

" solarized airline_theme
" let g:airline_theme='solarized'
" let g:airline_solarized_bg='light'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'


""""""""""""""""""""
"   Leader Key     "
""""""""""""""""""""

let mapleader = " "

" others
nnoremap <silent> <leader>/ :nohl<cr><c-l>
nnoremap <silent> <leader>* :%s/<c-r><c-w>//g<left><left>
"

""""""""""""""""""""
"   Key Mappings   "
""""""""""""""""""""

" Format jump
nnoremap <silent> g; g;zz
nnoremap <silent> g, g,zz

" Swap implementations of ` and ' jump to markers
" By default, ' jumps to the marked line, ` jumps to the marked line and
" column, so swap them
nnoremap ' `
nnoremap ` '

" Keep search matches in the middle of the window.
" zz centers the screen on the cursor, zv unfolds any fold if the cursor
" suddenly appears inside a fold.
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap n nzzzv
nnoremap N Nzzzv

" In normal mode, we use : much more often than ; so lets swap them.
" WARNING: this will cause any "ordinary" map command without the "nore" prefix
" that uses ":" to fail. For instance, "map <f2> :w" would fail, since vim will
" read ":w" as ";w" because of the below remappings. Use "noremap"s in such
" situations and you'll be fine.
" this will cause neovim not display command mode when press :
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" This makes j and k work on "screen lines" instead of on "file lines"; now, when
" we have a long line that wraps to multiple screen lines, j and k behave as we
" expect them to.
nnoremap j gj
nnoremap k gk

" Move a line of text using ALT+[jk] osx only
" <alt-j> : ∆    <alt-k> : ˚
" work before but not work now, don't know why
" nmap ∆ mz:m+<cr>`z
" nmap ˚ mz:m-2<cr>`z
" vmap ∆ :m'>+<cr>`<my`>mzgv`yo`z
" vmap ˚ :m'<-2<cr>`>my`<mzgv`yo`z


""""""""""""""""""""
" Plugins Settings "
""""""""""""""""""""

" NerdTree

nnoremap <silent><leader>nt :<c-u>NERDTreeToggle<CR>

" make sure not open files and other buffers on NerdTree window.
" If previous buffer was NERDTree, go back to it.
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" | b# | endif

" ale

" lint after 1000ms after changes are made both on insert mode and normal mode
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_delay = 1000

" use nice symbols for errors and warnings
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'

let g:ale_sign_column_always = 1
highlight clear SignColumn
let g:airline#extensions#ale#enabled = 1



" Easymotion

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" coc

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nnoremap <silent> <space>cl  :<C-u>CocList<cr>

" use <c-j> and <c-k> instead
" let g:coc_snippet_next = '<tab>'
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() :
                                           \"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Which key

" prefix settings

call which_key#register('<Space>', "g:which_key_map")

nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

" hide statusline when echo which key
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Define prefix dictionary
let g:which_key_map =  {}

" Space group

let g:which_key_map[' '] = {
      \ 'name' : '+Easymotion ' ,
      \ 'f' : ['<plug>(easymotion-prefix)f' , 'find {char} to the right'],
      \ 'F' : ['<plug>(easymotion-prefix)F' , 'find {char} to the left'],
      \ 't' : ['<plug>(easymotion-prefix)t' , 'till before the {char} to the right'],
      \ 'T' : ['<plug>(easymotion-prefix)T' , 'till after the {char} to the left'],
      \ 'w' : ['<plug>(easymotion-prefix)w' , 'beginning of word forward'],
      \ 'W' : ['<plug>(easymotion-prefix)W' , 'beginning of WORD forward'],
      \ 'b' : ['<plug>(easymotion-prefix)b' , 'beginning of word backward'],
      \ 'B' : ['<plug>(easymotion-prefix)B' , 'beginning of WORD backward'],
      \ 'e' : ['<plug>(easymotion-prefix)e' , 'end of word forward'],
      \ 'E' : ['<plug>(easymotion-prefix)E' , 'end of WORD forward'],
      \ 'g' : {
        \ 'name' : '+Backwards ' ,
        \ 'e' : ['<plug>(easymotion-prefix)ge' , 'end of word backward'],
        \ 'E' : ['<plug>(easymotion-prefix)gE' , 'end of WORD backward'],
        \ },
      \ 'j' : ['<plug>(easymotion-prefix)j' , 'line downward'],
      \ 'k' : ['<plug>(easymotion-prefix)k' , 'line upward'],
      \ 'n' : ['<plug>(easymotion-prefix)n' , 'jump to latest "/" or "?" forward'],
      \ 'N' : ['<plug>(easymotion-prefix)N' , 'jump to latest "/" or "?" backward.'],
      \ 's' : ['<plug>(easymotion-prefix)s' , 'find(search) {char} forward and backward.'],
      \ }

" buffer group

let g:which_key_map.b = {
      \ 'name' : '+buffer' ,
      \ 'f' : ['bfirst'    , 'first-buffer']    ,
      \ 'h' : ['Startify'  , 'home-buffer']     ,
      \ 'l' : ['blast'     , 'last-buffer']     ,
      \ 'n' : ['bnext'     , 'next-buffer']     ,
      \ 'p' : ['bprevious' , 'previous-buffer'] ,
      \ }

nnoremap <silent> <leader>bd :bd!<cr>
let g:which_key_map.b.d = 'delete-buffer'



" window group

let g:which_key_map.w = {
      \ 'name' : '+window' ,
      \ 's' : ['split'     , 'split'],
      \ 'v' : ['vsplit'    , 'vsplit'],
      \ }

nnoremap <silent> <leader>wt :split <bar> terminal<cr>
let g:which_key_map.w.t = 'terminal'

" file group
nnoremap <silent> <leader>fs :update<CR>
nnoremap <silent> <leader>fd :e $MYVIMRC<CR>
nnoremap <silent> <leader>fw :write<CR>
nnoremap <silent> <leader>fq :wq<CR>

let g:which_key_map.f = {
      \ 'name' : '+file',
      \ 'u' : 'update',
      \ 'w' : 'write',
      \ 'q' : 'quit',
      \ 'd' : 'open-vimrc',
      \ }

" nerdtree group

let g:which_key_map.n = {
      \ 'name' : '+nerdtree',
      \ }

