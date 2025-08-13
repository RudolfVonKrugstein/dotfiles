{ config, lib, pkgs,  ... }: {
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
