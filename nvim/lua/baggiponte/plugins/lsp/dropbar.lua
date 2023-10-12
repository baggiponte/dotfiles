return {
  'bekaboo/dropbar.nvim',
  enabled = false, -- requires v0.10
  event = 'LspAttach',
  -- optional, but required for fuzzy finder support
  dependencies = {
    'nvim-telescope/telescope-fzf-native.nvim',
  },
}
