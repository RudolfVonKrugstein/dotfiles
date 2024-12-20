local function file_exists(name)
  local f = io.open(name, "r")
  return f ~= nil and io.close(f)
end

-- test if antoropic api key exists and enable codecompanion
if file_exists("/home/nathan/.ANTHROPIC_API_KEY") then
  return {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      default_adapter = "anthropic",
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = "cmd:cat /home/nathan/.ANTHROPIC_API_KEY",
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
      },
    },
    config = true,
  }
else
  return {}
end
