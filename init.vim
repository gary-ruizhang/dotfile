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
" TODO migrate to packer.nvim and move to plugins.lua file
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
Plug 'AckslD/nvim-neoclip.lua'

Plug 'EdenEast/nightfox.nvim'

" lsp and completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'windwp/nvim-autopairs'

" TODO learn org mode in the future
" Plug 'nvim-orgmode/orgmode'

Plug 'tami5/sqlite.lua'

call plug#end()

" }}}

" easyalign {{{
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
" }}}

" lua {{{
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
            n = {
                ["q"] = actions.close,
            },
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

" completion {{{
lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
  end

  cmp.setup({
    -- gopls preselect for no fucking reasons
    preselect = cmp.PreselectMode.None,
    snippet = {
      -- We recommend using *actual* snippet engine.
      -- It's a simple implementation so it might not work in some of the cases.
      expand = function(args)
        local line_num, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line_text = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, true)[1]
        local indent = string.match(line_text, '^%s*')
        local replace = vim.split(args.body, '\n', true)
        local surround = string.match(line_text, '%S.*') or ''
        local surround_end = surround:sub(col)

        replace[1] = surround:sub(0, col - 1)..replace[1]
        replace[#replace] = replace[#replace]..(#surround_end > 1 and ' ' or '')..surround_end
        if indent ~= '' then
          for i, line in ipairs(replace) do
            replace[i] = indent..line
          end
        end

        vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, replace)
        -- just use for one line snippet, put position at the end
        vim.api.nvim_win_set_cursor(0, {line_num, col + #replace[1]})
      end,
    },
    mapping = {
      ['<C-f>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
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
      { name = 'nvim_lsp' },
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
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  },
  indent = {
    enable = true
  },
}
EOF
" }}}

" hop {{{
lua <<EOF
require'hop'.setup()
EOF
" }}}

" lspconfig {{{
lua <<EOF
  -- Setup lspconfig.
  local nvim_lsp = require('lspconfig')
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', 'gn', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

    -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    -- buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    -- buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  end

  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  local servers = { 'clangd', 'gopls' }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      }
    }
  end

  -- yaml
  require('lspconfig').yamlls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      yaml = {
          schemas = { kubernetes = "/*.yaml" },
      },
    }
  }
EOF
" }}}

" autopair {{{
lua <<EOF
  require('nvim-autopairs').setup({
    disable_filetype = { "TelescopePrompt" , "vim" },
    -- check treesitter
    check_ts = true,
  })
  -- If you want insert `(` after select function or method item
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  local cmp = require('cmp')
  cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
EOF
" }}}

" neoclip {{{
lua <<EOF
  require('neoclip').setup({
    enable_persistant_history = true,
    history = 1000,
    keys = {
        telescope = {
            i = {
                -- TODO: 影响telescope默认键
                paste = '<cr>',
                paste_behind = '<c-t>',
            }
        }
    }
  })
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
" vim register clipboard
nnoremap <silent> <space>c <cmd>lua require('telescope').extensions.neoclip.default()<CR>
" mru
nnoremap <silent> <space>m <cmd>Telescope frecency<CR>
" TODO builtin enter normal mode K-M map <shift> to <space>
nnoremap <silent> <space><space> <cmd>Telescope builtin<CR>

" }}}

" nvim-treesitter {{{
" TODO fold make code hard to view
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
" }}}

" UI {{{
" let g:nord_italic = 1
" let g:nord_italic_comments = 1
" colorscheme nord

" let g:dracula_colorterm = 0
colorscheme nordfox
highlight Comment gui=italic
" }}}

" Languages {{{
" go {{{
lua <<EOF
  function goimports(timeout_ms)
    local context = { only = { "source.organizeImports" } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result or next(result) == nil then return end
    local actions = result[1].result
    if not actions then return end
    local action = actions[1]

    -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
    -- is a CodeAction, it can have either an edit, a command or both. Edits
    -- should be executed first.
    if action.edit or type(action.command) == "table" then
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit)
      end
      if type(action.command) == "table" then
        vim.lsp.buf.execute_command(action.command)
      end
    else
      vim.lsp.buf.execute_command(action)
    end
  end
EOF
autocmd BufWritePre *.go lua goimports(1000)
" }}}
" }}}

" hop {{{
nnoremap <silent> s <cmd>HopChar2<CR>
" }}}

" Others {{{
let g:clever_f_smart_case = 1
" }}}
