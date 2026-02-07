-- Enable LSP servers
vim.lsp.enable({
  'biome',
  'docker',
  'docker-compose',
  'luals',
  'ruff',
  'rumdl',
  'sqruff',
  'ty',
  'yamlls',
  'zizmor',
  -- 'pyrefly',
  -- 'tombi',
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
  desc = 'Configure LSP keymaps on attach',
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if client == nil then
      return
    end

    -- Format the current buffer on save
    -- Don't do this for pyright/basedpyright, as I want to use ruff
    if client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = event.buf,
        callback = function()
          if client.name == 'ruff' then
            vim.lsp.buf.code_action({
              apply = true,
              filter = function(action)
                return action.title == 'Ruff: Organize imports'
              end,
            })
          end

          vim.lsp.buf.format({ bufnr = event.buf, id = client.id, async = true })
        end,
      })
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
