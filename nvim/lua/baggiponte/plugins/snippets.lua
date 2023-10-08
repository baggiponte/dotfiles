local safe_require = require('baggiponte.utils').safe_require

return {
  'L3MON4D3/LuaSnip',
  name = 'luasnip',
  event = { 'InsertEnter' },
  dependencies = {
    'rafamadriz/friendly-snippets',
    config = function()
      safe_require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
  config = function()
    local ls = require('luasnip')
    local snip = ls.snippet
    local text = ls.text_node
    local insert = ls.insert_node

    ls.add_snippets(nil, {
      python = {
        snip({
          trig = 'annotations',
          dscr = 'Add `from __future__ import annotations`',
        }, {
          text({ 'from __future__ import annotations' }),
        }),
      },
      markdown = {
        snip({
          trig = 'Rblock',
          dscr = 'Insert a R code fence using quarto/rmarkdown style (with {r})',
        }, {
          text({ '```{r}', '' }), -- more arguments make it multiline
          insert(1),
          text({ '', '```' }),
        }),
        snip({
          trig = 'pyblock',
          dscr = 'Insert a Python code fence using quarto/rmarkdown style (with {python})',
        }, {
          text({ '```{python}', '' }),
          insert(1),
          text({ '', '```' }),
        }),
      },
    })
  end,
}
