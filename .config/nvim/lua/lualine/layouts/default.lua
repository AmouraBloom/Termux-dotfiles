return{
      options = {
        theme = "nil",
        section_separators = { left = '', right = ''},
        component_separators = { left = '', right = ''},
        globalstatus = true,
        disabled_filetypes = { "NvimTree", "lazy" },
      },

      sections = {
        lualine_a = { { "mode", icon = "" } },
        lualine_b = { { "branch", icon = "" }, "diff" },
        lualine_c = { { "filename", path = 1, symbols = { modified = "" } } },
        lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    }
