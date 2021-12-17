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

" Recently vim can merge signcolumn and number column into one
set signcolumn=number

set t_Co=256

set completeopt=menu,menuone,noselect

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
nnoremap Y y$
nnoremap J mzJ`z

" undo break point
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u

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

Plug 'phaazon/hop.nvim'

Plug 'rhysd/clever-f.vim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-frecency.nvim'

Plug 'EdenEast/nightfox.nvim'

" lsp and completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }

Plug 'tami5/sqlite.lua'

call plug#end()

" }}}

" easyalign {{{
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
" }}}

" lua {{{
" TODO put in separate lua files
" telescope {{{
lua << EOF
local actions = require("telescope.actions")

require("telescope").setup({
    defaults = {
		layout_config = {
			horizontal = {
				preview_cutoff = 0,
			},
		},
        mappings = {
            i = {
                ["<esc>"] = actions.close,
                ["<c-j>"] = actions.move_selection_next,
                ["<c-k>"] = actions.move_selection_previous,
				["<C-w>"] = function()
				  vim.cmd [[normal! bcw]]
				end,
            },
        },
    },
})
require('telescope').load_extension('fzf')
require('telescope').load_extension('frecency')
EOF
" }}}

" lsp {{{
lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
  end

  local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
  end

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
      end,
    },
    mapping = {
      -- TODO add snippet

      ['<Tab>'] = function(fallback)
        if not cmp.select_next_item() then
          if vim.bo.buftype ~= 'prompt' and has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end
      end,

      ['<S-Tab>'] = function(fallback)
        if not cmp.select_prev_item() then
          if vim.bo.buftype ~= 'prompt' and has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end
      end,
    },
    sources = cmp.config.sources({
      -- tabnie ignore nvim_lsp
      -- { name = 'nvim_lsp' },
      { name = 'cmp_tabnine' },
    }, {
      { name = 'buffer' },
    }),
    formatting = {
      format = function(entry, vim_item)
          vim_item.kind = nil
        return vim_item
      end
    },
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use buffer source for `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('?', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
EOF
" }}}

" tabnine {{{
lua <<EOF
local tabnine = require('cmp_tabnine.config')
tabnine:setup({
	max_lines = 1000;
	max_num_results = 20;
	sort = true;
	run_on_every_keystroke = true;
	ignored_file_types = { -- default is not to ignore
		-- uncomment to ignore in lua:
		-- lua = true
	};
})
EOF
" }}}

" nvim-treesitter {{{
lua <<EOF
require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
      },
    },
  },
}
EOF
" }}}

" hop {{{
lua <<EOF
require'hop'.setup()
EOF
" }}}

" }}}

" telescope {{{
nnoremap <silent> <space>f <cmd>Telescope find_files<CR>
nnoremap <silent> <space>r <cmd>Telescope live_grep<CR>
nnoremap <silent> <space>b <cmd>Telescope buffers<CR>
nnoremap <silent> <space>; <cmd>Telescope command_history<CR>
nnoremap <silent> <space>/ <cmd>Telescope search_history<CR>
nnoremap <silent> <space>h <cmd>Telescope help_tags<CR>
" mru
nnoremap <silent> <space>m <cmd>Telescope frecency<CR>
" TODO builtin enter normal mode
nnoremap <silent> <space><space> <cmd>Telescope builtin<CR>

" }}}

" nvim-treesitter {{{
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  },
  indent = {
    enable = true
  }
}
EOF

" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
" }}}

" UI {{{
syntax enable

" let g:nord_italic = 1
" let g:nord_italic_comments = 1
" colorscheme nord

" let g:dracula_colorterm = 0
colorscheme nordfox
highlight Comment gui=italic
" }}}

" Languages {{{
" go
" }}}

" hop {{{
nnoremap <silent> s <cmd>HopChar2<CR>
" }}}

" Others {{{
let g:clever_f_smart_case = 1
" }}}
