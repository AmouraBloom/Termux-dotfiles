local M = {}

M.section_separators = { left = "█", right = "█" }
M.component_separators = { left = "│", right = "│" }

M.sections = {
  lualine_a = { "mode" },
  lualine_b = { "branch" },
  lualine_c = {},
  lualine_x = {},
  lualine_y = { "filetype" },
  lualine_z = { "location" },
}

M.inactive_sections = {
  lualine_c = {},
  lualine_x = {},
}

return M

