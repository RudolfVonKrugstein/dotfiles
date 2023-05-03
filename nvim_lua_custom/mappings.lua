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

    ["<leader>tt"] = {":lua require'trouble'.open({mode=\"workspace_diagnostics\"})<CR>"},
    ["<C-l>"] = {":lua require(\"tmux\").move_right()<CR>"},
    ["<C-h>"] = {":lua require(\"tmux\").move_left()<CR>"},
    ["<C-j>"] = {":lua require(\"tmux\").move_bottom()<CR>"},
    ["<C-k>"] = {":lua require(\"tmux\").move_top()<CR>"},
    ["<A-l>"] = {":lua require(\"tmux\").resize_right()<CR>"},
    ["<A-h>"] = {":lua require(\"tmux\").resize_left()<CR>"},
    ["<A-j>"] = {":lua require(\"tmux\").resize_bottom()<CR>"},
    ["<A-k>"] = {":lua require(\"tmux\").resize_top()<CR>"},

    ["gh"] = {":Lspsaga lsp_finder<CR>", "LSP Finder"},
    ["<leader>ca"] = {":Lspsaga code_action<CR>", "Code Action"},
    ["gr"] = {":Lspsaga rename< ++project<CR>", "Rename symbol"},
    ["gp"] = {":Lspsaga peek_definition<CR>", "Peek definition"},
    ["gd"] = {":Lspsaga goto_definition<CR>", "Goto definition"},
    ["gtp"] = {":Lspsaga peek_type_definition<CR>", "Peek definition"},
    ["gtd"] = {":Lspsaga goto_type_definition<CR>", "Goto definition"},
    ["<leader>sl"] = {":Lspsaga show_line_diagnostics<CR>"},
    ["<leader>sw"] = {":Lspsaga show_workspace_diagnostics<CR>"},
    ["<leader>sc"] = {":Lspsaga show_cursor_diagnostics<CR>"},
    ["<leader>ol"] = {":Lspsaga outline<CR>"},
    ["K"] = {":Lspsaga hover_doc ++keep<CR>"},
    ["[e"] = {":Lspsaga diagnostic_jump_prev<CR>"},
    ["]e"] = {":Lspsaga diagnostic_jump_next<CR>"},
  }
}

return M
