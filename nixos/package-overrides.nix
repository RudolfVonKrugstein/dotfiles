{ config, lib, pkgs, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: rec {
    plantuml-headless = pkgs.callPackage ./packages/plantuml-headless { };
  };
}
