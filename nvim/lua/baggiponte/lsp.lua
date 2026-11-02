-- Enable LSP servers.
-- Python type-checker is a coin flip between `ty` and `pyrefly`: uncomment the
-- entry below to switch. You can also switch live without editing config:
--   :lsp disable pyrefly | :lsp enable ty   (see :lsp for all subcommands)
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
  desc = 'Configure LSP keymaps on attach',
  callback = function(event)
    -- |grn| in Normal mode maps to |vim.lsp.buf.rename()|
    -- |grr| in Normal mode maps to |vim.lsp.buf.references()|
    -- |gri| in Normal mode maps to |vim.lsp.buf.implementation()|
    -- |gO| in Normal mode maps to |vim.lsp.buf.document_symbol()|
    -- |gra| in Normal and Visual mode maps to |vim.lsp.buf.code_action()|
    -- CTRL-S in Insert and Select mode maps to |vim.lsp.buf.signature_help()|
    local keymaps = {
      { 'gh', vim.diagnostic.open_float },
      { 'K', vim.lsp.buf.signature_help },
      { 'gd', vim.lsp.buf.definition },
    }

    local opts = { buffer = event.buf }

    for _, mapping in pairs(keymaps) do
      local mapopts = mapping.opts or {}
      vim.keymap.set(mapopts.mode or 'n', mapping[1], mapping[2], mapopts.opts or opts)
    end
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Enable inlay hints',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client == nil then
      return
    end

    if client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Enable code lenses only when the server advertises them',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client == nil then
      return
    end

    -- Few of the configured servers support textDocument/codeLens, so guard
    -- the enable on the provider capability. Run one at the cursor with the
    -- built-in `grx` mapping (vim.lsp.codelens.run()).
    if client.server_capabilities.codeLensProvider then
      vim.lsp.codelens.enable(true, { bufnr = args.buf })
    end
  end,
})
