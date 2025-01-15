local linters = {
  'actionlint',
  -- 'selene',
  -- 'shellcheck',
  'yamllint',
}

local formatters = {
  -- 'shfmt',
  'stylua',
}

local debuggers = {
  'debugpy',
}

local servers = {
  'basedpyright',
  'biome',
  'css-lsp',
  'docker-compose-language-service',
  'dockerfile-language-server',
  'lua-language-server',
  'r-languageserver',
  'ruff',
  'yaml-language-server',
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
    -- TODO: autocmd on LSPAttach (or VeryLazy) to install required tools
  end,
}
