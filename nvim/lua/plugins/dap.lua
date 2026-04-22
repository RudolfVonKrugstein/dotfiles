vim.pack.add({
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/leoluz/nvim-dap-go",
})

local dap, dapui = require("dap"), require("dapui")
local dapgo = require("dap-go")
dapui.setup()
dapgo.setup()
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end

vim.keymap.set("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "debug continue" })
vim.keymap.set("n", "<leader>dn", function()
  require("dap").step_over()
end, { desc = "debug step over" })
vim.keymap.set("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "debug step into" })
vim.keymap.set("n", "<leader>do", function()
  require("dap").step_out()
end, { desc = "debug step out" })
vim.keymap.set("n", "<Leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "toggle breakpoint" })
vim.keymap.set("n", "<Leader>dm", function()
  require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "debug set breakpoint with message" })
vim.keymap.set("n", "<Leader>dr", function()
  require("dap").repl.open()
end, { desc = "open debug repl" })
vim.keymap.set("n", "<Leader>dl", function()
  require("dap").run_last()
end, { desc = "debug run last" })

vim.keymap.set("n", "<Leader>do", function()
  dapui.open()
end, { desc = "open dap" })
vim.keymap.set("n", "<Leader>dc", function()
  dapui.close()
end, { desc = "close dap" })
