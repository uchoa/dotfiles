return {
	{
		"bullets-vim/bullets.vim", -- Pointing to the official organization
		ft = { "markdown", "text" },
		config = function()
			vim.g.bullets_enabled_file_types = { "markdown", "text" }
		end,
	},
	{
		"ray-x/yamlmatter.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			-- Customize icons for your YAML keys
			icon_mappings = {
				title = '󰗚',
				author = '󰰄',
				date = '󰃭',
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown", "quarto", "Avante" },
		opts = {
			heading = {
				icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
				signs = { "󰫎 " },
			},
		},
	},
	{
		"toppair/peek.nvim",
		event = { "BufReadPost *.md", "BufNewFile *.md" },
		build = "deno task build:fast",
		config = function()
			local peek = require("peek")
			peek.setup({
				app = "webview",
			})
			vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
			vim.api.nvim_create_user_command("PeekClose", peek.close, {})
			vim.api.nvim_create_user_command("PeekToggle", function()
				if peek.is_open() then
					peek.close()
				else
					peek.open()
				end
			end, {})
			local group = vim.api.nvim_create_augroup("markdown_autocommands", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "markdown" }, -- here you can add additional filetypes
				callback = function(ev)
					-- actual mapping
					vim.keymap.set("n", "<C-p>", "<cmd>PeekToggle<CR>", { buffer = ev.buf, silent = true, desc = "Toggle Peek Preview" })
				end,
				group = group,
			})
		end,
	},
}
