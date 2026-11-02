local defer = require('baggiponte.defer')

local keys = {
  { '<leader>fb', defer.call('telescope.builtin', 'buffers'), desc = 'Telescope: find buffer' },
  { '<leader>fd', defer.call('telescope.builtin', 'diagnostics'), desc = 'Telescope: find in workspace diagnostics' },
  { '<leader>fh', defer.call('telescope.builtin', 'help_tags'), desc = 'Telescope: help tags' },
  { '<leader>fk', defer.call('telescope.builtin', 'keymaps'), desc = 'Telescope: keymaps' },
}

-- telescope's plugin/ defines :Telescope, replacing the stub on load
local setup = defer.loader(
  { 'plenary.nvim', 'nvim-web-devicons', 'telescope.nvim', 'telescope-fzf-native.nvim' },
  function()
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
  end
)

defer.on_keys(keys, setup)
defer.on_cmd({ 'Telescope' }, setup)

return { load = setup }
