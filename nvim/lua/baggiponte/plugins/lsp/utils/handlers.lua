local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')

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
    'Incremental [r]e[n]ame of a symbol',
    { expr = true },
  },
  {
    '<leader>f',
    function()
      vim.lsp.buf.format({ async = true })
    end,
    '[f]ormat current buffer',
  },
  { '<leader>e', vim.diagnostic.open_float, 'Open diagnistics floating pane' },
  { 'ca', vim.lsp.buf.code_action, 'Execute [c]ode [a]ction' },
  { 'gf', '<cmd>Lspsaga finder<CR>', '[g]o [f]ind occurrences with Lspsaga' },
  { 'gp', '<cmd>Lspsaga peek_definition<CR>', '[g]o [p]eek the definition with Lspsaga' },
  { 'gD', vim.lsp.buf.declaration, '[g]o to [D]eclaration' },
  { 'gd', vim.lsp.buf.definition, '[g]o to [d]efinition' },
  { 'gi', vim.lsp.buf.implementation, '[g]o to [i]mplementation' },
  { 'gr', vim.lsp.buf.references, '[g]o to [r]eferences' },
  { 'gt', vim.lsp.buf.type_definition, '[g]o to [t]ype definition' },
  { '<leader>h', vim.lsp.buf.signature_help, 'go to signature help' },
}

M.on_attach = function(client, buffer)
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

  if client.name == 'ruff' then
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end

  for _, keymap in ipairs(M.keys) do
    bufmap(keymap)
  end
end

M.make_client_capabilities = function(opts)
  return vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {},
    opts.capabilities or {}
  )
end

return M
