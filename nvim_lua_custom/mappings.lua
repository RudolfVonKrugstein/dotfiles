local M = {}

M.dap = {
  n = {
    ["<C-F8>"] = {":lua require'dap'.toggle_breakpoint()<CR>", "Toggle Breakpoint"},
    ["<S-F9>"] = {":lua require'dap'.run_last()<CR>", "Debug run (last)"},
    ["<C-F9>"] = {":lua require'dap'.restart()<CR>", "Debug restart"},
    ["<leader>ds"] = {":lua require'dap'.terminate()<CR>", "Debug stop/terminate"},
    ["<F9>"] = {":lua require'dap'.continue()<CR>", "Debug continue"},
    ["<leader>du"] = {":lua require'dapui'.toggle()<CR>", "Debug toggle ui"},
    ["<leader>de"] = {":lua require'dapui'.eval()<CR>", "Debug evaluate expression under curser"},
    ["<F8>"] = {":lua require'dap'.step_over()<CR>", "Debug step over"},
    ["<F7>"] = {":lua require'dap'.step_into()<CR>", "Debug step into"},
    ["<S-F8>"] = {":lua require'dap'.step_out()<CR>", "Debug step out"},

    -- marks
    ["gm"] = {":Telescope marks<CR>"},
    ["m,"] = {":lua require('marks').set_next()<CR>"},
    ["m;"] = {":lua require('marks').toggle()<CR>"},
    ["dm-"] = {":lua require('marks').delete_line()<CR>"},
    ["dm<space>"] = {":lua require('marks').delete_buf()<CR>"},
    ["m]"] = {":lua require('marks').next()<CR>"},
    ["m["] = {":lua require('marks').prev()<CR>"},
    ["m:"] = {":lua require('marks').preview()<CR>"},

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

    -- ranger
    ["<leader>rr"] = {":RangerEdit<CR>"},
    ["<leader>rv"] = {":RangerVSplit<CR>"},
    ["<leader>rs"] = {":RangerSplit<CR>"},
    ["<leader>ri"] = {":RangerInsert<CR>"},
    ["<leader>ra"] = {":RangerAppend<CR>"},
    ["<leader>rc"] = {":set operatorfunc=RangerChangeOperator<CR>g@"},
    ["<leader>rd"] = {":RangerCD<CR>"},
    ["<leader>rld"] = {":RangerLCD<CR>"},

    -- undotree
    ["<leader>u"] = {":lua require('undotree').toggle()<CR>"}
  }
}

return M
