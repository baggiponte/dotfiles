-- Plugins are managed by the built-in vim.pack (Nvim 0.12+). They live in
-- stdpath('data')/site/pack/core/opt and are pinned in nvim-pack-lock.json.
-- vim.pack has no lazy-loading of its own. Plugins that are cheap or lazy by
-- design are loaded and configured eagerly. Plugins marked `opt` below are
-- kept off the runtimepath and packadd-ed on demand via baggiponte.defer.

-- Skip built-in runtime plugins (lazy.nvim's performance.rtp.disabled_plugins).
-- Their plugin/ files bail out when these are set.
for _, plugin in ipairs({
  'gzip',
  'matchit',
  'matchparen',
  'netrw',
  'netrwPlugin',
  'shada_plugin',
  'tarPlugin',
  'tutor_mode_plugin',
  'zipPlugin',
}) do
  vim.g['loaded_' .. plugin] = 1
end

local function gh(repo)
  return 'https://github.com/' .. repo
end

-- Build hooks (lazy.nvim's `build`). Must be defined before vim.pack.add() so
-- they also run on the very first install.
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('baggiponte-pack-hooks', { clear = true }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end

    if name == 'telescope-fzf-native.nvim' then
      vim.system({ 'make' }, { cwd = ev.data.path }):wait()
    elseif name == 'fff.nvim' then
      if not ev.data.active then
        vim.cmd.packadd(name)
      end
      require('fff.download').download_or_build_binary()
    elseif name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then
        vim.cmd.packadd(name)
      end
      vim.cmd('TSUpdate')
    end
  end,
})

-- `data = OPT`: install, but load on demand (see baggiponte.defer)
local OPT = { opt = true }

vim.pack.add({
  -- UI
  gh('sainnhe/gruvbox-material'),
  { src = gh('folke/snacks.nvim'), version = 'v2.22.0' },
  { src = gh('nvim-lualine/lualine.nvim'), data = OPT },
  { src = gh('folke/noice.nvim'), data = OPT },
  { src = gh('MunifTanjim/nui.nvim'), data = OPT },
  { src = gh('stevearc/dressing.nvim'), data = OPT },
  { src = gh('brenoprata10/nvim-highlight-colors'), data = OPT },

  -- libraries
  { src = gh('nvim-lua/plenary.nvim'), data = OPT },
  { src = gh('nvim-tree/nvim-web-devicons'), data = OPT },
  { src = gh('nvim-neotest/nvim-nio'), data = OPT },

  -- treesitter
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },
  { src = gh('nvim-treesitter/nvim-treesitter-textobjects'), version = 'main' },
  gh('RRethy/nvim-treesitter-endwise'),
  gh('kylechui/nvim-surround'),
  { src = gh('windwp/nvim-autopairs'), data = OPT },

  -- editing
  { src = gh('saghen/blink.cmp'), version = vim.version.range('*'), data = OPT },
  { src = gh('supermaven-inc/supermaven-nvim'), data = OPT },
  { src = gh('ray-x/lsp_signature.nvim'), data = OPT },
  { src = gh('folke/lazydev.nvim'), data = OPT },
  gh('stevearc/conform.nvim'),
  gh('mfussenegger/nvim-lint'),
  gh('echasnovski/mini.splitjoin'),
  { src = gh('ThePrimeagen/refactoring.nvim'), data = OPT },
  { src = gh('mg979/vim-visual-multi'), data = OPT },
  { src = gh('Wansmer/symbol-usage.nvim'), data = OPT },

  -- navigation
  gh('dmtrKovalenko/fff.nvim'),
  { src = gh('nvim-telescope/telescope.nvim'), data = OPT },
  { src = gh('nvim-telescope/telescope-fzf-native.nvim'), data = OPT },
  { src = gh('bassamsdata/namu.nvim'), data = OPT },
  { src = gh('stevearc/oil.nvim'), data = OPT },
  { src = gh('nvim-neo-tree/neo-tree.nvim'), version = 'v3.x', data = OPT },
  gh('stevearc/quicker.nvim'),
  gh('mhinz/vim-sayonara'),
  gh('christoomey/vim-tmux-navigator'),

  -- git
  gh('lewis6991/gitsigns.nvim'),
  { src = gh('NeogitOrg/neogit'), data = OPT },
  { src = gh('sindrets/diffview.nvim'), data = OPT },

  -- languages and tools
  { src = gh('OXY2DEV/markview.nvim'), data = OPT },
  { src = gh('tpope/vim-dadbod'), data = OPT },
  { src = gh('kristijanhusak/vim-dadbod-completion'), data = OPT },
  { src = gh('kristijanhusak/vim-dadbod-ui'), data = OPT },
  { src = gh('mfussenegger/nvim-dap'), data = OPT },
  { src = gh('igorlfs/nvim-dap-view'), data = OPT },
  { src = gh('mfussenegger/nvim-dap-python'), data = OPT },
  { src = gh('theHamsta/nvim-dap-virtual-text'), data = OPT },
  { src = gh('nvim-neotest/neotest'), data = OPT },
  { src = gh('nvim-neotest/neotest-python'), data = OPT },
}, {
  confirm = false,
  load = function(plugin)
    if not (plugin.spec.data and plugin.spec.data.opt) then
      vim.cmd.packadd({ plugin.spec.name, bang = true })
    end
  end,
})

