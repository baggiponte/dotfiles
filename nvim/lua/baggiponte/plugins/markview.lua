local keys = {
  {
    '<leader>mm',
    '<cmd>Markview<cr>',
    desc = 'Markview: toggle markview',
  },
}
local defer = require('baggiponte.defer')

local setup = defer.loader({ 'markview.nvim' }, function()
  require('markview').setup({
    preview = {
      enable = false,
    },
  })
end)

defer.keys(keys, setup)
defer.on_ft({ 'markdown', 'rmd', 'quarto', 'mdx', 'pandoc' }, setup)
