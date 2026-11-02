local defer = require('baggiponte.defer')

-- vim-dadbod, vim-dadbod-ui and vim-dadbod-completion are Vimscript plugins
-- that autoload their code, but sourcing their plugin/ files still costs
-- ~0.6ms, so keep lazy.nvim's `cmd` loading. Their plugin/ files define the
-- real commands, replacing these stubs.
defer.on_cmd(
  { 'DB', 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
  defer.loader({ 'vim-dadbod', 'vim-dadbod-completion', 'vim-dadbod-ui' })
)
