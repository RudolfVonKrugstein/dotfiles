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
    ./lazygit-activate.nix
    ./nushell-activate.nix
    ./fish-activate.nix
    ./zellij-activate.nix
    ./zsh.nix
  ];
    home = {
      stateVersion = "24.11";
    };

    programs.home-manager.enable = true;
    
    fonts.fontconfig.enable = true;
}
