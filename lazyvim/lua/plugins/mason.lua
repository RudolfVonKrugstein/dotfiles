return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- lua stuff
        "lua-language-server",
        "stylua",

        -- web dev stuff
        "prettier",

        -- python stuff
        "debugpy",
        "ruff",
        "basedpyright",
        -- "python-lsp-server",
      },
    },
    init = function()
      if require("mason-registry").is_installed("python-lsp-server") then
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
            "python-lsp-black",
            "pyflakes",
            "python-lsp-ruff",
            "pyls-flake8",
            "sqlalchemy-stubs",
          }

          require("plenary.job")
            :new({
              command = command,
              args = args,
              cwd = path,
            })
            :start()
        end)
      end
    end,
  },
}
