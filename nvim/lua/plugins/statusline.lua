-- internal state for toggles
local state = {
  show_path = true,
  show_branch = true,
}

-- config for placeholders + highlighting
local config = {
  icons = {
    path_hidden = "",
    branch_hidden = "",
  },
  git_add_hl = "StatusGitAdd",
  git_delete_hl = "StatusGitDelete",
  git_change_hl = "StatusGitChange",

  hint_hl = "DiagnosticHint",
  info_hl = "DiagnosticInfo",
  warning_hl = "DiagnosticWarn",
  error_hl = "DiagnosticError",

  placeholder_hl = "StatusLineDim",
  normal_hl = "StatusNormal",
  command_hl = "StatusCommand",
  terminal_hl = "StatusTerminal",
  insert_hl = "StatusInsert",
  replace_hl = "StatusReplace",
  visual_line_hl = "StatusVisualLine",
  visual_block_hl = "StatusVisualBlock",
  replacep_pending_hl = "StatusReplacePending",
  visual_hl = "StatusVisual",
}

-- Mode icons
local mode_icons = {
  n = { text = " N ", hl = config.normal_hl },
  c = { text = " C ", hl = config.command_hl },
  t = { text = " T ", hl = config.terminal_hl },
  i = { text = " I ", hl = config.insert_hl },
  R = { text = " R ", hl = config.replace_hl },
  V = { text = "V-L", hl = config.visual_line_hl },
  [""] = { text = "V-B", hl = config.visual_block_hl }, -- Visual Block
  r = { text = "R-P", hl = config.replacep_pending_hl },
  v = { text = " V ", hl = config.visual_hl },
}

local colors = require("tokyonight.colors").setup()
vim.api.nvim_set_hl(0, config.git_add_hl, { fg = colors.green }) -- create if missing
vim.api.nvim_set_hl(0, config.git_change_hl, { fg = colors.yellow }) -- create if missing
vim.api.nvim_set_hl(0, config.git_delete_hl, { fg = colors.red }) -- create if missing

vim.api.nvim_set_hl(0, config.normal_hl, { fg = colors.fg_light, bg = colors.blue7 }) -- create if missing
vim.api.nvim_set_hl(0, config.command_hl, { fg = colors.fg_dark, bg = colors.purple }) -- create if missing
vim.api.nvim_set_hl(0, config.terminal_hl, { fg = colors.fg_dark, bg = colors.green2 }) -- create if missing
vim.api.nvim_set_hl(0, config.insert_hl, { fg = colors.fg_dark, bg = colors.green }) -- create if missing
vim.api.nvim_set_hl(0, config.replace_hl, { fg = colors.fg_dark, bg = colors.red1 }) -- create if missing
vim.api.nvim_set_hl(0, config.visual_line_hl, { fg = colors.fg_dark, bg = colors.yellow }) -- create if missing
vim.api.nvim_set_hl(0, config.visual_block_hl, { fg = colors.fg_dark, bg = colors.yellow }) -- create if missing
vim.api.nvim_set_hl(0, config.replacep_pending_hl, { fg = colors.fg_dark, bg = colors.red2 }) -- create if missing
vim.api.nvim_set_hl(0, config.visual_hl, { fg = colors.fg_dark, bg = colors.orange }) -- create if missing

-- helper to wrap text in a statusline highlight group
local function hl(group, text)
  return string.format("%%#%s#%s%%*", group, text)
end

-- create and link the highlight group(s)
vim.api.nvim_set_hl(0, config.placeholder_hl, {}) -- create if missing
vim.api.nvim_set_hl(0, config.placeholder_hl, { link = "Comment" })

local function mode()
  local m = vim.fn.mode()
  return hl(mode_icons[m]["hl"], mode_icons[m]["text"])
end

local function filepath()
  local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:h")

  if fpath == "" or fpath == "." then
    return ""
  end

  if state.show_path then
    return string.format("%%<%s/", fpath)
  end

  return hl(config.placeholder_hl, config.icons.path_hidden .. "/")
end

