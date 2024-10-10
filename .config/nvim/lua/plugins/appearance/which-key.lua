return {
	"folke/which-key.nvim",
	opts = {},
	config = function()
		local wk = require("which-key")
		wk.add({
			{ "<leader>", group = "<leader>" },
			{ "<leader>b", group = "buffer" },
			{ "<leader>b_", hidden = true },
			{ "<leader>c", group = "code" },
			{ "<leader>c_", hidden = true },
			{ "<leader>d", group = "debugger" },
			{ "<leader>d_", hidden = true },
			{ "<leader>f", group = "find / file" },
			{ "<leader>f_", hidden = true },
			{ "<leader>g", group = "git" },
			{ "<leader>g_", hidden = true },
			{ "<leader>n", group = "notes (zk)" },
			{ "<leader>n_", hidden = true },
			{ "<leader>s", group = "split" },
			{ "<leader>s_", hidden = true },
			-- 	{ '<leader>h', group = 'git hunk' },
			-- 	{ '<leader>h_', hidden = true },
			{ "<leader>w", group = "workspace" },
			{ "<leader>w_", hidden = true },
			{ "<leader>x", group = "trouble" },
			{ "<leader>x_", hidden = true },
		})
	end,
}
