-- ref: https://github.com/benlubas/.dotfiles/blob/main/nvim/lua/plugins/quarto.lua
return {
  'GCBallesteros/jupytext.nvim',
  lazy = false,
  opts = {
    style = 'markdown',
    output_extension = 'md',
    force_ft = 'markdown',
  },
}
