"==================
"==== SETTINGS ====
"==================

filetype indent plugin on

"==== tabs and indentation ====

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

"==== numbering ====

set number
set relativenumber

"==== searching ====

set nohlsearch          "turns off highlighting after search
set incsearch
set ignorecase          "ignores cases when searching
set smartcase           "turns on case-sensitivity when writing a capital letter

"==== misc ====

set hidden              "for buffers
set noerrorbells

"==== system/OS stuff ====

set noswapfile 
set nobackup
set undodir=$CONFIG/nvim/undodir
set undofile

set clipboard+=unnamedplus

set mouse=a             "mouse in all modes

"==== UI ====

set termguicolors       "256 colors terminal
set cursorline
set signcolumn=yes      "for linting or git

"==== bottom bar ====

set showcmd
set wildmenu
set laststatus=2

"==== UI ====

set showmatch                       "highlight matching parentheses
set lazyredraw                      "prevents redrawing the buffer, e.g. when doing macros

set backspace=indent,eol,start      "backspace like any other editor
set nojoinspaces                    "suppress inserting two spaces between sentences
set linebreak                       "have lines wrap instead of continue off-screen

"====================
"==== REMAPPINGS ====
"====================

let mapleader = "\<space>"

"to save more quickly
nnoremap <leader>w :w<CR>

"to source the file more quickly
nnoremap <leader>s :source %<CR> 

"quit buffer quicker
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>

"as reference: https://www.youtube.com/watch?v=hSHATqh8svM
"have Y behave like every other capital letter
nnoremap Y y$

"jump to start and end of line using the home row keys
map H ^
map L $

"'Q' in normal mode enters Ex mode. You almost never want this.
nmap Q <Nop>

"==========================
"==== WINDOW MOVEMENTS ====
"==========================

"open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

"quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

"=================
"==== PLUGINS ====
"=================

"using vim-plug: https://github.com/junegunn/vim-plug
call plug#begin('~/.config/nvim/plugged')

"git
    Plug 'tpope/vim-fugitive'

"color scheme
    Plug 'gruvbox-community/gruvbox'

"telescope
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzy-native.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

"icons for some plugins
    Plug 'kyazdani42/nvim-web-devicons'

"LSP
    Plug 'neovim/nvim-lspconfig'

"autocompletion
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'

"snippets with UltiSnips
    Plug 'sirver/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'quangnguyen30192/cmp-nvim-ultisnips'

"quarto
    Plug 'quarto-dev/quarto-nvim'
"language Support
    Plug 'cespare/vim-toml', { 'branch': 'main' }   "TOML support
    Plug 'stephpy/vim-yaml'                         "YAML support
    Plug 'elzr/vim-json'                            "JSON support
    Plug 'godlygeek/tabular'                        "for markdown tables
    Plug 'plasticboy/vim-markdown'                  "markdown support
    
"syntax
    Plug 'tpope/vim-surround'                       "surround with parentheses & co
    Plug 'mechatroner/rainbow_csv'                  "csv color coding
    Plug 'ap/vim-css-color'                         "css colors
    Plug 'frazrepo/vim-rainbow'                     "rainbow parentheses

call plug#end()


"=====================
"==== COLORSCHEME ====
"=====================

colorscheme gruvbox

"================
"==== PYTHON ====
"================

" NOTE: g: denotes global variables

"see :help provider-python
let g:python3_host_prog = '/Users/luca/.pyenv/versions/3.9.9/envs/py3nvim/bin/python'   "path for python virtualenv with pynvim installed 
let g:loaded_python_provider = 0                                                        "disable python2    

"========================
"==== AUTOCOMPLETION ====
"========================

set completeopt=menu,menuone,noselect

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  local lspconfig = require('lspconfig')
  lspconfig['pyright'].setup{capabilities = capabilities}
  lspconfig['julials'].setup{capabilities = capabilities}
  lspconfig['dockerls'].setup{capabilities = capabilities}
  lspconfig['r_language_server'].setup{capabilities = capabilities}
EOF

"===================
"==== TELESCOPE ====
"===================

"enable fzy telescope extension
lua << EOF
    -- require('telescope').load_extension('fzf')
    require('telescope').load_extension('fzy_native')
EOF

"use telescope with leader f*
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

"==========================
"==== SNIPPETS CONFIGS ====
"==========================

"references:
"  https://castel.dev/post/lecture-notes-1/
"  https://jdhao.github.io/2019/01/15/markdown_edit_preview_nvim/

let g:UltiSnipsExpandTrigger = '<c-S>'
let g:UltiSnipsJumpForwardTrigger="<c-J>"
let g:UltiSnipsJumpBackwardTrigger="<c-K>"
let g:UltiSnipsSnippetDirectories=[$CONFIG.'/nvim/ultisnips']       "this is where snippets will be stored

"==================
"==== MARKDOWN ====
"==================

let g:vim_markdown_strikethrough = 1            "enable striketrough
let g:vim_markdown_new_list_item_indent = 2     "indent for new list items set to 2 (instead of 4)

" disable header folding
let g:vim_markdown_folding_disabled = 1

" do not use conceal feature, the implementation is not so good
let g:vim_markdown_conceal = 0

"do not conceal code blocks' fences
let g:vim_markdown_conceal_code_blocks = 0

" disable math and tex conceal feature
let g:tex_conceal = ""
let g:vim_markdown_math = 1

" support front matter of various format
let g:vim_markdown_frontmatter = 1  " for YAML format
let g:vim_markdown_toml_frontmatter = 1  " for TOML format
let g:vim_markdown_json_frontmatter = 1  " for JSON format
