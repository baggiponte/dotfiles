local M = {}

-- 0.10.0 defaults:
-- K -> hover
-- ]d [d -> next/prev diagnostic
M.keys = {
  {
    '<leader>rn',
    function()
      return ':IncRename ' .. vim.fn.expand('<cword>')
    end,
    'Incremental rename of a symbol',
    { expr = true },
  },
  { '<leader>e', vim.diagnostic.open_float, 'Open diagnistics floating pane' },
  { 'ca', vim.lsp.buf.code_action, 'Execute code action' },
  {
    'go',
    function()
      require('telescope.builtin').lsp_document_symbols()
    end,
    'Go to navigate symbols',
  },
  {
    'gf',
    function()
      require('telescope.builtin').lsp_references()
    end,
    'Go to find references',
  },
  {
    'gd',
    function()
      require('telescope.builtin').lsp_definitions()
    end,
    'Go to definition',
  },
  { '<leader>h', vim.lsp.buf.signature_help, 'Go to signature help' },
}

M.on_attach = function(client, buffer)
  if not client then
    return
  end

  local bufmap = function(args)
    local lhs, rhs, desc, opts
    lhs, rhs, desc, opts = unpack(args)

    local bufopts = vim.tbl_extend('force', { desc = desc, noremap = true, silent = true, buffer = buffer }, opts or {})

    local mode ---@type string
    if type(opts) == 'table' and vim.tbl_contains(opts, mode) then
      mode = vim.tbl_get(opts, 'mode')
    else
      mode = 'n'
    end

    vim.keymap.set(mode, lhs, rhs, bufopts)
  end

  for _, keymap in ipairs(M.keys) do
    bufmap(keymap)
  end

  if client.name == 'ruff' then
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end
end

M.extend_client_capabilities_with_cmp = function(opts)
  local blink_capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
  return vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    blink_capabilities() or {},
    opts.capabilities or {}
  )
end

M.handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
}

return M
