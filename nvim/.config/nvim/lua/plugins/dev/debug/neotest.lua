return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		{ "fredrikaverpil/neotest-golang", version = "*" },
		"lawrence-laz/neotest-zig",
	},
	config = function()
		local neotest = require("neotest")
		---@diagnostic disable-next-line: missing-fields
		neotest.setup({
			adapters = {
				require("neotest-golang")({}), -- Registration
				require("neotest-zig")({
					dap = {
						adapter = "lldb",
					},
				}),
			},
		})

		vim.keymap.set("n", "<leader>tr", function()
			neotest.output_panel.clear()
			neotest.run.run()
		end, { desc = "Run nearest test" })
		vim.keymap.set("n", "<leader>tR", function()
			neotest.run.stop()
		end, { desc = "Stop nearest test" })
		vim.keymap.set("n", "<leader>td", function()
			neotest.output_panel.clear()
			-- Debugs only the test under the cursor
			neotest.run.run({ suite = false, strategy = "dap" })
		end, { desc = "Debug nearest test" })
		vim.keymap.set("n", "<leader>tf", function()
			neotest.output_panel.clear()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "Run the current file" })
		vim.keymap.set("n", "<leader>ta", function()
			neotest.output_panel.clear()
			neotest.run.run(vim.fn.getcwd())
		end, { desc = "Run all tests in the workspace" })
		vim.keymap.set("n", "<leader>ts", function()
			neotest.summary.toggle()
		end, { desc = "Toggle test summary" })
		vim.keymap.set("n", "<leader>to", function()
			neotest.output_panel.toggle()
		end, { desc = "Toggle output panel" })
		vim.keymap.set("n", "<leader>tc", function()
			neotest.output_panel.clear()
		end, { desc = "Clear output panel" })
	end,
}
