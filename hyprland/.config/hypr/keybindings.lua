local M = {}

function M.set(programs)
	programs = programs or {}
	local terminal = programs.terminal or "ghostty"
	local fileManager = programs.fileManager or "yazi"
	local menu = programs.menu or "noctalia msg panel-open launcher"

	---------------------
	---- KEYBINDINGS ----
	---------------------

	local mainMod = "SUPER" -- Sets "Windows" key as main modifier

	-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
	hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
	local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
	-- closeWindowBind:set_enabled(false)
	-- hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
	hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("noctalia msg panel-open session"))
	hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
	hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
	hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
	hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
	hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

	-- Move focus with mainMod + arrow keys
	hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
	hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
	hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
	hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

	-- Swap active window with neighbor in direction with mainMod + SHIFT + arrow keys
	hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "left" }))
	hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
	hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.swap({ direction = "up" }))
	hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.swap({ direction = "down" }))

	-- Switch workspaces with mainMod + [0-9]
	-- Move active window to a workspace with mainMod + SHIFT + [0-9]
	for i = 1, 10 do
		local key = i % 10 -- 10 maps to key 0
		hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
		hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
	end

	-- Example special workspace (scratchpad)
	hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
	hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

	-- Scroll through existing workspaces with mainMod + scroll
	hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
	hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

	-- Notes Mode Submap
	hl.bind(mainMod .. " + SHIFT + N", hl.dsp.submap("notes"))
	hl.define_submap("notes", function()
		local captureCmd = [[ghostty --class=note.taking -e nvim -c "lua vim.schedule(require('org-roam').api.capture_node)"]]
		local findCmd = [[ghostty --class=note.taking -e nvim -c "lua vim.schedule(require('org-roam').api.find_node)"]]

		local function run_and_reset(cmd)
			return function()
				hl.dispatch(hl.dsp.submap("reset"))
				hl.dispatch(hl.dsp.exec_cmd(cmd))
			end
		end

		hl.bind("c", run_and_reset(captureCmd))
		hl.bind("f", run_and_reset(findCmd))
		hl.bind("escape", hl.dsp.submap("reset"))
		hl.bind("return", hl.dsp.submap("reset"))
	end)

	-- Move/resize windows with mainMod + LMB/RMB and dragging
	hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
	hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

	-- Laptop multimedia keys for volume and LCD brightness
	hl.bind(
		"XF86AudioRaiseVolume",
		hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
		{ locked = true, repeating = true }
	)
	hl.bind(
		"XF86AudioLowerVolume",
		hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
		{ locked = true, repeating = true }
	)
	hl.bind(
		"XF86AudioMute",
		hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
		{ locked = true, repeating = true }
	)
	hl.bind(
		"XF86AudioMicMute",
		hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
		{ locked = true, repeating = true }
	)
	hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -n6553 set 10%+"), { locked = true, repeating = true })
	hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -n6553 set 10%-"), { locked = true, repeating = true })

	-- Requires playerctl
	hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
	hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
	hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
	hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
end

return M
