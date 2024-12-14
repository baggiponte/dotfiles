return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  dependencies = {
    { 'williamboman/mason.nvim' },
  },
  config = function(opts)
    local lspconfig = require('lspconfig')
    local tools = require('baggiponte.plugins.lsp.utils.tools')
    local defaults = require('baggiponte.plugins.lsp.utils.defaults')

    require('lspconfig.ui.windows').default_options.border = 'rounded'

    vim.diagnostic.config({ virtual_text = { prefix = '' } })

    local capabilities = defaults.extend_client_capabilities_with_cmp(opts)

    ---@param spec MasonServerSpec
    local setup = function(spec)
      local server = spec['name']

      local config = {
        capabilities = vim.deepcopy(capabilities),
        on_attach = defaults.on_attach,
        handlers = defaults.handlers,
      }

      local settings = vim.tbl_deep_extend('force', config, spec['config'] or {})

      lspconfig[server].setup(settings)
    end

    for _, tool in pairs(tools.servers) do
      setup(tool)
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if not client then
          return
        end

        if client.name == 'ruff' then
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end

        if client.supports_method('textDocument/formatting') and not string.find(client.name, 'pyright') then
          -- Format the current buffer on save
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = args.buf,
            callback = function()
              if client.name == 'ruff' then
                vim.lsp.buf.code_action({
                  apply = true,
                  filter = function(action)
                    return action.title == 'Ruff: Organize imports'
                  end,
                })
              end
              vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
            end,
          })
        end
      end,
    })
  end,
}
