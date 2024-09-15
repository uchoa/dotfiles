local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config = {
	automatically_reload_config = true,
	enable_tab_bar = false,
	window_decorations = 'RESIZE',
	default_cursor_style = 'BlinkingBar',
	window_background_opacity = 0.95,
	window_close_confirmation = 'NeverPrompt',
	font = wezterm.font('InconsolataGo Nerd Font Mono'),
	font_size = 18,

	color_scheme = 'Vs Code Dark+ (Gogh)',

	--default_prog = { 'tmux' },
}

return config
