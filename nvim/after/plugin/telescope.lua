local telescope = require('telescope')
local actions = require('telescope.actions')
local trouble = require('trouble.providers.telescope')
local symbols_outline = require('symbols-outline')

telescope.setup({
  defaults = {
    initial_mode = 'normal',
    file_ignore_patterns = { 'node_modules/.*', 'git/*' },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-t>'] = trouble.open_with_trouble,
      },
      n = {
        ['<C-t>'] = trouble.open_with_trouble,
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
            require('telescope').extensions.file_browser.file_browser({ cwd = selection.path })
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

-- explore symbols within the document
vim.keymap.set('n', '<leader>fs', symbols_outline.toggle_outline, opts)

-- explore files
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').git_files, opts)
vim.keymap.set('n', '<leader>fF', require('telescope.builtin').find_files, opts)
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, opts)
vim.keymap.set(
  'n',
  '<leader>fd',
  "<cmd>lua require 'telescope'.extensions.file_browser.file_browser{ path = '%:p:h' }<CR>",
  opts
)
-- fuzzy find and file browser
vim.keymap.set('n', '<leader>fz', require('telescope.builtin').current_buffer_fuzzy_find, opts)
vim.keymap.set('n', '<leader>fZ', require('telescope.builtin').live_grep, opts)
vim.keymap.set('n', '<leader>cd', require('telescope').extensions.zoxide.list, opts)

-- explore directories
vim.keymap.set('n', '<leader>fr', telescope.extensions.frecency.frecency, opts)
