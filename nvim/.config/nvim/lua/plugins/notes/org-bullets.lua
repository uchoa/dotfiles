return {
  src = "https://github.com/nvim-orgmode/org-bullets.nvim",
  ft = "org",
  config = function()
    require("org-bullets").setup()
  end,
}
