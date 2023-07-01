local M = {}

M.mason = {
  dap = {
    'python',
  },
  lsp = {
    'dockerls',
    'jsonls',
    'lua_ls',
    'pyright',
    'ruff_lsp',
    'terraformls',
    'tflint', -- linter terraform, acts as lsp
    'yamlls',
    -- 'arduino_language_server',
    -- 'julials',
  },
  null_ls = {
    'actionlint', -- linter github actions
    'black', -- formatter python
    'isort', -- formatter python
    'jq', -- formatter json
    'jsonlint', -- linter json
    'ruff', -- linter python
    'selene', -- linter lua
    'shellcheck', -- linter shell
    'shfmt', -- formatter shell
    'stylua', -- formatter lua
    'tfsec', -- security terraform
    'yamllint', -- linter yaml
    -- 'yamlfmt', -- formatter yaml, lsp provides formatter capabilites
    -- 'cfn-lint', -- linter cloudformation
    -- 'semgrep',
    -- 'shellharden',
    -- 'vulture',
  },
}

M.servers = {
  cssls = {},
  pyright = {},
  ruff_lsp = {},
  dockerls = {},
  docker_compose_language_service = {},
  terraformls = {},
  tflint = {},
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
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' }, -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        diagnostics = { globals = { 'vim' } }, -- Get the language server to recognize the `vim` global
        telemetry = { enable = false }, -- Do not send telemetry data containing a randomized but unique identifier
        workspace = { checkThirdParty = false },
        format = { enable = false },
      },
    },
  },
  -- julials = {},
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
