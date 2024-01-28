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
    lualine_c = { "filename"  },
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
