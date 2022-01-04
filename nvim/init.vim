"=================
"==== GENERAL ====
"=================

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

set nohlsearch " turns off highlighting after search
set incsearch
set ignorecase " ignores cases when searching
set smartcase " turns on case-sensitivity when writing a capital letter

"==== misc ====

set hidden " for buffers
set noerrorbells

"==== system/OS stuff ====

set noswapfile 
set nobackup
set undodir=~/.vim/undodir
set undofile

set clipboard+=unnamedplus

set mouse=a " mouse in all modes

"==== UI ====

set termguicolors " 256 colors terminal
set cursorline
set signcolumn=yes " for linting or git

"==== bottom bar ====

set showcmd
set wildmenu
set laststatus=2

"==== UI ====

set showmatch " highlight matching parentheses
set lazyredraw " prevents redrawing the buffer, e.g. when doing macros

set backspace=indent,eol,start " backspace like any other editor
set nojoinspaces " suppress inserting two spaces between sentences
set linebreak           " Have lines wrap instead of continue off-screen

"=================
"==== PLUGINS ====
"=================

call plug#begin('~/.config/nvim/plugged')

" Color scheme
    Plug 'gruvbox-community/gruvbox'

"Telescope
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    "Plug 'nvim-telescope/telescope-fzy-native.nvim'

"Icons for some plugins
    Plug 'kyazdani42/nvim-web-devicons'

"Other tools
    Plug 'mbbill/undotree'
    Plug 'neovim/nvim-lspconfig'

"Syntax
    Plug 'tpope/vim-surround'             " Surround with parentheses & co
    Plug 'mechatroner/rainbow_csv'         " CSV color coding
    Plug 'ap/vim-css-color'                " CSS colors
    Plug 'frazrepo/vim-rainbow'                " Rainbow parentheses
    Plug 'vim-pandoc/vim-pandoc'           " Pandoc support
    Plug 'vim-pandoc/vim-pandoc-syntax'    " Pandoc syntax

"Language Support
    Plug 'godlygeek/tabular'
    Plug 'plasticboy/vim-markdown'         " Markdown support
    Plug 'mzlogin/vim-markdown-toc'        " Markdown TOC builder
    Plug 'cespare/vim-toml'                " TOML support
    Plug 'stephpy/vim-yaml'                " YAML support
    Plug 'elzr/vim-json'                   " Better JSON support

"Python autoformatter
    Plug 'dense-analysis/ale'

call plug#end()

"==== CHANGE COLORSCHEME ====

"let g:gruvbox_contrast_dark = 'hard'

colorscheme gruvbox

"set background=dark 
" for setting a darker background (different than the terminal's default) 

"==== LSP CONFIG ====

lua << EOF
require'lspconfig'.pyright.setup{}
EOF

"====================
"==== REMAPPINGS ====
"====================

let mapleader = "\<Space>"

"n = normal mode, nore = not recursive, map
nnoremap <leader>u :UndoTreeShow<CR>

" to save more quickly
nnoremap <leader>w :w<CR>

" to source the file more quickly
nnoremap <leader>s :source %<CR> 

" quit buffer quicker
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>

" as reference: https://www.youtube.com/watch?v=hSHATqh8svM
" have Y behave like every other capital letter
nnoremap Y y$

" (Shift)Tab (de)indents code
vnoremap <Tab> >
vnoremap <S-Tab> <

" Jump to start and end of line using the home row keys
map H ^
map L $

" 'Q' in normal mode enters Ex mode. You almost never want this.
nmap Q <Nop>

" ----------------------
" Window movements
" ----------------------

" open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
