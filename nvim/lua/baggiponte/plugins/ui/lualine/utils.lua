local M = {}

---@alias FontStyle "bold"|"italic"

---@overload fun(opts: table)
---@overload fun(fg: Palette)
---@param fg Palette|{fg:Palette, bg?:Palette, gui?:FontStyle|string}
---@return table
M.set_theme = function(fg)
  if type(fg) == 'table' and fg.fg then
    return { fg = fg.fg, bg = fg.bg or nil, gui = fg.gui or nil }
  else
    return { fg = fg }
  end
end

return M
