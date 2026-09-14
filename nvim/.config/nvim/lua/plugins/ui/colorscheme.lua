return {
	src = "https://github.com/aktersnurra/no-clown-fiesta.nvim",
	priority = 1000,
	config = function()
		require("no-clown-fiesta").setup({
			transparent = true,
		})

		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = function()
				vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#444444" })
				vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#888888", bold = true })
				vim.api.nvim_set_hl(0, "StatusLine", { fg = "#d9d9d9", bg = "#2d2d2d" })
				vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#888888", bg = "#1a1a1a" })

				local transparent_groups = { "Normal", "NormalFloat", "FloatBorder", "Pmenu" }
				for _, group in ipairs(transparent_groups) do
					vim.api.nvim_set_hl(0, group, { bg = "none" })
				end
			end,
		})

		vim.cmd([[colorscheme no-clown-fiesta]])
	end,
}
