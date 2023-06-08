local keys = {
  {
    '<leader>v',
    function()
      vim.cmd([[vsp %:p:h]])
      require('telescope.builtin').find_files({ path = '%:p:h ' })
    end,
    desc = 'Split window vertically and find files',
    silent = true,
    noremap = true,
  },
  {
    '<leader>V',
    function()
      vim.cmd([[sp %:p:h]])
      require('telescope.builtin').find_files({ path = '%:p:h ' })
    end,
    desc = 'Split window horizontally and find files',
    silent = true,
    noremap = true,
  },
  {
    '<leader>/',
    function()
      require('telescope.builtin').current_buffer_fuzzy_find()
    end,
    desc = 'Telescope fuzzy find within the current buffer',
    silent = true,
    noremap = true,
  },
  {
    '<leader>ff',
    function()
      require('telescope.builtin').find_files()
    end,
    desc = 'Telescope [f]ind [f]iles',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fF',
    function()
      require('telescope.builtin').git_files()
    end,
    desc = 'Telescope [f]ind within git [F]iles',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fg',
    function()
      require('telescope.builtin').live_grep()
    end,
    desc = 'Telescope [f]ind symbol using [g]rep',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fb',
    function()
      require('telescope.builtin').buffers()
    end,
    desc = 'Telescope [f]ind [b]uffer',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fd',
    function()
      require('telescope').extensions.file_browser.file_browser()
    end,
    desc = 'Telescope [f]ind in [d]irectory tree',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fr',
    function()
      require('telescope').extensions.frecency.frecency()
    end,
    desc = 'Telescope find files with [fr]ecency',
    silent = true,
    noremap = true,
  },
  {
    '<leader>ft',
    function()
      vim.cmd("TodoTelescope cwd='%:p:h")
    end,
    desc = 'Telescope [f]ind within [t]odos',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fs',
    function()
      require('telescope.builtin').symbols({ sources = { 'nerd' } })
    end,
    desc = 'Telescope [f]ind [s]ymbol',
    silent = true,
    noremap = true,
  },
}

return {
  {
    'nvim-telescope/telescope-file-browser.nvim',
    cmd = 'Telescope file_browser',
    config = function()
      require('telescope').load_extension('file_browser')
    end,
  },
  {
    'nvim-telescope/telescope-frecency.nvim',
    cmd = 'Telescope frecency',
    dependencies = { 'tami5/sqlite.lua' },
    config = function()
      require('telescope').load_extension('frecency')
    end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    config = function()
      require('telescope').load_extension('fzf')
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-telescope/telescope-symbols.nvim',
    },
    keys = keys,
    config = function()
      local actions = require('telescope.actions')

      require('telescope').load_extension('notify')
      require('telescope').setup({
        defaults = {
          sorting_strategy = 'descending',
          initial_mode = 'insert',
          file_ignore_patterns = {
            '__pycache__/*',
            '.git/',
            '.DS_Store',
            '.venv',
            '.*_cache',
            '.cache/',
            '.Rproj.user',
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
  },
}
