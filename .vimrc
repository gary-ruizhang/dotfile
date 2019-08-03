""""""""""""""""""""
"  Basic Settings  "
""""""""""""""""""""

set nocompatible

filetype plugin indent on  " Load plugins according to detected filetype.
syntax on                  " Enable syntax highlighting.
set mouse=a

set autoread               " set auto read when file changed outside
set autoindent             " Indent according to previous line.
set smartindent            " smart indent
set expandtab              " Use spaces instead of tabs.
set smarttab
set softtabstop =4         " Tab key indents by 4 spaces.
set shiftwidth  =4         " >> indents by 4 spaces.
set shiftround             " >> indents to next multiple of 'shiftwidth'.
set clipboard=unnamed

set backspace   =indent,eol,start  " Make backspace work as you would expect.
set hidden                 " Switch between buffers without having to save first.
set laststatus  =2         " Always show statusline.
set display     =lastline  " Show as much as possible of the last line.
set number                 " Show line number.
set relativenumber         " hybrid line number.
set ignorecase
set smartcase              " ignorecase affects substitutions
set noshowmode             " disable show mode
set showcmd                " Show already typed keys when more are expected.
set showmatch              " Jump to matches

set timeoutlen=500
set ttimeoutlen=50
set updatetime=100
set history=10000          " default by neovim
set undofile               " keep undo history cross multi files
set pyxversion=3
set encoding=utf-8

set completeopt-=preview   " disable sratch preview buffer

" seems like don't need this
" cursor on iterm2 and tmux
" if exists('$TMUX')
"   let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"   let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
" else
"   let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"   let &t_EI = "\<Esc>]50;CursorShape=0\x7"
" endif

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

" open file at last position when you close
" remap g' to g`, cause I switch this two keys
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif

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

" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" airline
Plug 'vim-airline/vim-airline'

" nerdtree
Plug 'scrooloose/nerdtree'

" vim surround
Plug 'tpope/vim-surround'

" ale
Plug 'w0rp/ale'

" vim commentary
Plug 'tpope/vim-commentary'

" which key
Plug 'liuchengxu/vim-which-key'

" easymotion
Plug 'easymotion/vim-easymotion'

" better syntax highlighting support
Plug 'sheerun/vim-polyglot'

" forest theme
Plug 'sainnhe/vim-color-forest-night'

" fzf-vim
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" deoplete just for neovim
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'SirVer/ultisnips'
    let g:deoplete#enable_at_startup = 1
endif


" vim-go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" python
Plug 'deoplete-plugins/deoplete-jedi'

" Initialize plugin system
call plug#end()

""""""""""""""""""""
"        UI        "
""""""""""""""""""""

" light theme need install airline-theme
set background=dark
colorscheme forest-night

" airline config
let g:airline_powerline_fonts = 1

let g:airline_theme = 'forest_night'

" airline extensions
" let g:airline#extensions#tabline#enabled = 1
let g:airline_extensions = ['branch', 'tabline']
let g:airline#extensions#default#section_truncate_width = {'a': 5, 'b': 5, 'x': 5, 'y': 5, 'z': 5, 'warning': 80, 'error': 80 }

" ext config
" let g:airline#extensions#tabline#formatter = 'unique_tail'

""""""""""""""""""""
"   Leader Key     "
""""""""""""""""""""

