return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  dependencies = {
    { 'williamboman/mason.nvim' },
  },
  config = function(opts)
    local lspconfig = require('lspconfig')
    local tools = require('baggiponte.plugins.lsp.utils.tools')
    local configuration = require('baggiponte.plugins.lsp.utils.configuration')

    require('lspconfig.ui.windows').default_options.border = 'rounded'

    vim.diagnostic.config({ virtual_text = { prefix = '' } })

    local capabilities = configuration.extend_client_capabilities_with_cmp(opts)

    local handlers = {
      ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' }),
      ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
    }

    ---@param spec MasonServerSpec
    local setup = function(spec)
      local server = spec['name']

      local defaults = {
        capabilities = vim.deepcopy(capabilities),
        on_attach = configuration.on_attach,
        handlers = handlers,
      }

      local settings = vim.tbl_deep_extend('force', defaults, spec['config'] or {})

      lspconfig[server].setup(settings)
    end

    for _, tool in pairs(tools.servers) do
      setup(tool)
    end
  end,
}
