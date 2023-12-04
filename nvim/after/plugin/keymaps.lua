local wk = require("which-key")
local builtin = require("telescope.builtin")

vim.lsp.buf.format()
local g = vim.g
local keymap = vim.keymap.set
local api = vim.api

-- Space as leader key
keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
g.mapleader = " "
g.maplocalleader = " "

-- setup which keys
wk.register({
  -- cade related stuff
  c = {
    name = "code",
    a = {
      function()
        vim.lsp.buf.code_action()
      end,
      "code action",
    },
    r = {
      "<cmd>Lspsaga rename ++project<CR>",
      "rename symbol",
    },
    d = {
      "<cmd>Lspsaga show_buf_diagnostics<CR>",
      "diagnostics (buffer)",
    },
    D = {
      "<cmd>Lspsaga show_workspace_diagnostics<CR>",
      "diagnostics (buffer)",
    },
    o = {
      "<cmd>Lspsaga outline<CR>",
      "toggle outline",
    },
    h = {
      "<cmd>Lspsaga hover_doc ++keep<CR>",
      "open doc window",
    },
    S = {
      function()
        builtin.lsp_workspace_symbols({})
      end,
      "symbols (workspace)",
    },
    s = {
      function()
        builtin.lsp_document_symbols({})
      end,
      "symbols (buffer)",
    },
    l = {
      function()
        require("lsp_lines").toggle()
      end,
      "Toggle LSP lines",
    },
  },
  f = {
    name = "file",
    f = {
      builtin.find_files,
      "Find files",
    },
    r = {
      builtin.oldfiles,
      "recent files",
    },
    e = {
      "<CMD>Oil<CR>",
      "Open file explorer",
    },
  },
  -- other file
  o = {
    name = "Alt File",
    o = {
      "<cmd>Other<CR>",
      "Open alternate file",
      { noremap = true, silent = true },
    },
    s = {
      "<cmd>OtherSplit<CR>",
      "Open alternate file in split",
      { noremap = true, silent = true },
    },
    v = {
      "<cmd>OtherVSplit<CR>",
      "Open alternate file in virtical split",
      { noremap = true, silent = true },
    },
  },
  -- debug
  d = {
    name = "Debug",
    c = {
      function()
        require("dap").continue()
      end,
      "Continue / Launch",
    },
    n = {
      function()
        require("dap").step_over()
      end,
      "step over",
    },
    i = {
      function()
        require("dap").step_into()
      end,
      "step into",
    },
    o = {
      function()
        require("dap").step_out()
      end,
      "step out",
    },
    b = {
      function()
        require("dap").toggle_breakpoint()
      end,
      "breakpoint toggle",
    },
    r = {
      function()
        require("dap").repl.toggle()
      end,
      "Debug REPL toggle",
    },
    d = {
      function()
        require("dap").run_last()
      end,
      "Run last",
    },
    h = {
      function()
        require("dap.ui.widgets").hover()
      end,
      "hover",
    },
    p = {
      function()
        require("dap.ui.widgets").preview()
      end,
      "Preview",
    },
    f = {
      function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.frames)
      end,
      "Frames",
    },
    s = {
      function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
      end,
      "Frames",
    },
    u = {
      function()
        require("dapui").toggle()
      end,
      "UI toggle",
    },
  },
  -- undotree
  u = {
    function()
      require("undotree").toggle()
    end,
    "Undotree toggle",
  },
  ["?"] = {
    function()
      vim.diagnostic.open_float()
    end,
    "show line diagnostics",
  },
  -- neotest
  t = {
    function()
      require("neotest").summary.toggle()
    end,
    "Toggle test summary",
  },
  -- searching
  ["/"] = { builtin.live_grep, "Search in pwd" },
  ["*"] = { builtin.grep_string, "Search for word under cursor in workspace" },
  b = {
    name = "buffer",
    b = { builtin.buffers, "Find buffer" },
    d = { "<cmd>bdelete<CR>", "Delete buffer" },
  },
  h = { builtin.help_tags, "Show help tags" },
  j = {
    function()
      builtin.jumplist({})
    end,
    "Jump List",
  },
}, { prefix = "<leader>" })

-- Word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- g menu (goto)
keymap("n", "gl", "<cmd>Lspsaga lsp_finder<CR>", { desc = "traverse symbols usage" })
keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "goto definition" })
keymap("n", "gpd", "<cmd>Lspsaga peek_definition<CR>", { desc = "peek definition" })
keymap("n", "gt", "<cmd>Lspsaga goto_type_definition<CR>", { desc = "goto type definition" })
keymap("n", "gpt", "<cmd>Lspsaga peek_type_definition<CR>", { desc = "peek type definition" })
keymap("n", "gr", function()
  require("telescope.builtin").lsp_references({})
end, { desc = "show references" })
keymap("n", "gi", function()
  require("telescope.builtin").lsp_implementations({})
end, { desc = "show implementations" })

--diagnostics
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "jump to prev lsp diagnostic" })
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "jump to next lsp diagnostic" })

-- Diagnostic jump with filters such as only jumping to an error
keymap("n", "[E", function()
  require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "jump to prev lsp error" })
keymap("n", "]E", function()
  require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "jump to next lsp error" })

-- diagnistcs window
vim.diagnostic.config({
  underline = true,
  signs = true,
  virtual_text = false,
  virtual_lines = { only_current_line = true },
  float = {
    show_header = true,
    source = "always",
    border = "rounded",
    focusable = false,
  },
  update_in_insert = false, -- default to false
  severity_sort = false, -- default to false
})

-- neotest commands
vim.api.nvim_create_user_command("NeotestRun", function()
  require("neotest").run.run()
end, { nargs = 0 })

api.nvim_create_user_command("NeotestRunFile", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { nargs = 0 })

api.nvim_create_user_command("NeotestDebug", function()
  require("neotest").run.run({ strategy = "dap" })
end, { nargs = 0 })

api.nvim_create_user_command("NeotestStop", function()
  require("neotest").run.stop()
end, { nargs = 0 })

api.nvim_create_user_command("NeotestAttach", function()
  require("neotest").run.attach()
end, { nargs = 0 })

api.nvim_create_user_command("NeotestSummaryToggle", function()
  require("neotest").suammary.toggle()
end, { nargs = 0 })

api.nvim_create_user_command("NeotestSummaryOpen", function()
  require("neotest").suammary.open()
end, { nargs = 0 })

api.nvim_create_user_command("NeotestSummaryClose", function()
  require("neotest").suammary.close()
end, { nargs = 0 })

api.nvim_create_user_command("NeotestOutputToggle", function()
  require("neotest").output.toggle()
end, { nargs = 0 })

api.nvim_create_user_command("NeotestOutputOpen", function()
  require("neotest").output.open()
end, { nargs = 0 })

api.nvim_create_user_command("NeotestOutputClose", function()
  require("neotest").output.close()
end, { nargs = 0 })
