-- [[ Configure LSP ]]
local servers = {
	lua_ls = {
		diagnostics = {
			globals = { "vim" },
		},
		completion = {
			callSnippet = "Replace",
		},
	},
	gopls = {
		completeUnimported = true,
		usePlaceholders = true,
		analyses = {
			unusedparams = true,
			unusedvariable = true,
			unusedwrite = true,
		},
	},
	htmx = {},
	jsonls = {},
	spectral = {},
	terraformls = {},
	marksman = {},
}

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
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "rename")
	-- nmap('<leader>ca', function()
	--   vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
	-- end, '[C]ode [A]ction')
	nmap("<leader>ca", vim.lsp.buf.code_action, "code action")

	nmap("gd", require("telescope.builtin").lsp_definitions, "goto gefinition")
	nmap("gr", require("telescope.builtin").lsp_references, "goto references")
	nmap("gI", require("telescope.builtin").lsp_implementations, "goto implementation")
	nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "type definition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "document symbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "workspace symbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "hover documentation")
	nmap("<C-S-K>", vim.lsp.buf.signature_help, "signature documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "goto declaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "workspace add folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "workspace remove folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "workspace list folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

return {
	-- LSP Configuration & Plugins
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		-- Useful status updates for LSP
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup([])`
		{ "j-hui/fidget.nvim", opts = {} },
		"folke/neodev.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},

	config = function()
		-- Specify how the border looks like
		local border = {
			{ "┌", "FloatBorder" },
			{ "─", "FloatBorder" },
			{ "┐", "FloatBorder" },
			{ "│", "FloatBorder" },
			{ "┘", "FloatBorder" },
			{ "─", "FloatBorder" },
			{ "└", "FloatBorder" },
			{ "│", "FloatBorder" },
		}

		-- Add the border on hover and on signature help popup window
		local handlers = {
			["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
			["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
		}

		-- Add border to the diagnostic popup window
		vim.diagnostic.config({
			virtual_text = {
				prefix = "■ ", -- Could be '●', '▎', 'x', '■', , 
			},
			float = {
				border = "single",
			},
		})

		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local neodev = require("neodev")

		-- mason-lspconfig requires that these setup functions are called in this order
		-- before setting up the servers.
		mason.setup()
		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
		})
		-- Setup neovim lua configuration
		neodev.setup()

		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

		mason_lspconfig.setup_handlers({
			function(server_name)
				local lspconfig = require("lspconfig")
				lspconfig[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = servers[server_name],
					filetypes = (servers[server_name] or {}).filetypes,
					handlers = handlers,
				})
			end,
		})
	end,
}
