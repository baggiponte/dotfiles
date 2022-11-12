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
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
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
local opts = { silent = true, noremap = true }

vim.keymap.set('n', '//', builtin.current_buffer_fuzzy_find, opts)
vim.keymap.set('n', '<leader>ff', builtin.find_files, opts)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, opts)
vim.keymap.set('n', '<leader>fb', builtin.buffers, opts)
vim.keymap.set('n', '<leader>dd', builtin.diagnostics, opts)
vim.keymap.set('n', '<leader>fd', extensions.file_browser.file_browser, opts)
vim.keymap.set('n', '<leader>cd', extensions.zoxide.list, opts)
vim.keymap.set('n', '<leader>fr', extensions.frecency.frecency, opts)
vim.keymap.set('n', '<leader>fz', function()
  vim.cmd("TodoTelescope cwd='%:p:h")
end)
