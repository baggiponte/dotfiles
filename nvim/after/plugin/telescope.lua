local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    initial_mode = 'normal',
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
          ['<C-d>'] = 'delete_buffer',
        },
        n = {
          ['d'] = 'delete_buffer',
        },
      },
    },
  },
  extensions = {
    file_browser = {
      hijack_netrw = true,
      hidden = true,
    },
  },
})

-- [[ Enable extensions ]]
local extensions = { 'fzf', 'file_browser', 'frecency' }
for _, extension in ipairs(extensions) do
  telescope.load_extension(extension)
end

-- [[ Set keymaps ]]
local opts = { silent = true, noremap = true }

-- explore symbols within the document
vim.keymap.set('n', '<leader>fH', require('telescope.builtin').help_tags, opts)
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').treesitter, opts)

-- explore files
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').git_files, opts)
vim.keymap.set('n', '<leader>fF', require('telescope.builtin').find_files, opts)
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, opts)

-- fuzzy find and file browser
vim.keymap.set('n', '<leader>fz', require('telescope.builtin').current_buffer_fuzzy_find, opts)
vim.keymap.set('n', '<leader>fZ', require('telescope.builtin').live_grep, opts)
vim.keymap.set('n', '<leader>fd', telescope.extensions.file_browser.file_browser, opts)
vim.keymap.set(
  'n',
  '<leader>fD',
  "<cmd>lua require 'telescope'.extensions.file_browser.file_browser{ path = '%:p:h' }<CR>",
  opts
) -- open in current buffer directory
vim.keymap.set('n', '<leader>fr', telescope.extensions.frecency.frecency, opts)
