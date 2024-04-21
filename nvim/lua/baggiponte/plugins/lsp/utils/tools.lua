local M = {}

M.linters = {
  'actionlint',
  'jsonlint',
  'ruff',
  'selene',
  'shellcheck',
  'tfsec',
  'yamllint',
}

M.formatters = {
  'jq',
  'shfmt',
  'stylua',
}

M.dap = {
  'debugpy',
}

M.servers = {
  cssls = {},
  pyright = {
    settings = {
      pyright = {
        -- Using Ruff's import organizer
        disableOrganizeImports = true,
      },
    },
  },
  ruff = {},
  dockerls = {},
  docker_compose_language_service = {},
  terraformls = {},
  tflint = {},
  lua_ls = {},
  yamlls = {
    settings = {
      yaml = {
        schemaStore = { enable = true },
        format = {
          enable = true,
          singleQuote = false,
          bracketSpacing = false,
        },
      },
    },
  },
  jsonls = {
    settings = {
      json = {
        validate = { enable = true },
      },
    },
  },
  rust_analyzer = {
    cmd = {
      'rustup',
      'run',
      'stable',
      'rust-analyzer',
    },
  },
}

M.tools = vim.tbl_flatten(vim.tbl_deep_extend('force', {}, { M.dap, M.linters, M.formatters, vim.tbl_keys(M.servers) }))

return M
