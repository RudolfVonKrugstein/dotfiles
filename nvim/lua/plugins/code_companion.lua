return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    strategies = {
      chat = {
        adapter = "anthropic",
      },
      inline = {
        adapter = "anthropic",
      },
      cmd = {
        adapter = "anthropic",
      },
      adapters = {
        http = {
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                api_key = "cmd:cut ~/.anthropic_api_key",
              },
            })
          end,
        },
      },
    },
    -- NOTE: The log_level is in `opts.opts`
    opts = {
      log_level = "INFO", -- or "TRACE"
    },
  },
}
