local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- config.window_background_image = 'C:\\MET\\bg-chess.jpg'
config.window_background_image_hsb = { brightness = 0.1 }
config.default_prog = { 'C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe' }
config.default_cwd = 'C:\\Projects'
config.font = wezterm.font('JetBrains Mono')
config.font_size = 9
config.color_scheme = 'Github Dark'
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_tabs_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

local c = {
  bg      = '#16161e',
  surface = '#1f2335',
  text    = '#c0caf5',
  muted   = '#565f89',
  green   = '#9ece6a',
}
 
config.colors = {
  tab_bar = { background = c.bg },
}

config.keys = {
  {
    key = 'h',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'j',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  {
    key = 'k',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'l',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'h',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'j',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.AdjustPaneSize { 'Down', 5 },
  },
  {
    key = 'k',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.AdjustPaneSize { 'Up', 5 },
  },
  {
    key = 'l',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.AdjustPaneSize { 'Right', 5 },
  },
  {
    key = 'O',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Text = 'Yeni workspace adı (boş = otomatik isim):' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line == nil then return end
        if line == '' then
          window:perform_action(wezterm.action.SwitchToWorkspace, pane)
        else
          window:perform_action(wezterm.action.SwitchToWorkspace { name = line }, pane)
        end
      end),
    },
  },
  {
    key = 'E',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.PromptInputLine {
      description = 'Workspace yeni adı:',
      action = wezterm.action_callback(function(window, pane, line)
        if line and line ~= '' then
          wezterm.mux.rename_workspace(window:active_workspace(), line)
        end
      end),
    },
  },
  { key = 'S', mods = 'CTRL|SHIFT', action = wezterm.action.SwitchWorkspaceRelative(-1) },
  { key = 'D', mods = 'CTRL|SHIFT', action = wezterm.action.SwitchWorkspaceRelative(1) },
}

wezterm.on('update-status', function(window, pane)
  local active = window:active_workspace()
  local names = wezterm.mux.get_workspace_names()
  local items = {}

  local show = #names > 1
  local overrides = window:get_config_overrides() or {}
  if overrides.enable_tab_bar ~= show then
    overrides.enable_tab_bar = show
    window:set_config_overrides(overrides)
  end
 
  for _, name in ipairs(names) do
    if name == active then
      table.insert(items, { Foreground = { Color = c.green } })
      table.insert(items, { Attribute = { Intensity = 'Bold' } })
      table.insert(items, { Text = '● ' .. name })
    else
      table.insert(items, { Foreground = { Color = c.muted } })
      table.insert(items, { Attribute = { Intensity = 'Normal' } })
      table.insert(items, { Text = '○ ' .. name })
    end
    table.insert(items, 'ResetAttributes')
    table.insert(items, { Text = '   ' })
  end
 
  window:set_right_status(wezterm.format(items))
end)

return config
