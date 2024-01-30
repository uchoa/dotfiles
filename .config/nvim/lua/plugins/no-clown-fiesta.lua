return {
	"no-clown-fiesta/no-clown-fiesta.nvim",
	event = "VeryLazy",
	opts = function (_, opts)
		return {
			transparent = true,
			styles = {
				-- You can set any of the style values specified for `:h nvim_set_hl`
				comments = { italic = true },
				keywords = {},
				functions = {},
				variables = {},
				type = { bold = true },
				lsp = { underline = true }
			},
		}
	end
}
