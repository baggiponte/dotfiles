local defer = require('baggiponte.defer')

defer.on_event(
  { 'InsertEnter', 'CmdlineEnter' },
  defer.loader({ 'blink.cmp' }, function()
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    local opts = {
      keymap = {
        preset = 'default',

        -- https://cmp.saghen.dev/configuration/keymap.html#default
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },

        ['<C-y>'] = { 'show', 'select_and_accept' },

        ['<C-p>'] = {},
        ['<C-n>'] = {},
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },

      completion = {
        menu = {
          border = 'rounded',
          draw = {
            columns = {
              { 'label', 'label_description' },
              { 'kind_icon', 'kind' },
            },
          },
        },

        ghost_text = { enabled = true },

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          window = { border = 'rounded' },
        },
      },

      cmdline = { completion = { menu = { auto_show = true } } },

      sources = {
        default = { 'lsp', 'path', 'buffer' },
      },
    }
    require('blink.cmp').setup(opts)
  end)
)
