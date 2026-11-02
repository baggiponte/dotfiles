local keys = {
  {
    '<leader>rr',
    function()
      require('refactoring').select_refactor()
    end,
    desc = 'Refactor: select refactor',
    mode = 'v',
  },
}

local defer = require('baggiponte.defer')

-- refactoring's plugin/ defines :Refactor, replacing the stub on load
local setup = defer.loader({ 'plenary.nvim', 'refactoring.nvim' }, function()
  require('refactoring').setup({})
end)

defer.keys(keys, setup)
defer.on_cmd({ 'Refactor' }, setup)
