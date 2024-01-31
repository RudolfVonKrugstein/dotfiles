local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Auto-install lazy.nvim if not present
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim....")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- load plugins
require("lazy").setup({
  { "folke/tokyonight.nvim" },
  { "kyazdani42/nvim-web-devicons" },
  { "nvim-lua/plenary.nvim" },
  { "folke/which-key.nvim" },
  { "folke/trouble.nvim" },
  { "wincent/ferret" },
  { "daenikon/marknav.nvim" },
  { "kevinhwang91/nvim-bqf" },
  { "code-biscuits/nvim-biscuits" },
  { "jdrupal-dev/code-refactor.nvim" },
  { "nvim-lualine/lualine.nvim" },
  { "mhartington/formatter.nvim" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-telescope/telescope.nvim" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-telescope/telescope-file-browser.nvim" },
  { "lewis6991/gitsigns.nvim" },
  { "jiaoshijie/undotree" },
  { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  { "L3MON4D3/LuaSnip" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "saadparwaiz1/cmp_luasnip" },
  { "rafamadriz/friendly-snippets" },
  { "windwp/nvim-autopairs" },
  { "kylechui/nvim-surround" },
  { "echasnovski/mini.nvim" },
  { "stevearc/oil.nvim" },
})

-- general options
local opt = vim.opt

opt.hlsearch = true
opt.number = true
opt.relativenumber = true
opt.hidden = true
opt.mouse = "a"
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250
opt.signcolumn = "yes"
opt.termguicolors = true
opt.expandtab = true
opt.spelllang = "en,de,cjk"
opt.spell = true
opt.guifont = "JetBrainsMono NF:h14"
opt.cursorline = true
opt.cursorcolumn = true
opt.timeout = false
opt.ttimeout = false
vim.cmd("colorscheme tokyonight")
vim.cmd("highlight GitSignsAdd guifg=GREEN")
vim.cmd("highlight GitSignsChange guifg=YELLOW")
vim.cmd("highlight GitSignsDelete guifg=RED")
vim.cmd(":set pumblend=0")
vim.cmd(":set winblend=0")
opt.clipboard = "unnamedplus"

-- git signs
require("gitsigns").setup({})

-- telescope
require("telescope").setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
  },
  defaults = {
    mappings = {
      i = { ["<c-t>"] = require("trouble").open_with_trouble },
      n = { ["<c-t>"] = require("trouble").open_with_trouble },
    },
  },
})
require("telescope").load_extension("ui-select")
require("telescope").load_extension("file_browser")

-- marknav
require("marknav").setup()

-- undotree
require("undotree").setup({
  float_diff = false,
  layout = "left_bottom",
})

-- oil
require("oil").setup({ keymaps = { ["q"] = "actions.close" } })

-- nvim-autopairs
require("nvim-autopairs").setup({
  check_ts = true,
  ignore_next_char = "[%w%.]",
  map_c_w = true,
  disable_filetype = { "TelescopePrompt", "clap_input" },
})

-- nvim surround
require("nvim-surround").setup({})

-- mini nvim plugings
-- allows for example replace inner function call via cif
require("mini.ai").setup({})
-- toggle comments
require("mini.comment").setup({})
-- highlight the word under cursor
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})

-- nvim context vt
require("nvim-biscuits").setup({})

-- trouble
require("trouble").setup({})

-- better quickfix
require("bqf").setup({})

-- code refactor
require("code-refactor").setup({})

-- lsp setup
local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
  -- keybindings
  -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/README.md#keybindings
  -- lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- set some fancy icons
lsp_zero.set_sign_icons({
  error = "✘",
  warn = "▲",
  hint = "⚑",
  info = "»",
})

-- setup mason and lspconfig
require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = {
    "ocamllsp",
    "astro",
    "efm",
    "elixirls",
    "taplo",
    "ruff_lsp",
    "pyright",
    "tailwindcss",
    "tflint",
    "terraformls",
    "tsserver",
    "clangd",
    "cssls",
    "html",
    "lua_ls",
  },
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require("lspconfig").lua_ls.setup(lua_opts)
    end,
  },
})

-- setup nvim-cmp
local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_action = lsp_zero.cmp_action()

-- setup autopair with nvim cmp
cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

