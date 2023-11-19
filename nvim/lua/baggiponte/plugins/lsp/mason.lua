local tools = require('baggiponte.plugins.lsp.utils.tools').tools

return {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  cmd = { 'MasonToolsInstall', 'MasonToolsUpdate', 'MasonToolsClean' },
  opts = { ensure_installed = tools },
  dependencies = {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    cmd = { 'Mason', 'MasonUpdate' },
    opts = {
      ui = {
        border = 'rounded',
        icons = { package_installed = '✓', package_uninstalled = '✗', package_pending = '⟳' },
      },
    },
  },
}
