local opts = {
	theme = "dark",
	transparent = true,
	styles = {
		comments = { italic = true },
		type = { bold = true },
		lsp = { underline = false },
		match_paren = { underline = true },
	},
}

local function config()
	local plugin = require("no-clown-fiesta")

	local loaded = plugin.load(opts)

	-- Set colors for the active status line
	vim.api.nvim_set_hl(0, "StatusLine", { fg = "#eaeaea", bg = "#040421", ctermfg = "white", ctermbg = "darkgrey" })

	-- Set colors for inactive status lines (in non-current windows)
	vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#a0a0a0", bg = "#222222", ctermfg = "lightgrey", ctermbg = "grey" })

	-- You can also link a highlight group to another existing group
	-- vim.api.nvim_set_hl(0, "StatusLineNC", { link = "Normal" })

	return loaded
end

return {
	"aktersnurra/no-clown-fiesta.nvim",
	priority = 1000,
	config = config,
	lazy = false,
}
