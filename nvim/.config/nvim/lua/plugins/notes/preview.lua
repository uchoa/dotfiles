vim.g.mkdp_node_path = "bun"

local preview_instances = {}

function _G.OpenNyxtPreview(url)
  local cur_buf = vim.api.nvim_get_current_buf()
  local socket_path = "/tmp/nyxt_mkdp_" .. cur_buf .. ".socket"

  -- Spawn Nyxt with dedicated socket and track its process
  local job_id = vim.fn.jobstart({
    "nyxt",
    "-s", socket_path,
    url,
  }, {
    detach = true,
  })

  local pid = vim.fn.jobpid(job_id)
  preview_instances[cur_buf] = {
    job = job_id,
    pid = pid,
    socket = socket_path,
  }
end

function _G.ToggleNyxtPreview()
  local cur_buf = vim.api.nvim_get_current_buf()
  local info = preview_instances[cur_buf]

  if info and info.pid then
    -- Close Nyxt window and terminate the instance
    pcall(vim.fn.jobstop, info.job)
    pcall(vim.fn.system, "kill " .. info.pid .. " 2>/dev/null")
    pcall(vim.fn.delete, info.socket)
    preview_instances[cur_buf] = nil
    pcall(vim.fn["mkdp#util#stop_preview"])
  else
    pcall(vim.fn["mkdp#util#open_preview_page"])
  end
end

vim.cmd([[
  function! OpenNyxtBrowser(url)
    call v:lua.OpenNyxtPreview(a:url)
  endfunction
]])
vim.g.mkdp_browserfunc = "OpenNyxtBrowser"

return {
  src = "https://github.com/iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = "markdown",
  build = "cd app && bun install",
  config = function()
    vim.keymap.set("n", "<C-p>", function()
      _G.ToggleNyxtPreview()
    end, { desc = "Toggle Markdown Preview (Nyxt with auto-close)" })
  end,
}
