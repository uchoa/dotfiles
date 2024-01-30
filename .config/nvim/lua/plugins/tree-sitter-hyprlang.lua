return {
  "luckasRanarison/tree-sitter-hyprlang",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      require("nvim-treesitter.parsers").get_parser_configs().hyprlang = {
        install_info = {
          url = "https://github.com/luckasRanarison/tree-sitter-hyprlang",
          files = { "src/parser.c" },
          branch = "master",
        },
        filetype = "hyprlang",
      }

      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "hyprlang" })
    end,
  },
  enabled = function()
    -- return have("hypr")
		return true
  end,
  event = "BufRead */hypr/*.conf",
}
