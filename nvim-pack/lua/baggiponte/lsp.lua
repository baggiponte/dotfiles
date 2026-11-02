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

--- Sort imports via a code action filtered by KIND, not by title.
-- Matching titles ("Ruff: Organize imports" vs "Organize Imports" vs
-- "Ruff (I001): Organize imports") broke across ruff versions, and the
-- I001-flavored action only shows up when the cursor sits on the diagnostic.
-- A `source.organizeImports` kind-filtered request is what editors use for
-- "organize imports on save" and is stable. Runs synchronously so the edit
-- lands before the buffer is actually written.
---@param client vim.lsp.Client
---@param bufnr integer
local function organize_imports(client, bufnr)
  -- Window 0: the autocmd is buffer-scoped, so the buffer being saved is the
  -- current one. Note this argument is a *window* id, not a buffer id.
  local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
  params.context = { only = { 'source.organizeImports' }, diagnostics = {} }

  local response = client:request_sync('textDocument/codeAction', params, 1000, bufnr)
  ---@type lsp.CodeAction[]
  local actions = response and response.result or {}

  local action = actions[1]
  if not action then
    return
  end

  -- Ruff's initial response carries neither edit nor command; the edit is
  -- filled in by codeAction/resolve (verified against `ruff server`).
  if not action.edit then
    local resolved = client:request_sync('codeAction/resolve', action, 1000, bufnr)
    action = resolved and resolved.result or action
  end

  if action.edit then
    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Organize imports and format on save (ruff only)',
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if client == nil or client.name ~= 'ruff' then
      return
    end

    -- ruff also attaches to toml/markdown, but import sorting and formatting
    -- only make sense for python.
    if vim.bo[event.buf].filetype ~= 'python' then
      return
    end

    -- NOTE: don't guard on client:supports_method('textDocument/formatting')
    -- here: ruff registers formatting dynamically *after* attach, so the
    -- check is false at this point. Check at save time instead.
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = event.buf,
      callback = function()
        organize_imports(client, event.buf)

        vim.lsp.buf.format({ bufnr = event.buf, id = client.id, async = true })
      end,
    })
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
