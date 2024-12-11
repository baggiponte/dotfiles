local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = {
    { import = 'baggiponte.plugins' },
    { import = 'baggiponte.plugins.ui' },
    { import = 'baggiponte.plugins.lsp' },
  },
  defaults = { lazy = true, version = false },
  install = { colorscheme = { 'gruvbox-material', 'nordic' } },
  ui = { border = 'rounded' },
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
