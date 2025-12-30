{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../overlays.nix
    ../../package-overrides.nix
    ../../home-manager/packages.nix
    ../../home-manager/git.nix
    ../../home-manager/gpg.nix
    ../../home-manager/neovim-activate.nix
    ../../home-manager/marksman-activate.nix
    ../../home-manager/lazygit-activate.nix
    ../../home-manager/nushell-activate.nix
    ../../home-manager/fish-activate.nix
    ../../home-manager/zellij-activate.nix
    ../../home-manager/uv-tools-activate.nix
    ../../home-manager/direnv-activate.nix
    ../../home-manager/zsh.nix
  ];
  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    stateVersion = "25.11";
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
