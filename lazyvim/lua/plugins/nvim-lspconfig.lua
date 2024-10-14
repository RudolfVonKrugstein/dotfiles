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

return {
  "neovim/nvim-lspconfig",
  opts = {
    autoformat = false,
    codelens = { enabled = true },
    inlay_hints = { exclude = { "vue", "lua" } },
    servers = servers,
  },
}
