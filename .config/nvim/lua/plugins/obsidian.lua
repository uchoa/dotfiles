return {
	"epwalsh/obsidian.nvim",
	version = "*",  -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
		--   "BufReadPre path/to/my-vault/**.md",
		--   "BufNewFile path/to/my-vault/**.md",
		-- },
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",

			-- see below for full list of optional dependencies 👇
		},
		opts = {
			workspaces = {
				{
					name = "notes",
					path = "~/notes",
				},
				{
					name = "no-vault",
					path = function()
						-- alternatively use the CWD:
						-- return assert(vim.fn.getcwd())
						return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
					end,
					overrides = {
						notes_subdir = vim.NIL,  -- have to use 'vim.NIL' instead of 'nil'
						completion = {
							new_notes_location = "current_dir",
						},
						templates = {
							subdir = vim.NIL,
						},
						disable_frontmatter = true,
					},
				},
			},

			-- see below for full list of options 👇
			daily_notes = {
				-- Optional, if you keep daily notes in a separate directory.
				folder = "journal",
				-- Optional, if you want to change the date format for the ID of daily notes.
				date_format = "%Y-%m-%d",
				-- Optional, if you want to change the date format of the default alias of daily notes.
				alias_format = "%B %-d, %Y",
				-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
				template = "daily-note.template.md"
			},

			templates = {
				subdir = "templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
				-- A map for custom variables, the key should be the variable and the value a function
				substitutions = {},
			},

			backlinks = {
				-- The default height of the backlinks location list.
				height = 10,
				-- Whether or not to wrap lines.
				wrap = true,
			},

			tags = {
				-- The default height of the tags location list.
				height = 10,
				-- Whether or not to wrap lines.
				wrap = true,
			},

			follow_url_func = function(url)
				-- Open the URL in the default web browser.
				vim.fn.jobstart({"open", url})  -- Mac OS
				-- vim.fn.jobstart({"xdg-open", url})  -- linux
			end,
		},
	}
