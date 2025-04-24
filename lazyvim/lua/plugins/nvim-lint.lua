return {
  "mfussenegger/nvim-lint",
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      python = { "pydoclint" },
      -- Use the "*" filetype to run linters on all filetypes.
      -- ['*'] = { 'global linter' },
      -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
      -- ['_'] = { 'fallback linter' },
      -- ["*"] = { "typos" },
      go = { "golangcilint" },
    },
    linters = {
      pydoclint = {
        cmd = "pydoclint",
        stdin = false, -- or false if it doesn't support content input via stdin. In that case the filename is automatically added to the arguments.
        append_fname = true, -- Automatically append the file name to `args` if `stdin = false` (default: true)
        args = { "-q" }, -- list of arguments. Can contain functions with zero arguments that will be evaluated once the linter is used.
        stream = "stderr", -- ('stdout' | 'stderr' | 'both') configure the stream to which the linter outputs the linting result.
        ignore_exitcode = true, -- set this to true if the linter exits with a code != 0 and that's considered normal.
        env = nil, -- custom environment table to use with the external process. Note that this replaces the *entire* environment, it is not additive.
        parser = function(output, bufnr, linter_cwd)
          return require("lint.parser").from_pattern("^ *(%d+): (DOC%d+): (.+)$", { "lnum", "code", "message" }, {}, {
            ["source"] = "pydoclint",
            ["severity"] = vim.diagnostic.severity.WARN,
          }, {})(output, bufnr, linter_cwd)
        end,
      },
    },
  },
}
