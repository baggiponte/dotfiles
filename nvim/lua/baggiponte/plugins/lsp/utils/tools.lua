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
  ruff = {
    name = 'ruff',
  },
  basedpyright = {
    name = 'basedpyright',
    config = {
      basedpyright = {
        disableOrganizeImports = true,
      },
    },
  },
  ['yaml-language-server'] = {
    name = 'yamlls',
  },
  ['json-lsp'] = {
    name = 'jsonls',
  },
}

M.all = vim.iter({ M.dap, M.linters, M.formatters, vim.tbl_keys(M.servers) }):flatten():totable()

return M
