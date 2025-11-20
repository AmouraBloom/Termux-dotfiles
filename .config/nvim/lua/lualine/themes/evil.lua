local colors = {
    bg       = "#1c1c1c",
    fg       = "#d0d0d0",
    red      = "#ff5f5f",
    blue     = "#5fafff",
    green    = "#5fd787",
    yellow   = "#ffd75f",
    black    = "#000000",
}

return {
    normal = {
        a = { fg = colors.black, bg = colors.blue },
        b = { fg = colors.fg,    bg = colors.bg },
        c = { fg = colors.fg,    bg = colors.bg },
    },

    insert = { a = { fg = colors.black, bg = colors.green } },
    visual = { a = { fg = colors.black, bg = colors.yellow } },
    replace = { a = { fg = colors.black, bg = colors.red } },

    inactive = {
        a = { fg = colors.fg, bg = colors.bg },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
    },
}

