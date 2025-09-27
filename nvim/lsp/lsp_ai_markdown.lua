local lspconfig = require("lspconfig")

return {
  cmd = { "lsp-ai" },
  filetypes = {
    "markdown",
  },
  --root_dir = lspconfig.util.root_pattern(".git"),
  init_options = {
    memory = {
      file_store = vim.empty_dict(),
    },
    models = {
      completion = {
        type = "anthropic",
        chat_endpoint = "https://api.anthropic.com/v1/messages",
        model = "claude-3-5-haiku-20241022",
        auth_token_env_var_name = "ANTHROPIC_API_KEY",
      },
    },
    completion = {
      model = "completion",
      parameters = {
        max_context = 1048,
        max_tokens = 128,
        system = [[Instructions:
- You are an AI text writing assistant for markdown.
- Given a piece of code with the cursor location marked by "<CURSOR>", replace "<CURSOR>" with the correct code or comment.
- Then output the code replacing the "<CURSOR>"

Rules:
- Only respond with the text to insert.
- Only replace "<CURSOR>"; do not include any previously written code.
- Never include "<CURSOR>" in your response
- Handle ambiguous cases by providing the most contextually appropriate completion.
- Be consistent with your responses.]],
        messages = {
          {
            role = "user",
            content = "{CODE}",
          },
        },
      },
    },
  },
}
