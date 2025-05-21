---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  root_markers = {
    '.git'
    '.luarc.json',
    '.luarc.jsonc',
  },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
}
