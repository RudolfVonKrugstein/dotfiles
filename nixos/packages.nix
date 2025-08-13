{ config, lib, pkgs, ... }:
{
  environment.systemPackages = import ./system-packages-list.nix {pkgs=pkgs;};
}

