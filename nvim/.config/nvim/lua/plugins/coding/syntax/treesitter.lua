return {
  src = "https://github.com/nvim-treesitter/nvim-treesitter",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("nvim-treesitter").setup({})
    
    local ts = require("nvim-treesitter")

    -- Auto-install missing parsers on-demand when opening an uninstalled filetype,
    -- and activate native syntax highlighting + foldexpr once the parser is ready.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local filetype = vim.bo[args.buf].filetype
        local buftype = vim.bo[args.buf].buftype
        if filetype == "" or buftype ~= "" or filetype:match("^blink%-cmp") then return end

        local lang = vim.treesitter.language.get_lang(filetype) or filetype
        local installed = ts.get_installed()

        if not vim.list_contains(installed, lang) then
          pcall(ts.install, lang)
        end

        local ok, parser = pcall(vim.treesitter.get_parser, args.buf)
        if ok and parser then
          pcall(vim.treesitter.start, args.buf)
          vim.opt_local.foldmethod = "expr"
          vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
      end,
    })
  end,
}