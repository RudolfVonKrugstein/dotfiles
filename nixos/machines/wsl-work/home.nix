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
    username = "nathan";
    homeDirectory = "/home/nathan";
    stateVersion = "25.05";
    sessionVariables = {
      noproxy = "*.github.com,*.ghe.com,ghe.com,*.githubusercontent.com,*.githubcopilot.com";
      NOPROXY = "*.github.com,*.ghe.com,ghe.com,*.githubusercontent.com,*.githubcopilot.com";
    };
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

  installBundles = {
    quarto = false;
    pandoc = true;
    asciidoc = true;
    latex = false;
    rust = false;
    golang = true;
    aws = true;
    kube = false;
    ocaml = false;
    elixir = false;
    gleam = false;
    qmk = false;
    ai = false;
  };

  nixpkgs.config.allowUnfree = true;
}
