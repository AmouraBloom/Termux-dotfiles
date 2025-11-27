local M = {}

M.section_separators = { left = "", right = "" }
--M.component_separators = { left = "", right = "" }
--M.component_seperators = {left = "|", right = "|"}

M.sections = {
  lualine_a = { "mode" },
  lualine_b = { { "branch", icon = "" }, "diff" },
  lualine_c = { { "filename", path = 1, symbols = { modified = "" } } },
  lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
  lualine_y = { "progress" },
  lualine_z = { "location" },
}

M.inactive_sections = {
  lualine_c = { "filename" },
  lualine_x = { "location" },
}

return M

