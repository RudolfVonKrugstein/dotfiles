return {
  "nvimtools/hydra.nvim",
  config = function()
    local Hydra = require("hydra")

    Hydra({
      name = "Change / Resize Window",
      mode = { "n" },
      body = "<C-w>",
      config = {
        -- color = "pink",
      },
      heads = {
        -- move between windows
        { "<C-h>", "<C-w>h" },
        { "<C-j>", "<C-w>j" },
        { "<C-k>", "<C-w>k" },
        { "<C-l>", "<C-w>l" },

        -- resizing window
        { "<", "<C-w><" },
        { ">", "<C-w>>" },
        { "+", "<C-w>+" },
        { "-", "<C-w>-" },

        -- equalize window sizes
        { "=", "<C-w>=" },

        -- close active window
        { "Q", ":q<cr>" },
        { "<C-q>", ":q<cr>" },

        -- exit this Hydra
        { "q", nil, { exit = true, nowait = true } },
        { ";", nil, { exit = true, nowait = true } },
        { "<Esc>", nil, { exit = true, nowait = true } },
      },
    })
  end,
}
