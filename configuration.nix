# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in {
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
    (import "${home-manager}/nixos")
  ];

  wsl.enable = true;
  wsl.defaultUser = "nathan";

  # user management
  users.users.nathan = {
    isNormalUser = true;
    description = "Nathan Hüsken";
    home = "/home/nathan";
    createHome = true;
    shell = "${pkgs.zsh}/bin/zsh";
    extraGroups = [ "wheel" "docker" ];
  };
  
  home-manager.users.nathan = import "/home/nathan/dotfiles/home-manager/home.nix";
	
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

  # enable and configure nix-ld
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    alsa-lib
    atk
    curl
    dbus
    expat
    fontconfig
    freetype
    fuse3
    glib
    icu
    libdrm
    libnotify
    libpulseaudio
    libunwind
    libusb1
    libuuid
    libxml2
    nspr
    nss
    openssl
    pango
    pipewire
    stdenv.cc.cc
    systemd
    zlib
    ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
