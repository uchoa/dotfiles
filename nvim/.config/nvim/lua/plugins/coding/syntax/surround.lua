return {
  src = "https://github.com/kylechui/nvim-surround",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("nvim-surround").setup({})
  end,
}