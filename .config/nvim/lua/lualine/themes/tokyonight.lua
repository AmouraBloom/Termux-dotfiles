-- tokyonight_custom.lua
-- Minimal theme that matches real Tokyonight colors

local colors = {
  bg       = "#1a1b26",
  fg       = "#c0caf5",
  blue     = "#7aa2f7",
  cyan     = "#7dcfff",
  green    = "#9ece6a",
  yellow   = "#e0af68",
  red      = "#f7768e",
  magenta  = "#bb9af7",
  gray     = "#414868",
}

return {
  normal = {
    a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
    b = { fg = colors.fg, bg = colors.gray },
    c = { fg = colors.fg, bg = colors.bg },
  },

  insert  = { a = { fg = colors.bg, bg = colors.green,  gui = "bold" } },
  visual  = { a = { fg = colors.bg, bg = colors.magenta, gui = "bold" } },
  replace = { a = { fg = colors.bg, bg = colors.red,     gui = "bold" } },
  command = { a = { fg = colors.bg, bg = colors.yellow, gui = "bold" } },

  inactive = {
    a = { fg = colors.fg, bg = colors.bg, gui = "bold" },
    b = { fg = colors.fg, bg = colors.bg },
    c = { fg = colors.fg, bg = colors.bg },
  },
}
