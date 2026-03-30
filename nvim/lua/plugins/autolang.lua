vim.pack.add({"https://github.com/suderio/autolang.nvim"})
require("autolang").setup({
  -- -- Enable auto-detection
  auto_detect = true,

  -- Interactive Mode:
  -- false: Changes spelllang silently (default)
  -- true: Opens a prompt asking if you want to change the language
  interactive = false,

  -- How many lines of "human text" to analyze.
  -- Since we use Tree-sitter to strip code, 50 lines is usually enough.
  -- Sometimes it is useful to change it to 100.
  lines_to_check = 50,

  -- Limit the detection to specific languages.
  -- OPTIONAL: If nil, checks against ALL keys defined in 'lang_mapping'.
  -- This is likely the best way to improve performance.
  -- limit_languages = { "en", "pt_BR" },
})
