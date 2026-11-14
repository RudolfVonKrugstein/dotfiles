{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./packages.nix
    ./git.nix
    ./gpg.nix
    ./neovim-activate.nix
    ./emacs-activate.nix
    ./configs-activate.nix
    ./lazygit-activate.nix
    ./nushell-activate.nix
    ./fish-activate.nix
    ./zellij-activate.nix
    ./uv-tools-activate.nix
    ./direnv-activate.nix
    ./jev-mcp-activate.nix
    ./zsh.nix
  ];
  home = {
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
  };

  fonts.fontconfig.enable = true;
}
