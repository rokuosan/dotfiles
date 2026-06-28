local wezterm = require("wezterm")
local act = wezterm.action

wezterm.on("bell", function(window, pane)
  local title = pane:get_title() or "WezTerm"
  local message = "Terminal bell at " .. wezterm.strftime("%H:%M:%S")
  window:toast_notification(title, message, nil, 4000)
end)

local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
  "CaskaydiaMono Nerd Font Mono",
  "UDEV Gothic 35NF",
})
config.font_size = 16
config.harfbuzz_features = {
  "calt=0",
  "dlig=0",
  "liga=0",
}

config.color_scheme = "Tokyo Night Moon"

config.window_background_opacity = 1.0
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.initial_cols = 160
config.initial_rows = 48

config.hide_tab_bar_if_only_one_tab = true
config.notification_handling = "AlwaysShow"
config.term = "xterm-256color"
config.quit_when_all_windows_are_closed = true

config.keys = {
  {
    key = "d",
    mods = "CMD",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "d",
    mods = "CMD|SHIFT",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "]",
    mods = "CMD",
    action = act.ActivatePaneDirection("Next"),
  },
  {
    key = "[",
    mods = "CMD",
    action = act.ActivatePaneDirection("Prev"),
  },
  {
    key = "Enter",
    mods = "SHIFT",
    action = act.SendString("\n"),
  },
}

return config
