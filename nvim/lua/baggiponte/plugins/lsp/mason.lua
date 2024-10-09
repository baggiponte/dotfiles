return {
  'williamboman/mason.nvim',
  build = ':MasonUpdate',
  dependencies = { 'Zeioth/mason-extra-cmds', opts = {} },
  cmd = {
    'Mason',
    'MasonInstall',
    'MasonUninstall',
    'MasonUninstallAll',
    'MasonUpdate',
    'MasonUpdateAll',
  },
  opts = {
    ui = {
      border = 'rounded',
      icons = { package_installed = '✓', package_uninstalled = '✗', package_pending = '⟳' },
    },
  },
  config = function(_, opts)
    require('mason').setup(opts)

    local tools = require('baggiponte.plugins.lsp.utils.tools')
    local registry = require('mason-registry')

    registry.refresh(function()
      vim.iter(tools.all):map(function(tool)
        local pkg = registry.get_package(tool)
        if not pkg:is_installed() then
          pkg:install()
        end
      end)
    end)
  end,
}
