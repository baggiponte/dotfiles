---@alias MasonTool string name of a Mason tool (lsp, formatter, linter, debugger)
---@alias NvimLSPServer string name of a nvim-lspconfig server

---@class MasonServerSpec
---@field name NvimLSPServer
---@field config? table

---@class MasonTools
---@field linters MasonTool[]
---@field formatters MasonTool[]
---@field dap MasonTool[]
---@field servers table<MasonTool, MasonServerSpec>
---@field all MasonTool[]
local M = {}

M.linters = {
  'actionlint',
  'jsonlint',
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
  ['lua-language-server'] = {
    name = 'lua_ls',
    config = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
          hint = { enable = true },
          arrayIndex = 'Disable',
          telemetry = {
            enable = false,
          },
        },
      },
    },
  },
  ['css-lsp'] = {
    name = 'cssls',
  },
  ['dockerfile-language-server'] = {
    name = 'dockerls',
  },
  ['docker-compose-language-service'] = {
    name = 'docker_compose_language_service',
  },
  ['terraform-ls'] = {
    name = 'terraformls',
  },
  tflint = {
    name = 'tflint',
  },
  ruff = {
    name = 'ruff',
  },
  pyright = {
    name = 'pyright',
    config = {
      settings = {
        pyright = {
          -- Using Ruff's import organizer
          disableOrganizeImports = true,
        },
      },
    },
  },
  ['yaml-language-server'] = {
    name = 'yamlls',
  },
  ['json-lsp'] = {
    name = 'jsonls',
  },
  ['bacon-ls'] = {
    name = 'bacon-ls',
  },
  ['azure-pipelines-language-server'] = {
    name = 'azure-pipelines-language-server',
  },
  ['helm-ls'] = {
    name = 'helm-ls',
  },
  -- ignore since using rustaceanvim
  -- ['rust-analyzer'] = {
  --   name = 'rust_analyzer',
  --   config = {
  --     cmd = {
  --       'rustup',
  --       'run',
  --       'stable',
  --       'rust-analyzer',
  --     },
  --   },
  -- },
}

M.all = vim.iter({ M.dap, M.linters, M.formatters, vim.tbl_keys(M.servers) }):flatten():totable()

return M
