" =================
" ==== GENERAL ====
" =================

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

"=================
"==== PLUGINS ====
"=================

"using vim-plug: https://github.com/junegunn/vim-plug

call plug#begin('~/.config/nvim/plugged')

"git
    Plug 'tpope/vim-fugitive'

"Color scheme
    Plug 'gruvbox-community/gruvbox'

"Telescope
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzy-native.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

"Snippets manager
    Plug 'sirver/ultisnips'

"Icons for some plugins
    Plug 'kyazdani42/nvim-web-devicons'

"LSP, autocompletion and other
    Plug 'mbbill/undotree'
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'quangnguyen30192/cmp-nvim-ultisnips'

"Syntax
    Plug 'tpope/vim-surround'                       "surround with parentheses & co
    Plug 'mechatroner/rainbow_csv'                  "csv color coding
    Plug 'ap/vim-css-color'                         "css colors
    Plug 'frazrepo/vim-rainbow'                     "rainbow parentheses

"Vim Pandoc: conflicts with vim-markdown
    "Plug 'vim-pandoc/vim-pandoc'
    "Plug 'vim-pandoc/vim-pandoc-syntax'
    "Plug 'quarto-dev/quarto-vim'

"Language Support
    Plug 'godlygeek/tabular'                        "needed for vim-markdown
    Plug 'preservim/vim-markdown'                   "support for markdown
    Plug 'cespare/vim-toml', { 'branch': 'main' }   "TOML support
    Plug 'stephpy/vim-yaml'                         "YAML support
    Plug 'elzr/vim-json'                            "better JSON support

"Zig
    Plug 'ziglang/zig.vim'

"Python autoformatter
    Plug 'dense-analysis/ale'

call plug#end()

"=====================
"==== COLORSCHEME ====
"=====================

colorscheme gruvbox

"================
"==== PYTHON ====
"================

"see :help provider-python
let g:python3_host_prog = '/Users/luca/.pyenv/versions/3.9.9/envs/py3nvim/bin/python'   "path for python virtualenv with pynvim installed 
let g:loaded_python_provider = 0                                                        "disable python2    

"====================
"==== LSP CONFIG ====
"====================

lua << EOF
require'lspconfig'.pyright.setup{}
EOF

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
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
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

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
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

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }
EOF

"===================
"==== TELESCOPE ====
"===================

"enable fzy telescope extension
lua << EOF
-- require('telescope').load_extension('fzf')
require('telescope').load_extension('fzy_native')
EOF

"using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

"==========================
"==== SNIPPETS CONFIGS ====
"==========================

"courtesy of https://castel.dev/post/lecture-notes-1/

let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories=[$CONFIG.'/nvim/UltiSnips']       "this is where snippets will be stored

"===================
"==== vim-pandox ===
"===================

let g:pandoc#modules#disabled = ["folding", "spell"]
let g:pandoc#syntax#conceal#use = 0

"=============================
"==== vim markdown config ====
"=============================

set conceallevel=2
let g:vim_markdown_strikethrough = 1            "enable striketrough
let g:vim_markdown_new_list_item_indent = 2     "indent for new list items set to 2 (instead of 4)
let g:vim_markdown_conceal_code_blocks = 0      "do not conceal code blocks' fences

"====================
"==== REMAPPINGS ====
"====================

let mapleader = "\<Space>"

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

"(Shift)Tab (de)indents code
vnoremap <Tab> >
vnoremap <S-Tab> <

"Jump to start and end of line using the home row keys
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
