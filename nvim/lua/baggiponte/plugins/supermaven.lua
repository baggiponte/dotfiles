return {
  'supermaven-inc/supermaven-nvim',
  event = { 'InsertEnter' },
  opts = {
    keymaps = {
      accept_suggestion = '<Tab>',
      clear_suggestion = '<C-]>',
    },
  },
  config = function()
    require('supermaven-nvim').setup({})

    local api = require('supermaven-nvim.api')
    api.use_free_version()
  end,
}
