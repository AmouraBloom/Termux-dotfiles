-- lua/plugins/init.lua

require("lazy").setup({

  -----------------------------------------------------
  -- LUALINE (loaded from its own file)
  -----------------------------------------------------
  require("plugins.lualine"),

  -----------------------------------------------------
  -- Treesitter
  -----------------------------------------------------
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

  -----------------------------------------------------
  -- Colorscheme
  -----------------------------------------------------
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -----------------------------------------------------
  -- Other plugins
  -----------------------------------------------------

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

}, {
  -----------------------------------------------------
  -- Lazy UI icons
  -----------------------------------------------------
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤",
    },
  },
})

-------------------------------------------------------
-- Custom Lualine Health Command
-------------------------------------------------------
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
