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
    Plug 'tpope/vim-markdown'
    Plug 'ap/vim-css-color'
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

let mapleader = " "

" remaps ';' to ':' to write commands faster
nnoremap ; :
"n = normal mode, nore = not recursive, map
nnoremap <leader>u :UndoTreeShow<CR>
" to save more quickly
nnoremap <leader>w :w<CR>
nnoremap <leader>W :wq<CR>
" to source the file more quickly
nnoremap <leader>s :so %<CR> 
" quit buffer quicker
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>
" as reference: https://www.youtube.com/watch?v=hSHATqh8svM
" have Y behave like every other capital letter
nnoremap Y y$