-- load more snippets from friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- supertab functions
local function luasnip_supertab(select_opts)
  return cmp.mapping(function(fallback)
    local col = vim.fn.col(".") - 1

    if cmp.visible() then
      cmp.select_next_item(select_opts)
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
      fallback()
    else
      cmp.complete()
    end
  end, { "i", "s" })
end

local function luasnip_shift_supertab(select_opts)
  return cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item(select_opts)
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { "i", "s" })
end

cmp.setup({
  sources = {
    { name = "path" },
    { name = "nvim_lsp" },
    { name = "luasnip", keyword_length = 2 },
    { name = "buffer", keyword_length = 3 },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    -- complete common
    ["<Tab>"] = luasnip_supertab(),
    ["<S-Tab>"] = luasnip_shift_supertab(),

    -- confirm completion item
    ["<Enter>"] = cmp.mapping.confirm({ select = false }),
    ["<S-Enter>"] = cmp.mapping.confirm({ select = true }),

    -- trigger completion menu
    ["<C-Space>"] = cmp.mapping.complete(),

    -- abort
    ["<C-e>"] = cmp.mapping.abort(),

    -- scroll up and down the documentation window
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),

    -- navigate between snippet placeholders
    ["<C-f>"] = cmp_action.luasnip_jump_forward(),
    ["<C-b>"] = cmp_action.luasnip_jump_backward(),
  }),
  formatting = lsp_zero.cmp_format(),
})

-- formatter
local futil = require("formatter.util")
require("formatter").setup({
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    python = {
      require("formatter.filetypes.python").ruff,
    },
    rust = {
      require("formatter.filetypes.rust").default,
    },
    lua = {
      require("formatter.filetypes.lua").stylua,
    },
    yaml = {
      require("formatter.filetypes.yaml").prettier,
    },
    javascript = {
      require("formatter.filetypes.javascript").prettiereslint,
    },
    typescript = {
      require("formatter.filetypes.typescript").prettiereslint,
    },
    json = {
      require("formatter.filetypes.json").prettier,
    },
    toml = {
      require("formatter.filetypes.toml").taplo,
    },
    markdown = {
      require("formatter.filetypes.markdown").prettier,
    },
    go = {
      require("formatter.filetypes.go").gofmt,
    },
    cmake = {
      require("formatter.filetypes.cmake").cmakeformat,
    },
    cpp = {
      require("formatter.filetypes.cpp").clangformat,
    },
    dart = {
      require("formatter.filetypes.dart").dartformat,
    },
    html = {
      require("formatter.filetypes.html").htmlbeautify,
    },
    css = {
      require("formatter.filetypes.css").prettier,
    },
    vue = {
      require("formatter.filetypes.vue").prettier,
    },
    svelte = {
      require("formatter.filetypes.svelte").prettier,
    },
    terraform = {
      require("formatter.filetypes.terraform").terraformfmt,
    },
    astro = {
      function()
        return {
          exe = "npx",
          args = {
            "prettier",
            "--stdin-filepath",
            futil.escape_path(futil.get_current_buffer_file_path()),
          },
          stdin = true,
        }
      end,
    },
    elixir = {
      function()
        return {
          exe = "mix",
          args = "format",
        }
      end,
    },
    ocaml = {
      function()
        return {
          exe = "ocamlformat",
          args = {
            "--enable-outside-detected-project",
            futil.escape_path(futil.get_current_buffer_file_path()),
          },
          stdin = true,
        }
      end,
    },
    dune = {
      function()
        return {
          exe = "dune",
          args = {
            "format-dune-file",
            futil.escape_path(futil.get_current_buffer_file_path()),
          },
          stdin = true,
        }
      end,
    },
  },
})

-- lualine
local function lsp_server()
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return "[]"
  end
  local result = "[ "
  local first_client = true
  for _, client in ipairs(clients) do
    if not first_client then
      result = result .. ", "
    end
    result = result .. client.name
    first_client = false
  end
  return result .. " ]"
end

require("lualine").setup({
  component_separators = { left = "", right = "" },
  section_separators = { left = "", right = "" },
  theme = "codedark",
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { lsp_server, "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
})

local api = vim.api

-- Highlight on yank
api.nvim_exec(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
  ]],
  false
)

