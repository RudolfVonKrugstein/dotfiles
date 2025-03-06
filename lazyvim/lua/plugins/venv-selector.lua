local function shorter_name(filename)
  if filename:len() > 70 then
    return filename:sub("..." .. filename:len() - 70)
  end
  return filename
end

return {
  "linux-cultist/venv-selector.nvim",
  dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
  cmd = "VenvSelect",
  config = function()
    require("venv-selector").setup({
      settings = {
        options = {
          -- Your options go here
          name = { "venv", ".venv" },
          auto_refresh = true,
          on_telescope_result_callback = shorter_name,
        },
      },
    })
  end,
  event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
  keys = {
    -- Keymap to open VenvSelector to pick a venv.
    { "<leader>ce", "<cmd>VenvSelect<cr>" },
    { "<leader>co", "<cmd>VenvSelectCached<cr>" },
  },
}
