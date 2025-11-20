local M = {}

M.section_separators   = { left = "", right = "" }
M.component_separators = "|"

M.sections = {
  lualine_a = {
    { "mode", separator = { left = "", right = "" } },
  },
  lualine_b = {},
  lualine_c = { { "filename", path = 1 } },
  lualine_x = { "encoding", "filetype" },
  lualine_y = { "progress" },
  lualine_z = { "location" },
}

M.inactive_sections = {
  lualine_c = { "filename" },
}

return M