-- close certain windows with q
local group = vim.api.nvim_create_augroup("NeotestConfig", {})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "neotest-output", "neotest-summary", "quickfix" },
  group = group,
  callback = function(opts)
    vim.keymap.set("n", "q", function()
      pcall(vim.api.nvim_win_close, 0, true)
    end, {
      buffer = opts.buf,
    })
  end,
})

-- keymaps
require("which-key").setup()
local wk = require("which-key")
wk.setup()
local ts_builtin = require("telescope.builtin")
local ts_file_browser_extension = require("telescope").extensions.file_browser
local trouble = require("trouble")

local g = vim.g
local keymap = vim.keymap.set
local api = vim.api
vim.o.timeout = true
vim.o.timeoutlen = 300
-- Space as leader key
keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
g.mapleader = " "
g.maplocalleader = " "
wk.register({
  c = {
    name = "code",
    f = { "<cmd>Format<CR>", "format code" },
    a = {
      function()
        vim.lsp.buf.code_action()
      end,
      "code action",
    },
    b={
            "<cmd>CodeActions all<CR>",
            "non lsp code action"
    },
    s = { ts_builtin.lsp_workspace_symbols, "symbols (workspace)" },
    S = { ts_builtin.lsp_document_symbols, "symbols (document)" },
    r = { vim.lsp.buf.rename, "rename symbol" },
  },
  f = {
    name = "file",
    f = { ts_builtin.find_files, "Find files" },
    b = { ts_file_browser_extension.file_browser, "browse files" },
    e = { "<CMD>Oil<CR>", "Open file explorer" },
    s = { "<CMD>FormatWrite<CR><CMD>w<CR>", "save" },
  },
  u = {
    function()
      require("undotree").toggle()
    end,
    "Toggle Undotree",
  },
  d = {
    name = "diagnostics",
    d = {
      function()
        vim.diagnostic.open_float()
      end,
      "show line diagnostic",
    },
    l = {
      function()
        trouble.toggle("document_diagnostics")
      end,
      "document diagnostics",
    },
    w = {
      function()
        trouble.toggle("workspace_diagnostics")
      end,
      "workspace diagnostics",
    },
    q = {
      function()
        trouble.open("quickfix")
      end,
      "open quickfix list in trouble",
    },
  },
  s = {
    name = "search",
    g = { ts_builtin.live_grep, "Live Grep" },
    w = { ts_builtin.grep_string, "Search for word under cursor in workspace" },
    s = { ":Ack ", "search in files to quickfix list" },
    n = { ":Quack ", "narrow items in quickfix list" },
    r = { ":Acks ", "replace items in quickfix list" },
  },
  b = {
    name = "buffer",
    b = { ts_builtin.buffers, "Find buffer" },
    d = { "<cmd>bdelete<CR>", "Delete buffer" },
  },
  h = { ts_builtin.help_tags, "Show help tags" },
  j = {
    ts_builtin.jumplist,
    "Jump List",
  },
  p = { ts_builtin.register, "Paste from register" },
  l = {
    name = "language and spelling",
    l = { ts_builtin.spell_suggest, "fix spelling" },
    e = { "<cmd>setlocal spell spelllang=en_us<CR>", "switch to english" },
    d = { "<cmd>setlocal spell spelllang=de_de<CR>", "swich to german" },
  },
}, { prefix = "<leader>" })

wk.register({
  d = { ts_builtin.lsp_definitions, "jump to definition" },
  D = { vim.lsp.buf.declaration, "jump to declaration" },
  k = { ts_builtin.lsp_type_definitions, "jump to type definition" },
  r = { ts_builtin.lsp_references, "jump to references" },
  i = { ts_builtin.lsp_implementations, "jump to implementation" },
  l = { ts_builtin.lsp_incoming_calls, "jump to incoming calls" },
  o = { ts_builtin.lsp_outgoing_calls, "jump to outgoing calls" },
  s = { vim.lsp.buf.signature_help, "show signature help" },

  m = { ts_builtin.marks, "jump to mark" },
}, { prefix = "g" })

wk.register({
  K = {
    vim.lsp.buf.hover,
    "Help/Hover",
  },
})

-- signature help in insert mode
keymap("i", "<C-s>", vim.lsp.buf.signature_help, { noremap = true })
