return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  dependencies = {
    { 'folke/neodev.nvim', opts = {}, ft = { 'lua' } },
    { 'williamboman/mason.nvim' },
    { 'b0o/schemastore.nvim' },
  },
  config = function(opts)
    local lspconfig = require('lspconfig')
    local tools = require('baggiponte.plugins.lsp.utils.tools')
    local handlers = require('baggiponte.plugins.lsp.utils.handlers')

    require('lspconfig.ui.windows').default_options.border = 'rounded'

    vim.diagnostic.config({ virtual_text = { prefix = '' } })

    local capabilities = handlers.make_client_capabilities(opts)

    ---@param spec MasonLSPSpec
    local setup = function(spec)
      local server = spec['name']
      local settings = vim.tbl_deep_extend('force', {
        capabilities = vim.deepcopy(capabilities),
        on_attach = handlers.on_attach,
      }, spec['config'] or {})
      lspconfig[server].setup(settings)
    end

    for _, tool in pairs(tools.servers) do
      setup(tool)
    end
  end,
}
