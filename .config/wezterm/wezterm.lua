local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action
local os = require 'os'


local move_around = function(window, pane, direction_wez, direction_nvim)
  local result = os.execute("env NVIM_LISTEN_ADDRESS=/tmp/nvim0" .. pane:pane_id() .. " " .. wezterm.home_dir .. "/go/bin/wezterm.nvim.navigator" .. " " .. direction_nvim)
  if result then
  window:perform_action(
      act({ SendString = "\x17" .. direction_nvim }),
      pane
    )
  else
    window:perform_action(
      act({ ActivatePaneDirection = direction_wez }),
      pane
    )
  end
end

wezterm.on("move-left", function(window, pane)
	move_around(window, pane, "Left", "h")
end)

wezterm.on("move-right", function(window, pane)
	move_around(window, pane, "Right", "l")
end)

wezterm.on("move-up", function(window, pane)
	move_around(window, pane, "Up", "k")
end)

wezterm.on("move-down", function(window, pane)
	move_around(window, pane, "Down", "j")
end)

-- wezterm.on('update-status', function(window, pane)
-- 	local activeTabTitle = window:active_tab():get_title()
-- 	window:set_left_status(activeTabTitle)
-- 	window:set_right_status("right")
-- end)

config = {
	-- SET LEADER KEY TO Ctrl-A
	leader = {
		key = 'a',
		mods = 'CTRL',
		timeout_milliseconds = math.maxinteger,
	},
	-- CUSTOM KEY BINDINGS
	keys = {
		-- CTRL + (h,j,k,l) to move between panes
		{
			key = 'h',
			mods = 'CTRL',
			action = act({ EmitEvent = "move-left" }),
		},
		{
			key = 'j',
			mods = 'CTRL',
			action = act({ EmitEvent = "move-down" }),
		},
		{
			key = 'k',
			mods = 'CTRL',
			action = act({ EmitEvent = "move-up" }),
		},
		{
			key = 'l',
			mods = 'CTRL',
			action = act({ EmitEvent = "move-right" }),
		},
		-- ALT + (h,j,k,l) to resize panes
		{
			key = 'h',
			mods = 'ALT',
			action = act.AdjustPaneSize { 'Left', 2 },
		},
		{
			key = 'j',
			mods = 'ALT',
			action = act.AdjustPaneSize { 'Down', 1 },
		},
		{
			key = 'k',
			mods = 'ALT',
			action = act.AdjustPaneSize { 'Up', 1 },
		},
		{
			key = 'l',
			mods = 'ALT',
			action = act.AdjustPaneSize { 'Right', 2 },
		},
		{
			-- |
			key = 's',
			mods = 'LEADER',
			action = act.PaneSelect { mode = 'SwapWithActiveKeepFocus' }
		},
		{
			-- SET COPY MODE
			key = '[',
			mods = 'LEADER',
			action = act.ActivateCopyMode,
		},
		{
			key = 'm',
			mods = 'LEADER',
			action = act.TogglePaneZoomState,
		},
		{
			key = 'c',
			mods = 'LEADER',
			action = act.SpawnTab 'CurrentPaneDomain',
		},
		{
			key = 'n',
			mods = 'LEADER',
			action = act.ActivateTabRelative(1),
		},
		{
			key = 'p',
			mods = 'LEADER',
			action = act.ActivateTabRelative(-1),
		},
		{
			key = ',',
			mods = 'LEADER',
			action = act.PromptInputLine {
				description = 'Enter new name for tab',
				action = wezterm.action_callback(
					---@diagnostic disable-next-line: unused-local
					function(window, pane, line)
						if line then
							window:active_tab():set_title(line)
						end
					end
				),
			},
		},
		{
			key = 'w',
			mods = 'LEADER',
			action = act.ShowTabNavigator,
		},
		-- Close tab
		{
			key = '&',
			mods = 'LEADER|SHIFT',
			action = act.CloseCurrentTab{ confirm = true },
		},
		-- Vertical split
		{
			-- |
			key = '|',
			mods = 'LEADER|SHIFT',
			action = act.SplitPane {
				direction = 'Right',
				size = { Percent = 50 },
			},
		},
		-- Horizontal split
		{
			-- -
			key = '-',
			mods = 'LEADER',
			action = act.SplitPane {
				direction = 'Down',
				size = { Percent = 50 },
			},
		},
	},
	automatically_reload_config = true,
	enable_tab_bar = true,
	show_tabs_in_tab_bar = true,
	use_fancy_tab_bar = false,
	tab_max_width = 32,
	switch_to_last_active_tab_when_closing_tab = true,
	-- hide_tab_bar_if_only_one_tab = true,
	window_decorations = 'RESIZE',
	default_cursor_style = 'BlinkingBar',
	window_background_opacity = 0.4,
	macos_window_background_blur = 100,
	inactive_pane_hsb = {
		saturation = 0.6,
		brightness = 0.9,
	},
	window_close_confirmation = 'NeverPrompt',
	font = wezterm.font('InconsolataGo Nerd Font Mono'),
	font_size = 18,
	scrollback_lines = 5000,

	color_scheme = 'Vs Code Dark+ (Gogh)',
}

return config
