local defer = require('baggiponte.defer')

-- The dadbod plugins autoload their code, but sourcing their plugin/ files
-- still costs ~0.6 ms, so they load on their commands. Their plugin/ files
-- define the real commands, replacing these stubs.
defer.on_cmd(
  { 'DB', 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
  defer.loader({ 'vim-dadbod', 'vim-dadbod-completion', 'vim-dadbod-ui' })
)
