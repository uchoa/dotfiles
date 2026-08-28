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
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = "cd app && bun install",
		config = function()
			vim.g.mkdp_browser = "/bin/surf"
			vim.keymap.set("n", "<C-p>", "<cmd>MarkdownPreviewToggle<CR>")
		end,
	},
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*",
		ft = "markdown",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- legacy_commands is deprecated, use move from commands like `ObsidianBacklinks` to `Obsidian backlinks`
		-- and set `opts.legacy_commands` to false to get rid of this warning.
		-- see https://github.com/obsidian-nvim/obsidian.nvim/wiki/Commands for details.
		--      instead.
		-- Feature will be removed in obsidian.nvim 4.0
		opts = function()
			local cwd = vim.fn.getcwd()
			local templates_folder = ".templates"
			if vim.fn.isdirectory(cwd .. "/docs/.templates") == 1 then
				templates_folder = "docs/.templates"
			end

			return {
				workspaces = {
					{
						name = "notebook",
						path = vim.fn.expand("~/.notebook"),
					},
					{
						name = "uch",
						path = vim.fn.expand("~/.notebook/work/uch"),
					},
					{
						name = "begen",
						path = vim.fn.expand("~/.notebook/work/begen"),
					},
					{
						name = "scienti",
						path = vim.fn.expand("~/.notebook/work/scienti"),
					},
					{
						name = "personal",
						path = vim.fn.expand("~/.notebook/personal"),
					},
				},
				legacy_commands = false,
				daily_notes = {
					folder = "personal/journal",
					date_format = "%Y-%m-%d",
					template = "journal.md",
				},
				link = { style = "markdown" },
				frontmatter = { enabled = true },
				ui = { enable = true },
				templates = {
					folder = templates_folder,
					date_format = "%Y-%m-%d",
					time_format = "%H:%M",
					substitutions = {
						title = function()
							local name = vim.fn.expand("%:t:r")
							return name:gsub("^%d%d%d%d%-%d%d%-%d%d%-?", "")
						end,
						date = function()
							return os.date("%Y-%m-%d")
						end,
						author = "André Uchôa",
						["extra.author"] = "André Uchôa",
						['format-date now "%Y-%m-%d"'] = function()
							return os.date("%Y-%m-%d")
						end,
						["format-date now"] = function()
							return os.date("%Y-%m-%d")
						end,
						['format-date now "full"'] = function()
							return os.date("%A, %B %d, %Y")
						end,

						["extra.tag"] = function()
							local path = vim.fn.expand("%:p")
							if path:find("/work/uch") then
								return "uch"
							elseif path:find("/work/begen") then
								return "begen"
							elseif path:find("/work/scienti") then
								return "scienti"
							else
								return "personal"
							end
						end,

						["extra.tags"] = function()
							local path = vim.fn.expand("%:p")
							local tags = { "meeting" }

							if path:find("/work/uch") then
								table.insert(tags, "uch")
							elseif path:find("/work/begen") then
								table.insert(tags, "begen")
							elseif path:find("/work/scienti") then
								table.insert(tags, "scienti")
							else
								table.insert(tags, "personal")
							end

							return table.concat(tags, ", ")
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
