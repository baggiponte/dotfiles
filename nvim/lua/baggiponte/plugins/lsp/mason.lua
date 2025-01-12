local linters = {
  'actionlint',
  'jsonlint',
  'selene',
  'shellcheck',
  'yamllint',
}

local formatters = {
  'shfmt',
  'stylua',
}

local debuggers = {
  'debugpy',
}

local servers = {
  'lua-language-server',
  'css-lsp',
  'dockerfile-language-server',
  'docker-compose-language-service',
  'yaml-language-server',
  'r-languageserver',
  'biome',
  'ruff',
  'basedpyright',
}

return {
  'williamboman/mason.nvim',
  build = ':MasonUpdate',
  cmd = {
    'Mason',
    'MasonInstall',
    'MasonUninstall',
    'MasonUninstallAll',
    'MasonUpdate',
  },
  opts = {
    plugin = {
      ui = {
        border = 'rounded',
        icons = { package_installed = '✓', package_uninstalled = '✗', package_pending = '⟳' },
      },
    },
    tools = {
      linters = linters,
      formatters = formatters,
      debuggers = debuggers,
      servers = servers,
    },
  },
  config = function(_, opts)
    require('mason').setup(opts.plugin)

    -- perhaps this is a chicken and egg problem
    -- the lsp might not attach if you don't have the server installed
    --
    -- the for loop + check adds ~10ms to startup time, so it might
    -- make sense to disable it until an lsp is actually attached
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function()
        local tools = vim.iter({ opts.debuggers, opts.linters, opts.formatters, opts.servers }):flatten():totable()
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
