local import = require('baggiponte.utils').import

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    {
      -- required to discover LSPs installed with Mason
      'williamboman/mason-lspconfig.nvim',
      cmd = { 'Mason', 'LspInstall', 'LspUninstall' },
      opts = { ensure_installed = vim.tbl_keys(servers) },
    },
    {
      'folke/neodev.nvim',
      ft = 'lua',
      opts = {},
    },
  },
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  config = function()
    local borders = import('baggiponte.utils.borders')
    local configs = import('baggiponte.plugins.lsp.utils.configs')

    require('lspconfig.ui.windows').default_options.border = 'rounded'

    local lsp_general_configs = {
      capabilities = configs.capabilities,
      on_attach = configs.lsp_on_attach,
      handlers = configs.handlers,
    }

    for lsp, lsp_specific_configs in pairs(servers) do
      local lsp_configs = vim.tbl_deep_extend('force', lsp_general_configs, lsp_specific_configs)

      import('lspconfig')[lsp].setup(lsp_configs)
    end
  end,
}
