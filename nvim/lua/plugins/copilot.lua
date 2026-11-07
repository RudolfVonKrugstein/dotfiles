vim.pack.add({ "https://github.com/zbirenbaum/copilot.lua" })

local config = {
  suggestion = {
    enabled = true,
  },
  panel = {
    enabled = false,
  },
  filetypes = {
    markdown = true,
    help = true,
  },
}

if vim.env.NVIM_CONFIG_VARIANT == "db" then
  config.auth_provider_url = "https://deutschebahn.ghe.com/"
end

require("copilot").setup(config)

vim.keymap.set({ "n", "i" }, "<A-.>", function()
  require("blink.cmp").hide()
  require("copilot.suggestion").next()
end, { desc = "Next copilot suggestion" })
vim.keymap.set({ "n", "i" }, "<A-,>", function()
  require("blink.cmp").hide()
  require("copilot.suggestion").prev()
end, { desc = "Prev copilot suggestion" })
vim.keymap.set({ "n", "i" }, "<A-y>", function()
  require("copilot.suggestion").accept()
end, { desc = "Accept copilot suggestion" })
vim.keymap.set({ "n", "i" }, "<A-u>", function()
  require("copilot.suggestion").dismiss()
end, { desc = "Prev copilot suggestion" })
