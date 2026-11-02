local defer = require('baggiponte.defer')

-- Neogit needs no setup() call (the lazy.nvim spec had neither `opts` nor
-- `config`); its plugin/ defines the commands, replacing the stubs on load.
-- diffview and telescope are its optional integrations.
local setup = defer.loader({ 'plenary.nvim', 'diffview.nvim', 'neogit' }, function()
  require('baggiponte.plugins.telescope').load()
end)

defer.on_cmd({ 'Neogit' }, setup)
defer.on_keys({
  {
    '<leader>g',
    '<cmd>Neogit<CR>',
    mode = { 'n', 'v' },
    desc = 'Neogit: toggle git status window',
  },
  {
    '<leader>gc',
    '<cmd>Neogit commit<CR>',
    mode = { 'n', 'v' },
    desc = 'Neogit: git commit',
  },
}, setup)
