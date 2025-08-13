
{ config, lib, pkgs, ... }: {
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
    libgcc
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
    stdenv.cc.cc.lib
    systemd
    zlib
    openssl
    ];
}
