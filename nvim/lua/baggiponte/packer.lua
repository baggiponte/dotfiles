local packer = require('packer')

local borders = require('baggiponte.utils.borders')

-- autocommand to reload nvim and sync plugins when this file is saved
vim.cmd([[
  augroup packer_auto_sync
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | PackerSync
  augroup end
]])

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

local packer_bootstrap = ensure_packer()

return packer.startup({
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = borders })
      end,
    },
  },

  function(use)
    -- package management
    use('wbthomason/packer.nvim') -- package manager
    use('lewis6991/impatient.nvim') -- improve startup time

    -- tmux integration
    use('christoomey/vim-tmux-navigator')

    -- terminal inside vim
    use({ 'akinsho/toggleterm.nvim', tag = '*' })

    -- git integration
    use({
      'tpope/vim-fugitive',
      -- { 'f-person/git-blame.nvim' },
      { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' },
      { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' },
    })

    use('mbbill/undotree')

    -- color scheme
    use('sainnhe/gruvbox-material')
    -- use('wittyjudge/gruvbox-material.nvim') -- still WIP

    -- highlight HEX colors
    use({
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup()
      end,
    })

    -- editor
    use({
      'echasnovski/mini.comment',
      config = function()
        require('mini.comment').setup({})
      end,
    })

    use({
      'RRethy/vim-illuminate',
      setup = function()
        require('illuminate').configure({ delay = 200 })

        vim.keymap.set('n', ']]', function()
          require('illuminate').goto_next_reference(false)
        end, {
          desc = 'Go to the next reference',
        })

        vim.keymap.set('n', '[[', function()
          require('illuminate').goto_prev_reference(false)
        end, {
          desc = 'Go to the previous reference',
        })
      end,
    })

    use({
      'echasnovski/mini.pairs',
      config = function()
        require('mini.pairs').setup({})
      end,
    })

    use({
      'echasnovski/mini.bufremove',
      config = function()
        require('mini.bufremove').setup({})

        vim.keymap.set('n', 'q', function()
          require('mini.bufremove').delete(0, false)
        end, {
          desc = 'Delete buffer',
        })

        vim.keymap.set('n', 'Q', function()
          require('mini.bufremove').delete(0, true)
        end, {
          desc = 'buffer delete (force)',
        })
      end,
    })

    -- indentation
    use('lukas-reineke/indent-blankline.nvim')

    -- statusline
    use({
      'nvim-lualine/lualine.nvim',
      config = function()
        require('lualine').setup({ theme = 'gruvbox' })
      end,
    })

    -- multiline cursor
    use('mg979/vim-visual-multi')

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

    use({
      'folke/trouble.nvim',
      requires = 'nvim-tree/nvim-web-devicons',
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

    -- [[ Telescope ]]
    use({
      'nvim-telescope/telescope.nvim',
      requires = {
        -- dependencies
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        -- extra plugins
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
        'RRethy/nvim-treesitter-endwise', -- automatically add `end` to structs of certain languages
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

    -- [[ LSP & Tooling ]]

    -- installer for external tooling e.g. LSP servers, linters, formatters, debuggers...
    use({
      'williamboman/mason.nvim',
      requires = {
        'williamboman/mason-lspconfig.nvim',
        'jayp0521/mason-nvim-dap.nvim',
        'jayp0521/mason-null-ls.nvim',
      },
    })

    -- LSP
    use({
      'neovim/nvim-lspconfig',
      {
        'simrat39/symbols-outline.nvim',
        requires = 'neovim/nvim-lspconfig',
        config = function()
          require('symbols-outline').setup()
        end,
      },
      {
        'SmiteshP/nvim-navic',
        requires = 'neovim/nvim-lspconfig',
      },
    })

    -- better ui
    use({ { 'glepnir/lspsaga.nvim', branch = 'version_2.2' }, 'onsails/lspkind.nvim' })

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

    -- hook linters, formatters... into lsp keybindings
    use({ 'jose-elias-alvarez/null-ls.nvim', after = 'nvim-cmp', requires = 'nvim-lua/plenary.nvim' })

    -- debug adapter
    use({
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
      'mfussenegger/nvim-dap-python',
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

    -- -- quarto support
    -- use({
    --   {
    --     'quarto-dev/quarto-vim',
    --     requires = { 'vim-pandoc/vim-pandoc-syntax', ft = { 'quarto' } },
    --     after = { 'vim-pandoc-syntax' },
    --   },
    --   {
    --     'quarto-dev/quarto-nvim',
    --     after = { 'quarto-vim' },
    --   },
    -- })

    if packer_bootstrap then
      packer.sync()
    end
  end,
})
