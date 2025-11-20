local colors = {
    red     = "#ff5f5f",
    black   = "#1c1c1c",
    white   = "#ffffff",
    gray    = "#3a3a3a",
}

-- Evil mode component
local evil_mode = {
    function()
        return ""
    end,
    color = function()
        local mode = vim.fn.mode()
        local mode_color = {
            n = colors.red,
            i = "#5fff87",
            v = "#5fafff",
            V = "#5fafff",
            c = "#ffd75f",
        }
        return { fg = colors.black, bg = mode_color[mode] or colors.gray }
    end,
    padding = { left = 1, right = 1 },
}

local simple_sep_left  = ""
local simple_sep_right = ""

return {
    options = {
        theme = nil,      --change →"auto"         -- theme loaded by engine
        globalstatus = true,
        component_separators = "",
        section_separators = {
            left = simple_sep_left,
            right = simple_sep_right
        },
    },

    sections = {
        lualine_a = { evil_mode },

        lualine_b = {
            { "branch", icon = "" },
            { "diff" },
        },

        lualine_c = {
            {
                "filename",
                path = 1,
                symbols = { modified = " ", readonly = " " },
            },
        },

        lualine_x = {
            "encoding",
            "filetype",
        },

        lualine_y = { "location" },
        lualine_z = { "progress" },
    },

    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
}

