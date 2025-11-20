return {
  options = {
    theme = nil,  -- filled by engine
    section_separators = { left = "", right = "" },
    component_separators = "",
    icons_enabled = true,
  },

  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { { "filename", path = 0 } },

    lualine_x = { "encoding" },
    lualine_y = { "filetype" },
    lualine_z = { "location" },
  },
}

