-- Port of ~/.config/tmux/tmux.conf. Ctrl-S is the tmux prefix;
-- Ctrl-H/J/K/L navigate seamlessly through Neovim windows and Rex panes.
local terminal = "com.superlogical.terminal"
local shell = "com.superlogical.terminal.shell"
-- Load the same PATH/tools as an interactive tmux shell (e.g. diff-so-fancy).
local function lazygit_command()
  return { "/opt/homebrew/bin/zsh", "-lic", "exec /opt/homebrew/bin/lazygit" }
end

local function checked(result, err)
  if err ~= nil then error(err, 0) end
  return result
end

local function current_directory()
  local pwd = rex.block.call(terminal, "pwd", {})
  if pwd and pwd.pwd and pwd.pwd ~= "" then return pwd.pwd end

  -- OSC 7 isn't reported by every shell. Rex can also inspect process cwds.
  local process, err = rex.block.call(terminal, "process", {})
  checked(process, err)
  if process then
    if process.foreground and process.foreground.cwd then
      return process.foreground.cwd
    end
    for _, ancestor in ipairs(process.ancestors or {}) do
      if ancestor.cwd then return ancestor.cwd end
    end
    if process.child and process.child.cwd then return process.child.cwd end
  end
  error("Cannot determine the focused terminal's directory", 0)
end

local function shell_layout(options)
  options = options or {}
  options.cwd = options.cwd or current_directory()
  -- Match tmux's Homebrew zsh rather than Rex's default /bin/zsh.
  if not options.command then options.command = { "/opt/homebrew/bin/zsh", "-l" } end
  options.shell = "none"
  return rex.layout.block{ flavor = shell, options = options }
end

local function new_focused_tab(ctx, options)
  options.focus = true
  local window = checked(rex.session.new_window(options))
  -- Server focus alone doesn't necessarily select the tab in the macOS client.
  rex.client.queue("session.select", {
    session_id = ctx.session_id,
    window_id = window.window_id,
  })
  return window
end

rex.action{
  name = "tmux_new_tab",
  title = "New Tab in Current Directory",
  category = "Tmux",
  run = function(ctx)
    return new_focused_tab(ctx, { layout = shell_layout() })
  end,
}

for _, direction in ipairs({ "horizontal", "vertical" }) do
  local split_direction = direction
  rex.action{
    name = "tmux_split_" .. direction,
    title = direction == "horizontal" and "Split Right in Current Directory"
      or "Split Down in Current Directory",
    category = "Tmux",
    run = function(ctx)
      return checked(rex.session.new_split{
        anchor_block_id = ctx.block_id,
        direction = split_direction,
        side = "after",
        focus = true,
        layout = shell_layout(),
      })
    end,
  }
end

rex.action{
  name = "tmux_lazygit",
  title = "Open Lazygit in New Tab",
  category = "Tmux",
  run = function(ctx)
    return new_focused_tab(ctx, {
      window_label = "lazygit",
      layout = shell_layout{ command = lazygit_command() },
    })
  end,
}

rex.action{
  name = "tmux_lazygit_popup",
  title = "Open Lazygit Popup",
  category = "Tmux",
  run = function(ctx)
    local placement = checked(rex.session.describe_block{ block_id = ctx.block_id })
    return checked(rex.session.new_layer{
      window_id = placement.block.window_id,
      bounds = { 0.05, 0.025, 0.90, 0.95 },
      focus = true,
      layout = shell_layout{ command = lazygit_command() },
    })
  end,
}

rex.action{
  name = "tmux_close_pane",
  title = "Close Pane or Last-Pane Tab",
  category = "Tmux",
  run = function(ctx)
    local placement = checked(rex.session.describe_block{ block_id = ctx.block_id })
    local window_id = placement.block.window_id
    local view = checked(rex.session.view{})
    for _, window in ipairs(view.windows or {}) do
      if window.window_id == window_id then
        local count = 0
        for _, layer in ipairs(window.layers or {}) do
          count = count + #(layer.blocks or {})
        end
        if count == 1 then
          return checked(rex.session.close_window{ window_id = window_id })
        end
        rex.client.queue("pane.close")
        return
      end
    end
    error("Cannot find the focused pane's window", 0)
  end,
}

local function bind(key, action, args)
  rex.bind("ctrl+s>" .. key, action, args)
end

bind("n", "tmux_new_tab")
bind("v", "tmux_split_horizontal")
bind("b", "tmux_split_vertical")
bind("g", "tmux_lazygit")
-- Repeat tab navigation without re-entering Ctrl-S. Escape leaves the mode.
-- Rex has no tmux-style repeat timeout, so this mode stays active until exited.
rex.mode("tmux_tabs", {})
rex.bind("tmux_tabs/escape", "client.mode.exit")
rex.bind("tmux_tabs/enter", "client.mode.exit")
for key, direction in pairs({ ["]"] = "next", ["["] = "previous" }) do
  local action = "client.tab." .. direction
  local name = "tmux_tab_" .. direction
  rex.action{
    name = name,
    title = "Show " .. direction .. " Tab and Repeat",
    category = "Tmux",
    run = function(ctx)
      rex.client.queue(action)
      rex.client.queue("client.mode.enter", { name = "tmux_tabs" })
    end,
  }
  bind(key, name)
  rex.bind("tmux_tabs/" .. key, action)
end
bind("m", "pane.zoom")
bind("x", "tmux_close_pane")
bind("s", "session.switch")
bind("p", "client.palette.toggle")
-- Match tmux: prefix Ctrl-L clears the screen; standalone Ctrl-L navigates panes.
bind("ctrl+l", "pane.send_key", { key = "ctrl+l" })

-- Persistent resize mode: repeat h/j/k/l without re-entering the prefix.
rex.mode("tmux_resize", { exclusive = true })
bind("r", "client.mode.enter", { name = "tmux_resize" })
rex.bind("tmux_resize/escape", "client.mode.exit")

for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  -- Rex measures resize steps in percent, not tmux's terminal cells.
  rex.bind("tmux_resize/" .. key, "pane.resize", { direction = direction, amount = 5 })
end
