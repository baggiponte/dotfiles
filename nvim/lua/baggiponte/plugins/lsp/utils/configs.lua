local import = require('baggiponte.utils').import

local M = {}

M.lsp_on_attach = function(_, bufnr)
  local bufmap = function(shortcut, command, desc)
    local bufopts = { desc = desc, noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', shortcut, command, bufopts)
  end

  vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action)
  vim.keymap.set('n', '<leader>rn', function()
    return ':IncRename ' .. vim.fn.expand('<cword>')
  end, { expr = true, desc = 'Incremental [r]e[n]ame of a symbol' })

  bufmap('<leader>f', function()
    vim.lsp.buf.format({ async = true })
  end, '[f]ormat current buffer')

  bufmap('[d', vim.diagnostic.goto_prev, 'Go to next [d]iagnostic')
  bufmap(']d', vim.diagnostic.goto_next, 'Go to previous [d]iagnostic')
  bufmap('gf', '<cmd>Lspsaga finder<CR>', '[g]o [f]ind occurrences with Lspsaga')
  bufmap('gp', '<cmd>Lspsaga peek_definition<CR>', '[g]o [p]eek the definition with Lspsaga')
  bufmap('gD', vim.lsp.buf.declaration, '[g]o to [D]eclaration')
  bufmap('gd', vim.lsp.buf.definition, '[g]o to [d]efinition')
  bufmap('gi', vim.lsp.buf.implementation, '[g]o to [i]mplementation')
  bufmap('gr', vim.lsp.buf.references, '[g]o to [r]eferences')
  bufmap('gt', vim.lsp.buf.type_definition, '[g]o to [t]ype definition')
  bufmap('K', vim.lsp.buf.hover, 'Display documentation on hover')
  bufmap('<C-k>', vim.lsp.buf.signature_help, 'go to signature help')
end

M.handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
}

M.capabilities = import('cmp_nvim_lsp').default_capabilities()

return M
