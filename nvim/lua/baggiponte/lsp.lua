vim.diagnostic.config({
  virtual_text = { prefix = '' },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.HINT] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
    },
  },
})

-- Python type-checker is a coin flip between `ty` and `pyrefly`: swap them in
-- this list, or live with `:lsp disable pyrefly | lsp enable ty`.
vim.lsp.enable({
  'docker',
  'docker-compose',
  'luals',
  'ruff',
  'sqruff',
  -- 'ty',
  'zizmor',
  'oxfmt',
  'oxlint',
  'pyrefly',
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('baggiponte-lsp', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    local buf = args.buf

    -- Neovim maps the other LSP actions by default (grn, grr, gri, gra, gO, ...).
    vim.keymap.set('n', 'gh', vim.diagnostic.open_float, { buffer = buf, desc = 'Show diagnostics under the cursor' })
    vim.keymap.set('n', 'K', vim.lsp.buf.signature_help, { buffer = buf, desc = 'Show the signature' })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = buf, desc = 'Go to definition' })

    if client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end
    -- Run a lens at the cursor with the built-in `grx`.
    if client:supports_method('textDocument/codeLens') then
      vim.lsp.codelens.enable(true, { bufnr = buf })
    end
  end,
})
