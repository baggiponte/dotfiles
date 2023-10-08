local safe_require = require('baggiponte.utils').safe_require

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local borders = safe_require('baggiponte.utils.borders')

safe_require('lazy').setup({
  spec = {
    { import = 'baggiponte.plugins' },
    { import = 'baggiponte.plugins.ui' },
    { import = 'baggiponte.plugins.extras' },
  },
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
