{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in {
  imports = [
      (import "${home-manager}/nixos")
  ];
  # user management
  users.users.nathan = {
    isNormalUser = true;
    description = "Nathan Hüsken";
    home = "/home/nathan";
    createHome = true;
    shell = "${pkgs.zsh}/bin/zsh";
    extraGroups = [ "wheel" "docker" ];
  };
  
  home-manager.useGlobalPkgs = true;
  home-manager.users.nathan = import "/home/nathan/dotfiles/home-manager/home.nix";
}
