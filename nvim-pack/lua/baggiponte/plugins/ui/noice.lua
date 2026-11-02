local defer = require('baggiponte.defer')

defer.very_lazy(defer.loader({ 'nui.nvim', 'noice.nvim' }, function()
  require('noice').setup({
    cmdline = { enabled = true },
    notify = { enabled = false },
    lsp = {
      enabled = false,
      hover = { enabled = false },
      signature = { enabled = false },
    },
  })
end))
