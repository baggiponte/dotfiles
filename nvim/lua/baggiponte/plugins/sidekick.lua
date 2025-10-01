return {
  'folke/sidekick.nvim',
  opts = {
    -- add any options here
    cli = {
      mux = {
        backend = 'tmux',
        enabled = true,
      },
      tools = {
        claude = { cmd = { 'bunx', '@anthropic-ai/claude-code' } },
        codex = { cmd = { 'bunx', '@openai/codex --model=gpt-5-codex --search' } },
      },
    },
  },
  keys = {
    {
      '<tab>',
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require('sidekick').nes_jump_or_apply() then
          return '<Tab>' -- fallback to normal tab
        end
      end,
      expr = true,
      desc = 'Goto/Apply Next Edit Suggestion',
    },
    {
      '<c-.>',
      function()
        require('sidekick.cli').focus()
      end,
      mode = { 'n', 'x', 'i', 't' },
      desc = 'Sidekick Switch Focus',
    },
    {
      '<leader>ac',
      function()
        require('sidekick.cli').toggle({ name = 'claude', focus = true })
      end,
      desc = 'Sidekick Claude Toggle',
      mode = { 'n', 'v' },
    },
  },
}
