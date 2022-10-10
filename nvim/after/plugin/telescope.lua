local telescope = require('telescope')
local filebrowser = telescope.extensions.file_browser
local actions = require('telescope.actions')
local trouble = require('trouble.providers.telescope')
local symbols_outline = require('symbols-outline')

telescope.setup({
  defaults = {
    initial_mode = 'normal',
    file_ignore_patterns = {'__pycache__/*', 'git/*', '.DS_Store' },
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
            filebrowser.file_browser({ path = selection.path })
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

vim.keymap.set('n', '<leader>cd', telescope.extensions.zoxide.list, opts)
vim.keymap.set('n', '<leader>fs', symbols_outline.toggle_outline, opts)
vim.keymap.set('n', '<leader>fr', telescope.extensions.frecency.frecency, opts)
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, opts)
vim.keymap.set('n', '<leader>ff', '<cmd>lua' .. filebrowser.file_browser({ path = '%:p:h' }) .. '<CR>', opts)
vim.keymap.set(
  'n',
  '<leader>fd',
  '<cmd>lua' .. filebrowser.file_browser({ path = '%:p:h', respect_gitignore = false }) .. '<CR>',
  opts
)
