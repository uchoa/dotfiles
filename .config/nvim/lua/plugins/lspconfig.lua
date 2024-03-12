-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', function()
    vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
  end, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

return {
	-- LSP Configuration & Plugins
	'neovim/nvim-lspconfig',
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{
			'williamboman/mason.nvim',
			dependencies = {
				{
					'WhoIsSethDaniel/mason-tool-installer.nvim',
					opts = {
						ensure_installed = {
							'gopls',
							'templ'
						},
						-- if set to true this will check each tool for updates. If updates
						-- are available the tool will be updated. This setting does not
						-- affect :MasonToolsUpdate or :MasonToolsInstall.
						-- Default: false
						auto_update = false,

						-- automatically install / update on startup. If set to false nothing
						-- will happen on startup. You can use :MasonToolsInstall or
						-- :MasonToolsUpdate to install tools and check for updates.
						-- Default: true
						run_on_start = true,

						-- set a delay (in ms) before the installation starts. This is only
						-- effective if run_on_start is set to true.
						-- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
						-- Default: 0
						start_delay = 3000, -- 3 second delay

						-- Only attempt to install if 'debounce_hours' number of hours has
						-- elapsed since the last time Neovim was started. This stores a
						-- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
						-- This is only relevant when you are using 'run_on_start'. It has no
						-- effect when running manually via ':MasonToolsInstall' etc....
						-- Default: nil
						debounce_hours = 5, -- at least 5 hours between attempts to install/update
					}
				}
			},
			config = true,
		},
		'williamboman/mason-lspconfig.nvim',

		-- Useful status updates for LSP
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ 'j-hui/fidget.nvim', opts = {} },

		-- Additional lua configuration, makes nvim stuff amazing!
		'folke/neodev.nvim'
	},

	config = function()
		-- mason-lspconfig requires that these setup functions are called in this order
		-- before setting up the servers.
		require('mason').setup()
		require('mason-lspconfig').setup()

		-- local lsputil = require 'lspconfig/util'
		-- local rootPattern = lsputil.root_pattern('go.work', 'go.mod', '.git')
		local servers = {
			-- clangd = {},
			gopls = {
				-- cmd = { 'gopls' },
				-- filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
				-- templateExtensions = { 'gotmpl' },
				-- root_dir = lsputil.root_pattern('go.work', 'go.mod', '.git'),
				completeUnimported = true,
				usePlaceholders = true,
				analyses = {
					unusedparams = true,
					unusedvariable = true,
					unusedwrite = true,
				},
			},
			templ = { },
			-- pyright = {},
			-- rust_analyzer = {},
			-- tsserver = {},
			-- html = { filetypes = { 'html', 'twig', 'hbs'} },
			marksman = {},
			lua_ls = {
				filetypes = { 'lua' },
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
					-- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
					-- diagnostics = { disable = { 'missing-fields' } },
				},
			},
		}

		-- Setup neovim lua configuration
		require('neodev').setup()

		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

		-- Ensure the servers above are installed
		local mason_lspconfig = require 'mason-lspconfig'

		mason_lspconfig.setup {
			ensure_installed = vim.tbl_keys(servers)
		}

		mason_lspconfig.setup_handlers {
			function(server_name)
				local lspconfig = require('lspconfig')
				lspconfig[server_name].setup {
					capabilities = capabilities,
					on_attach = on_attach,
					settings = servers[server_name],
					filetypes = (servers[server_name] or {}).filetypes,
				}
				-- if server_name == 'gopls' then
				-- 	local lsputil = require 'lspconfig/util'
				-- 	lspconfig.gopls.root_dir = lsputil.root_pattern('go.work', 'go.mod', '.git')
				-- end
				-- if server_name == 'templ' then
				-- 	local lsputil = require 'lspconfig/util'
				-- 	lspconfig.templ.root_dir = lsputil.root_pattern('go.work', 'go.mod', '.git')
				-- end
			end
		}

		vim.filetype.add({
			pattern = { [".*%.templ"] = "templ" },
		})
	end
}

