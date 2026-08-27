return {
  'ray-x/lsp_signature.nvim',
  event = 'InsertEnter',
  opts = {
    -- Genuine deviations from plugin defaults; everything else is left
    -- as-is (rounded border, floating window, virtual hints are defaults).
    close_timeout = 1500, -- default 4000: close sooner after last param
    doc_lines = 5, -- default 10: fewer doc lines in the popup
    hint_prefix = { above = '↙ ', current = '← ', below = '↖ ' }, -- Nerd-safe, vs default 🐼
    toggle_key = '<M-x>', -- defaults to nil; add in insert-mode toggle
    select_signature_key = '<M-n>', -- defaults to nil; cycle overloads
  },
}