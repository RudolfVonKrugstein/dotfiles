-- custom/configs/null-ls.lua

local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

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
  code_actions.gitsigns.with({
    config = {
        filter_actions = function(title)
            return title:lower():match("blame") == nil -- filter out blame actions
        end,
    },
  })
  --  code_actions.gitsigns
}

null_ls.setup {
   debug = true,
   sources = sources,
}
