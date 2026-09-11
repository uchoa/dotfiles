vim.g.mkdp_node_path = "bun"

vim.cmd([[
  function! OpenInSplit(url)
    execute 'vsplit | terminal terminal-browser ' . fnameescape(a:url)
  endfunction
]])
vim.g.mkdp_browserfunc = "OpenInSplit"

return {
  src = "https://github.com/iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview" },
  ft = "markdown",
  build = "cd app && bun install",
  config = function()
    vim.keymap.set("n", "<C-p>", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Markdown Preview Toggle" })
  end,
}
