local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local borders = require('baggiponte.utils.borders')

require('lazy').setup('baggiponte.plugins', {
  defaults = { lazy = true, version = false },
  install = { colorscheme = { 'gruvbox-material', 'nordic' } },
  ui = { border = borders },
  checker = { enabled = false }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'shada_plugin',
        'tar',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zip',
        'zipPlugin',
      },
    },
  },
})
