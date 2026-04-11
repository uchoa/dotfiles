-- local opts = {
-- 	theme = "dark",
-- 	transparent = true,
-- 	styles = {
-- 		comments = { italic = true },
-- 		type = { bold = true },
-- 		lsp = { underline = false },
-- 		match_paren = { underline = true },
-- 	},
-- }
--
-- local function config()
-- 	local plugin = require("no-clown-fiesta")
--
-- 	local loaded = plugin.load(opts)
--
-- 	-- Set colors for the active status line
-- 	-- vim.api.nvim_set_hl(0, "StatusLine", { fg = "#eaeaea", bg = "#040421", ctermfg = "white", ctermbg = "darkgrey" })
--
-- 	-- Set colors for inactive status lines (in non-current windows)
-- 	-- vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#a0a0a0", bg = "#222222", ctermfg = "lightgrey", ctermbg = "grey" })
--
-- 	-- You can also link a highlight group to another existing group
-- 	-- vim.api.nvim_set_hl(0, "StatusLineNC", { link = "Normal" })
--
-- 	return loaded
-- end
--
-- return {
-- 	"aktersnurra/no-clown-fiesta.nvim",
-- 	priority = 1000,
-- 	config = config,
-- 	lazy = false,
-- }

local setColorScheme = function(cs)
	vim.cmd.colorscheme(cs)

	-- transparent background
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
	vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
end

return {
	{
		"gbprod/nord.nvim",
		enabled = false,
		lazy = false,
		priority = 1000,
		config = function()
			require("nord").setup({
				transparent = true,
				styles = {
					comments = { italic = true },
				},
			})
			setColorScheme("nord")
		end,
	},
	{
		"askfiy/visual_studio_code",
		enabled = true,
		priority = 100,
		config = function()
			local vscode = require("visual_studio_code")
			-- vscode.get_lualine_sections()
			vscode.setup({
				mode = "dark",
				transparent = true,
				hooks = {
					after = function(_conf, _colors, _utils)
						local function set_hl_style(group, styles)
							local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
							local merged = vim.tbl_extend("force", hl, styles) --[[@as vim.api.keyset.highlight]]
							vim.api.nvim_set_hl(0, group, merged)
						end

						-- Apply styles to both standard and Treesitter groups
						set_hl_style("Comment", { italic = true })
						set_hl_style("@comment", { italic = true })

						set_hl_style("Keyword", { bold = true })
						set_hl_style("@keyword", { bold = true })

						set_hl_style("@markup.italic", { italic = true })
						set_hl_style("@markup.strong", { bold = true })
						set_hl_style("@markup.heading", { bold = true })

						set_hl_style("@text.emphasis", { italic = true })
						set_hl_style("@text.strong", { bold = true })
					end,
				},
			})
			setColorScheme("visual_studio_code")

			-- vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })
			-- vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", ctermbg = "NONE" })
			vim.api.nvim_set_hl(0, "StatusLine", { bg = "#222222", ctermbg = "NONE" })
			vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#222222", ctermbg = "NONE" })
		end,
	},
}
