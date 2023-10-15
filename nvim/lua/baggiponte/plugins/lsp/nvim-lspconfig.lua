local safe_require = require('baggiponte.utils').safe_require

local mason = safe_require('baggiponte.plugins.lsp.utils.sources').mason

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    {
      'williamboman/mason-lspconfig.nvim',
      cmd = { 'Mason', 'LspInstall', 'LspUninstall' },
      opts = { ensure_installed = mason.lsp },
    },
    {
      'folke/neodev.nvim',
      ft = 'lua',
      opts = {},
    },
  },
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  config = function()
    local borders = safe_require('baggiponte.utils.borders')
    local servers = safe_require('baggiponte.plugins.lsp.utils.sources').servers
    local configs = safe_require('baggiponte.plugins.lsp.utils.configs')

    safe_require('lspconfig.ui.windows').default_options.border = borders

    for lsp, lsp_specific_configs in pairs(servers) do
      local lsp_general_configs = {
        capabilities = configs.capabilities,
        on_attach = configs.lsp_on_attach,
        handlers = configs.handlers,
      }

      local lsp_configs = vim.tbl_deep_extend('force', lsp_general_configs, lsp_specific_configs)

      safe_require('lspconfig')[lsp].setup(lsp_configs)
    end
  end,
}
