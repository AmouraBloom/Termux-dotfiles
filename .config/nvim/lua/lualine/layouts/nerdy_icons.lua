local M = {}

M.section_separators = { left = "", right = "" }
M.component_separators = { left = "", right = "" }

M.sections = {
  lualine_a = { { "mode", icon = "" } },
  lualine_b = { { "branch", icon = "" } },
  lualine_c = { { "filename", path = 1, icon = "", symbols = { modified = "" } } },
  lualine_x = { { "diagnostics", icon = "" } },
  lualine_y = { { "filetype", icon_only = true },"encoding" },
  lualine_z = { "location" },
}

M.inactive_sections = {
  lualine_c = { "filename" }
}

return M

