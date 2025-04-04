local servers = {
  lua_ls = {},
  cssls = {},
  dockerls = {},
  docker_compose_language_service = {},
  yamlls = {},
  biome = {},
  ruff = {
    capabilities = {
      hoverProvider = false,
    },
  },
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

-- |grn| in Normal mode maps to |vim.lsp.buf.rename()|
-- |grr| in Normal mode maps to |vim.lsp.buf.references()|
-- |gri| in Normal mode maps to |vim.lsp.buf.implementation()|
-- |gO| in Normal mode maps to |vim.lsp.buf.document_symbol()|
-- |gra| in Normal and Visual mode maps to |vim.lsp.buf.code_action()|
-- CTRL-S in Insert and Select mode maps to |vim.lsp.buf.signature_help()|
local keymaps = {
  {
    'n',
    'ge',
    vim.diagnostic.open_float,
    { desc = 'LSP: Open diagnistics floating pane' },
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
    'gh',
    vim.lsp.buf.signature_help,
    { desc = 'LSP: Go to signature help' },
  },
}

return {
  'neovim/nvim-lspconfig',
  version = 'v1.3.0',
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
    local lspconfig = require('lspconfig')
    local utils = require('baggiponte.utils.lsp')

    vim.diagnostic.config({
      virtual_text = { prefix = '' },
      -- virtual_lines = true,
    })

    local capabilities = require('blink.cmp').get_lsp_capabilities({ include_nvim_defaults = true })

    local defaults = {
      capabilities = vim.deepcopy(capabilities),
    }

    for server, overrides in pairs(opts.servers) do
      local config = vim.tbl_deep_extend('force', defaults, overrides)
      lspconfig[server].setup(config)
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'Configure LSP keymaps on attach',
      callback = function(event)
        utils.on_attach(event, opts.keymaps)
      end,
    })
  end,
}
