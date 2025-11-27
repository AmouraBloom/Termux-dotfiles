local M = {}

----------------------------------------------------------
-- Defaults
----------------------------------------------------------
M.current_theme  = "tokyonight"
M.current_layout = "evil1"

-- Save file
local state_file = vim.fn.stdpath("state") .. "/lualine_state.json"

----------------------------------------------------------
-- JSON Save/Load
----------------------------------------------------------
local function save_state()
  local tbl = {
    theme  = M.current_theme,
    layout = M.current_layout,
  }
  vim.fn.writefile({ vim.fn.json_encode(tbl) }, state_file)
end

local function load_state()
  if vim.fn.filereadable(state_file) == 1 then
    local raw = vim.fn.readfile(state_file)
    local ok, decoded = pcall(vim.fn.json_decode, raw[1])
    if ok and decoded then
      M.current_theme  = decoded.theme or M.current_theme
      M.current_layout = decoded.layout or M.current_layout
    end
  end
end

----------------------------------------------------------
-- Safe require helper
----------------------------------------------------------
local function safe_require(path)
  local ok, mod = pcall(require, path)
  if not ok then
    return nil
  end
  return mod
end

----------------------------------------------------------
-- Loaders
----------------------------------------------------------

-- Built-in Lualine themes list
local builtin_themes = {
    "auto","16color","ayu_dark","ayu_light","codedark","dracula",
    "everforest","gruvbox","gruvbox_dark","gruvbox_light","horizon",
    "iceberg","jellybeans","material","modus_vivendi","molokai",
    "nightfly","nord","OceanicNext","onedark","palenight",
    "papercolor_dark","papercolor_light","powerline_dark","powerline",
    "seoul256","solarized_dark","solarized_light","tokyonight",
}

-- Now using:
--   lua/lualine/themes/<name>.lua
--   lua/lualine/layouts/<name>.lua

local function load_theme(name)
  local custom = safe_require("lualine.themes." .. name)
  if custom then
    return custom
  end
  return name
end

local function load_layout(name)
  return safe_require("lualine.layouts." .. name)
end

----------------------------------------------------------
-- Apply final config
----------------------------------------------------------
function M.apply()
  local theme  = load_theme(M.current_theme)
  local layout = load_layout(M.current_layout)

  if not layout then
    vim.notify("Lualine layout not found: " .. M.current_layout, vim.log.levels.ERROR)
    return
  end

  require("lualine").setup({
    options = {
      theme = theme,
      globalstatus = true,
      icons_enabled = true,
      section_separators = layout.section_separators,
      component_separators = layout.component_separators,
    },
    sections = layout.sections,
    inactive_sections = layout.inactive_sections,
  })
end

----------------------------------------------------------
-- API
----------------------------------------------------------
function M.set_theme(name)
  M.current_theme = name
  save_state()
  M.apply()
end

function M.set_layout(name)
  M.current_layout = name
  save_state()
  M.apply()
end

----------------------------------------------------------
-- Autocomplete helpers
----------------------------------------------------------
local function list_custom(subdir)
  local base = vim.fn.stdpath("config") .. "/lua/lualine/" .. subdir
  local items = vim.fn.readdir(base)

  for i, f in ipairs(items) do
    items[i] = f:gsub("%.lua$", "")
  end

  return items
end

local function list_themes()
  local custom = list_custom("themes")
  return vim.tbl_extend("force", builtin_themes, custom)
end

local function list_layouts()
  return list_custom("layouts")
end

----------------------------------------------------------
-- Commands
----------------------------------------------------------
vim.api.nvim_create_user_command("LualineTheme", function(opts)
  M.set_theme(opts.args)
end, {
  nargs = 1,
  complete = function() return list_themes() end,
})

vim.api.nvim_create_user_command("LualineLayout", function(opts)
  M.set_layout(opts.args)
end, {
  nargs = 1,
  complete = function() return list_layouts() end,
})

----------------------------------------------------------
-- Startup
----------------------------------------------------------
load_state()

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function() M.apply() end,
})

return M

