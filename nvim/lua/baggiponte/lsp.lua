-- Configure diagnostics
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

  -- virtual_lines = true, -- Uncomment to use virtual lines instead of virtual text
})

-- Enable LSP servers
vim.lsp.enable({
  'luals',
  -- 'cssls',
  -- 'docker',
  -- 'docker-compose',
  -- 'yamlls',
  -- 'biome',
  -- 'ruff',
  'basedpyright',
  -- 'ty',
})
