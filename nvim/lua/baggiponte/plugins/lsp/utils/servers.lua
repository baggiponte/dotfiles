return {
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
        runtime = { version = 'LuaJIT' }, -- Tell the language server which version of Lua you're using
        diagnostics = { globals = { 'vim' } }, -- Get the language server to recognize the `vim` global
        telemetry = { enable = false }, -- Do not send telemetry data containing a randomized but unique identifier
        workspace = { checkThirdParty = false },
        format = { enable = false }, -- formatting is done via selene
        hint = { enable = true },
      },
    },
  },
}
