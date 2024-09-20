
{ config, lib, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
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
    pipewire
    stdenv.cc.cc
    systemd
    zlib
    ];
}
