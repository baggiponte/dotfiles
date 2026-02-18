---@type vim.lsp.Config
return {
  cmd = { 'bunx', '--', 'oxlint', '--lsp' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'toml',
    'json',
    'jsonc',
    'json5',
    'yaml',
    'html',
    'vue',
    'handlebars',
    'hbs',
    'css',
    'scss',
    'less',
    'graphql',
    'markdown',
    'mdx',
  },
  workspace_required = true,
  root_markers = {
    '.git',
    '.oxlintrc.json',
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspOxlintFixAll', function()
      client:exec_cmd({
        title = 'Apply Oxlint automatic fixes',
        command = 'oxc.fixAll',
        arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
      })
    end, {
      desc = 'Apply Oxlint automatic fixes',
    })
  end,
}
