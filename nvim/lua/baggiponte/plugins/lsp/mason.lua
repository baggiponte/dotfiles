local safe_require = require('baggiponte.utils').safe_require

local borders = safe_require('baggiponte.utils.borders')
local tools = safe_require('baggiponte.plugins.lsp.utils.tools')

return {
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    cmd = { 'Mason', 'MasonUpdate' },
    opts = {
      -- PATH = 'append',
      ui = {
        border = borders,
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
