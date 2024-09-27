
return {
	-- Fuzzy Finder (files, lsp, etc)
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		-- Fuzzy Finder Algorithm which requires local dependencies to be built.
		-- Only load if `make` is available. Make sure you have the system
		-- requirements installed.
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			-- NOTE: If you are having trouble with this installation,
			--       refer to the README for telescope-fzf-native for more instructions.
			build = 'make',
			cond = function()
				return vim.fn.executable 'make' == 1
			end,
		},
	},

	config = function()
		local telescope = require('telescope')
		local builtin = require('telescope.builtin')
		-- [[ Configure Telescope ]]
		-- See `:help telescope` and `:help telescope.setup()`
		telescope.setup {
			defaults = {
				mappings = {
					i = {
						['<C-u>'] = false,
						['<C-d>'] = false,
					},
				},
			},
		}

		-- Enable telescope fzf native, if installed
		pcall(telescope.load_extension, 'fzf')

		-- Telescope live_grep in git root
		-- Function to find the git root directory based on the current buffer's path
		local function find_git_root()
			-- Use the current buffer's path as the starting point for the git search
			local current_file = vim.api.nvim_buf_get_name(0)
			local current_dir
			local cwd = vim.fn.getcwd()
			-- If the buffer is not associated with a file, return nil
			if current_file == '' then
				current_dir = cwd
			else
				-- Extract the directory from the current file's path
				current_dir = vim.fn.fnamemodify(current_file, ':h')
			end

			-- Find the Git root directory from the current file's path
			local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
			if vim.v.shell_error ~= 0 then
				print 'Not a git repository. Searching on current working directory'
				return cwd
			end
			return git_root
		end

		-- Custom live_grep function to search in git root
		local function live_grep_git_root()
			local git_root = find_git_root()
			if git_root then
				builtin.live_grep {
					search_dirs = { git_root },
				}
			end
		end

		vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

		-- See `:help telescope.builtin`
		vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] find recently opened files' })
		vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] find existing buffers' })
		vim.keymap.set('n', '<leader>/', function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
				winblend = 10,
				previewer = false,
			})
		end, { desc = '[/] fuzzily search in current buffer' })

		local function telescope_live_grep_open_files()
			builtin.live_grep {
				grep_open_files = true,
				prompt_title = 'Live Grep in Open Files',
			}
		end

		local function telescope_search_neovim_config()
			builtin.find_files { cwd = vim.fn.stdpath('config') }
		end

		vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = 'search in open files' })
		vim.keymap.set('n', '<leader>sn', telescope_search_neovim_config, { desc = 'search neovim config files' })
		vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = 'search select Telescope' })
		vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'search git files' })
		vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'search files' })
		vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'search help' })
		vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'search current word' })
		vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'search by grep' })
		vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = 'search by grep on git root' })
		vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'search diagnostics' })
		vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'search resume' })
	end
}
