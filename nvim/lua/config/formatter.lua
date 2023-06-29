-- Utilities for creating configurations
local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		python = {
			require("formatter.filetypes.python").black,
		},
		rust = {
			require("formatter.filetypes.rust").default,
		},
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		yaml = {
			require("formatter.filetypes.yaml").default,
		},
		javascript = {
			require("formatter.filetypes.javascript").default,
		},
		typescript = {
			require("formatter.filetypes.typescript").default,
		},
		json = {
			require("formatter.filetypes.json").default,
		},
		toml = {
			require("formatter.filetypes.toml").default,
		},
		markdown = {
			require("formatter.filetypes.markdown").default,
		},
		go = {
			require("formatter.filetypes.go").default,
		},
		cmake = {
			require("formatter.filetypes.cmake").default,
		},
		cpp = {
			require("formatter.filetypes.cpp").default,
		},
		dart = {
			require("formatter.filetypes.dart").default,
		},
		html = {
			require("formatter.filetypes.html").default,
		},
		css = {
			require("formatter.filetypes.css").default,
		},
		vue = {
			require("formatter.filetypes.vue").default,
		},
		svelte = {
			require("formatter.filetypes.svelte").default,
		},
		terraform = {
			require("formatter.filetypes.terraform").default,
		},
	},
})
