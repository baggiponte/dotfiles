return {
  'L3MON4D3/LuaSnip',
  config = function()
    local ls = require('luasnip')
    local snip = ls.snippet
    local text = ls.text_node
    local insert = ls.insert_node

    -- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#loaders
    require('luasnip.loaders.from_vscode').lazy_load() -- load snippets from rafamadriz/friendly-snippets

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
