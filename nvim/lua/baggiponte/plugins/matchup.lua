return {
  'andymass/vim-matchup',
  enabled = false,
  init = function()
    vim.g.matchup_matchparen_offscreen = { method = 'popup' }
  end,
}
