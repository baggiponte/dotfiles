-- creati il tuo tema servono solo tre bg color 
-- https://github.com/sainnhe/gruvbox-material/blob/c75bf1e96fdc33b8b3b613e5172a0acdba198fca/autoload/gruvbox_material.vim#L48-L50
return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        theme = 'gruvbox-material',
        component_separators = '⋅',
        section_separators = '',
      },
    },
  },
}
