local is_arm = vim.loop.os_uname().machine == "aarch64"

-- dont use mason for somee lspss ion arm
local servers = {}
if is_arm then
  servers["lua_ls"] = { mason = false }
  servers["erlangls"] = { mason = false }
  servers["nil_ls"] = { mason = false }
  servers["helm_ls"] = { mason = false }
  servers["texlab"] = { mason = false }
end

local util = require("lspconfig.util")
servers["marksman"] = {
  filetypes = { "markdown", "quarto" },
  root_dir = util.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
}

servers["basedpyright"] = {
  single_file_support = true,
  settings = {
    basedpyright = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly", -- openFilesOnly, workspace
        typeCheckingMode = "standard",
      },
    },
  },
}

servers["pylsp"] = {
  settings = {
    pylsp = {
      plugins = {
        -- formatter options
        black = { enabled = false },
        autopep8 = { enabled = false },
        flake8 = { enabled = false },
        yapf = { enabled = false },
        -- linter options
        pylint = { enabled = false },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        ruff = { enabled = false },
        -- type checker
        pylsp_mypy = { enabled = false },
        -- auto-completion options
        jedi_completion = { enabled = false },
        jedi_definition = { enabled = false },
        jedi_hover = { enabled = false },
        jedi_symbols = { enabled = false },
        -- other stuff
        mccabe = { enabled = true },
        preload = { enabled = false },
        -- import sorting
        pyls_isort = { enabled = false },
        -- rope
        rope_rename = { enabled = false },
        rope_completion = { enabled = false },
      },
    },
  },
  on_attach = function(client)
    if client.name == "pylsp" then
      client.server_capabilities.renameProvider = false
    end
  end,
}

return {
  "neovim/nvim-lspconfig",
  opts = {
    autoformat = false,
    codelens = { enabled = true },
    inlay_hints = { enabled = false, exclude = { "vue", "lua" } },
    servers = servers,
    diagnostics = { virtual_text = false },
  },
  init = function(_)
    local pylsp = require("mason-registry").get_package("python-lsp-server")
    pylsp:on("install:success", function()
      local function mason_package_path(package)
        local path = vim.fn.resolve(vim.fn.stdpath("data") .. "/mason/packages/" .. package)
        return path
      end

      local path = mason_package_path("python-lsp-server")
      local command = path .. "/venv/bin/pip"
      local args = {
        "install",
        "-U",
        "pylsp-rope",
        "pyls-memestra",
        "pylsp-mypy",
      }

      require("plenary.job")
        :new({
          command = command,
          args = args,
          cwd = path,
        })
        :start()
    end)
  end,
}
