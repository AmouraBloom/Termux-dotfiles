local M = {}

M.section_separators   = { left = "", right = "" }
M.component_separators = { left = "", right = "" }

M.sections = {
  lualine_a = { "mode" },
  lualine_b = {},
  lualine_c = { "filename" },
  lualine_x = { "filetype" },
  lualine_y = { "progress" },
  lualine_z = { "location" },
}

M.inactive_sections = {
  lualine_c = { "filename" },
}

return M

