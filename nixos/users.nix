{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
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
    extraGroups = [ "wheel" "docker" "mlocate" ];
  };
  
  home-manager.useGlobalPkgs = true;
  home-manager.users.nathan = ./home-manager/nathan.nix;
}
