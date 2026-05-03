{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./bluetooth.nix
  ];
  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Enable the KDE Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.enableRedistributableFirmware = true;

  # firefox
  programs.firefox.enable = true;
  # thunderbird
  programs.thunderbird.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  environment.systemPackages = with pkgs; [
    mesa-demos
    networkmanagerapplet
    wl-clipboard
  ];
  services.flatpak.enable = true;

  # enable scanners
  hardware.sane.enable = true;

  # enable fingerprintscanner
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
}
