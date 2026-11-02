local defer = require('baggiponte.defer')

local keys = {
  { '<leader>ff', defer.call('fff', 'find_files'), desc = 'FFF: find files' },
  { '<leader>fg', defer.call('fff', 'live_grep'), desc = 'FFF: live grep' },
  {
    '<leader>fw',
    function()
      require('fff').live_grep({ query = vim.fn.expand('<cword>') })
    end,
    desc = 'FFF: grep current word',
  },
}

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

defer.on_keys(keys, setup)
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