" <space>
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
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" TODO: still need improve
" autopairs
inoremap " ""<left>
inoremap ' ''<left>
inoremap ` ``<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap "" ""
inoremap '' ''
inoremap `` ``
inoremap () ()
inoremap [] []
inoremap {} {}
inoremap ) <right>
inoremap ] <right>
inoremap } <right>
inoremap )) )
inoremap ]] ]
inoremap }} }
inoremap "<CR> "<CR>"<ESC>O
inoremap '<CR> '<CR>'<ESC>O
inoremap `<CR> `<CR>`<ESC>O
inoremap (<CR> (<CR>)<ESC>O
inoremap [<CR> [<CR>]<ESC>O
inoremap {<CR> {<CR>}<ESC>O


" Move a line of text using ALT+[jk] osx only
" <alt-j> : ∆    <alt-k> : ˚
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
"autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" | b# | endif

" ale

" lint after 1000ms after changes are made both on insert mode and normal mode
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_delay = 1000

" use nice symbols for errors and warnings
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'

let g:ale_sign_column_always = 1
highlight clear SignColumn



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

" fzf
nnoremap <silent> <leader>zf :Files<cr>
nnoremap <silent> <leader>zb :Buffers<cr>
nnoremap <silent> <leader>zC :Colors<cr>
nnoremap <silent> <leader>zt :Tags<cr>
nnoremap <silent> <leader>zm :Marks<cr>
nnoremap <silent> <leader>zh :History<cr>
nnoremap <silent> <leader>z: :History:<cr>
nnoremap <silent> <leader>z/ :History/<cr>
nnoremap <silent> <leader>zs :Snippets<cr>
nnoremap <silent> <leader>zc :Commands<cr>
nnoremap <silent> <leader>zr :Rg<space>

" completion
"

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

" ultisnips
" not conflict with completion tab
let g:UltiSnipsExpandTrigger="<c-j>"
" disable c-n and c-p before remap
" can not be tab bc this can still trigger after type some words
let g:UltiSnipsJumpForwardTrigger="<c-j>"
" FIXME: backward not work, still not figure out why
" let g:UltiSnipsJumpBackwardTrigger="<c-k>"

let g:UltiSnipsSnippetDirectories=["$HOME/.vim/snippets"]

" golang
" make deoplete work with vim-go

if has('nvim')
    call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })
endif

" better syntax highlighting
let g:go_highlight_types = 1

" golang use tab instead spaces and default width is 8
au FileType go set noexpandtab
au FileType go set shiftwidth=8
au FileType go set softtabstop=8
au FileType go set tabstop=8

" set bin path for vim-go
let g:go_bin_path = $HOME."/go/bin"

" python

" Which key

" prefix settings

call which_key#register('<Space>', "g:which_key_map")

nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

" hide statusline when echo which key
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
let g:which_key_use_floating_win = 0

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
nnoremap <silent> <leader>wz :pclose<cr>

let g:which_key_map.w.t = 'terminal'
let g:which_key_map.w.z = 'close preview'

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

" fzf group

let g:which_key_map.z = { 'name' : '+fzf' }

let g:which_key_map.z.r = 'RipGrep'

" hunk group (for gitgutter)

let g:which_key_map.h = { 'name' : '+hunk (gitgutter)' }

" git group (for fugitive)

let g:which_key_map.g = { 'name' : '+git' }

nnoremap <silent> <leader>gg :Git
nnoremap <silent> <leader>gs :Gstatus<cr>
" effective git add
nnoremap <silent> <leader>gw :Gwrite<cr>
nnoremap <silent> <leader>gl :Gpull
nnoremap <silent> <leader>gh :Gpush<cr>
nnoremap <silent> <leader>gf :Gfetch
nnoremap <silent> <leader>gm :Gmerge
nnoremap <silent> <leader>gc :Gcommit

" run means run the command, others just send the command to the command mode
let g:which_key_map.g.g = 'git <command>'
let g:which_key_map.g.s = 'run git status'
let g:which_key_map.g.w = 'run git add'
let g:which_key_map.g.l = 'git pull'
let g:which_key_map.g.h = 'run git push'
let g:which_key_map.g.f = 'git fetch'
let g:which_key_map.g.m = 'git merge'
let g:which_key_map.g.c = 'git commit'

" vim-go grup

let g:which_key_map.v = { 'name' : '+vim-go' }

nnoremap <silent> <leader>vb :GoBuild<cr>
nnoremap <silent> <leader>vr :GoRun<cr>
nnoremap <silent> <leader>vi :GoImport<space>
nnoremap <silent> <leader>vd :GoDrop<space>
