local M = {}

M.dap = {
  n = {
    ["<leader>db"] = {":lua require'dap'.toggle_breakpoint()<CR>", "Toggle Breakpoint"},
    ["<leader>dr"] = {":lua require'dap'.run_last()<CR>", "Debug run (last)"},
    ["<leader>dR"] = {":lua require'dap'.restart()<CR>", "Debug restart"},
    ["<leader>ds"] = {":lua require'dap'.terminate()<CR>", "Debug stop/terminate"},
    ["<leader>dc"] = {":lua require'dap'.continue()<CR>", "Debug continue"},
    ["<leader>du"] = {":lua require'dapui'.toggle()<CR>", "Debug toggle ui"},
    ["<leader>de"] = {":lua require'dapui'.eval()<CR>", "Debug evaluate expression under curser"},
    ["<leader>so"] = {":lua require'dap'.step_over()<CR>", "Debug step over"},
    ["<leader>si"] = {":lua require'dap'.step_into()<CR>", "Debug step into"},
    ["<leader>st"] = {":lua require'dap'.step_out()<CR>", "Debug step out"},
    ["<leader>od"] = {":lua require'diaglist'.open_all_diagnostics()<CR>", "Open global quickfix"},

    ["<leader>tt"] = {":lua require'trouble'.open({mode=\"workspace_diagnostics\"})<CR>"},
    ["<C-l>"] = {":lua require(\"tmux\").move_right()<CR>"},
    ["<C-h>"] = {":lua require(\"tmux\").move_left()<CR>"},
    ["<C-j>"] = {":lua require(\"tmux\").move_bottom()<CR>"},
    ["<C-k>"] = {":lua require(\"tmux\").move_top()<CR>"},
    ["<A-l>"] = {":lua require(\"tmux\").resize_right()<CR>"},
    ["<A-h>"] = {":lua require(\"tmux\").resize_left()<CR>"},
    ["<A-j>"] = {":lua require(\"tmux\").resize_bottom()<CR>"},
    ["<A-k>"] = {":lua require(\"tmux\").resize_top()<CR>"},
  }
}

return M
