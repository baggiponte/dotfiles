local import = require('baggiponte.utils').import

local dependencies = {
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-nvim-lua' },
  { 'hrsh7th/cmp-path' },
  { 'saadparwaiz1/cmp_luasnip', name = 'cmp-luasnip' },
  {
    'zbirenbaum/copilot.lua',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
  {
    'zbirenbaum/copilot-cmp',
    name = 'cmp-copilot',
    config = true,
  },
}

return {
  'hrsh7th/nvim-cmp',
  dependencies = dependencies,
  version = false, -- last release is way too old
  event = { 'InsertEnter', 'CmdlineEnter' },
  config = function()
    local cmp = import('cmp')
    local luasnip = import('luasnip')

    vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      formatting = {
        format = function(_, item)
          local icons = import('baggiponte.utils.icons').icons.kinds
          if icons[item.kind] then
            item.kind = icons[item.kind] .. item.kind
          end
          return item
        end,
      },
      mapping = {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-space>'] = cmp.mapping.complete(),
        ['<esc>'] = cmp.mapping.close(),
        ['<C-n>'] = cmp.mapping.confirm({ select = true }),
        [']'] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end,
        ['['] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end,
      },
      sources = cmp.config.sources({
        { name = 'copilot' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
      }),
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      experimental = {
        ghost_text = {
          hl_group = 'LspCodeLens',
        },
      },
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype('lua', {
      sources = cmp.config.sources({
        { name = 'nvim_lua' },
        { name = 'copilot' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      }),
    })

    local text_filetypes = { 'markdown', 'gitcommit', 'text' }

    for _, filetype in ipairs(text_filetypes) do
      cmp.setup.filetype(filetype, {
        sources = cmp.config.sources({
          { name = 'copilot' },
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end

    local window = {
      completion = cmp.config.window.bordered({
        winhighlight = 'Normal:Normal,FloatBorder:SpecialCmpBorder,Search:None',
      }),
    }
    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      window = window,
      sources = {
        { name = 'buffer' },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      window = window,
      sources = cmp.config.sources({
        { name = 'nvim_lua' },
        { name = 'cmdline' },
        { name = 'path' },
      }),
    })
  end,
}
