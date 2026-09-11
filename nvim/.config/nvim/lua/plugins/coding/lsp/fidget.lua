return {
  src = "https://github.com/j-hui/fidget.nvim",
  event = "LspAttach",
  config = function()
    require("fidget").setup({})
  end,
}
