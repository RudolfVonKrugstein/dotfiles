
  
{ config, lib, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  environment.systemPackages = with pkgs; [
    # User-facing stuff that you really really want to have
    vim # or some other editor, e.g. nano or neovim

    # Some common stuff that people expect to have
    procps
    killall
    diffutils
    findutils
    utillinux
    tzdata
    hostname
    file
    #man
    gnugrep
    gnupg
    pinentry
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzip
    openssh
    nettools
    curl
    wget
    gitFull
  ];
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = ["FiraCode" "JetBrainsMono"]; })
  ];
  nixpkgs.config.packageOverrides = pkgs: rec {
    plantuml-headless = pkgs.callPackage ./packages/plantuml-headless { };
  };
}

