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
    'jayp0521/mason-nvim-dap.nvim',
    cmd = { 'Mason', 'DapInstall', 'DapUninstall' },
    opts = { ensure_installed = mason.dap },
  },
  {
    'jayp0521/mason-null-ls.nvim',
    cmd = { 'Mason', 'NullLsInstall', 'NullLsUninstall' },
    opts = { ensure_installed = mason.null_ls },
  },
}
