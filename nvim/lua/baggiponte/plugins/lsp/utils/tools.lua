---@alias MasonTool string name of a Mason tool (lsp, formatter, linter, debugger)
---@alias NvimLSPServer string name of a nvim-lspconfig server

---@class MasonServer
---@field name NvimLSPServer
---@field config? table

---@class MasonTools
---@field linters MasonTool[]
---@field formatters MasonTool[]
---@field dap MasonTool[]
---@field servers table<MasonTool, MasonServer>
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
    config = {
      settings = {
        yaml = {
          schemaStore = {
            -- You must disable built-in schemaStore support if you want to use
            -- schemastore.nvim and its advanced options like `ignore`.
            enable = false,
            -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
            url = '',
          },
          schemas = function()
            return require('schemastore').yaml.schemas()
          end,
        },
      },
    },
  },
  ['json-lsp'] = {
    name = 'jsonls',
    config = {
      settings = {
        json = {
          schemas = function()
            return require('schemastore').json.schemas()
          end,
          validate = { enable = true },
        },
      },
    },
  },
  ['rust-analyzer'] = {
    name = 'rust_analyzer',
    config = {
      cmd = {
        'rustup',
        'run',
        'stable',
        'rust-analyzer',
      },
    },
  },
}

M.all = vim.iter({ M.dap, M.linters, M.formatters, vim.tbl_keys(M.servers) }):flatten():totable()

return M
