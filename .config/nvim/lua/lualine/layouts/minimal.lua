local M = {}

M.section_separators = { left = "", right = "" }
M.component_separators = { left = "│", right = "│" }

M.sections = {
  lualine_a = { "mode" },
  lualine_b = { "branch" },
  lualine_c = { "filename" },
  lualine_x = { "encoding", "fileformat", "filetype" },
  lualine_y = { "progress" },
  lualine_z = { "location" },
}

M.inactive_sections = {
  lualine_c = { "filename" },
  lualine_x = { "location" },
}

return M

