local packer = require('packer')

local configure = function(plugin, opts)
  require(plugin).setup(opts)
end

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
    -- [[ generics ]]
    use('wbthomason/packer.nvim') -- Package manager
    use('lewis6991/impatient.nvim') -- Improve startup time
    use('lukas-reineke/indent-blankline.nvim') -- Indentation
    use('mg979/vim-visual-multi') -- Multiline cursor
    use('mhinz/vim-sayonara')
    use('sainnhe/gruvbox-material') -- Colorscheme
    use({ 'akinsho/toggleterm.nvim', tag = '*' }) -- Terminal inside vim
    use({ 'numToStr/Comment.nvim', config = configure('Comment') }) -- Comments
    use({ 'nvim-lualine/lualine.nvim', config = configure('lualine', { theme = 'gruvbox' }) }) -- Statusline
    use({ 'tpope/vim-fugitive', { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' } }) -- git
    use({ 'windwp/nvim-autopairs', config = configure('nvim-autopairs') }) -- Autopair parentheses
    -- Lua
    use({
      'folke/todo-comments.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = configure('todo-comments'),
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
        { 'kylechui/nvim-surround', config = configure('nvim-surround') },
      },
    })

    -- [[ LSP ]]
    use('neovim/nvim-lspconfig')
    use({ 'williamboman/mason.nvim', requires = { 'williamboman/mason-lspconfig.nvim' } }) -- Installer for external tooling e.g. LSP servers, linters, formatters...

    use({
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-path',
        'onsails/lspkind.nvim',
      },
      after = 'nvim-lspconfig',
    })

    -- hook linters, formatters... into lsp keybindings
    use({ 'jose-elias-alvarez/null-ls.nvim', after = 'nvim-cmp', requires = 'nvim-lua/plenary.nvim' })

    -- snippets
    use({
      'L3MON4D3/LuaSnip',
      requires = { 'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets' },
      after = 'nvim-cmp',
    })

    -- [[ filetype-dependent plugins ]]
    use({
      'iamcco/markdown-preview.nvim',
      run = 'cd app && npm install',
      setup = function()
        vim.g.mkdp_filetypes = { 'markdown' }
      end,
      ft = { 'markdown' },
    })

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
