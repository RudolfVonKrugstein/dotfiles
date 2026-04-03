{ config, lib, pkgs, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: rec {
    plantuml-headless = pkgs.callPackage ./packages/plantuml-headless { };
    pandocBinary = pkgs.callPackage ./packages/pandocBinary {};
    quarto = pkgs.callPackage ./packages/quarto {};
    d2 = pkgs.callPackage ./packages/d2 {};
  };
}
