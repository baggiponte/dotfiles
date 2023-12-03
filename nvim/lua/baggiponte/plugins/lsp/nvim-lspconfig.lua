local servers = require('baggiponte.plugins.lsp.utils.tools').servers

return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  dependencies = {
    { 'folke/neodev.nvim', opts = {}, ft = { 'lua' } },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
  },
  opts = {
    servers = servers,
  },
  config = function(_, opts)
    local lspconfig = require('lspconfig')
    local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    local has_mason, mlsp = pcall(require, 'mason-lspconfig')

    require('lspconfig.ui.windows').default_options.border = 'rounded'

    vim.diagnostic.config({
      virtual_text = { prefix = '' },
    })

    local default_capabilities = vim.tbl_deep_extend(
      'force',
      {},
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp and cmp_nvim_lsp.default_capabilities() or {},
      opts.capabilities or {}
    )

    local function setup(server)
      local settings =
        vim.tbl_deep_extend('force', { capabilities = vim.deepcopy(default_capabilities) }, opts.servers[server] or {})

      lspconfig[server].setup(settings)
    end

    ---@type string[]
    local ensure_installed = {}

    for server, server_opts in pairs(opts.servers) do
      if server_opts.mason == false then
        setup(server)
      else
        ensure_installed[#ensure_installed + 1] = server
      end
    end

    if has_mason then
      -- install missing servers and configures those already installed with mason
      mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
    end

    -- set keympas when LSP is attached
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(client, buffer)
        require('baggiponte.plugins.lsp.utils.keymaps').on_attach(client, buffer)
      end,
    })
  end,
}
