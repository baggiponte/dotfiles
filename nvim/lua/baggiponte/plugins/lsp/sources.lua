local M = {}

M.mason = {
  dap = {
    'python',
  },
  lsp = {
    'docker-compose-language-server',
    'dockerfile-language-server',
    'jsonls',
    'lua_ls',
    'pyright',
    'ruff_lsp',
    -- 'arduino_language_server',
    -- 'julials',
    -- 'sourcery',
    -- 'yamlls',
  },
  null_ls = {
    'actionlint', -- linter github actions
    'black', -- formatter python
    'cfn-lint', -- linter cloudformation
    'isort', -- formatter python
    'jq', -- formatter json
    'jsonlint', -- linter json
    'ruff', -- linter python
    'selene', -- linter lua
    'shellcheck', -- linter shell
    'shfmt', -- formatter shell
    'stylua', -- formatter lua
    'yamlfmt', -- formatter yaml
    'yamllint', -- linter yaml
    -- 'semgrep',
    -- 'shellharden',
    -- 'vulture',
  },
}

M.servers = {
  pyright = {},
  ruff_lsp = {},
  docker_compose_language_service = {},
  dockerls = {},
  yamlls = {
    settings = {
      yaml = {
        schemas = function()
          require('schemastore').yaml.schemas()
        end,
        validate = { enable = true },
      },
    },
  },
  jsonls = {
    settings = {
      json = {
        schemas = function()
          require('schemastore').json.schemas()
        end,
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
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' }, -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        diagnostics = { globals = { 'vim' } }, -- Get the language server to recognize the `vim` global
        workspace = { checkThirdParty = false },
        telemetry = { enable = false }, -- Do not send telemetry data containing a randomized but unique identifier
      },
    },
  },
  -- 'julials' = {},
  -- sourcery = {},
  -- r_language_server = {
  --   filetypes = { 'r', 'rmd', 'quarto' },
  -- },
  -- arduino_language_server = {
  --   cmd = {
  --     'arduino-language-server',
  --     '-cli-config',
  --     vim.fn.expand('$XDG_CONFIG_HOME') .. '/arduino/arduino-cli.yaml',
  --     '-fqbn',
  --     'arduino:avr:uno',
  --     '-cli',
  --     'arduino-cli',
  --     '-clangd',
  --     vim.fn.stdpath('data') .. '/' .. 'mason/bin/clangd',
  --   },
  -- },
  -- clangd = {
  --   filetypes = { 'arduino', 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
  -- },
}

return M
