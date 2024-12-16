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

    -- perhaps this is a chicken and egg problem
    -- the lsp might not attach if you don't have the server installed
    --
    -- the for loop + check adds ~10ms to startup time, so it might
    -- make sense to disable it until an lsp is actually attached
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function()
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
    })
  end,
}
