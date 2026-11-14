{
  config,
  lib,
  pkgs,
  ...
}:
# Registers the Jev MCP server (https://github.com/jkudish/jev-mcp) with
# Claude Code. It only works if the TypeSafe API key file exists.
#
# The key is never written into ~/.claude.json: Claude Code launches a
# wrapper that reads the key file at startup.
let
  keyFile = "$HOME/.config/typesafe/key";

  wrapper = pkgs.writeShellScript "jev-mcp" ''
    keyFile="${keyFile}"
    if [ ! -s "$keyFile" ]; then
      echo "jev-mcp: API key file $keyFile is missing or empty" >&2
      exit 1
    fi
    TYPESAFE_API_KEY="$(${pkgs.coreutils}/bin/tr -d '[:space:]' < "$keyFile")"
    export TYPESAFE_API_KEY
    export PATH="${pkgs.nodejs}/bin:$PATH"
    exec npx -y @jkudish/jev-mcp "$@"
  '';

  # Stable path, so the Claude Code registration survives rebuilds.
  wrapperPath = "${config.home.homeDirectory}/.local/share/jev-mcp/jev-mcp";
in
{
  options.installBundles.jevMcp = lib.mkOption { default = false; };

  config = lib.mkIf config.installBundles.jevMcp {
    home.file.".local/share/jev-mcp/jev-mcp".source = wrapper;

    home.activation.jevMcp = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      keyFile="${keyFile}"
      claude="${pkgs.claude-code}/bin/claude"
      currentCmd="$(${pkgs.jq}/bin/jq -r '.mcpServers.jev.command // empty' "$HOME/.claude.json" 2>/dev/null || true)"

      # Always registered; the wrapper checks for the key file at startup, so
      # adding/removing the key only needs a Claude Code restart, not a switch.
      if [ "$currentCmd" != "${wrapperPath}" ]; then
        if [ -n "$currentCmd" ]; then
          $DRY_RUN_CMD "$claude" mcp remove --scope user jev >/dev/null
        fi
        $DRY_RUN_CMD "$claude" mcp add --scope user jev -- "${wrapperPath}" >/dev/null
      fi

      if [ -s "$keyFile" ]; then
        echo "Jev MCP: enabled (found $keyFile)"
      else
        echo "Jev MCP: NOT available, $keyFile does not exist (create it and restart Claude Code)"
      fi
    '';
  };
}
