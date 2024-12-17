{
config, 
lib, 
pkgs,
... }: {
  imports = [
    ./../package-overrides.nix
    ./packages.nix
    ./git-work.nix
    ./lazyvim-activate-work.nix
    ./marksman-activate.nix
    ./lazygit-activate.nix
    ./nushell-activate.nix
    ./fish-activate.nix
    ./zellij-activate.nix
    ./zsh.nix
  ];
    home = {
      username = "nathan";
      homeDirectory = "/home/nathan";
      stateVersion = "24.05";
    };

    targets.genericLinux.enable = true;

    programs.home-manager.enable = true;
    
    fonts.fontconfig.enable = true;

    installBundles = {
      quarto=false;
      pandoc=true;
      asciidoc=true;
      latex=false;
      rust=true;
      golang=true;
      aws=true;
      kube=true;
      ocaml=false;
      elixir=false;
      gleam=false;
      qmk=false;
    };
}
