-- lua/lualine/health_checker.lua
-- v3: robust, colorized, verbose, floating-window report
local M = {}

-- --------------------
-- Utilities
-- --------------------
local function safe_require(mod)
  local ok, result = pcall(require, mod)
  if not ok then
    return nil, result -- result is the error message
  end
  return result, nil
end

local function file_exists(path)
  return vim.fn.filereadable(path) == 1
end

local function dir_exists(path)
  return vim.fn.isdirectory(path) == 1
end

local function list_dir(path)
  local ok = dir_exists(path)
  if not ok then return {} end
  return vim.fn.readdir(path)
end

local function pretty(v)
  return vim.inspect(v, { depth = 3 })
end

-- --------------------
-- Highlight groups (idempotent)
-- --------------------
local function define_hls()
  -- safe: don't error if set_hl missing
  pcall(vim.api.nvim_set_hl, 0, "LualineHealthTitle", { fg = "#5fd7ff", bold = true })
  pcall(vim.api.nvim_set_hl, 0, "LualineHealthOK",    { fg = "#00ff5f", bold = true })
  pcall(vim.api.nvim_set_hl, 0, "LualineHealthWARN",  { fg = "#ffd75f", bold = true })
  pcall(vim.api.nvim_set_hl, 0, "LualineHealthERR",   { fg = "#ff5f5f", bold = true })
  pcall(vim.api.nvim_set_hl, 0, "LualineHealthInfo",  { fg = "#c7c7ff" })
end

-- --------------------
-- Validators
-- --------------------

-- Validate engine (reads engine values but does not modify)
local function validate_engine()
  local engine, err = safe_require("lualine.lualine_engine")
  if not engine then
    return { ok = false, level = "err", msg = "Cannot require engine: " .. tostring(err), detail = err }
  end

  local need = { "current_theme", "current_layout", "apply" }
  for _, k in ipairs(need) do
    if engine[k] == nil then
      return { ok = false, level = "err", msg = ("Engine missing field: %s"):format(k) }
    end
  end

  return { ok = true, level = "ok", msg = "Engine loaded", meta = { current_theme = engine.current_theme, current_layout = engine.current_layout } }
end

-- Validate a layout module by name (e.g. "evil1" => require "lualine.layouts.evil1")
local function validate_layout_module(name)
  local modname = "lualine.layouts." .. name
  local mod, err = safe_require(modname)
  if not mod then
    return { ok = false, level = "err", msg = ("Failed to load layout '%s': %s"):format(name, tostring(err)), detail = err }
  end

  -- If module returns non-table, consider invalid
  if type(mod) ~= "table" then
    return { ok = false, level = "err", msg = ("Layout '%s' did not return a table (type=%s)"):format(name, type(mod)) }
  end

  -- Required fields for layout
  if type(mod.sections) ~= "table" then
    return { ok = false, level = "err", msg = ("Layout '%s' missing 'sections' table"):format(name), detail = pretty(mod) }
  end
  if type(mod.inactive_sections) ~= "table" then
    -- `inactive_sections` occasionally omitted; warn but not fatal
    return { ok = true, level = "warn", msg = ("Layout '%s' missing 'inactive_sections' (recommended)"):format(name) }
  end

  -- Check common keys for separators (not required but helpful)
  if mod.section_separators == nil or mod.component_separators == nil then
    -- not fatal, warn
    return { ok = true, level = "warn", msg = ("Layout '%s' missing separator fields (section/component)"):format(name) }
  end

  -- Validate that sections contain tables / valid components (best-effort)
  local function validate_section(sec, entries)
    if type(entries) ~= "table" then
      return { ok = false, level = "err", msg = ("Layout '%s' section '%s' should be table"):format(name, sec) }
    end
    -- check entries types
    for i, comp in ipairs(entries) do
      local t = type(comp)
      if t ~= "string" and t ~= "function" and t ~= "table" then
        return { ok = false, level = "err", msg = ("Layout '%s' section '%s' component[%d] invalid type: %s"):format(name, sec, i, t) }
      end
    end
    return nil
  end

  for secname, entries in pairs(mod.sections) do
    local bad = validate_section(secname, entries)
    if bad then return bad end
  end

  return { ok = true, level = "ok", msg = ("Layout '%s' valid"):format(name) }
end

