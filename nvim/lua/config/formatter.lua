-- Utilities for creating configurations
local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
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
    },
    yaml = {
      require("formatter.filetypes.yaml").prettier,
    },
    javascript = {
      require("formatter.filetypes.javascript").prettiereslint,
    },
    typescript = {
      require("formatter.filetypes.typescript").prettiereslint,
    },
    json = {
      require("formatter.filetypes.json").prettier,
    },
    toml = {
      require("formatter.filetypes.toml").taplo,
    },
    markdown = {
      require("formatter.filetypes.markdown").prettier,
    },
    go = {
      require("formatter.filetypes.go").gofmt,
    },
    cmake = {
      require("formatter.filetypes.cmake").cmakeformat,
    },
    cpp = {
      require("formatter.filetypes.cpp").clangformat,
    },
    dart = {
      require("formatter.filetypes.dart").dartformat,
    },
    html = {
      require("formatter.filetypes.html").htmlbeautify,
    },
    css = {
      require("formatter.filetypes.css").prettier,
    },
    vue = {
      require("formatter.filetypes.vue").prettier,
    },
    svelte = {
      require("formatter.filetypes.svelte").prettier,
    },
    terraform = {
      require("formatter.filetypes.terraform").terraformfmt,
    },
    astro = {
      function()
        return {
          exe = "npx",
          args = {
            "prettier",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
          },
          stdin = true,
        }
      end,
    },
    elixir = {
      function()
        return {
          exe = "mix",
          args = "format",
        }
      end,
    },
    ocaml = {
      function()
        return {
          exe = "ocamlformat",
          args = {
            "--enable-outside-detected-project",
            util.escape_path(util.get_current_buffer_file_path()),
          },
          stdin = true,
        }
      end,
    },
    dune = {
      function()
        return {
          exe = "dune",
          args = {
            "format-dune-file",
            util.escape_path(util.get_current_buffer_file_path()),
          },
          stdin = true,
        }
      end,
    },
  },
})
