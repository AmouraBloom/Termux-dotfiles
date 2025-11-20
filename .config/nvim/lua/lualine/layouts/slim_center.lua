local M = {}

M.section_separators = { left = "", right = "" }
M.component_separators = { left = " ", right = " " }

M.sections = {
  lualine_a = {},
  lualine_b = { "mode" },
  lualine_c = {},
  lualine_x = {},
  lualine_y = { "filename" },
  lualine_z = { "location" },
}

M.inactive_sections = {
  lualine_c = { "filename" },
}

return M

