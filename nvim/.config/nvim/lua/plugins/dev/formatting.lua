vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text", "yaml" },
	callback = function()
		vim.opt_local.textwidth = 80
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = { "markdown" },
			callback = function()
				-- This runs the command to tidy all tables in the buffer before saving
				vim.cmd("TableTidyAll")
			end,
		})
	end,
})

return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				go = { "gofumpt" },
				zig = { "zig fmt" },
				javascript = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				yaml = { "prettier" },
				toml = { "tombi" },
				http = { "kulala-fmt" },
				markdown = { "prettier_markdown" },
				lua = { "stylua" },
				python = { "isort", "black" },
			},
			formatters = {
				prettier_markdown = {
					command = "prettier",
					args = { "--prose-wrap", "always", "--print-width", "80", "--stdin-filepath", "$FILENAME" },
				},
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>cf", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "format file or range (in visual mode)" })
	end,
}
