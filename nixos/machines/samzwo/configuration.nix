# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  config,
  lib,
  pkgs,
  ...
}:
let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../gnome.nix
    ../../overlays.nix
    ../../nix-ld.nix
    ../../users.nix
    ../../package-overrides.nix
    ../../packages.nix
    ../../general.nix
    ../../podman.nix
    ../../mlocate.nix
    ../../ollama.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      # systemd-boot.enable = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
    };
    initrd.luks.devices.cryptroot.device = "/dev/disk/by-uuid/4d20b300-cc6b-46c0-89ef-9c2b67637ac2";
    kernelModules = [ "amdgpu" ];
  };
  networking.hostName = "SamZwo"; # Define your hostname.

  home-manager.users.nathan.installBundles = {
    gui = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
