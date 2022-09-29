local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- [[ Package management ]]
  use('wbthomason/packer.nvim') -- Package manager
  use('lewis6991/impatient.nvim') -- Improve startup time

  -- [[ Colorscheme ]]
  use('sainnhe/gruvbox-material') -- Colorscheme

  -- [[ Dependencies ]]
  use('nvim-lua/popup.nvim')
  use('nvim-lua/plenary.nvim')
  use('kyazdani42/nvim-web-devicons')

  -- [[ Git ]]
  use('tpope/vim-fugitive') -- git
  use('lewis6991/gitsigns.nvim') -- git marks to denote added/changed/deleted line
  use('kdheepak/lazygit.nvim') -- Open a floating panel with lazygit

  -- [[ Indentation ]]
  use('tpope/vim-sleuth') -- Better auto indentation
  use('lukas-reineke/indent-blankline.nvim') -- Highlight indentation

  -- [[ Bracket pairing ]]
  use({
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({})
    end,
  })

  -- [[ Comments ]]
  use({
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({})
    end,
  })

  -- [[ Statusline ]]
  use({
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup({ theme = 'gruvbox' })
    end,
  })

  -- [[ Terminal ]]
  use({ 'akinsho/toggleterm.nvim', tag = '*' })

  -- [[ Telescope ]]
  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
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
      'nvim-treesitter/nvim-treesitter-context',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'p00f/nvim-ts-rainbow',
      {
        'kylechui/nvim-surround',
        config = function()
          require('nvim-surround').setup({})
        end,
      },
    },
  })

  -- [[ LSP ]]
  use('neovim/nvim-lspconfig') -- Collection of configurations for built-in LSP client

  -- Installer for external tooling e.g. LSP servers, linters, formatters...
  use({
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  })

  -- Completion sources
  use({
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
  })

  -- hook linters, formatters... into lsp keybindings
  use('jose-elias-alvarez/null-ls.nvim')

  -- A tree like view for symbols in Neovim using the Language Server Protocol.
  use({
    'simrat39/symbols-outline.nvim',
    config = function()
      require('symbols-outline').setup({})
    end,
  })

  -- adds vscode-like pictograms
  use('onsails/lspkind.nvim')

  -- [[ Diagnostics ]]
  use({
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('trouble').setup({})
    end,
  })
  -- [[ Snippets ]]
  use({ 'L3MON4D3/LuaSnip', requires = { 'saadparwaiz1/cmp_luasnip' } }) -- Snippet Engine and Snippet Expansion
  use('rafamadriz/friendly-snippets') -- Crowdsourced snippets

  -- [[ Others ]]
  use({
    'quarto-dev/quarto-vim', -- Quarto syntax highting
    requires = { { 'vim-pandoc/vim-pandoc-syntax' } },
    ft = { 'quarto' },
  })
  use('quarto-dev/quarto-nvim') -- Quarto support

  if packer_bootstrap then
    require('packer').sync()
  end
end)
