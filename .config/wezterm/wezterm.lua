local wezterm = require "wezterm"

local is_darwin = wezterm.target_triple:find "darwin" ~= nil
local is_linux = wezterm.target_triple:find "linux" ~= nil

local config = wezterm.config_builder()
config.color_scheme = "Catppuccin Frappe"
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.font_size = 16
config.enable_scroll_bar = false

if is_darwin then
    config.window_padding = {
        left = 10,
        right = 10,
        top = 0,
        bottom = 0,
    }

    config.send_composed_key_when_left_alt_is_pressed = true
    config.send_composed_key_when_right_alt_is_pressed = true
end

config.initial_cols = 110
config.initial_rows = 34
config.window_close_confirmation = "NeverPrompt"

if is_linux then
    config.window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    }

    config.enable_wayland = false
    config.default_prog = { "fish" }
    config.window_decorations = "RESIZE"
    config.initial_cols = 100
    config.initial_rows = 30
end

return config
