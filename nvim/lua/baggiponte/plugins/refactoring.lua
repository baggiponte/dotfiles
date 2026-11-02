local defer = require('baggiponte.defer')

local keys = {
  { '<leader>rr', defer.call('refactoring', 'select_refactor'), mode = 'v', desc = 'Refactor: select refactor' },
}

-- refactoring's plugin/ defines :Refactor, replacing the stub on load
local setup = defer.loader({ 'plenary.nvim', 'refactoring.nvim' }, function()
  require('refactoring').setup({})
end)

defer.keys(keys, setup)
defer.on_cmd({ 'Refactor' }, setup)
