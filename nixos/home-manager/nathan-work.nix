{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./../package-overrides.nix
    ./packages.nix
    ./git-work.nix
    ./neovim-activate.nix
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
    username = "nathan";
    homeDirectory = "/home/nathan";
    stateVersion = "24.05";
    sessionVariables = {
      noproxy = "*.github.com,*.ghe.com,ghe.com,*.githubusercontent.com,*.githubcopilot.com";
      NOPROXY = "*.github.com,*.ghe.com,ghe.com,*.githubusercontent.com,*.githubcopilot.com";
    };
  };

  targets.genericLinux.enable = true;

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  installBundles = {
    quarto = false;
    pandoc = true;
    asciidoc = true;
    latex = false;
    rust = true;
    golang = true;
    aws = true;
    kube = true;
    ocaml = false;
    elixir = false;
    gleam = false;
    qmk = false;
    ai = false;
  };

  nixpkgs.config.allowUnfree = true;

}
