{
config, 
lib, 
pkgs,
... }: let
  unstable = import <nixpkgs-unstable> { config = { allowUnfree = true; }; };
in {
  imports = [
    ./packages.nix
    ./git.nix
    ./gpg.nix
    ./lazyvim-activate.nix
    ./marksman-activate.nix
    ./nushell-activate.nix
    ./zellij-activate.nix
    ./zsh.nix
  ];
    home = {
      stateVersion = "24.05";
    };

    programs.home-manager.enable = true;
    
    fonts.fontconfig.enable = true;
}
