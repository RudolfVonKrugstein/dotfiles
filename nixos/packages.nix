
  
{ config, lib, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = import ./system-packages-list.nix {pkgs=pkgs; unstable=unstable;};
}

