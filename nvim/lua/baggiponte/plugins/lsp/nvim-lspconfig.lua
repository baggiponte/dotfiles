local servers = {
  lua_ls = {},
  cssls = {},
  dockerls = {},
  docker_compose_language_service = {},
  yamlls = {},
  biome = {},
  ruff = {},
  basedpyright = {
    settings = {
      basedpyright = {
        disableOrganizeImports = true,
        analysis = {
          diagnosticMode = 'workspace',
        },
      },
    },
  },
}

local keymaps = {
  {
    'n',
    '<leader>rn',
    vim.lsp.buf.rename,
    { desc = 'LSP: Rename word under cursor' },
  },
  {
    'n',
    '<leader>e',
    vim.diagnostic.open_float,
    { desc = 'LSP: Open diagnistics floating pane' },
  },
  {
    'n',
    'ca',
    vim.lsp.buf.code_action,
    { desc = 'LSP: Execute code action' },
  },
  {
    'n',
    'gf',
    function()
      require('telescope.builtin').lsp_references()
    end,
    { desc = 'LSP: Go to find references' },
  },
  {
    'n',
    'gd',
    function()
      require('telescope.builtin').lsp_definitions()
    end,
    { desc = 'LSP: Go to definition' },
  },
  {
    'n',
    '<leader>h',
    vim.lsp.buf.signature_help,
    { desc = 'LSP: Go to signature help' },
  },
}

return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  dependencies = {
    'williamboman/mason.nvim',
    {
      'folke/lazydev.nvim',
      ft = 'lua', -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },
  },
  opts = {
    servers = servers,
    keymaps = keymaps,
  },
  config = function(_, opts)
    local utils = require('baggiponte.plugins.lsp.config.utils')

    -- this will actually be deprecated
    require('lspconfig.ui.windows').default_options.border = 'rounded'

    vim.diagnostic.config({ virtual_text = { prefix = '' } })

    local capabilities = utils.extend_capabilities(opts.capabilities)

    for server, config in pairs(opts.servers) do
      utils.setup(server, config, capabilities)
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'Configure LSP keymaps on attach',
      callback = function(event)
        utils.on_attach(event, opts)
      end,
    })
  end,
}
