---@type vim.lsp.Config
return {
  cmd = { 'mise', 'x', 'lua-language-server', '--', 'lua-language-server' },
  root_markers = {
    '.git',
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
