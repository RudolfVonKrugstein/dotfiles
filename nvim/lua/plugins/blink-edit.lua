return {
  "BlinkResearchLabs/blink-edit.nvim",
  config = function()
    require("blink-edit").setup({
      llm = {
        provider = "sweep",
        backend = "openai",
        url = "http://localhost:8000",
        model = "sweep",
      },
    })
  end,
}
