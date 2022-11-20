local packer = require('packer')

-- function to bootstrap packer
local ensure_packer = function()
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end

  return false
end

-- autocommand to reload nvim and sync plugins when this file is saved
vim.cmd([[
  augroup packer_auto_sync
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | PackerSync
  augroup end
]])

local packer_bootstrap = ensure_packer()

return packer.startup({
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({
          border = { -- default borders are vim.g.border_chars
            { '╭', 'FloatBorder' },
            { '─', 'FloatBorder' },
            { '╮', 'FloatBorder' },
            { '│', 'FloatBorder' },
            { '╯', 'FloatBorder' },
            { '─', 'FloatBorder' },
            { '╰', 'FloatBorder' },
            { '│', 'FloatBorder' },
          },
        })
      end,
    },
  },
  function(use)
    -- [[ general purpose ]]
    -- package management
    use('wbthomason/packer.nvim') -- package manager
    use('lewis6991/impatient.nvim') -- improve startup time

    -- color scheme
    use('sainnhe/gruvbox-material')

    -- tmux integration
    use('christoomey/vim-tmux-navigator')

    -- indentation
    use('lukas-reineke/indent-blankline.nvim')

    -- autopair parentheses
    use({
      'windwp/nvim-autopairs',
      config = function()
        require('nvim-autopairs').setup()
      end,
    })

    -- statusline
    use({
      'nvim-lualine/lualine.nvim',
      config = function()
        require('lualine').setup({ theme = 'gruvbox' })
      end,
    })

    -- multiline cursor
    use('mg979/vim-visual-multi')

    -- terminal inside vim
    use({ 'akinsho/toggleterm.nvim', tag = '*' })

    -- smart close buffer
    use('mhinz/vim-sayonara')

    -- comment and uncomment with gc
    use({
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end,
    })

    -- git integration
    use({ 'tpope/vim-fugitive', { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' } })

    -- renaming (rg + sed)
    use('nvim-pack/nvim-spectre')

    -- find across your todos
    use({
      'folke/todo-comments.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('todo-comments').setup()
      end,
    })

    -- use the UI for messages, cmdline and popupmenu
    use({
      'folke/noice.nvim',
      config = function()
        require('noice').setup()
      end,
      requires = {
        'MunifTanjim/nui.nvim',
        -- 'rcarriga/nvim-notify',
      },
    })

    -- [[ Debug Adapter ]]
    use({
      'mfussenegger/nvim-dap',
      requires = {
        { 'rcarriga/nvim-dap-ui', after = { 'nvim-dap' } },
        { 'mfussenegger/nvim-dap-python', ft = { 'python' } },
      },
    })

    -- [[ Telescope ]]
    use({
      'nvim-telescope/telescope.nvim',
      requires = {
        -- dependencies
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons',
        -- extra plugins
        'nvim-telescope/telescope-file-browser.nvim',
        'jvgrootveld/telescope-zoxide',
        {
          'nvim-telescope/telescope-frecency.nvim',
          requires = { 'tami5/sqlite.lua' },
        },
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
          cond = vim.fn.executable('make') == 1,
        },
      },
    })

    -- [[ Treesitter ]]
    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      requires = {
        'RRethy/nvim-treesitter-endwise', -- automatically add `end` to structs of certain languages
        'danymat/neogen',
        'nvim-treesitter/nvim-treesitter-context',
        'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-treesitter/playground',
        'p00f/nvim-ts-rainbow',
        {
          'kylechui/nvim-surround',
          config = function()
            require('nvim-surround').setup()
          end,
        },
      },
    })

    -- [[ LSP ]]
    use('neovim/nvim-lspconfig')

    -- installer for external tooling e.g. LSP servers, linters, formatters...
    use({ 'williamboman/mason.nvim', requires = { 'williamboman/mason-lspconfig.nvim' } })

    -- better ui
    use({ { 'glepnir/lspsaga.nvim', branch = 'main' }, 'onsails/lspkind.nvim' })

    -- completion sources
    use({
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-emoji',
        'dmitmel/cmp-cmdline-history',
        'saadparwaiz1/cmp_luasnip',
      },
      after = 'nvim-lspconfig',
    })

    -- hook linters, formatters... into lsp keybindings
    use({ 'jose-elias-alvarez/null-ls.nvim', after = 'nvim-cmp', requires = 'nvim-lua/plenary.nvim' })

    -- snippets
    use({
      'L3MON4D3/LuaSnip',
      requires = 'rafamadriz/friendly-snippets',
      after = 'nvim-cmp',
    })

    -- nicer incremental rename
    use({
      'smjonas/inc-rename.nvim',
      config = function()
        require('inc_rename').setup()
      end,
    })

    -- [[ filetype specific plugins ]]
    -- previews for markdown
    use({
      'iamcco/markdown-preview.nvim',
      run = 'cd app && npm install',
      config = function()
        vim.g.mkdp_filetypes = { 'markdown' }
      end,
      ft = { 'markdown' },
    })

    -- r support
    use({
      'jalvesaq/Nvim-R',
      ft = { 'r', 'rmd' },
    })

    -- quarto support
    use({
      {
        'quarto-dev/quarto-vim',
        requires = { 'vim-pandoc/vim-pandoc-syntax', ft = { 'quarto' } },
        after = { 'vim-pandoc-syntax' },
      },
      {
        'quarto-dev/quarto-nvim',
        after = { 'quarto-vim' },
      },
    })

    if packer_bootstrap then
      packer.sync()
    end
  end,
})
