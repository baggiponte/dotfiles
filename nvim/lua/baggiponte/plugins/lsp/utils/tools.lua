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
      settings = {
        basedpyright = {
          disableOrganizeImports = true,
          analysis = {
            diagnosticMode = 'workspace',
          },
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
  ['r-languageserver'] = {
    name = 'r_language_server',
  },
}

M.all = vim.iter({ M.dap, M.linters, M.formatters, vim.tbl_keys(M.servers) }):flatten():totable()

return M
