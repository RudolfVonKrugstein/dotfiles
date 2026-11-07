vim.pack.add({ "https://github.com/folke/sidekick.nvim" })
require("sidekick").setup({
  nes = { enabled = true },
  -- add any options here
  cli = {
    mux = {
      backend = "zellij",
      enabled = true,
    },
  },
})

vim.keymap.set({ "i", "n" }, "<Tab>", function()
  -- jump to the next suggestion, or apply it if you're already there
  if require("sidekick").nes_jump_or_apply() then
    return
  end
  -- otherwise behave like a normal <Tab>
  return "<Tab>"
end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })

vim.keymap.set({ "n", "t", "i", "x" }, "<c-.>", function()
  require("sidekick.cli").focus()
end, { desc = "Sidekick Focus" })
vim.keymap.set("n", "<leader>aa", function()
  require("sidekick.cli").toggle()
end, { desc = "Sidekick Toggle CLI" })
vim.keymap.set("n", "<leader>as", function()
  require("sidekick.cli").select({ filter = { installed = true } })
end, { desc = "Select CLI" })
vim.keymap.set("n", "<leader>ad", function()
  require("sidekick.cli").close()
end, { desc = "Detach a CLI Session" })
vim.keymap.set({ "x", "n" }, "<leader>at", function()
  require("sidekick.cli").send({ msg = "{this}" })
end, { desc = "Send This" })
vim.keymap.set("n", "<leader>af", function()
  require("sidekick.cli").send({ msg = "{file}" })
end, { desc = "Send File" })
vim.keymap.set("x", "<leader>av", function()
  require("sidekick.cli").send({ msg = "{selection}" })
end, { desc = "Send Visual Selection" })
vim.keymap.set({ "n", "x" }, "<leader>ap", function()
  require("sidekick.cli").prompt()
end, { desc = "Sidekick Select Prompt" })
-- Example of a keybinding to open Claude directly
vim.keymap.set("n", "<leader>ac", function()
  require("sidekick.cli").toggle({ name = "claude", focus = true })
end, { desc = "Sidekick Toggle Claude" })
