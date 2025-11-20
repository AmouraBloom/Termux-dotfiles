local M = {}

M.section_separators = { left = "", right = "" }
M.component_separators = { left = " ", right = " " }

M.sections = {
  lualine_a = { { "mode", separator = { left = "", right = "" } } },
  lualine_b = { { "branch", separator = { left = "", right = "" } } },
  lualine_c = {},
  lualine_x = {},
  lualine_y = { { "progress", separator = { left = "", right = "" } } },
  lualine_z = { { "location", separator = { left = "", right = "" } } },
}

M.inactive_sections = {
  lualine_c = {},
  lualine_x = {},
}

return M

