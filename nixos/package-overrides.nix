
{ config, lib, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = ["FiraCode" "JetBrainsMono"]; })
  ];
  nixpkgs.config.packageOverrides = pkgs: rec {
    plantuml-headless = pkgs.callPackage ./packages/plantuml-headless { };
  };
}
