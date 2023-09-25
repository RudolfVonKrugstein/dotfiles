-- auto install lazyvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- install plugins
require("lazy").setup({
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "kyazdani42/nvim-web-devicons" },
  { "nvim-lua/plenary.nvim" },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup()
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  { "L3MON4D3/LuaSnip" },
  {
    "williamboman/mason.nvim",
    lazy = false,
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    config = function()
      require("mason-lspconfig").setup()
    end,
    requires = { { "williamboman/mason.nvim" } },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    requires = { { "williamboman/mason.nvim" }, { "williamboman/mason-lspconfig" } },
  },
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "hrsh7th/cmp-buffer",
  },
  {
    "hrsh7th/cmp-path",
  },
  {
    "hrsh7th/cmp-cmdline",
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("config.nvim-cmp")
    end,
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    config = function()
      require("lsp-inlayhints").setup({
        inlay_hints = {
          highlight = "Comment",
        },
      })
      vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
      vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspAttach_inlayhints",
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end

          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("lsp-inlayhints").on_attach(client, bufnr)
        end,
      })
    end,
  },
  {
    "https://github.com/RudolfVonKrugstein/lsp_lines.git",
    config = function()
      require("lsp_lines").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup()
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "echasnovski/mini.nvim",
    version = "*",
    init = function()
      require("config.mini.indentscope").init()
    end,
    config = function(_, opts)
      -- setup nvim plugins
      require("mini.ai").setup({})
      -- require("mini.basics").setup({ options = { extra_ui = true } }) -- makes trouble with neotest
      require("mini.align").setup({})
      -- require('mini.animate').setup({})
      -- require("config.mini.base16")
      require("mini.bracketed").setup({})
      require("mini.bufremove").setup({})
      -- require('mini.colors').setup({})
      require("mini.comment").setup({})
      require("mini.cursorword").setup({})
      -- require('mini.doc').setup({})
      require("mini.fuzzy").setup({})
      -- require('mini.hipatterns').setup({})
      -- require('mini.hues').setup({})
      require("config.mini.indentscope").config(_, opts)
      require("mini.jump").setup({})
      -- require('mini.jump2d').setup({})
      require("mini.map").setup({})
      require("mini.misc").setup({})
      require("mini.move").setup({})
      require("mini.pairs").setup({})
      -- require('mini.sessions').setup({})
      require("mini.splitjoin").setup({})
      require("mini.starter").setup({})
      -- require('mini.statusline').setup({})
      --require("mini.surround").setup({})
      --require("mini.tabline").setup({})
      -- require('mini.test').setup({})
      -- require('mini.trailspace').setup({})
    end,
  },
  {
    "echasnovski/mini.files",
    version = false,
    config = function()
      require("mini.files").setup({})
    end,
  },
  {
    "rgroli/other.nvim",
    config = function()
      require("other-nvim").setup({
        mappings = {
          {
            pattern = "(.*).ml$",
            target = "%1.mli",
          },
          {
            pattern = "(.*).mli$",
            target = "%1.ml",
          },
        },
      })
    end,
  },
  { "nvim-telescope/telescope.nvim" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("lspsaga").setup({
        lightbulb = {
          enable = false,
        },
      })
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  -- rust
  {
    "simrat39/rust-tools.nvim",
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      require("config.rust-tools")
    end,
  },
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    config = function(_, opts)
      local crates = require("crates")
      crates.setup(opts)
      crates.show()
    end,
  },
  {
    "jiaoshijie/undotree",
    lazy = false,
    config = function()
      require("undotree").setup({
        float_diff = false,
        layout = "left_bottom",
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "-" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "?" },
        },
      })
    end,
  },
  {
    "tpope/vim-fugitive",
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
    tag = "legacy",
    requires = { "neovim/nvim-lspconfig" },
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("config.lualine")
    end,
  },
  {
    "nvim-neotest/neotest-python",
  },
  {
    "rouge8/neotest-rust",
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rouge8/neotest-rust",
      "nvim-neotest/neotest-python",
    },
    config = function()
      require("neotest").setup({
        signs = true,
        virtual_text = true,
        adapters = {
          require("neotest-python")({
            runner = "pytest",
          }),
          require("neotest-rust")({}),
        },
        quickfix = {
          open = false,
        },
      })
    end,
  },
  {
    "mhartington/formatter.nvim",
    config = function()
      require("config.formatter")
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("config.linter")
    end,
  },
  -- dap
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "nvim-dap" },
        cmd = { "DapInstall", "DapUninstall" },
        opts = { handlers = {} },
      },
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup({})
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-dap" },
    config = function()
      require("config.dap-ui")
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mfussenegger/nvim-dap", "williamboman/mason.nvim" },
    config = function()
      require("mason-nvim-dap").setup({
        automatic_installation = true,
      })
    end,
  },
  -- repl
  { "tpope/vim-repeat" },
  { "pappasam/nvim-repl" },
  -- python specific stuff
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "nvim-dap" },
    config = function()
      require("dap-python").setup()
    end,
  },
  -- tabbar
  { "romgrk/barbar.nvim", opts = {} },
  -- hydra
  {
    "anuvyklack/hydra.nvim",
    dependencies = { "sindrets/winshift.nvim", "mrjones2014/smart-splits.nvim", "romgrk/barbar.nvim" },
    config = function()
      require("config.hydra.windows")
    end,
  },
}, {})

--merlin (opam/ocaml
local opamshare = vim.api.nvim_eval("substitute(system('opam var share'),'\n$','','''')")
vim.opt.runtimepath:append(opamshare .. "$opamshare/merlin/vim")
