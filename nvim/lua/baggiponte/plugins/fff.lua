local keys = {
  {
    '<leader>ff',
    function()
      require('fff').find_files()
    end,
    desc = 'FFF: find files',
  },
  {
    '<leader>fg',
    function()
      require('fff').live_grep()
    end,
    desc = 'FFF: live grep',
  },
  {
    '<leader>fw',
    function()
      require('fff').live_grep({ query = vim.fn.expand('<cword>') })
    end,
    desc = 'FFF: grep current word',
  },
}

local defer = require('baggiponte.defer')

-- Loading fff starts its Rust core and file indexer; do that on first use.
local setup = defer.loader({ 'fff.nvim' }, function()
  require('fff').setup({
    layout = {
      height = 0.9,
      width = 0.9,
    },
    keymaps = {
      select_vsplit = '<C-v>',
      move_up = { '<Up>', '<C-p>', '<C-k>' },
      move_down = { '<Down>', '<C-n>', '<C-j>' },
      preview_scroll_up = '<C-u>',
      preview_scroll_down = '<C-d>',
      send_to_quickfix = '<C-q>',
    },
  })
end)

defer.keys(keys, setup)
-- fff's plugin/ defines the real commands, replacing these stubs
defer.on_cmd({
  'FFFClearCache',
  'FFFDebug',
  'FFFFind',
  'FFFHealth',
  'FFFOpenLog',
  'FFFRefreshGit',
  'FFFResume',
  'FFFScan',
}, setup)
