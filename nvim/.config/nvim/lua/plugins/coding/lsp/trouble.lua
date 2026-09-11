return {
  src = "https://github.com/folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    {
      "<leader>xb",
      function()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "marksman" })
        if #clients == 0 then
          vim.notify("Marksman is not attached", vim.log.levels.WARN)
          return
        end
        local client = clients[1]
        
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local headings = {}
        for i, line in ipairs(lines) do
          local title = string.match(line, "^#+%s+(.*)")
          if title then
            table.insert(headings, { line = i - 1, title = title })
          end
        end

        if #headings == 0 then
          vim.notify("No headings found", vim.log.levels.INFO)
          return
        end

        local results = {}
        local expected_responses = #headings
        local received_responses = 0

        for _, heading in ipairs(headings) do
          local params = {
            textDocument = vim.lsp.util.make_text_document_params(bufnr),
            position = { line = heading.line, character = 0 },
            context = { includeDeclaration = false },
          }

          client.request("textDocument/references", params, function(err, result, ctx)
            received_responses = received_responses + 1
            if not err and result and #result > 0 then
              for _, ref in ipairs(result) do
                table.insert(results, {
                  title = heading.title,
                  uri = ref.uri,
                  range = ref.range,
                })
              end
            end

            if received_responses == expected_responses then
              if #results == 0 then
                vim.notify("No backlinks found", vim.log.levels.INFO)
                return
              end

              local has_snacks, snacks = pcall(require, "snacks")
              if has_snacks and snacks.picker then
                local items = {}
                for _, res in ipairs(results) do
                  table.insert(items, {
                    text = res.title .. " (Backlink)",
                    file = vim.uri_to_fname(res.uri),
                    pos = { res.range.start.line + 1, res.range.start.character },
                  })
                end
                snacks.picker({
                  title = "Markdown Backlinks",
                  items = items,
                  format = "file",
                })
              else
                local items = {}
                for _, res in ipairs(results) do
                  table.insert(items, {
                    filename = vim.uri_to_fname(res.uri),
                    lnum = res.range.start.line + 1,
                    col = res.range.start.character + 1,
                    text = "Backlink to: " .. res.title,
                  })
                end
                vim.fn.setqflist({}, ' ', { title = "Markdown Backlinks", items = items })
                require("trouble").open("qflist")
              end
            end
          end, bufnr)
        end
      end,
      desc = "Markdown Backlinks",
    },
  },
}
