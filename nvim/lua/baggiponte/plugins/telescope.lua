local keys = {
  {
    '<leader>fb',
    function()
      require('telescope.builtin').buffers()
    end,
    desc = 'Telescope: find buffer',
  },
  {
    '<leader>fd',
    function()
      require('telescope.builtin').diagnostics()
    end,
    desc = 'Telescope: find in workspace diagnostics',
  },
  {
    '<leader>fh',
    function()
      require('telescope.builtin').help_tags()
    end,
    desc = 'Telescope: help tags',
  },
  {
    '<leader>fk',
    function()
      require('telescope.builtin').keymaps()
    end,
    desc = 'Telescope: keymaps',
  },
}

return {
  'nvim-telescope/telescope.nvim',
  cmd = { 'Telescope' },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
  },
  keys = keys,
  config = function()
    local actions = require('telescope.actions')

    require('telescope').load_extension('fzf')

    require('telescope').setup({
      defaults = {
        sorting_strategy = 'descending',
        initial_mode = 'insert',
        file_ignore_patterns = {
          '**/.terraform/*',
          '*.egg-info',
          '.*_cache',
          '.DS_Store',
          '.Rproj.user',
          '.cache/',
          '.git/',
          '.venv',
          '__pycache__/*',
          'renv/*',
        },
        mappings = {
          n = {
            ['v'] = actions.file_vsplit,
          },
          i = {
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-v>'] = actions.file_vsplit,
          },
        },
      },
      pickers = {
        buffers = {
          initial_mode = 'normal',
          mappings = {
            i = {
              ['<C-q>'] = 'delete_buffer',
            },
            n = {
              ['q'] = 'delete_buffer',
            },
          },
        },
      },
    })
  end,
}
