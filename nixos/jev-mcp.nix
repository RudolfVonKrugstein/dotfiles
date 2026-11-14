{
  config,
  lib,
  pkgs,
  ...
}:
# Enables the Jev MCP server for Claude Code (see home-manager/jev-mcp-activate.nix)
# and reports during `nixos-rebuild switch` whether the API key file exists.
let
  home = config.users.users.nathan.home;
  keyFile = "${home}/.config/typesafe/key";
in
{
  home-manager.users.nathan.installBundles.jevMcp = true;

  system.activationScripts.jevMcpNotice = {
    text = ''
      if [ -s "${keyFile}" ]; then
        echo "Jev MCP: enabled (found ${keyFile})"
      else
        echo "Jev MCP: NOT available, ${keyFile} does not exist (create it and restart Claude Code)"
      fi
    '';
  };
}
