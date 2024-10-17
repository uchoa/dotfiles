local wezterm = require("wezterm")
local config = wezterm.config_builder()

config = {
	automatically_reload_config = true,
	enable_tab_bar = false,
	show_tabs_in_tab_bar = true,
	use_fancy_tab_bar = false,
	tab_max_width = 32,
	switch_to_last_active_tab_when_closing_tab = true,
	hide_tab_bar_if_only_one_tab = true,
	window_decorations = "RESIZE",
	default_cursor_style = "BlinkingBar",
	window_background_opacity = 0.94,
	-- macos_window_background_blur = 100,
	inactive_pane_hsb = {
		saturation = 0.6,
		brightness = 0.9,
	},
	window_close_confirmation = "NeverPrompt",
	font = wezterm.font("FiraCode Nerd Font"), -- -> =>
	font_size = 15,
	scrollback_lines = 5000,

	color_scheme = "rose-pine-moon",

	default_gui_startup_args = { "start", "--", "/usr/local/bin/tmux" },
}

return config