local function git()
  local git_info = vim.b.gitsigns_status_dict
  if not git_info or git_info.head == "" then
    return ""
  end

  local head = git_info.head
  local added = git_info.added and (" +" .. git_info.added) or ""
  local changed = git_info.changed and (" ~" .. git_info.changed) or ""
  local removed = git_info.removed and (" -" .. git_info.removed) or ""
  if git_info.added == 0 then
    added = ""
  end
  if git_info.changed == 0 then
    changed = ""
  end
  if git_info.removed == 0 then
    removed = ""
  end

  if not state.show_branch then
    head = hl(config.placeholder_hl, config.icons.branch_hidden)
  end

  return table.concat({
    "[ ",
    head,
    hl(config.git_add_hl, added),
    hl(config.git_change_hl, changed),
    hl(config.git_delete_hl, removed),
    "]",
  })
end

-- Diagnostics symbols
local function get_diagnostics()
  if not vim.diagnostic then
    return ""
  end
  local d = vim.diagnostic.get(0)
  local e, w, i, h = 0, 0, 0, 0
  for _, v in ipairs(d) do
    if v.severity == vim.diagnostic.severity.ERROR then
      e = e + 1
    elseif v.severity == vim.diagnostic.severity.WARN then
      w = w + 1
    elseif v.severity == vim.diagnostic.severity.INFO then
      i = i + 1
    elseif v.severity == vim.diagnostic.severity.HINT then
      h = h + 1
    end
  end

  local s = ""
  if e > 0 then
    s = s .. hl(config.error_hl, " " .. e .. " ")
  end
  if w > 0 then
    s = s .. hl(config.warning_hl, " " .. w .. " ")
  end
  if i > 0 then
    s = s .. hl(config.info_hl, " " .. i .. " ")
  end
  if h > 0 then
    s = s .. hl(config.hint_hl, " " .. h .. " ")
  end

  -- reset to StatusLine for following text
  return s .. "%#StatusLine#"
end

local function sidekick_copilot()
  -- copilot status
  local status = require("sidekick.status").get()
  local color = "Special"
  if status then
    if status.kind == "Error" then
      color = "DiagnosticError"
    end
    if status.busy then
      color = "DiagnosticWarn"
    end
  end
  return hl(color, " ")
end

local function sidekick_cli()
  -- cli session status
  local status = require("sidekick.status").cli()
  if #status == 0 then
    return "-"
  end
  local color = "Special"
  return hl(color, "𐓙" .. (#status > 1 and #status or ""))
end

local function lsps()
  local bufnr = vim.api.nvim_get_current_buf()
  local active_lsps = vim.lsp.get_clients({ bufnr = bufnr })

  local names = {}
  for _, lsp in ipairs(active_lsps) do
    table.insert(names, lsp["name"])
  end

  return table.concat(names, "|")
end

Statusline = {}

function Statusline.active()
  return table.concat({
    mode(),
    " [",
    filepath(),
    "%t] ",
    git(),
    "%=[",
    sidekick_copilot(),
    "/",
    sidekick_cli(),
    "] [",
    lsps(),
    "]%< ",
    get_diagnostics(),
    " %y [%P %l:%c]",
  })
end

function Statusline.inactive()
  return " %t"
end

function Statusline.should_attach()
  local win = vim.api.nvim_get_current_win()
  local config = vim.api.nvim_win_get_config(win)
  if config.relative ~= "" then
    return false
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local bt = vim.bo[bufnr].buftype
  if bt ~= "" then
    return false
  end

  local ft = vim.bo[bufnr].filetype
  if
    ft == nil
    or vim.tbl_contains({
      "TelescopePrompt",
      "TelescopeResults",
      "NvimTree",
      "neo-tree",
      "lazy",
      "mason",
      "help",
    }, ft)
  then
    return false
  end

  return true
end

function Statusline.toggle_path()
  state.show_path = not state.show_path
  vim.cmd("redrawstatus")
end

function Statusline.toggle_branch()
  state.show_branch = not state.show_branch
  vim.cmd("redrawstatus")
end

vim.keymap.set("n", "<leader>sp", function()
  Statusline.toggle_path()
end, { desc = "Toggle statusline path" })
vim.keymap.set("n", "<leader>sb", function()
  Statusline.toggle_branch()
end, { desc = "Toggle statusline git branch" })

local group = vim.api.nvim_create_augroup("Statusline", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = group,
  desc = "Activate statusline on focus",
  callback = function()
    if Statusline.should_attach() then
      vim.opt_local.statusline = "%!v:lua.Statusline.active()"
    end
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = group,
  desc = "Deactivate statusline when unfocused",
  callback = function()
    if Statusline.should_attach() then
      vim.opt_local.statusline = "%!v:lua.Statusline.inactive()"
    end
  end,
})
