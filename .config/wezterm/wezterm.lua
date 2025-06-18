local wezterm = require 'wezterm'

return {
  font = wezterm.font_with_fallback {
    "JetBrainsMono Nerd Font",
    "FiraCode Nerd Font",
  },
  font_size = 12.0,

  color_scheme = "Catppuccin Mocha",
  window_background_opacity = 0.92,
  text_background_opacity = 1.0,
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = false,

  window_frame = {
    active_titlebar_bg = "#191924",
    inactive_titlebar_bg = "#44474a",
  },

  tab_bar_at_bottom = true,
  use_fancy_tab_bar = true,

  window_padding = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 2,
  },

  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
  },

  keys = {
    { key = "Return", mods = "ALT|SHIFT", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
    { key = " ", mods = "ALT|SHIFT", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = " ", mods = "ALT", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "Tab", mods = "ALT", action = wezterm.action.ActivateTabRelative(1) },
    { key = "n", mods = "ALT|SHIFT", action = wezterm.action.PromptInputLine {
      description = "Rename Tab",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end)
    }
  },
},
}

