vim.opt_local.textwidth = 80

_G.org_preview_instances = _G.org_preview_instances or {}

function _G.StopOrgPreview(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local info = _G.org_preview_instances[bufnr]
  if not info then
    return
  end

  if info.job then
    pcall(vim.fn.jobstop, info.job)
  end
  if info.pid then
    pcall(vim.fn.system, "kill " .. info.pid .. " 2>/dev/null")
  end
  if info.socket then
    pcall(vim.fn.delete, info.socket)
  end
  if info.html_target then
    pcall(vim.fn.delete, info.html_target)
  end

  pcall(vim.api.nvim_del_augroup_by_name, "OrgPreview_" .. bufnr)
  _G.org_preview_instances[bufnr] = nil
end

function _G.ToggleOrgPreview()
  local cur_buf = vim.api.nvim_get_current_buf()
  local info = _G.org_preview_instances[cur_buf]

  if info then
    _G.StopOrgPreview(cur_buf)
  else
    local file_path = vim.api.nvim_buf_get_name(cur_buf)
    if file_path == "" then
      vim.notify("Org preview: Buffer has no file name", vim.log.levels.WARN)
      return
    end

    if vim.bo[cur_buf].modified and vim.fn.filereadable(file_path) == 1 then
      vim.cmd("silent update")
    end

    local html_target = "/tmp/org_preview_" .. cur_buf .. ".html"
    local socket_path = "/tmp/nyxt_org_" .. cur_buf .. ".socket"

    local res = vim.fn.system({ "pandoc", "-s", file_path, "-o", html_target })
    if vim.v.shell_error ~= 0 then
      vim.notify("Org preview: Pandoc export failed: " .. res, vim.log.levels.ERROR)
      return
    end

    local job_id = vim.fn.jobstart({
      "nyxt",
      "-s",
      socket_path,
      "file://" .. html_target,
    }, {
      detach = true,
    })

    local pid = vim.fn.jobpid(job_id)
    _G.org_preview_instances[cur_buf] = {
      job = job_id,
      pid = pid,
      socket = socket_path,
      html_target = html_target,
      file_path = file_path,
    }

    local augroup = vim.api.nvim_create_augroup("OrgPreview_" .. cur_buf, { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = augroup,
      buffer = cur_buf,
      callback = function()
        local inst = _G.org_preview_instances[cur_buf]
        if not inst then
          return
        end
        local current_path = vim.api.nvim_buf_get_name(cur_buf)
        if current_path ~= "" then
          inst.file_path = current_path
        end
        vim.fn.system({ "pandoc", "-s", inst.file_path, "-o", inst.html_target })
        pcall(vim.fn.system, {
          "nyxt",
          "-s",
          inst.socket,
          "-e",
          "(nyxt:reload-current-buffer)",
        })
      end,
    })

    vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
      group = augroup,
      buffer = cur_buf,
      callback = function()
        _G.StopOrgPreview(cur_buf)
      end,
    })
  end
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("OrgPreviewGlobalCleanup", { clear = true }),
  callback = function()
    for bufnr, _ in pairs(_G.org_preview_instances) do
      _G.StopOrgPreview(bufnr)
    end
  end,
})

vim.keymap.set("n", "<C-p>", function()
  _G.ToggleOrgPreview()
end, { buffer = true, desc = "Toggle Org Preview (Nyxt with auto-close)" })

