vim.opt_local.textwidth = 80
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    pcall(vim.cmd, "TableTidyAll")
  end,
})
