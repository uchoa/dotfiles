return {
	-- Add indentation lines even on blank lines
	'lukas-reineke/indent-blankline.nvim',
	event = { 'BufReadPre', 'BufNewFile' },
	-- Enable `lukas-reineke/indent-blankline.nvim`
	-- See `:help ibl`
	main = 'ibl',
	opts = {
		indent = {
			char = "▏",
			-- tab_char = "│",
			smart_indent_cap = true,
			repeat_linebreak = true,
		},
		-- scope = { show_start = true, show_end = false },
		scope = { enabled = false },
		exclude = {
			filetypes = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
			},
		},
	}
}
