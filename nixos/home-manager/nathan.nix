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
    ./marksman-activate.nix
    ./lazygit-activate.nix
    ./nushell-activate.nix
    ./fish-activate.nix
    ./zellij-activate.nix
    ./uv-tools-activate.nix
    ./direnv-activate.nix
    ./zsh.nix
  ];
  home = {
    stateVersion = "24.11";
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
