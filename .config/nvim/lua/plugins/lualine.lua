-- lua/plugins/lualine.lua
local engine = require("lualine.lualine_engine")

return {
	
  "nvim-lualine/lualine.nvim",
   event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        engine.apply() 
      end,
    })
    
  end,
}