-- Like lazy.nvim: requiring a module of an `opt` plugin that is not loaded yet
-- packadds it, so optional integrations (e.g. fff -> devicons) keep working.
-- Hard dependencies are still listed in each defer.loader() call: :packadd is
-- not allowed in every context (e.g. inside UI event callbacks).
local opt_plugins ---@type table<string, string>? lua top-level module -> plugin name
table.insert(package.loaders, function(modname)
  if not opt_plugins then
    opt_plugins = {}
    for _, plugin in ipairs(vim.pack.get()) do
      if plugin.spec.data and plugin.spec.data.opt then
        for entry in vim.fs.dir(plugin.path .. '/lua') do
          opt_plugins[entry:gsub('%.lua$', '')] = plugin.spec.name
        end
      end
    end
  end

  local name = opt_plugins[modname:match('^[^.]+')]
  if not name then
    return
  end
  opt_plugins[modname:match('^[^.]+')] = nil
  require('baggiponte.defer').packadd(name)
  local path = vim.api.nvim_get_runtime_file('lua/' .. modname:gsub('%.', '/') .. '.lua', false)[1]
    or vim.api.nvim_get_runtime_file('lua/' .. modname:gsub('%.', '/') .. '/init.lua', false)[1]
  return path and loadfile(path) or nil
end)

-- Local, unmanaged plugin (lazy.nvim's `dir = ...`).
local rex = vim.fn.expand('~/dev/projs/rex-navigator.nvim')
if vim.uv.fs_stat(rex) then
  vim.opt.rtp:append(rex)
end

for _, module in ipairs({
  -- colorscheme first, like lazy.nvim's `priority = 1000`
  'ui.colorscheme',
  'ui.snacks',
  'treesitter',
  'blink',
  'conform',
  'dadbod',
  'dap',
  'fff',
  'gitsigns',
  'lazydev',
  'lint',
  'lsp-signature',
  'markview',
  'mini',
  'namu',
  'neo-tree',
  'neogit',
  'neotest',
  'oil',
  'quicker',
  'refactoring',
  'rex-navigator',
  'sayonara',
  'supermaven',
  'symbol-usage',
  'telescope',
  'vim-tmux-navigator',
  'vim-visual-multi',
  'ui.dressing',
  'ui.lualine',
  'ui.noice',
  'ui.nvim-highlight-colors',
}) do
  require('baggiponte.plugins.' .. module)
end
