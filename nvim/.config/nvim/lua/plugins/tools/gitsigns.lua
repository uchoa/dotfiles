return {
	src = "https://github.com/lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("gitsigns").setup({
			-- signs = {
			--   add = { text = "+" },
			--   change = { text = "~" },
			--   delete = { text = "-" },
			--   topdelete = { text = "-" },
			--   changedelete = { text = "~" },
			-- },
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				map("n", "]h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gs.nav_hunk("next")
					end
				end, { desc = "Next Hunk" })
				map("n", "[h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gs.nav_hunk("prev")
					end
				end, { desc = "Prev Hunk" })
				map("n", "]H", function()
					gs.nav_hunk("last")
				end, { desc = "Last Hunk" })
				map("n", "[H", function()
					gs.nav_hunk("first")
				end, { desc = "First Hunk" })
				map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
				map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
				map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage Buffer" })
				map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
				map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset Buffer" })
				map("n", "<leader>ghp", gs.preview_hunk_inline, { desc = "Preview Hunk Inline" })
				map("n", "<leader>ghb", function()
					gs.blame_line({ full = true })
				end, { desc = "Blame Line" })
				map("n", "<leader>ghB", function()
					gs.blame()
				end, { desc = "Blame Buffer" })
				map("n", "<leader>ghd", gs.diffthis, { desc = "Diff This" })
				map("n", "<leader>ghD", function()
					gs.diffthis("~")
				end, { desc = "Diff This ~" })
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "GitSigns Select Hunk" })
			end,
		})
	end,
}
