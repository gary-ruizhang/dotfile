" vim:fdm=marker
" don't put anything in here that you don't understand

" basic settings {{{
set nocompatible

filetype plugin indent on
set autoread
set autoindent
set smartindent
set expandtab
set smarttab
set tabstop=4
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
set wildmenu
set wildmode=full
set nrformats=
" set Vim-specific sequences for RGB colors | enable true colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
set cursorline
set ruler
set scrolloff=8
set laststatus=0
set viminfo='100,<1000,s100,h
" maximum lines of items show in popup window
set pumheight=20
set autochdir
set tags=./tags,tags;$HOME
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" Recently vim can merge signcolumn and number column into one
set signcolumn=number

set t_Co=256

if exists('$TMUX')
    " vim cursor shape with tmux
    " back to normal mode will have delay on show not operation
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    " vim cursor shape without tmux
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_SR = "\<Esc>]50;CursorShape=2\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" }}}

" auto function {{{

" strip trailing whitespace and not jump the cursor on save
" TODO: this will remove some random lines and add again, git will see the diff
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

" }}}

" key mappings {{{
" leader key mappings
let mapleader = " "

nnoremap <silent> <C-l> :<C-u>nohl<CR><C-l>

" key mappings
nnoremap <silent> g; g;zz
nnoremap <silent> g, g,zz
nnoremap ' `
nnoremap ` '
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap ; :
vnoremap ; :
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz

" Allow saving of files as sudo when I forgot to start vim using sudo.
" TODO: not worked
" cmap w!! w !sudo tee > /dev/null %

" TODO: add check only work for single char 'f'
" cnoremap f<enter> echo expand('%:p')<enter>

" }}}

" Plugins {{{
call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align'

Plug 'tpope/vim-surround'

Plug 'tpope/vim-commentary'

Plug 'easymotion/vim-easymotion'

Plug 'junegunn/fzf', {'dir': '~/.fzf','do': './install --all'}

Plug 'junegunn/fzf.vim' " needed for previews

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'antoinemadec/coc-fzf'

" TODO fzf.vim and fzf-lua is duplicate but not conflicts, compare and remove one in the future
Plug 'ibhagwan/fzf-lua'
Plug 'vijaymarupudi/nvim-fzf'

Plug 'mrjones2014/dash.nvim', { 'do': 'make install' }

Plug '~/.vim/plugged/dracula-pro'

call plug#end()

" }}}

" easymotion {{{
let g:EasyMotion_do_mapping = 0 " Disable default mappings

nmap s <Plug>(easymotion-s2)
nmap t <Plug>(easymotion-t2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

" map  / <Plug>(easymotion-sn)
" omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
" map  n <Plug>(easymotion-next)
" map  N <Plug>(easymotion-prev)

" }}}

" easyalign {{{
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
" }}}

" lua {{{
" TODO put in separate lua files
lua << EOF
-- require'lspconfig'.clangd.setup{}
-- require'lspconfig'.gopls.setup{}
EOF

" }}}

" coc.nvim {{{
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" <C-f> complete snippets, tabnine suggestion is considered snippets.
inoremap <silent><expr> <C-f> pumvisible() ? coc#_select_confirm() :
                                           \"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `gp` and `gn` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> gp <Plug>(coc-diagnostic-prev)
nmap <silent> gn <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Add missing imports on save
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

" }}}

" fzf {{{
nnoremap <silent> <space>f :<C-u>Files<CR>
nnoremap <silent> <space>gf :<C-u>GFiles<CR>
nnoremap <silent> <space>gs :<C-u>GFiles?<CR>
nnoremap <silent> <space>r :<C-u>Rg<CR>
nnoremap <silent> <space>b :<C-u>Buffers<CR>
nnoremap <silent> <space>l :<C-u>Lines<CR>
nnoremap <silent> <space>t :<C-u>Tags<CR>
nnoremap <silent> <space>m :<C-u>Marks<CR>
nnoremap <silent> <space>w :<C-u>Windows<CR>
nnoremap <silent> <space>; :<C-u>History:<CR>
nnoremap <silent> <space>/ :<C-u>History/<CR>
nnoremap <silent> <space>c :<C-u>Commands<CR>
nnoremap <silent> <space>h :<C-u>Helptags<CR>
" file extension
nnoremap <silent> <space>e :<C-u>Filetypes<CR>
" coc-fzf
nnoremap <silent> <space><space> :<C-u>CocFzfList<CR>
nnoremap <silent> <space>d :<C-u>FzfLua dash<CR>

" adjust window size
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
" }}}

" UI {{{
syntax enable

" let g:nord_italic = 1
" let g:nord_italic_comments = 1
" colorscheme nord

" let g:dracula_colorterm = 0
colorscheme dracula_pro
" }}}
