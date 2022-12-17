local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local extensions = require('telescope').extensions
local telescope = require('telescope')

telescope.setup({
  defaults = {
    sorting_strategy = 'descending',
    initial_mode = 'insert',
    file_ignore_patterns = { '__pycache__/*', 'git/*', '.DS_Store' },
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
    find_files = {
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
    zoxide = {
      mappings = {
        default = {
          after_action = function(selection)
            print('Directory changed to ' .. selection.path)
            builtin.find_files({ path = selection.path })
          end,
        },
      },
    },
  },
})

-- [[ Enable extensions ]]
local exts = { 'fzf', 'file_browser', 'frecency', 'zoxide' }
for _, extension in ipairs(exts) do
  telescope.load_extension(extension)
end

-- [[ Set keymaps ]]
vim.keymap.set(
  'n',
  '<leader>/',
  builtin.current_buffer_fuzzy_find,
  { desc = 'Telescope fuzzy find within the current buffer', silent = true, noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>ff',
  builtin.find_files,
  { desc = 'Telescope [f]ind [f]iles', silent = true, noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>fF',
  builtin.git_files,
  { desc = 'Telescope find within git files', silent = true, noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>fg',
  builtin.live_grep,
  { desc = 'Telescope [f]ind symbol using [g]rep', silent = true, noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>fb',
  builtin.buffers,
  { desc = 'Telescope [f]ind [b]uffer', silent = true, noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>fd',
  extensions.file_browser.file_browser,
  { desc = 'Telescope [f]ind in [d]irectory tree', silent = true, noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>cd',
  extensions.zoxide.list,
  { desc = 'Telescope [c]hange [d]irectory with zoxide', silent = true, noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>fr',
  extensions.frecency.frecency,
  { desc = 'Telescope find files with [fr]ecency', silent = true, noremap = true }
)
vim.keymap.set('n', '<leader>ft', function()
  vim.cmd("TodoTelescope cwd='%:p:h")
end, { desc = 'Telescope [f]ind within [t]odos' })