-- Validate a theme module by name (e.g. "dark" => require "lualine.themes.dark")
-- Note: built-in themes (lualine's internal) will not be found in config path; caller may treat absence as builtin ok
local function validate_theme_module(name)
  local modname = "lualine.themes." .. name
  local mod, err = safe_require(modname)
  if not mod then
    -- module not found in user folder; attempt to see if it's a builtin theme by checking lualine's themes table
    local ok, lualine = pcall(require, "lualine")
    if ok and lualine and lualine.get_config then
      -- cannot reliably enumerate builtin themes from lualine since API differs; assume builtin if not found locally
      return { ok = true, level = "info", msg = ("Theme '%s' not found in config; assuming builtin or external"):format(name) }
    end
    return { ok = false, level = "err", msg = ("Failed to load theme '%s': %s"):format(name, tostring(err)), detail = err }
  end

  if type(mod) ~= "table" then
    return { ok = false, level = "err", msg = ("Theme '%s' did not return a table (type=%s)"):format(name, type(mod)) }
  end

  -- Try a best-effort set of expected color groups (the shape varies, warn if missing many)
  local expected = { "normal", "insert", "visual", "replace", "command" }
  local missing = {}
  for _, k in ipairs(expected) do
    if mod[k] == nil then table.insert(missing, k) end
  end

  if #missing > 0 then
    return { ok = true, level = "warn", msg = ("Theme '%s' missing groups: %s"):format(name, table.concat(missing, ", ")) }
  end

  return { ok = true, level = "ok", msg = ("Theme '%s' valid"):format(name) }
end

-- --------------------
-- File / folder scanners
-- --------------------
local function scan_layout_names()
  local base = vim.fn.stdpath("config") .. "/lua/lualine/layouts"
  if not dir_exists(base) then return {} end
  local items = list_dir(base)
  local out = {}
  for _, f in ipairs(items) do
    if f:match("%.lua$") then
      out[#out+1] = f:gsub("%.lua$", "")
    end
  end
  table.sort(out)
  return out
end

local function scan_theme_names()
  local base = vim.fn.stdpath("config") .. "/lua/lualine/themes"
  if not dir_exists(base) then return {} end
  local items = list_dir(base)
  local out = {}
  for _, f in ipairs(items) do
    if f:match("%.lua$") then
      out[#out+1] = f:gsub("%.lua$", "")
    end
  end
  table.sort(out)
  return out
end

-- --------------------
-- Reporting helpers
-- --------------------
local function make_win(lines, title)
  define_hls()

  -- try floating window, fall back to new split
  local ok, api = pcall(function()
    return vim.api
  end)
  if not ok then
    -- fallback
    vim.cmd("new")
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    return bufnr
  end

  -- create scratch buffer
  local bufnr = vim.api.nvim_create_buf(false, true)
  local width = math.min(100, math.max(50, math.floor(vim.o.columns * 0.7)))
  local height = math.min(20, math.max(8, math.floor(vim.o.lines * 0.5)))
  local row = math.floor((vim.o.lines - height) / 2 - 1)
  local col = math.floor((vim.o.columns - width) / 2)

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

  local win_opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
  }

  local winnr = nil
  local ok2, err = pcall(function()
    winnr = vim.api.nvim_open_win(bufnr, true, win_opts)
  end)
  if not ok2 then
    -- fallback: open split
    vim.api.nvim_set_current_buf(bufnr)
    return bufnr
  end

  -- return buf id
  return bufnr
end

local function add_line(bufnr, text, hlgroup)
  if not bufnr then return end
  local last = vim.api.nvim_buf_line_count(bufnr)
  vim.api.nvim_buf_set_lines(bufnr, last, last, false, { text })
  if hlgroup then
    vim.api.nvim_buf_add_highlight(bufnr, -1, hlgroup, last, 0, -1)
  end
end

-- --------------------
-- Main runner
-- --------------------
-- verbose: boolean (if true include details & errors)
function M.run(verbose)
  verbose = not not verbose

  local results = {}
  results.engine = validate_engine()

  -- If engine loaded, also extract names it references (best-effort)
  local engine_mod = nil
  if results.engine.ok then
    engine_mod = safe_require("lualine.lualine_engine")
  end

  -- Layouts to check: if engine gives current_layout, check that first, then all files
  local layout_names = scan_layout_names()
  local theme_names = scan_theme_names()

  -- If engine provided current layout / theme, prioritize it in list
  if engine_mod and engine_mod.current_layout then
    local cur = engine_mod.current_layout
    if type(cur) == "string" then
      table.insert(layout_names, 1, cur)
    end
  end
  if engine_mod and engine_mod.current_theme then
    local cur = engine_mod.current_theme
    if type(cur) == "string" then
      table.insert(theme_names, 1, cur)
    end
  end

  -- De-duplicate lists
  local function dedupe(t)
    local seen = {}
    local out = {}
    for _, v in ipairs(t) do
      if v and not seen[v] then seen[v] = true out[#out+1] = v end
    end
    return out
  end
  layout_names = dedupe(layout_names)
  theme_names = dedupe(theme_names)

  -- Validate layouts
  results.layouts = {}
  if #layout_names == 0 then
    results.layouts.summary = { ok = false, level = "err", msg = "No layout files found" }
  else
    for _, name in ipairs(layout_names) do
      local r = validate_layout_module(name)
      table.insert(results.layouts, { name = name, res = r })
    end
  end

  -- Validate themes
  results.themes = {}
  if #theme_names == 0 then
    results.themes.summary = { ok = false, level = "warn", msg = "No theme files found (might be using builtin themes)" }
  else
    for _, name in ipairs(theme_names) do
      local r = validate_theme_module(name)
      table.insert(results.themes, { name = name, res = r })
    end
  end

  -- State file
  local state_file = vim.fn.stdpath("state") .. "/lualine_state.json"
  if file_exists(state_file) then
    local raw = vim.fn.readfile(state_file)
    local ok, decoded = pcall(vim.fn.json_decode, raw[1])
    if not ok then
      results.state = { ok = false, level = "err", msg = "State JSON invalid", detail = decoded }
    else
      results.state = { ok = true, level = "ok", msg = "State loaded", detail = decoded }
    end
  else
    results.state = { ok = false, level = "warn", msg = "State file missing (first run is OK)" }
  end

  -- Build report lines and display
  local lines = {}
  lines[#lines+1] = " LUALINE HEALTH REPORT"
  lines[#lines+1] = "────────────────────────────────────────"
  lines[#lines+1] = ""

  local function push_status(prefix, res)
    local marker = (res.level == "ok") and "✔" or ((res.level == "warn") and "⚠" or "✘")
    local line = string.format("%s %s — %s", marker, prefix, res.msg or "")
    lines[#lines+1] = line
    if verbose and res.detail then
      lines[#lines+1] = ("    detail: %s"):format(tostring(res.detail))
    end
  end

  -- Engine
  push_status("Engine", results.engine)

  lines[#lines+1] = ""
  lines[#lines+1] = "Layouts:"
  if results.layouts.summary then
    push_status("  Layouts (summary)", results.layouts.summary)
  else
    for _, entry in ipairs(results.layouts) do
      local label = ("  %s"):format(entry.name)
      push_status(label, entry.res)
    end
  end

  lines[#lines+1] = ""
  lines[#lines+1] = "Themes:"
  if results.themes.summary then
    push_status("  Themes (summary)", results.themes.summary)
  else
    for _, entry in ipairs(results.themes) do
      local label = ("  %s"):format(entry.name)
      push_status(label, entry.res)
    end
  end

  lines[#lines+1] = ""
  lines[#lines+1] = "State:"
  push_status("  State file", results.state)

  lines[#lines+1] = ""
  lines[#lines+1] = ("Run: :LualineHealth [verbose]   (verbose=%s)"):format(tostring(verbose))
  lines[#lines+1] = ""

  -- show in floating window
  local bufnr = make_win(lines, "Lualine Health")
  -- highlight lines by scanning them
  local nlines = vim.api.nvim_buf_line_count(bufnr)
  for i = 0, nlines - 1 do
    local text = vim.api.nvim_buf_get_lines(bufnr, i, i+1, false)[1] or ""
    if text:match("^✔") then
      vim.api.nvim_buf_add_highlight(bufnr, -1, "LualineHealthOK", i, 0, -1)
    elseif text:match("^⚠") then
      vim.api.nvim_buf_add_highlight(bufnr, -1, "LualineHealthWARN", i, 0, -1)
    elseif text:match("^✘") then
      vim.api.nvim_buf_add_highlight(bufnr, -1, "LualineHealthERR", i, 0, -1)
    elseif text:match("^ LUALINE HEALTH REPORT") or text:match("^─") then
      vim.api.nvim_buf_add_highlight(bufnr, -1, "LualineHealthTitle", i, 0, -1)
    end
  end

  -- If verbose, also write details to :messages for easier copy/paste
  if verbose then
    vim.schedule(function()
      vim.notify("LualineHealth: verbose output shown in floating window", vim.log.levels.INFO)
    end)
  end

  return results
end

-- --------------------
-- Completion helper for command
-- --------------------
function M.complete(arg)
  local opts = { "verbose", "layouts", "themes", "engine", "state", "all" }
  if not arg or arg == "" then return opts end
  local out = {}
  for _, v in ipairs(opts) do
    if v:match("^" .. vim.pesc(arg)) then out[#out+1] = v end
  end
  return out
end

return M
