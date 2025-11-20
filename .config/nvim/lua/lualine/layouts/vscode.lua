local M = {}

M.section_separators   = ""
M.component_separators = ""

M.sections = {
  lualine_a = { "mode" },
  lualine_b = {},
  lualine_c = { { "filename", path = 1 } },
  lualine_x = { "filetype" },
  lualine_y = {},
  lualine_z = { "location" },
}

M.inactive_sections = {
  lualine_c = { "filename" },
}

return M

