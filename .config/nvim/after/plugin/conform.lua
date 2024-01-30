local conform = require("conform")

conform.setup({
  formatters_by_ft = {
		go = { "gofumpt", "goimports-reviser", "golines" },
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- Use a sub-list to run only the first available formatter
    javascript = { { "prettierd", "prettier" } },
  },
	format_on_save = {
		lsp_fallback = true,
		timeout_ms = 500,
	},
	notify_on_error = true,
})
