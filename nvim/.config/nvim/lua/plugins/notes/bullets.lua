return {
  src = "https://github.com/bullets-vim/bullets.nvim",
  ft = { "markdown", "text", "gitcommit" },
  config = function()
    require("bullets").setup({})
  end,
}
