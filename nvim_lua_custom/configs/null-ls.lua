-- custom/configs/null-ls.lua

local null_ls = require "null-ls"
local h = require("null-ls.helpers")

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

-- leptosfmt source
local leptos_fmt_source = h.make_builtin({
  filetypes = {"rust"},
  method = require("null-ls.methods").internal.FORMATTING,
  factory = h.formatter_factory,
  generator_opts = {
    command = "leptosfmt",
    to_temp_file = true
  }
})

local sources = {
  formatting.prettier,
  formatting.stylua,
  formatting.rustfmt,
  formatting.rustywind,
  lint.shellcheck,
  lint.write_good,
  lint.eslint_d,
  lint.actionlint,
  lint.ansiblelint,
  lint.chktex,
  leptos_fmt_source,
  -- code_actions.gitsigns.with({
  --   config = {
  --       filter_actions = function(title)
  --           return title:lower():match("blame") == nil -- filter out blame actions
  --       end,
  --   },
  -- })
  --  code_actions.gitsigns
}



null_ls.setup {
   debug = true,
   sources = sources,
}
