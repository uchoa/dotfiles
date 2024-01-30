return {
	"kdheepak/lazygit.nvim",
	-- optional for floating window border decoration
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{"<leader>gl", "<cmd>LazyGitCurrentFile<CR>", desc = "Open LazyGit at project root"}
	}
}
