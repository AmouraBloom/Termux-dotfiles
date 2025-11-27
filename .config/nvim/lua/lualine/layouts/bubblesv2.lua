-- ~/.config/nvim/lua/lualine/layouts/bubblesv2.lua

local layout = {}

-- separators expected by your engine
layout.section_separators = { left = "", right = "" }
layout.component_separators = "" 

-- sections
layout.sections = {
  lualine_a = {
    {
      "mode",
      separator = { left = "" },
      right_padding = 2,
    },
  },

  lualine_b = { "filename", "branch" },

  lualine_c = {
    "%=",
  },

  lualine_x = {},

  lualine_y = { "filetype", "progress" },

  lualine_z = {
    {
      "location",
      separator = { right = "" },
      left_padding = 2,
    },
  },
}

-- inactive sections
layout.inactive_sections = {
  lualine_a = { "filename" },
  lualine_b = {},
  lualine_c = {},
  lualine_x = {},
  lualine_y = {},
  lualine_z = { "location" },
}

return layout
