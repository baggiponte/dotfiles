local telescope = require('telescope')
local actions = require('telescope.actions')
local symbols_outline = require('symbols-outline')

telescope.setup({
  defaults = {
    sorting_strategy = 'descending',
    initial_mode = 'normal',
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
  extensions = {
    file_browser = {
      hijack_netrw = true,
      hidden = true,
    },
    zoxide = {
      mappings = {
        default = {
          after_action = function(selection)
            print('Directory changed to ' .. selection.path)
            telescope.extensions.file_browser.file_browser({ path = selection.path })
          end,
        },
      },
    },
  },
})

-- [[ Enable extensions ]]
local extensions = { 'fzf', 'file_browser', 'frecency', 'zoxide' }
for _, extension in ipairs(extensions) do
  telescope.load_extension(extension)
end

-- [[ Set keymaps ]]
local opts = { silent = true, noremap = true }

vim.keymap.set('n', '<leader>fs', symbols_outline.toggle_outline, opts)
vim.keymap.set('n', '<leader>cd', telescope.extensions.zoxide.list, opts)
vim.keymap.set('n', '<leader>fr', telescope.extensions.frecency.frecency, opts)
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, opts)
vim.keymap.set('n', '<leader>dd', require('telescope.builtin').diagnostics, opts)
vim.keymap.set(
  'n',
  '<leader>ff',
  "<cmd>lua require'telescope'.extensions.file_browser.file_browser({ path = '%:p:h', grouped = true })<CR>",
  opts
)
vim.keymap.set(
  'n',
  '<leader>fd',
  "<cmd>lua require'telescope'.extensions.file_browser.file_browser({ path = '%:p:h', grouped = true, respect_gitignore = false })<CR>",
  opts
)
