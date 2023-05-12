--@type NvPluginSpec[]
local plugins = {
	-- LSP
	{
		"neovim/nvim-lspconfig",

		dependencies = {
		"jose-elias-alvarez/null-ls.nvim",
			config = function()
				require("custom.configs.null-ls")
			end,
		},

		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end,
	},
  {
		"glepnir/lspsaga.nvim",
		event = "LspAttach",
		config = function()
			require("lspsaga").setup({})
		end,
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter" },
		},
	},
	-- lsp navigation
	{
		"SmiteshP/nvim-navic",
		lazy = false,
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("nvim-navic").setup({
				lsp = {
					auto_attach = true,
					preference = { "rust-analyzer" },
				},
			})
		end,
	},
	{
		"SmiteshP/nvim-navbuddy",
		lazy = false,
		dependencies = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
			"numToStr/Comment.nvim", -- Optional
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("nvim-navbuddy").setup({
				lsp = {
					auto_attach = true,
					preference = { "rust-analyzer" },
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		lazy = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	-- rust specific stuff
	{
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 1
		end,
	},
	{
		"simrat39/rust-tools.nvim",
		ft = "rust",
		dependencies = "neovim/nvim-lspconfig",
		opts = function()
			return require("custom.configs.rust-tools")
		end,
		config = function(_, opts)
			require("rust-tools").setup(opts)
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
	-- nvim-cmp update
	{
		"hrsh7th/nvim-cmp",
		opts = function()
			local M = require("plugins.configs.cmp")
			table.insert(M.sources, { name = "crates" })
			return M
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
			require("dapui").setup()
			require("custom.configs.dap-ui")
		end,
	},
	-- python specific stuff
	{
		"mfussenegger/nvim-dap-python",
		dependencies = { "nvim-dap" },
		config = function()
			require("dap-python").setup({})
		end,
	},
	-- other stuff
	{
		"elkowar/yuck.vim",
		lazy = false,
	},
	{
		"ahmedkhalf/project.nvim",
		lazy = false,
		config = function()
			require("project_nvim").setup({
				detection_methods = { "pattern", "lsp" },
				silent_chdir = false,
			})
		end,
	},
	{
		"kylechui/nvim-surround",
		lazy = false,
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	-- markdown
	{
		"iamcco/markdown-preview.nvim",
		lazy = false,
		config = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	-- asciidoctor
	{
		"habamax/vim-asciidoctor",
		ft = "asciidoctor",
	},
	{
		"pest-parser/pest.vim",
		lazy = false,
	},
	{
		"okuuva/auto-save.nvim",
		lazy = false,
		config = function()
			require("auto-save").setup({
				trigger_events = { "BufLeave", "FocusLost" },
			})
		end,
	},
	{
		"folke/lsp-trouble.nvim",
		lazy = false,
		config = function()
			require("trouble").setup({})
		end,
	},
	{
		"aserowy/tmux.nvim",
		config = function()
			return require("tmux").setup()
		end,
	},
	-- terraform
	{
		"hashivim/vim-terraform",
		lazy = false,
	},
	-- file manager
	{
		"rafaqz/ranger.vim",
		lazy = false,
	},
	-- undotree
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
	-- marks
	{
		"chentoast/marks.nvim",
		lazy = false,
		config = function()
			require("marks").setup({
				default_mapping = true,
			})
		end,
	},

	-- {
	--    "Lilja/zellij.nvim",
	--    lazy =false,
	--    config = function()
	--      require('zellij').setup({})
	--    end
	--  }
}

return plugins
