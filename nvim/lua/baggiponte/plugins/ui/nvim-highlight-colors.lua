local defer = require('baggiponte.defer')

-- :HighlightColors is created when the module is first required
defer.on_cmd(
  { 'HighlightColors' },
  defer.loader({ 'nvim-highlight-colors' }, function()
    require('nvim-highlight-colors').setup({
      ---@usage 'background'|'foreground'|'virtual'
      render = 'virtual',
      virtual_symbol = '●',
    })
  end)
)
