return {
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
