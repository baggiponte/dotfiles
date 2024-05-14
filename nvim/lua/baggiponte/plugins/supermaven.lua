return {
  'supermaven-inc/supermaven-nvim',
  event = { 'InsertEnter', 'CmdlineEnter' },
  opts = {
    keymaps = {
      accept_suggestion = '<Tab>',
      clear_suggestion = '<C-]>',
    },
  },
}
