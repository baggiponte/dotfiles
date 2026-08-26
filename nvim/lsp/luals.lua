---@type vim.lsp.Config
return {
  cmd = { 'mise', 'x', 'lua-language-server', '--', 'lua-language-server' },
  root_markers = {
    { '.luarc.json', '.luarc.jsonc' },
    '.git',
  },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim', 'Snacks' },
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
}
