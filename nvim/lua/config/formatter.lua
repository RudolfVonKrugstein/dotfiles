-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    python = {
      require("formatter.filetypes.python").black,
    },
    rust = {
      require("formatter.filetypes.rust").default,
    },
    lua = {
      require("formatter.filetypes.lua").stylua,
    }
  }
}
