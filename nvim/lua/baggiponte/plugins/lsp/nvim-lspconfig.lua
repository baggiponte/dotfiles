local safe_require = require('baggiponte.utils').safe_require

local borders = safe_require('baggiponte.utils.borders')
local mason = safe_require('baggiponte.plugins.lsp.utils.sources').mason
local utils = safe_require('baggiponte.plugins.lsp.utils.capabilities')

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    cmd = { 'Mason', 'LspInstall', 'LspUninstall' },
    opts = { ensure_installed = mason.lsp },
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local servers = safe_require('baggiponte.plugins.lsp.utils.sources').servers

    safe_require('lspconfig.ui.windows').default_options.border = borders

    for lsp, lsp_specific_configs in pairs(servers) do
      local lsp_general_configs = {
        capabilities = utils.capabilities,
        on_attach = utils.lsp_on_attach,
        handlers = utils.handlers,
      }

      local lsp_configs = vim.tbl_deep_extend('force', lsp_general_configs, lsp_specific_configs)

      safe_require('lspconfig')[lsp].setup(lsp_configs)
    end
  end,
}
