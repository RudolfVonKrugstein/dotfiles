-- jevr: semantic code search ("where is X done?") backed by TypeSafe Jev.
-- Results land in the quickfix list, best match first. The search blocks
-- Neovim until it finishes (a cold query takes a few seconds).
--
--   :Jevr {question}    search the working directory
--   :Jevr! {question}   search the current buffer's directory
--
-- jevr comes from the dotfiles (nixos/packages/jevr) and reads the API key
-- from ~/.config/typesafe/key itself, so nothing to configure here.

local function first_line(snippet)
  for line in (snippet or ""):gmatch("[^\n]+") do
    local trimmed = vim.trim(line)
    if trimmed ~= "" then
      return trimmed
    end
  end
  return ""
end

local function to_qf_items(results, root)
  local items = {}
  for _, r in ipairs(results) do
    local window = r.best_window ~= vim.NIL and r.best_window or nil
    local text = string.format("%.2f", r.score)
    if r.fallback then
      text = text .. " (low confidence)"
    end
    if r.error ~= vim.NIL and r.error then
      text = text .. " error: " .. r.error
    else
      text = text .. "  " .. first_line(r.best_snippet ~= vim.NIL and r.best_snippet or nil)
    end
    table.insert(items, {
      filename = vim.fs.joinpath(root, r.file),
      lnum = window and window[1] or 1,
      end_lnum = window and window[2] or nil,
      text = text,
    })
  end
  return items
end

local function jevr(question, root)
  if vim.fn.executable("jevr") == 0 then
    vim.notify("jevr: not installed (installBundles.jev)", vim.log.levels.ERROR)
    return
  end
  if question == "" then
    return
  end

  -- Blocks until jevr is done; redraw so the message shows while waiting.
  vim.api.nvim_echo({ { "jevr: searching " .. vim.fn.fnamemodify(root, ":~") .. " …" } }, false, {})
  vim.cmd.redraw()
  -- Run inside `root` and search ".", so the returned paths are relative to it.
  local res = vim.system({ "jevr", "--json", question, "." }, { cwd = root, text = true }):wait()

  -- Exit codes follow grep: 0 = matches, 1 = none above threshold (may still
  -- print low-confidence guesses), 2 = error.
  if res.code ~= 0 and res.code ~= 1 then
    local msg = vim.trim(res.stderr or "")
    vim.notify(msg:match("^jevr:") and msg or ("jevr: " .. msg), vim.log.levels.ERROR)
    return
  end

  local results = {}
  if res.stdout and vim.trim(res.stdout) ~= "" then
    local ok, decoded = pcall(vim.json.decode, res.stdout)
    if not ok then
      vim.notify("jevr: could not parse output: " .. decoded, vim.log.levels.ERROR)
      return
    end
    results = decoded
  end

  if #results == 0 then
    vim.notify("jevr: no matches for " .. question, vim.log.levels.WARN)
    return
  end

  vim.fn.setqflist({}, " ", {
    title = "jevr: " .. question,
    items = to_qf_items(results, root),
  })
  vim.cmd("botright copen")
  if res.code == 1 then
    vim.notify("jevr: nothing above threshold, showing best guesses", vim.log.levels.WARN)
  end
end

vim.api.nvim_create_user_command("Jevr", function(opts)
  local root = vim.fn.getcwd()
  if opts.bang then
    local name = vim.api.nvim_buf_get_name(0)
    root = name ~= "" and vim.fs.dirname(name) or root
  end
  jevr(opts.args, root)
end, { nargs = "+", bang = true, desc = "Semantic code search (jevr) into quickfix" })

vim.keymap.set("n", "<leader>jr", function()
  vim.ui.input({ prompt = "jevr: " }, function(question)
    if question then
      jevr(question, vim.fn.getcwd())
    end
  end)
end, { desc = "Jev[r] semantic search" })
