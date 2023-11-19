local import = require('baggiponte.utils').import

local tools = import('baggiponte.plugins.lsp.utils.tools')

return {
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    cmd = { 'Mason', 'MasonUpdate' },
    opts = {
      -- PATH = 'append',
      ui = {
        border = 'rounded',
        icons = { package_installed = '✓', package_uninstalled = '✗', package_pending = '⟳' },
      },
    },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    cmd = { 'MasonToolsInstall', 'MasonToolsUpdate', 'MasonToolsClean' },
    opts = { ensure_installed = tools },
  },
}
