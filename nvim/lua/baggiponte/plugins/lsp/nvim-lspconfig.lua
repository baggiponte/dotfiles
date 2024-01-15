return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  dependencies = {
    { 'folke/neodev.nvim', opts = {}, ft = { 'lua' } },
    {
      'williamboman/mason-lspconfig.nvim',
      dependencies = {
        'williamboman/mason.nvim',
        build = ':MasonUpdate',
        cmd = { 'Mason', 'MasonUpdate' },
        opts = {
          ui = {
            border = 'rounded',
            icons = { package_installed = '✓', package_uninstalled = '✗', package_pending = '⟳' },
          },
        },
        config = function(_, opts)
          local registry = require('mason-registry')
          local tools = require('baggiponte.plugins.lsp.utils.tools')

          registry.refresh(function()
            for _, pkg_name in ipairs(tools) do
              local pkg = registry.get_package(pkg_name)
              if not pkg:is_installed() then
                pkg:install()
              end
            end
          end)

          require('mason').setup(opts)
        end,
      },
    },
  },
  config = function(_, opts)
    local lspconfig = require('lspconfig')
    local servers = require('baggiponte.plugins.lsp.utils.tools').servers
    local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    local _, mlsp = pcall(require, 'mason-lspconfig')

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
        vim.tbl_deep_extend('force', { capabilities = vim.deepcopy(default_capabilities) }, servers[server] or {})

      lspconfig[server].setup(settings)
    end

    -- install missing servers and configures those already installed with mason
    -- TODO: don't need mason-lspconfig since servers are installed upon mason startup. just need to map the mason to
    -- lspconfig name
    mlsp.setup({ ensure_installed = vim.tbl_keys(servers), handlers = { setup } })

    -- set keympas when LSP is attached
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(client, buffer)
        require('baggiponte.plugins.lsp.utils.keymaps').on_attach(client, buffer)
      end,
    })
  end,
}
