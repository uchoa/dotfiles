return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main", -- Required for the 2026 rewrite
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
		"windwp/nvim-ts-autotag",
	},
	config = function()
		--
		-- 1. Setup core Treesitter engine
		require("nvim-treesitter.config").setup({
			highlight = { enable = true },
			indent = { enable = true },
		})

		--
		-- 2. Setup textobjects separately (Required in 2026 main branch)
		require("nvim-treesitter-textobjects").setup({
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
					["af"] = "@function.outer",
					["if"] = "@function.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
				goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
			},
		})

		--
		-- 3. Install Parsers silently
		local ensure_installed = {
			"c",
			"go",
			"gotmpl",
			"lua",
			"python",
			"tsx",
			"javascript",
			"typescript",
			"json",
			"vimdoc",
			"vim",
			"bash",
			"html",
			"css",
			"http",
			"gitignore",
			"dockerfile",
			"yaml",
			"toml",
			"markdown",
			"markdown_inline",
			"hyprlang",
		}

		-- Filter to only install what is missing to avoid 'Press Enter' prompts
		local installed = require("nvim-treesitter.config").get_installed()
		local to_install = vim.iter(ensure_installed)
			:filter(function(p)
				return not vim.tbl_contains(installed, p)
			end)
			:totable()

		if #to_install > 0 then
			require("nvim-treesitter").install(to_install)
		end

		--
		-- 4. Filetype detection
		vim.filetype.add({
			extension = { gohtml = "gotmpl" },
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}
