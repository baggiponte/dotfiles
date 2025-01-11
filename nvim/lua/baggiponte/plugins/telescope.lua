local keys = {
  {
    '<leader>ff',
    function()
      require('telescope.builtin').find_files()
    end,
    desc = 'Telescope find files',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fg',
    function()
      require('telescope.builtin').live_grep()
    end,
    desc = 'Telescope find symbol using grep',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fb',
    function()
      require('telescope.builtin').buffers()
    end,
    desc = 'Telescope find buffer',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fd',
    function()
      require('telescope.builtin').diagnostics()
    end,
    desc = 'Telescope find in workspace diagnostics',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fh',
    function()
      require('telescope.builtin').help_tags()
    end,
    desc = 'Telescope help tags',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fw',
    function()
      require('telescope.builtin').grep_string()
    end,
    desc = 'Telescope grep string',
    silent = true,
    noremap = true,
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
        diagnostics = {
          initial_mode = 'normal',
        },
        live_grep = {
          additional_args = { '--hidden' },
        },
        find_files = {
          find_command = { 'rg', '--files', '--color', 'never', '--follow' },
          initial_mode = 'insert',
          hidden = true,
          no_ignore = false,
        },
      },
      extensions = {
        file_browser = {
          initial_mode = 'normal',
          hijack_netrw = true,
          hidden = true,
          grouped = true,
          path = '%:p:h',
          cwd = '%:p:h',
          respect_gitignore = false,
        },
      },
    })
  end,
}
