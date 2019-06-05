" Basic Settings

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
set undofile

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

" Remember folding
augroup remember_folds
  autocmd!
  autocmd BufWinLeave ?* mkview
  autocmd BufWinEnter ?* silent! loadview
augroup END

" Vim ONLY

if !has('nvim')
endif

" NeoVim ONLY

if has('nvim')
    " terminal
    tnoremap <Esc> <C-\><C-n>
    tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
endif

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

" coc
Plug 'neoclide/coc.nvim', {'do': './install.sh nightly'}
Plug 'honza/vim-snippets'

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

" Initialize plugin system
call plug#end()

" UI

set background=light
colorscheme solarized

let g:airline_theme='solarized'
let g:airline_solarized_bg='light'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Leader Key

let mapleader = " "

" Split fast
nnoremap <leader>\ :vs<cr> "error
nnoremap <leader>- :sp<cr>

" others
nnoremap <silent> <leader>/ :nohl<cr><c-l>
nnoremap <silent> <leader>* :%s/<c-r><c-w>//g<left><left>
"

" Key Mappings

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

" This makes j and k work on "screen lines" instead of on "file lines"; now, when
" we have a long line that wraps to multiple screen lines, j and k behave as we
" expect them to.
nnoremap j gj
nnoremap k gk

" Move a line of text using ALT+[jk] osx only
nmap ∆ mz:m+<cr>`z
nmap ˚ mz:m-2<cr>`z
vmap ∆ :m'>+<cr>`<my`>mzgv`yo`z
vmap ˚ :m'<-2<cr>`>my`<mzgv`yo`z

" Coc Settings

" coc.nvim

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
" set noswapfile

" Better display for messages
" set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=100

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
" set signcolumn=no

" show diagnostics info on statusline
set statusline^=%{coc#status()}

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

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>crn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>cf  <Plug>(coc-format-selected)
nmap <leader>cf  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>ca  <Plug>(coc-codeaction-selected)
nmap <leader>ca  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>cac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>cqf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)


" Add diagnostic info for https://github.com/itchyny/lightline.vim
" let g:lightline = {
"       \ 'colorscheme': 'wombat',
"       \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ],
"       \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
"       \ },
"       \ 'component_function': {
"       \   'cocstatus': 'coc#status'
"       \ },
"       \ }

" Using CocList

" Show CocList
nnoremap <silent> <leader>cl :CocList<cr>
" Show all diagnostics
nnoremap <silent> <leader>cA  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <leader>ce  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <leader>cs  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <leader>cj  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <leader>ck  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <leader>cp  :<C-u>CocListResume<CR>
" coc-yank
nnoremap <silent> <leader>cy  :<C-u>CocList --normal yank<cr>

" coc-snippets

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() :
                                           \"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

let g:coc_snippet_next = '<TAB>'

let g:coc_snippet_prev = '<S-TAB>'

" others

" if you want to disable auto detect, comment out those two lines
" let g:airline#extensions#disable_rtp_load = 1
" let g:airline_extensions = ['branch', 'hunks', 'coc']

let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

" NerdTree

map <leader>nt :NERDTreeToggle<CR>

" make sure not open files and other buffers on NerdTree window.
" If previous buffer was NERDTree, go back to it.
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" | b# | endif

" ale

let g:ale_sign_column_always = 1
highlight clear SignColumn
let g:airline#extensions#ale#enabled = 1

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
      \ 'd' : ['bd'        , 'delete-buffer']   ,
      \ 'f' : ['bfirst'    , 'first-buffer']    ,
      \ 'h' : ['Startify'  , 'home-buffer']     ,
      \ 'l' : ['blast'     , 'last-buffer']     ,
      \ 'n' : ['bnext'     , 'next-buffer']     ,
      \ 'p' : ['bprevious' , 'previous-buffer'] ,
      \ }

" coc group

let g:which_key_map.c = {
      \ 'name' : '+coc',
      \ }

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
