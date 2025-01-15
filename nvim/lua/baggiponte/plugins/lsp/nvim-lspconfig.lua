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

    vim.diagnostic.config({ virtual_text = { prefix = '' } })

    local handlers = {
      ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
      ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
    }

    local capabilities = require('blink.cmp').get_lsp_capabilities({ include_nvim_defaults = true })

    local defaults = {
      capabilities = vim.deepcopy(capabilities),
      handlers = handlers,
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
