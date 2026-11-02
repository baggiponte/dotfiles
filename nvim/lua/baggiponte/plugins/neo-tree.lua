local defer = require('baggiponte.defer')

-- neo-tree's plugin/ defines :Neotree (replacing the stub) and would hijack
-- directory buffers at startup, so it stays unloaded until first use.
local setup = defer.loader({ 'plenary.nvim', 'nvim-web-devicons', 'neo-tree.nvim' }, function()
  local function on_move(data)
    require('neat.rename').on_rename_file(data.source, data.destination)
  end
  local events = require('neo-tree.events')
  require('neo-tree').setup({
    event_handlers = {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
    },
  })
end)

defer.on_keys({
  {
    '<leader>N',
    '<cmd>Neotree toggle<CR>',
    mode = { 'n', 'v' },
    desc = 'NeoTree: Toggle',
  },
}, setup)
defer.on_cmd({ 'Neotree' }, setup)
