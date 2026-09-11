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