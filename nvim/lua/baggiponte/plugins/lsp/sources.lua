local M = {}

M.mason = {
  dap = {
    'python',
  },
  lsp = {
    'jsonls',
    'lua_ls',
    'pyright',
    'ruff_lsp',
    'sourcery',
    -- 'arduino_language_server',
    -- 'docker-compose-language-server',
    -- 'dockerfile-language-server',
    -- 'julials',
    -- 'yamlls',
  },
  null_ls = {
    'actionlint',
    'black',
    'isort',
    'jq',
    'ruff',
    'selene',
    'shellcheck',
    'shfmt',
    'stylua',
    'yamlfmt',
    'yamllint',
    -- 'semgrep',
    -- 'shellharden',
    -- 'vulture',
  },
}

M.servers = {
  -- 'docker-compose-language-server',
  -- 'dockerfile-language-server',
  -- 'julials',
  yamlls = {
    settings = {
      yaml = {
        schemas = function()
          require('schemastore').json.schemas()
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
  pyright = {},
  ruff_lsp = {},
  sourcery = {},
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
  r_language_server = {
    filetypes = { 'r', 'rmd', 'quarto' },
  },
  arduino_language_server = {
    cmd = {
      'arduino-language-server',
      '-cli-config',
      vim.fn.expand('$XDG_CONFIG_HOME') .. '/arduino/arduino-cli.yaml',
      '-fqbn',
      'arduino:avr:uno',
      '-cli',
      'arduino-cli',
      '-clangd',
      vim.fn.stdpath('data') .. '/' .. 'mason/bin/clangd',
    },
  },
  clangd = {
    filetypes = { 'arduino', 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
  },
}

return M
