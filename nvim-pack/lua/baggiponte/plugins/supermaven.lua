local defer = require('baggiponte.defer')

defer.on_event(
  'InsertEnter',
  defer.loader({ 'supermaven-nvim' }, function()
    require('supermaven-nvim').setup({
      keymaps = {
        accept_suggestion = '<Tab>',
        clear_suggestion = '<C-]>',
      },
    })
  end)
)
