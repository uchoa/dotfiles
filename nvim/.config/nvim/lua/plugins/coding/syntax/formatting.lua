return {
  src = "https://github.com/stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        go = { "gofumpt", "godoc_wrap" },
        rust = { "rustfmt" },
        lua = { "stylua" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        json = { "prettier" },
        toml = { "tombi" },
        http = { "kulala-fmt" },
        org = { "org_wrap" },
      },
      formatters = {
        prettier = {
          command = "bunx",
          prepend_args = { "--no-install", "prettier" },
        },
        godoc_wrap = {
          format = function(self, ctx, lines, callback)
            local out = {}
            local i = 1
            local max_width = 80

            while i <= #lines do
              local line = lines[i]
              local indent, space, content = line:match("^(%s*)//( ?)(.*)$")

              if indent and not content:match("^go:") and not content:match("^%+build") and not content:match("^%s%s%s") then
                local block = {}
                while i <= #lines do
                  local c_line = lines[i]
                  local c_indent, _, c_content = c_line:match("^(%s*)//( ?)(.*)$")
                  if c_indent == indent and not c_content:match("^go:") and not c_content:match("^%+build") and not c_content:match("^%s%s%s") then
                    if vim.trim(c_content) == "" then
                      break
                    end
                    table.insert(block, c_content)
                    i = i + 1
                  else
                    break
                  end
                end

                if #block > 0 then
                  local full_text = table.concat(block, " ")
                  local words = vim.split(full_text, "%s+", { trimempty = true })
                  local prefix = indent .. "// "
                  local cur = prefix

                  for _, word in ipairs(words) do
                    if #cur + #word + (cur == prefix and 0 or 1) > max_width then
                      table.insert(out, cur)
                      cur = prefix .. word
                    else
                      cur = (cur == prefix and cur or (cur .. " ")) .. word
                    end
                  end
                  if cur ~= prefix then
                    table.insert(out, cur)
                  end
                else
                  table.insert(out, line)
                  i = i + 1
                end
              else
                table.insert(out, line)
                i = i + 1
              end
            end

            callback(nil, out)
          end,
        },
        org_wrap = {
          format = function(self, ctx, lines, callback)
            local out = {}
            local i = 1
            local n = #lines
            local max_width = 80

            while i <= n do
              local line = lines[i]

              if line:match("^%s*$") then
                table.insert(out, "")
                i = i + 1
              elseif line:match("^%s*#%+[bB][eE][gG][iI][nN]_") then
                table.insert(out, line)
                i = i + 1
                while i <= n do
                  local bline = lines[i]
                  table.insert(out, bline)
                  i = i + 1
                  if bline:match("^%s*#%+[eE][nN][dD]_") then
                    break
                  end
                end
              elseif line:match("^%*+%s") then
                table.insert(out, line)
                i = i + 1
              elseif
                line:match("^%s*:[%w_%-]+:")
                or line:match("^%s*DEADLINE:")
                or line:match("^%s*SCHEDULED:")
                or line:match("^%s*CLOSED:")
              then
                table.insert(out, line)
                i = i + 1
              elseif line:match("^%s*#%+") or line:match("^%s*#%s") or line:match("^%s*#$") then
                table.insert(out, line)
                i = i + 1
              elseif line:match("^%s*%-%-%-%-+%s*$") then
                table.insert(out, line)
                i = i + 1
              elseif line:match("^%s*|") then
                local table_lines = {}
                local indent = line:match("^(%s*)")
                while i <= n and lines[i]:match("^%s*|") do
                  table.insert(table_lines, lines[i])
                  i = i + 1
                end

                local parsed_rows = {}
                local col_widths = {}
                for _, tline in ipairs(table_lines) do
                  local content = tline:match("^%s*(.*)$")
                  if content:match("^|[%s%-%+|]+$") and content:match("%-") then
                    table.insert(parsed_rows, { is_divider = true })
                  else
                    local cells = {}
                    local inner = content:gsub("^|", ""):gsub("|$", "")
                    local raw_cells = vim.split(inner, "|", { plain = true })
                    for col_idx, cell in ipairs(raw_cells) do
                      local trimmed = vim.trim(cell)
                      table.insert(cells, trimmed)
                      local w = vim.fn.strdisplaywidth(trimmed)
                      col_widths[col_idx] = math.max(col_widths[col_idx] or 1, w)
                    end
                    table.insert(parsed_rows, { is_divider = false, cells = cells })
                  end
                end

                local num_cols = #col_widths
                for _, row in ipairs(parsed_rows) do
                  if row.is_divider then
                    local div_parts = {}
                    for c = 1, num_cols do
                      local w = col_widths[c] or 1
                      table.insert(div_parts, string.rep("-", w + 2))
                    end
                    table.insert(out, indent .. "|" .. table.concat(div_parts, "+") .. "|")
                  else
                    local cell_parts = {}
                    for c = 1, num_cols do
                      local val = row.cells[c] or ""
                      local w = col_widths[c] or 1
                      local pad = w - vim.fn.strdisplaywidth(val)
                      table.insert(cell_parts, " " .. val .. string.rep(" ", pad) .. " ")
                    end
                    table.insert(out, indent .. "|" .. table.concat(cell_parts, "|") .. "|")
                  end
                end
              elseif line:match("^%s*[%-%+]%s+") or line:match("^%s*%d+[%.)]%s+") then
                local indent, bullet, rest
                if line:match("^%s*[%-%+]%s+") then
                  indent, bullet, rest = line:match("^(%s*)([%-%+])%s+(.*)$")
                else
                  indent, bullet, rest = line:match("^(%s*)(%d+[%.)])%s+(.*)$")
                end

                local prefix = indent .. bullet .. " "
                local cont_prefix = indent .. string.rep(" ", #bullet + 1)
                local words = vim.split(rest, "%s+", { trimempty = true })
                i = i + 1

                while i <= n do
                  local next_line = lines[i]
                  if
                    next_line:match("^%s*$")
                    or next_line:match("^%*+%s")
                    or next_line:match("^%s*[%-%+]%s+")
                    or next_line:match("^%s*%d+[%.)]%s+")
                    or next_line:match("^%s*|")
                    or next_line:match("^%s*#")
                    or next_line:match("^%s*:[%w_%-]+:")
                  then
                    break
                  end
                  local next_indent = next_line:match("^(%s*)")
                  if #next_indent >= #cont_prefix then
                    local more_words = vim.split(vim.trim(next_line), "%s+", { trimempty = true })
                    for _, w in ipairs(more_words) do
                      table.insert(words, w)
                    end
                    i = i + 1
                  else
                    break
                  end
                end

                local cur = prefix
                for _, word in ipairs(words) do
                  local test_len = vim.fn.strdisplaywidth(cur) + vim.fn.strdisplaywidth(word) + (cur == prefix and 0 or 1)
                  if test_len > max_width and cur ~= prefix then
                    table.insert(out, cur)
                    cur = cont_prefix .. word
                  else
                    cur = (cur == prefix and cur or (cur .. " ")) .. word
                  end
                end
                if cur ~= "" and cur ~= prefix then
                  table.insert(out, cur)
                end
              else
                local indent = line:match("^(%s*)")
                local words = vim.split(vim.trim(line), "%s+", { trimempty = true })
                i = i + 1

                while i <= n do
                  local next_line = lines[i]
                  if
                    next_line:match("^%s*$")
                    or next_line:match("^%*+%s")
                    or next_line:match("^%s*[%-%+]%s+")
                    or next_line:match("^%s*%d+[%.)]%s+")
                    or next_line:match("^%s*|")
                    or next_line:match("^%s*#")
                    or next_line:match("^%s*:[%w_%-]+:")
                    or next_line:match("^%s*DEADLINE:")
                    or next_line:match("^%s*SCHEDULED:")
                    or next_line:match("^%s*%-%-%-%-")
                  then
                    break
                  end

                  local more_words = vim.split(vim.trim(next_line), "%s+", { trimempty = true })
                  for _, w in ipairs(more_words) do
                    table.insert(words, w)
                  end
                  i = i + 1
                end

                local cur = indent
                for _, word in ipairs(words) do
                  local test_len = vim.fn.strdisplaywidth(cur) + vim.fn.strdisplaywidth(word) + (cur == indent and 0 or 1)
                  if test_len > max_width and cur ~= indent then
                    table.insert(out, cur)
                    cur = indent .. word
                  else
                    cur = (cur == indent and cur or (cur .. " ")) .. word
                  end
                end
                if cur ~= "" and cur ~= indent then
                  table.insert(out, cur)
                end
              end
            end

            callback(nil, out)
          end,
        },
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 1000,
      },
    })

    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add({
        { "<leader>c", group = "code" },
        { "<leader>cf", function() conform.format({ async = true, lsp_fallback = true }) end, desc = "Format Buffer" },
      })
    else
      vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        conform.format({ async = true, lsp_fallback = true })
      end, { desc = "Format Buffer" })
    end
  end,
}