require("lazy").setup({
	  require("plugins.lualine"),

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        ensure_installed = {
          "lua",
          "python",
          "javascript",
          "c",
          "json",
        },
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("plugins.lualine")
  end,
  },
  
  
vim.api.nvim_create_user_command("LualineHealth", function(opts)
  local hc = require("lualine.health_checker")
  hc.run(opts.args)
end, {
  nargs = "?",
  complete = function(arg)
    local hc = require("lualine.health_checker")
    return hc.complete(arg)
  end,
})

})

