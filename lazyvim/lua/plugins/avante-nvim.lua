local function file_exists(name)
  local f = io.open(name, "r")
  return f ~= nil and io.close(f)
end

local opts = { provider = "copilot", providers = {} }

-- test if antoropic api key exists and enable claude if so
if file_exists("/home/nathan/.ANTHROPIC_API_KEY") then
  opts["provider"] = "claude"
  opts["providers"]["claude"] = {
    api_key_name = { "cat", "/home/nathan/.ANTHROPIC_API_KEY" },
  }
end

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = opts,
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  },
}
