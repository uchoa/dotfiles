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
				title = "󰗚",
				author = "󰰄",
				date = "󰃭",
			},
		},
	},
	{
		"timantipov/md-table-tidy.nvim",
		-- default config
		opts = {
			padding = 1, -- number of spaces for cell padding
			-- keymap = {
			-- 	table_tidy = "<leader>tt", -- key for command :TableTidy<CR>
			-- 	table_tidy_all = "<leader>ta", -- key for command :TableTidyAll<CR>
			-- },
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
				position = "inline",
			},
			indent = {
				enabled = true,
				skip_heading = true,
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
					vim.keymap.set(
						"n",
						"<C-p>",
						"<cmd>PeekToggle<CR>",
						{ buffer = ev.buf, silent = true, desc = "Toggle Peek Preview" }
					)
				end,
				group = group,
			})
		end,
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = function()
			local cwd = vim.fn.getcwd()
			local templates_folder = vim.fn.expand("~/.templates")
			if vim.fn.isdirectory(cwd .. "/docs/.templates") == 1 then
				templates_folder = cwd .. "/docs/.templates"
			else
				if vim.fn.isdirectory(templates_folder) == 0 then
					vim.fn.mkdir(templates_folder, "p")
				end
			end

			return {
				workspaces = {
					{
						name = "project",
						path = function()
							return vim.fn.getcwd()
						end,
					},
				},
				preferred_link_style = "markdown",
				disable_frontmatter = true,
				ui = { enable = false },
				templates = {
					folder = templates_folder,
					date_format = "%Y-%m-%d",
					time_format = "%H:%M",
					substitutions = {
						title = function()
							return vim.fn.expand("%:t:r")
						end,
						date = function()
							return os.date("%Y-%m-%d")
						end,
					},
				},
			}
		end,
		config = function(_, opts)
			require("obsidian").setup(opts)

			vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
				pattern = "**/adr/*.md",
				callback = function(args)
					local bufnr = args.buf
					-- Only trigger if the buffer is empty
					local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
					if #lines == 0 or (#lines == 1 and lines[1] == "") then
						-- Schedule it to ensure obsidian is fully attached and ready
						vim.schedule(function()
							-- Check if file exists, we don't want to override existing ADRs
							if vim.fn.filereadable(vim.api.nvim_buf_get_name(bufnr)) == 0 then
								vim.cmd("ObsidianTemplate adr")
							end
						end)
					end
				end,
			})
		end,
	},
}
