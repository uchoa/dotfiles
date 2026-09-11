return {
  src = "https://github.com/folke/which-key.nvim",
  lazy = false,
  config = function()
    local ok, wk = pcall(require, "which-key")
    if not ok then return end
    
    wk.setup({
      preset = "modern",
    })
    
    _G.safe_wk_add = function(spec)
      local ok_wk, wk_module = pcall(require, "which-key")
      if ok_wk then
        wk_module.add(spec)
      end
    end
  end,
}
