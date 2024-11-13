return {
  "nvim-neotest/neotest",
  dependencies = { "nvim-neotest/nvim-nio" },
  opts = {
    adapters = {
      ["neotest-python"] = {
        pytest_discover_instances = true,
      },
    },
  },
}
