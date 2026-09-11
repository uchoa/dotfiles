local function mode()
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_map = {
    n = "N", i = "I", v = "V", V = "V", ["\22"] = "V",
    c = "C", R = "R", t = "T",
  }
  return mode_map[current_mode] or current_mode
end

local function git()
  local dict = vim.b.gitsigns_status_dict
  if not dict then return "" end
  local res = dict.head or ""
  if dict.added and dict.added > 0 then res = res .. " +" .. dict.added end
  if dict.changed and dict.changed > 0 then res = res .. " ~" .. dict.changed end
  if dict.removed and dict.removed > 0 then res = res .. " -" .. dict.removed end
  return res == "" and res or "[" .. res .. "]"
end

local function lsp()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return "" end
  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  return "[" .. table.concat(names, ",") .. "]"
end

local function diag()
  local counts = vim.diagnostic.count(0)
  local err = counts[vim.diagnostic.severity.ERROR] or 0
  local warn = counts[vim.diagnostic.severity.WARN] or 0
  local info = counts[vim.diagnostic.severity.INFO] or 0
  local hint = counts[vim.diagnostic.severity.HINT] or 0
  local res = {}
  if err > 0 then table.insert(res, "E:" .. err) end
  if warn > 0 then table.insert(res, "W:" .. warn) end
  if info > 0 then table.insert(res, "I:" .. info) end
  if hint > 0 then table.insert(res, "H:" .. hint) end
  if #res == 0 then return "" end
  return "[" .. table.concat(res, " ") .. "]"
end

local function filepath()
  local path = vim.fn.expand("%:p:.")
  if path == "" then return "[No Name]" end
  return path
end

_G.Statusline = function()
  local m = mode()
  local file = filepath()
  local modified = vim.bo.modified and "[+]" or ""
  local readonly = vim.bo.readonly and "[RO]" or ""
  local g = git()
  local d = diag()
  local l = lsp()
  
  return string.format(
    " %%#StatusLine# %s %%* %s %s%s %s %%= %s %s %%l:%%c %%p%%%% ",
    m, file, modified, readonly, g, d, l
  )
end

vim.opt.statusline = "%!v:lua.Statusline()"

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local status_group = augroup("StatusLineGroup", {})
autocmd({ "LspAttach", "LspDetach", "DiagnosticChanged" }, {
  group = status_group,
  callback = function()
    vim.cmd.redrawstatus()
  end,
})
