local function file_exists(name)
  local f = io.open(name, "r")
  return f ~= nil and io.close(f)
end

local adapters = {
  adapters = {
    ollama = function()
      return require("codecompanion.adapters").extend("ollama", {
        schema = {
          model = {
            default = "qwen2.5-coder:7b-instruct",
          },
        },
        env = {
          url = "http://localhost:11434",
        },
        headers = {
          ["Content-Type"] = "application/json",
        },
        parameters = {
          sync = true,
        },
      })
    end,
  },
}
local default_adapter = "copilot"
if file_exists("/home/nathan/.ANTHROPIC_API_KEY") then
  default_adapter = "anthropic"
  adapters["anthropic"] = function()
    return require("codecompanion.adapters").extend("anthropic", {
      env = {
        api_key = "cmd:cat /home/nathan/.ANTHROPIC_API_KEY",
      },
    })
  end
end

-- test if antoropic api key exists and enable codecompanion
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    default_adapter = "anthoropic",
    display = {
      diff = {
        provider = "mini_diff",
      },
    },
    adapters = adapters,
    strategies = {
      chat = {
        adapter = default_adapter,
      },
      inline = {
        adapter = default_adapter,
      },
    },
  },
  config = true,
}
