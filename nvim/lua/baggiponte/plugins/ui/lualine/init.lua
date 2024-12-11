local utils = require('baggiponte.plugins.ui.lualine.utils')
local widgets = require('baggiponte.plugins.ui.lualine.widgets')

-- my variation on gruvbox-material
---@enum Palette
local palette = {
  lightgrey = '#a89984',
  darkgrey = '#504945',
  dust = '#ddc7a1',
  black = '#32302f',
  red = '#ea6962',
  yellow = '#d8a657',
  green = '#a9b665',
  orange = '#e78a4e',
  purple = '#d3869b',
  aqua = '#89b482',
  blue = '#7daea3',
}

local theme = {
  normal = {
    a = utils.set_theme({ fg = palette.dust, gui = 'bold' }),
    b = utils.set_theme(palette.red),
    c = utils.set_theme(palette.dust),
    x = utils.set_theme(palette.blue),
    y = utils.set_theme(palette.aqua),
    z = utils.set_theme(palette.dust),
  },
  insert = { a = utils.set_theme(palette.cyan) },
  command = { a = utils.set_theme(palette.yellow) },
  replace = { a = utils.set_theme(palette.green) },
  terminal = { a = utils.set_theme(palette.pink) },
  visual = { a = utils.set_theme(palette.red) },
  inactive = {
    a = utils.set_theme(palette.darkgrey),
    z = utils.set_theme(palette.darkgrey),
  },
}

local sections = {
  lualine_a = { { 'mode', icon = '' } },
  lualine_b = { 'branch', 'diff' },
  lualine_c = {
    { 'filetype', icon_only = true, padding = { left = 1, right = 0 } },
    widgets.filepath,
  },
  lualine_x = { 'diagnostics', widgets.lsp_clients, widgets.null_ls_sources },
  lualine_y = { { widgets.copilot_active, padding = { left = 1, right = 0 } } },
  lualine_z = { 'location', 'progress' },
}

return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      sections = sections,
      options = {
        theme = theme,
        component_separators = '',
        section_separators = '',
      },
      extensions = {
        'fugitive',
        'lazy',
        'man',
        'nvim-dap-ui',
        'nvim-tree',
        'quickfix',
        'toggleterm',
        'trouble',
      },
    },
  },
}
