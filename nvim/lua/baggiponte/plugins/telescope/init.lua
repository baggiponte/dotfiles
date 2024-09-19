local import = require('baggiponte.utils').import

local keys = import('baggiponte.plugins.telescope.keys')

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
    local actions = import('telescope.actions')

    import('telescope').load_extension('fzf')

    import('telescope').setup({
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
            ['<S-k>'] = actions.preview_scrolling_up,
            ['<S-j>'] = actions.preview_scrolling_down,
          },
          i = {
            ['<C-v>'] = actions.file_vsplit,
            ['<S-k>'] = actions.preview_scrolling_up,
            ['<S-j>'] = actions.preview_scrolling_down,
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
